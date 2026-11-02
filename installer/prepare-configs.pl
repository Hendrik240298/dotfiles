#!/usr/bin/env perl

# Internal helper: back up only conflicting settings leaves, never whole app
# directories. Use Stow's own ignore rules so runtime data is not selected.
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use Getopt::Long qw(GetOptions);
use POSIX qw(strftime);
use Stow;

my ($repo, $target, $apply);
GetOptions('repo=s' => \$repo, 'target=s' => \$target, 'apply' => \$apply)
    or die "Usage: prepare-configs.pl --repo PATH --target HOME [--apply] PACKAGES...\n";
die "Run as your normal user, not root.\n" if $> == 0;
$repo = defined($repo) ? abs_path($repo) : undef;
$target = defined($target) ? abs_path($target) : undef;
die "Specify an existing repository and HOME target.\n"
    unless defined($repo) && -d $repo && defined($target) && -d $target;
my $home = abs_path($ENV{HOME});
die "Replacement is limited to the normal HOME target, never a vault or /.\n"
    unless defined($home) && $target eq $home && $target ne '/' && $target ne $repo;
my %allowed = map { $_ => 1 } qw(hyprland ghostty vscode flatpak voxtype);
die "Select supported home-directory config packages.\n"
    unless @ARGV && !grep { !$allowed{$_} || !-d "$repo/$_" } @ARGV;

my $stow = Stow->new(dir => $repo, target => $target, 'no-folding' => 1);
my (@conflicts, %selected);

sub same_destination {
    my ($source, $live) = @_;
    my $a = abs_path($source);
    my $b = abs_path($live);
    return defined($a) && defined($b) && $a eq $b;
}

sub managed_link {
    my ($package, $rel, $source, $live) = @_;
    return 0 unless -l $live && same_destination($source, $live);
    my @owner;
    $stow->within_target_do(sub {
        @owner = $stow->find_stowed_path($rel, readlink($live));
    });
    return $owner[2] eq $package;
}

sub inspect {
    my ($package, $rel) = @_;
    return if $stow->ignore($repo, $package, $rel);
    my $source = "$repo/$package/$rel";
    my $live = "$target/$rel";
    if (-d $source && !-l $source) {
        if (-l $live) {
            # Existing folded links into this package are already managed.
            return if managed_link($package, $rel, $source, $live);
            die "Refusing to traverse or replace directory symlink: $live\n";
        }
        die "Refusing to replace a non-directory parent: $live\n"
            if -e $live && !-d $live;
        opendir(my $dir, $source) or die "Cannot read $source: $!\n";
        my @entries = sort grep { $_ ne '.' && $_ ne '..' } readdir($dir);
        closedir($dir);
        inspect($package, "$rel/$_") for @entries;
        return;
    }
    die "Unsupported source setting: $source\n" unless -f $source || -l $source;
    if (exists $selected{$rel}) {
        die "Two packages select different sources for $live\n"
            unless same_destination($source, $selected{$rel});
        return;
    }
    $selected{$rel} = $source;
    return unless -e $live || -l $live;
    return if managed_link($package, $rel, $source, $live);
    die "Refusing to replace a directory or special file: $live\n"
        unless -l $live || -f $live;

    # Compare before replacing. Keep the diff in the backup rather than dumping
    # potentially large/private app settings into the installation output.
    my $diff = '';
    if (-f $source && -f $live) {
        open(my $pipe, '-|', 'diff', '-u', '--', $source, $live)
            or die "Cannot run diff (install diffutils): $!\n";
        $diff = do { local $/; <$pipe> } // '';
        close($pipe);
        die "Cannot compare $live\n" if $? != 0 && $? != 256;
    }
    push @conflicts, { rel => $rel, diff => $diff };
}

# Finish the entire safety check before moving any files.
for my $package (@ARGV) {
    opendir(my $dir, "$repo/$package") or die "Cannot read package $package: $!\n";
    my @entries = sort grep { $_ ne '.' && $_ ne '..' } readdir($dir);
    closedir($dir);
    inspect($package, $_) for @entries;
}
if (!@conflicts) {
    print "No conflicting setting files need backing up.\n";
    exit 0;
}
if (!$apply) {
    print "Would back up and replace: $target/$_->{rel}\n" for @conflicts;
    exit 0;
}

my $backup_root = "$home/.local/state/dotfiles/backups";
make_path($backup_root, { mode => 0700 });
my $resolved_backup = abs_path($backup_root);
die "Backup storage must be outside the source repository.\n"
    if $resolved_backup eq $repo || index($resolved_backup, "$repo/") == 0;
my $backup = tempdir('configs-' . strftime('%Y%m%d-%H%M%S', localtime) . '-XXXXXX',
                     DIR => $backup_root, CLEANUP => 0);
open(my $diffs, '>', "$backup/changes.diff") or die "Cannot record diffs: $!\n";
print {$diffs} $_->{diff} for @conflicts;
close($diffs) or die "Cannot save diffs: $!\n";
print "Config backup: $backup\n";
for my $conflict (@conflicts) {
    my $rel = $conflict->{rel};
    my $live = "$target/$rel";
    my $saved = "$backup/$rel";
    make_path(dirname($saved), { mode => 0700 });
    # GNU mv preserves symlinks themselves (never their destinations) and also
    # supports backup storage on another filesystem. Never clobber a backup.
    system('mv', '-T', '--no-clobber', '--', $live, $saved) == 0
        or die "Cannot back up $live; previous backups are in $backup\n";
    die "Backup was not completed for $live\n"
        if -e $live || -l $live || !(-e $saved || -l $saved);
    print "Backed up: $live\n";
}
