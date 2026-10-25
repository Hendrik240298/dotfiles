" Obsidian Vimrc Support configuration
" Goal: keep Obsidian close to the VS Code LazyVim-style keymap.
" Install the Obsidian community plugin "Vimrc Support" and enable core Vim mode.
" Stow this package with an explicit vault-root target, NOT the default home target.
" Normal-mode editor mappings only; native Obsidian hotkeys handle sidebar focus.
" See docs/obsidian/README.md for setup, parity gaps, and manual checks.
" No JavaScript snippets or additional community plugins are required.

" Core Vim feel
set clipboard=unnamed

" Make wrapped Markdown lines behave naturally.
nmap j gj
nmap k gk

" Space leader, matching VS Code.
" Vimrc Support requires unmapping Space before using Space chords.
" Use literal <Space>: released plugin versions may not support let mapleader.
unmap <Space>

" -----------------------------------------------------------------------------
" Root leader commands
" VS Code: <leader><leader> quick open, <leader>/ find in file, <leader>e explorer
" Obsidian: <leader><leader> opens the Quick Switcher / Ctrl+O fuzzy finder.
" -----------------------------------------------------------------------------

exmap quickopen obcommand switcher:open
nmap <Space><Space> :quickopen<CR>

exmap findinfile obcommand editor:open-search
nmap <Space>/ :findinfile<CR>

exmap explorer obcommand file-explorer:open
nmap <Space>e :explorer<CR>

" -----------------------------------------------------------------------------
" Buffers / tabs
" VS Code: <leader>b... buffer/editor actions
" Obsidian: tabs. Do not substitute vault search for the open-buffer picker.
" -----------------------------------------------------------------------------

" <leader>bb is reserved: core Obsidian has no verified open-tab picker command.

exmap newtab obcommand workspace:new-tab
nmap <Space>bn :newtab<CR>

exmap nexttab obcommand workspace:next-tab
exmap prevtab obcommand workspace:previous-tab
nmap gt :nexttab<CR>
nmap gT :prevtab<CR>

" -----------------------------------------------------------------------------
" Files
" VS Code: <leader>ff find file, <leader>fr open recent
" -----------------------------------------------------------------------------

nmap <Space>ff :quickopen<CR>

" New Markdown note: same intent as VS Code's new Markdown editor.
" Obsidian creates a file using its configured new-note location.
exmap newmarkdown obcommand file-explorer:new-file
nmap <Space>fm :newmarkdown<CR>

exmap renamefile obcommand workspace:edit-file-title
nmap <Space>fR :renamefile<CR>

" Obsidian addition: reveal the currently open note in the native file explorer.
exmap revealfile obcommand file-explorer:reveal-active-file
nmap <Space>fe :revealfile<CR>

" <leader>fr stays reserved for recent-file navigation, not reveal-file.
" The core Quick Switcher shows recent notes when its query is empty.

" -----------------------------------------------------------------------------
" Search / command palette
" VS Code: <leader>sg find in files, <leader>sc command palette, <leader>sb sidebar
" -----------------------------------------------------------------------------

exmap globalsearch obcommand global-search:open
nmap <Space>sg :globalsearch<CR>

exmap commands obcommand command-palette:open
nmap <Space>sc :commands<CR>

exmap leftsidebar obcommand app:toggle-left-sidebar
nmap <Space>sb :leftsidebar<CR>

" -----------------------------------------------------------------------------
" Windows / panes
" VS Code: <leader>wv, <leader>ws, <leader>ww, <leader>wd, <leader>wS
" -----------------------------------------------------------------------------

exmap splitv obcommand workspace:split-vertical
exmap splith obcommand workspace:split-horizontal
nmap <Space>wv :splitv<CR>
nmap <Space>ws :splith<CR>

" Keep direct mnemonic split bindings from the VS Code setup.
nmap <Space>vs :splitv<CR>
nmap <Space>hs :splith<CR>

" Directional group focus matches VS Code's direct Ctrl+h/j/k/l mappings.
" Remove conflicting native hotkeys for these keys before testing the Vim maps.
exmap focusleft obcommand editor:focus-left
exmap focusbelow obcommand editor:focus-bottom
exmap focusabove obcommand editor:focus-top
exmap focusright obcommand editor:focus-right
nmap <C-h> :focusleft<CR>
nmap <C-j> :focusbelow<CR>
nmap <C-k> :focusabove<CR>
nmap <C-l> :focusright<CR>

" Leader alternatives are Obsidian additions, with the same window meaning.
nmap <Space>wh :focusleft<CR>
nmap <Space>wj :focusbelow<CR>
nmap <Space>wk :focusabove<CR>
nmap <Space>wl :focusright<CR>

" <leader>ww stays reserved for cycling groups, NOT for switching tabs.
" Core Obsidian has no verified cycle-group command; use directional focus.

exmap closetab obcommand workspace:close
exmap closegroup obcommand workspace:close-tab-group
nmap <Space>wd :closegroup<CR>

exmap savefile obcommand editor:save-file
nmap <Space>wS :savefile<CR>

" -----------------------------------------------------------------------------
" Quit / close
" VS Code: <leader>qq close window, <leader>qe close active editor
" Close window and close active tab remain distinct, matching VS Code.
" -----------------------------------------------------------------------------

nmap <Space>qe :closetab<CR>
exmap closewindow obcommand workspace:close-window
nmap <Space>qq :closewindow<CR>

" -----------------------------------------------------------------------------
" UI
" VS Code: <leader>us sidebar, <leader>uv auxiliary/right sidebar
" -----------------------------------------------------------------------------

nmap <Space>us :leftsidebar<CR>

exmap rightsidebar obcommand app:toggle-right-sidebar
nmap <Space>uv :rightsidebar<CR>

" -----------------------------------------------------------------------------
" Obsidian navigation history (optional)
" -----------------------------------------------------------------------------

" Keep native Ctrl+O (Quick Switcher) and Ctrl+I (italics) unchanged for now.
" Uncomment only if Vim-style history is wanted, and remove native conflicts.
" exmap back obcommand app:go-back
" exmap forward obcommand app:go-forward
" nmap <C-o> :back<CR>
" nmap <C-i> :forward<CR>

" -----------------------------------------------------------------------------
" Markdown / note navigation
" Vimrc Support already provides some useful defaults:
" [[ / ]] previous/next heading, gl/gL next/previous link, gf open link/file.
" These mappings make folding closer to Vim.
" -----------------------------------------------------------------------------

exmap togglefold obcommand editor:toggle-fold
nmap za :togglefold<CR>
" Do not map zo/zc to a toggle: that reverses their explicit open/close meaning.

exmap foldall obcommand editor:fold-all
exmap unfoldall obcommand editor:unfold-all
nmap zM :foldall<CR>
nmap zR :unfoldall<CR>

" -----------------------------------------------------------------------------
" Obsidian-specific useful leader commands
" These have no direct VS Code equivalent but fit the same leader-key style.
" -----------------------------------------------------------------------------

exmap backlinks obcommand backlink:open
nmap <Space>sl :backlinks<CR>

exmap outline obcommand outline:open
nmap <Space>so :outline<CR>

exmap outgoinglinks obcommand outgoing-links:open
nmap <Space>sx :outgoinglinks<CR>

exmap properties obcommand properties:open-local
nmap <Space>sp :properties<CR>

" Calendar is optional: only uncomment if the existing Calendar plugin is enabled.
" exmap calendar obcommand calendar:show-calendar-view
" nmap <Space>uc :calendar<CR>

exmap graph obcommand graph:open
nmap <Space>ug :graph<CR>

" -----------------------------------------------------------------------------
" Placeholders from VS Code that do not map cleanly to core Obsidian
" -----------------------------------------------------------------------------

" <leader>a...  AI: depends on the AI plugin you use in Obsidian.
" <leader>c...  Code actions/refactor: not relevant for standard Markdown editing.
" <leader>g...  Git: depends on an Obsidian Git plugin command IDs.
" <leader>rn    Symbol rename: do not substitute file rename (use <leader>fR).
" <leader>ss/sq SQL commands: do not repurpose as Outline (use <leader>so).
" <leader>um    Menu bar: no verified equivalent to VS Code's menu-bar toggle.
" Pane resizing and moving existing tabs between groups need extra functionality.
