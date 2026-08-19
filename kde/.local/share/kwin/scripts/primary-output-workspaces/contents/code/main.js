/*
 * SPDX-License-Identifier: MIT
 */

const PRIMARY_OUTPUT = 0;
const SECONDARY_OUTPUT = 1;
const SECONDARY_DESKTOP = 1;
const SHIFTED_NUMBER_KEYS = [")", "!", "@", "#", "$", "%", "^", "&", "*", "("];

function outputAt(index) {
    return workspace.screenOrder[index] ?? null;
}

function desktopAt(number) {
    return workspace.desktops[number - 1] ?? null;
}

function isOnDesktop(window, desktop) {
    return window.onAllDesktops || window.desktops.includes(desktop);
}

function focusTopWindow(output, desktop) {
    const windows = workspace.stackingOrder;

    for (let index = windows.length - 1; index >= 0; index--) {
        const window = windows[index];
        if (window.normalWindow
            && !window.minimized
            && window.output === output
            && isOnDesktop(window, desktop)) {
            workspace.activeWindow = window;
            return true;
        }
    }

    return false;
}

function focusOutput(output) {
    if (workspace.activeScreen !== output) {
        // This script targets two outputs, so the next output is the requested one.
        workspace.slotSwitchToNextScreen();
    }
}

function switchTo(outputIndex, desktopNumber) {
    const output = outputAt(outputIndex);
    const desktop = desktopAt(desktopNumber);
    if (!output || !desktop) {
        return;
    }

    workspace.setCurrentDesktopForScreen(desktop, output);
    if (!focusTopWindow(output, desktop)) {
        focusOutput(output);
    }
}

function moveActiveWindowTo(outputIndex, desktopNumber) {
    const window = workspace.activeWindow;
    const output = outputAt(outputIndex);
    const desktop = desktopAt(desktopNumber);
    if (!window || !window.normalWindow || !output || !desktop) {
        return;
    }

    workspace.sendClientToScreen(window, output);
    window.onAllDesktops = false;
    window.desktops = [desktop];
}

for (let number = 1; number <= 9; number++) {
    registerShortcut(
        `PrimaryOutputDesktop${number}`,
        `Switch primary output to desktop ${number}`,
        `Meta+${number}`,
        () => switchTo(PRIMARY_OUTPUT, number)
    );

    registerShortcut(
        `MoveWindowToPrimaryOutputDesktop${number}`,
        `Move active window to desktop ${number} on primary output`,
        `Meta+${SHIFTED_NUMBER_KEYS[number]}`,
        () => moveActiveWindowTo(PRIMARY_OUTPUT, number)
    );
}

registerShortcut(
    "SecondaryOutputDesktop1",
    "Switch secondary output to desktop 1",
    "Meta+0",
    () => switchTo(SECONDARY_OUTPUT, SECONDARY_DESKTOP)
);

registerShortcut(
    "MoveWindowToSecondaryOutputDesktop1",
    "Move active window to desktop 1 on secondary output",
    `Meta+${SHIFTED_NUMBER_KEYS[0]}`,
    () => moveActiveWindowTo(SECONDARY_OUTPUT, SECONDARY_DESKTOP)
);
