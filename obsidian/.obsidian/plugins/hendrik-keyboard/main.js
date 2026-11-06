const { Plugin, Notice } = require("obsidian");

// Calendar-specific compatibility boundary. These two members are internals of
// liamcain/obsidian-calendar-plugin, not stable Obsidian APIs. Fail visibly if
// they change; never fall back to guessing filenames or creating notes ourselves.
function compatible(view) {
  return typeof view?.calendar?.$set === "function" &&
    typeof view?.openOrCreateDailyNote === "function" &&
    typeof window.moment === "function";
}

function shiftDate(date, amount, unit = "day") {
  const next = new Date(date);
  if (unit === "month") {
    const day = next.getDate();
    next.setDate(1);
    next.setMonth(next.getMonth() + amount);
    const lastDay = new Date(next.getFullYear(), next.getMonth() + 1, 0).getDate();
    next.setDate(Math.min(day, lastDay));
  } else {
    next.setDate(next.getDate() + amount);
  }
  return next;
}

function dateLabel(date) {
  return [date.getFullYear(), String(date.getMonth() + 1).padStart(2, "0"),
    String(date.getDate()).padStart(2, "0")].join("-");
}

module.exports = class HendrikKeyboard extends Plugin {
  onload() {
    this.selectedDate = new Date();
    this.calendarLeaf = null;
    this.returnLeaf = null;
    this.status = null;
    this.unloaded = false;
    this.addCommand({
      id: "focus-calendar",
      name: "Focus Calendar",
      hotkeys: [{ modifiers: ["Mod", "Alt"], key: "C" }],
      callback: () => this.focusCalendar().catch(error => this.report(error)),
    });
    // Do not intercept the editor, other widgets, dialogs, IME or modified keys.
    this.registerDomEvent(document, "keydown", event => this.onKey(event), true);
  }

  report(error) {
    console.error("Hendrik Keyboard:", error);
    new Notice("Hendrik Keyboard: " + error.message);
  }

  async focusCalendar() {
    const workspace = this.app.workspace;
    if (!this.app.plugins?.getPlugin("calendar")) {
      this.cleanView();
      this.calendarLeaf = null;
      new Notice("Enable the Calendar plugin before using Calendar keyboard navigation.");
      return;
    }
    const recent = workspace.getMostRecentLeaf();
    if (recent?.view.getViewType() === "markdown") this.returnLeaf = recent;

    let leaf = workspace.getLeavesOfType("calendar")[0];
    if (!leaf) {
      leaf = workspace.getRightLeaf(false);
      if (!leaf) throw new Error("No right sidebar is available.");
      await leaf.setViewState({ type: "calendar", active: true });
    }
    await workspace.revealLeaf(leaf);
    if (this.unloaded) return;
    if (!compatible(leaf.view)) {
      new Notice("Calendar's interface has changed. Keyboard adapter disabled; no notes changed.");
      this.cleanView();
      this.calendarLeaf = null;
      return;
    }
    if (this.calendarLeaf !== leaf) this.cleanView();
    this.calendarLeaf = leaf;
    workspace.setActiveLeaf(leaf, { focus: true });
    const root = leaf.view.contentEl;
    if (this.originalTabIndex === undefined) this.originalTabIndex = root.getAttribute("tabindex");
    root.tabIndex = -1;
    await this.paint();
    if (!this.unloaded) root.focus({ preventScroll: true });
  }

  async paint() {
    const view = this.calendarLeaf?.view;
    if (this.unloaded || !compatible(view)) return;
    view.calendar.$set({ displayedMonth: window.moment(this.selectedDate) });
    // Svelte applies $set in a microtask. Paint only after that render.
    await Promise.resolve();
    if (this.unloaded || !view.contentEl.isConnected) return;
    const root = view.contentEl;
    root.querySelectorAll(".hk-calendar-selected").forEach(el => el.classList.remove("hk-calendar-selected"));
    const selected = [...root.querySelectorAll(".day:not(.adjacent-month)")].find(el => {
      const text = [...el.childNodes].filter(node => node.nodeType === 3)
        .map(node => node.textContent).join("").trim();
      return Number(text) === this.selectedDate.getDate();
    });
    selected?.classList.add("hk-calendar-selected");
    if (!this.status?.isConnected) {
      this.status = root.ownerDocument.createElement("div");
      this.status.className = "hk-calendar-status";
      this.status.setAttribute("role", "status");
      this.status.setAttribute("aria-live", "polite");
      root.append(this.status);
    }
    this.status.textContent = `${dateLabel(this.selectedDate)} · h/l day · j/k week · [/] month · t today · Enter open · Esc note`;
  }

  onKey(event) {
    if (this.unloaded || event.isComposing || event.defaultPrevented ||
        event.ctrlKey || event.altKey || event.metaKey || event.shiftKey ||
        event.target.closest?.("input, textarea, select, [contenteditable]:not([contenteditable='false']), .is-being-renamed") ||
        document.querySelector(".modal, .menu")) return;
    if (this.onExplorerKey(event)) return;
    const root = this.calendarLeaf?.view.contentEl;
    if (!root?.contains(event.target)) return;
    if (!compatible(this.calendarLeaf.view)) {
      this.cleanView();
      this.calendarLeaf = null;
      new Notice("Calendar's interface changed; keyboard adapter disabled.");
      return;
    }
    const days = { h: -1, l: 1, j: 7, k: -7 };
    const months = { "[": -1, "]": 1 };
    let action;
    if (Object.hasOwn(days, event.key)) {
      this.selectedDate = shiftDate(this.selectedDate, days[event.key]);
      action = () => this.paint();
    } else if (Object.hasOwn(months, event.key)) {
      this.selectedDate = shiftDate(this.selectedDate, months[event.key], "month");
      action = () => this.paint();
    } else if (event.key === "t") {
      this.selectedDate = new Date();
      action = () => this.paint();
    } else if (event.key === "Enter") {
      action = () => this.calendarLeaf.view.openOrCreateDailyNote(window.moment(this.selectedDate), false);
    } else if (event.key === "Escape") {
      action = () => this.focusNote();
    } else return;
    event.preventDefault();
    event.stopImmediatePropagation();
    Promise.resolve().then(() => {
      if (!this.unloaded) return action();
    }).catch(error => this.report(error));
  }

  onExplorerKey(event) {
    const leaf = this.app.workspace.getLeavesOfType("file-explorer")
      .find(leaf => leaf.view.containerEl.contains(event.target));
    if (!leaf) return false;
    if (event.key === "Escape") {
      event.preventDefault();
      event.stopImmediatePropagation();
      this.focusNote(false);
      return true;
    }
    // Use semantic letters, NOT event.code/QWERTY positions. Delegate movement
    // to the native tree; do not implement another file tree or file operations.
    const methods = { h: "onKeyArrowLeft", j: "onKeyArrowDown", k: "onKeyArrowUp", l: "onKeyArrowRight" };
    if (!Object.hasOwn(methods, event.key)) return false;
    const view = leaf.view;
    const openFile = event.key === "l" && typeof view.tree?.focusedItem?.file?.extension === "string";
    const target = openFile ? view : view.tree;
    const method = openFile ? "onKeyOpen" : methods[event.key];
    if (typeof target?.[method] !== "function") {
      new Notice("File Explorer's keyboard interface changed; use native arrows until the adapter is updated.");
      return false;
    }
    event.preventDefault();
    event.stopImmediatePropagation();
    try { target[method](event); }
    catch (error) { this.report(error); }
    return true;
  }

  focusNote(preferRemembered = true) {
    const workspace = this.app.workspace;
    const notes = workspace.getLeavesOfType("markdown");
    const leaf = preferRemembered && notes.includes(this.returnLeaf) ? this.returnLeaf :
      notes.find(note => note === workspace.getMostRecentLeaf()) || notes[0];
    if (!leaf) {
      new Notice("No previous Markdown note is open.");
      return;
    }
    workspace.setActiveLeaf(leaf, { focus: true });
    leaf.view.editor?.focus();
  }

  cleanView() {
    const root = this.calendarLeaf?.view.contentEl;
    this.status?.remove();
    this.status = null;
    root?.querySelectorAll(".hk-calendar-selected").forEach(el => el.classList.remove("hk-calendar-selected"));
    if (root && this.originalTabIndex !== undefined) {
      if (this.originalTabIndex === null) root.removeAttribute("tabindex");
      else root.setAttribute("tabindex", this.originalTabIndex);
    }
    this.originalTabIndex = undefined;
  }

  onunload() {
    this.unloaded = true;
    this.cleanView();
  }
};
