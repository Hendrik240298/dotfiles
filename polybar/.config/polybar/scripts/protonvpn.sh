#!/usr/bin/env sh

is_connected() {
    command -v nmcli >/dev/null 2>&1 || return 1
    nmcli -t -f DEVICE,STATE device status | grep -q '^proton0:connected$'
}

notify() {
    command -v notify-send >/dev/null 2>&1 || return 0
    notify-send "Proton VPN" "$1"
}

if ! command -v protonvpn >/dev/null 2>&1; then
    case "${1:-}" in
        status)
            printf 'VPN:n/a\n'
            exit 0
            ;;
        *)
            notify 'Install Proton VPN CLI to use this toggle'
            exit 1
            ;;
    esac
fi

connect_de() {
    output=$(protonvpn connect --country DE 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
        message=$(printf '%s\n' "$output" | grep -m1 '^Connected to ')
        [ -n "$message" ] || message='Connected to Germany'
        notify "$message"
    else
        message=$(printf '%s\n' "$output" | grep -m1 .)
        [ -n "$message" ] || message='Connection failed'
        notify "$message"
        exit $status
    fi
}

disconnect_vpn() {
    output=$(protonvpn disconnect 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
        notify 'Disconnected from Proton VPN'
    else
        message=$(printf '%s\n' "$output" | grep -m1 .)
        [ -n "$message" ] || message='Disconnect failed'
        notify "$message"
        exit $status
    fi
}

case "$1" in
    status)
        if is_connected; then
            printf 'VPN:on\n'
        else
            printf 'VPN:off\n'
        fi
        ;;
    toggle)
        if is_connected; then
            disconnect_vpn
        else
            connect_de
        fi
        ;;
    connect)
        connect_de
        ;;
    disconnect)
        disconnect_vpn
        ;;
    *)
        printf 'usage: %s {status|toggle|connect|disconnect}\n' "$0" >&2
        exit 1
        ;;
esac
