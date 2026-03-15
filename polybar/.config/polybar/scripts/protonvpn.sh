#!/usr/bin/env sh

is_connected() {
    nmcli -t -f DEVICE,STATE device status | grep -q '^proton0:connected$'
}

notify() {
    notify-send "Proton VPN" "$1"
}

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
