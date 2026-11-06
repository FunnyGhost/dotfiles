-- Migrated from ~/.config/wezterm/wezterm.lua (leader ctrl+s)
rex.bind("ctrl+s>ctrl+s", "pane.send_key", { key = "ctrl+s" })
rex.bind("ctrl+s>h", "pane.split", { direction = "right" })
rex.bind("ctrl+s>v", "pane.split", { direction = "down" })
rex.bind("ctrl+s>m", "pane.zoom")
rex.bind("ctrl+s>t", "client.tab.new")
rex.bind("ctrl+s>[", "client.tab.previous")
rex.bind("ctrl+s>]", "client.tab.next")
rex.bind("ctrl+s>r", "client.tab.rename")

-- Ported from Herdr.app's Ctrl+B prefix popup (mods/my-prefix)
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+b>h", "pane.focus.left")
rex.bind("ctrl+b>j", "pane.focus.down")
rex.bind("ctrl+b>k", "pane.focus.up")
rex.bind("ctrl+b>l", "pane.focus.right")
rex.bind("ctrl+b>shift+tab", "pane.focus_previous")
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
for i = 1, 9 do
  rex.bind("ctrl+b>" .. i, "client.tab.goto", { index = i })
end
rex.bind("ctrl+b>shift+t", "client.tab.rename")
rex.bind("ctrl+b>shift+x", "client.tab.close")
rex.bind("ctrl+b>shift+n", "session.new")
rex.bind("ctrl+b>shift+s", "session.rename")
rex.bind("ctrl+b>shift+d", "session.close")
rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>-", "pane.split", { direction = "down" })
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>b", "client.sidebar.toggle")
rex.bind("ctrl+b>s", "client.settings")
rex.bind("ctrl+b>w", "session.switch")
rex.bind("ctrl+b>g", "session.switch")

-- Smart pane navigation (vim-tmux-navigator style). Programs that use
-- ctrl+hjkl themselves get the key; nvim calls `rex focus` at its edge split.
local passthrough = { nvim = true, vim = true, fzf = true }

local function navigate(direction)
  return function(ctx)
    local proc = rex.block.call("com.superlogical.terminal", "process", {})
    local fg = proc and proc.foreground and proc.foreground.name
    if fg and passthrough[fg] then
      return false
    end
    rex.session.focus_direction{ session_id = ctx.session_id, direction = direction }
    return true
  end
end

rex.bind("ctrl+h", navigate("left"))
rex.bind("ctrl+j", navigate("down"))
rex.bind("ctrl+k", navigate("up"))
rex.bind("ctrl+l", navigate("right"))
