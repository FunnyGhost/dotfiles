import { View, div } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { theme, run, focused, panes, props, closeOverlay, openOverlay, notify } from "herdr";

// Ctrl+B (keys.json) opens this as an overlay; it takes the next key,
// tmux-style, without rebinding typing keys.
const ACTIONS = {
  "]": ["agent.next", {}, "Next agent"],
  "[": ["agent.prev", {}, "Previous agent"],
  h: ["pane.go", { direction: "left" }, "Focus left"],
  j: ["pane.go", { direction: "down" }, "Focus down"],
  k: ["pane.go", { direction: "up" }, "Focus up"],
  l: ["pane.go", { direction: "right" }, "Focus right"],
  c: ["tab.new", {}, "New tab"],
  n: ["tab.next", {}, "Next tab"],
  p: ["tab.prev", {}, "Previous tab"],
  "shift-t": ["tab.rename", {}, "Rename tab"],
  "shift-x": ["tab.close", {}, "Close tab"],
  "shift-n": ["space.new", {}, "New space"],
  "shift-s": ["space.rename", {}, "Rename space"],
  "shift-d": ["space.close", {}, "Close space"],
  v: ["pane.split", { direction: "right" }, "Split right"],
  "-": ["pane.split", { direction: "down" }, "Split down"],
  x: ["pane.close", {}, "Close pane"],
  z: ["pane.zoom", {}, "Zoom pane"],
  b: ["layout.toggle", { id: "sidebar" }, "Toggle sidebar"],
  s: ["app.settings", {}, "Settings"],
  w: ["mod.open", { name: "picker" }, "Space picker"],
  g: ["mod.open", { name: "picker" }, "Go to…"],
};

function keyOf(e) {
  if (ACTIONS[e.keystroke] || ["shift-tab", "shift-g", "escape"].includes(e.keystroke)) return e.keystroke;
  if (e.modifiers.control || e.modifiers.platform) return e.keystroke;
  const char = e.key_char ?? e.key;
  return /^[A-Z]$/.test(char) ? `shift-${char.toLowerCase()}` : char;
}

export default class Prefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  press(e, cx) {
    cx.stop_propagation();
    if (e.is_held) return;
    const key = keyOf(e);
    if (key === "?") return;
    const current = focused();
    closeOverlay(props().overlay);
    if (key === "escape") return;
    if (key === "shift-tab") {
      const list = panes().filter(p => p.tab === current?.tab);
      const at = list.findIndex(p => p.pane === current?.pane);
      if (at >= 0 && list.length > 1) run("pane.focus", { pane: list[(at + list.length - 1) % list.length].pane });
    } else if (/^[1-9]$/.test(key)) {
      run("tab.select", { index: Number(key) });
    } else if (key === "shift-g") {
      openOverlay({ mod: "worktree", kind: "dialog", width: 600, props: { space: current?.space, action: "new" } });
    } else if (ACTIONS[key]) {
      const [command, args] = ACTIONS[key];
      run(command, args);
    } else {
      notify({ title: "No prefix action for this key", body: "Ctrl+B shows the shortcuts. Esc cancels.", timeout: 2500 });
    }
  }

  render() {
    const t = theme();
    const rows = [
      ["Shift+Tab", "Previous pane in this tab"],
      ["1–9", "Select tab"],
      ...Object.entries(ACTIONS).map(([key, action]) => [key.replace("shift-", "Shift+"), action[2]]),
      ["Shift+g", "New worktree"],
      ["?", "Keep this help open"],
    ];
    const half = Math.ceil(rows.length / 2);
    return v_flex().id("my-prefix").track_focus(this.handle)
      .on_key_down((e, cx) => this.press(e, cx))
      .size_full().min_h(0).p(18).gap(14).bg(t.popover).text_color(t.foreground)
      .child(h_flex().justify_between().items_center()
        .child(div().text_size(16).font_semibold().child("Ctrl+B · choose a shortcut"))
        .child(div().text_size(12).text_color(t.muted).child("Esc cancels")))
      .child(h_flex().flex_1().min_h(0).gap(24).children([rows.slice(0, half), rows.slice(half)].map((column, i) =>
        v_flex().id(`keys-${i}`).flex_1().min_w(0).overflow_y_scrollbar().children(column.map(([key, label]) =>
          h_flex().h(26).flex_none().gap(8).items_center().text_size(12)
            .child(div().w(72).flex_none().text_color(t.accent).child(key))
            .child(div().flex_1().min_w(0).truncate().child(label)))))))
      .child(div().text_size(11).text_color(t.muted).child("Press a shortcut key, or Esc to cancel. Native Cmd shortcuts also work."));
  }
}
