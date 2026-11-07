-- Wayfinder: a tab picker for Rex. Setup and options are in README.md, beside
-- this file.
--
-- This half runs inside Rex: it collects every tab, with its agent status,
-- and opens picker.sh (fzf) in a floating pane with the list. Collecting here
-- rather than from the shell is what keeps it fast: no process per query.

local M = {}

local here = debug.getinfo(1, "S").source:gsub("^@", ""):match("(.*/)") or "./"
local picker = here .. "picker.sh"

local defaults = {
  key = nil, -- e.g. "ctrl+b>w"; nil leaves binding to you (the action is "wayfinder")
  bounds = { 0.32, 0.2, 0.36, 0.5 }, -- x, y, width, height, as fractions of the window
  icons = "nerd", -- "nerd" (needs a Nerd Font) or "plain"
}

-- Most urgent first, as in Herdr: a tab shows the most urgent of its panes.
local urgency = { blocked = 5, error = 4, done = 3, working = 2, idle = 1 }
local shells = { zsh = true, bash = true, sh = true, fish = true, nu = true, login = true }

local function block(sid, bid, method)
  return rex.call("block.method", { session_id = sid, block_id = bid, method = method })
end

-- Another session's layout. The action's connection must be attached to it.
local function view(sid)
  local v = rex.call("session.view", { session_id = sid })
  if v and v.windows then return v end
  local a = rex.call("session.attach", { session_id = sid })
  return a and ((a.view and a.view.windows and a.view) or (a.windows and a)) or nil
end

local function clean(s)
  return (tostring(s or ""):gsub("[\t\r\n]", " "))
end

-- One line per tab: session id, session, tab id, tab name, agent|term,
-- state (working, blocked, done, error or idle), is-current (1 or 0).
local function collect(ctx)
  local lines = {}
  local list = rex.call("session.list") or { sessions = {} }
  for _, s in ipairs(list.sessions or {}) do
    local v = view(s.session_id)
    for _, w in ipairs(v and v.windows or {}) do
      -- Tiled panes only: floating ones are overlays, not the tab.
      local panes = {}
      for _, layer in ipairs(w.layers or {}) do
        if layer.kind == "tiled" then
          for _, b in ipairs(layer.blocks or {}) do table.insert(panes, b.block_id) end
        end
      end

      -- Unnamed tabs are labeled "Window 1a2b3c4d"; show a terminal title
      -- instead, the focused pane's first, else the first pane that has one.
      local name = w.label
      if not name or name:match("^Window %x%x%x%x%x%x%x%x$") then
        name = nil
        local order = { w.focused_block_id }
        for _, p in ipairs(panes) do table.insert(order, p) end
        for _, p in ipairs(order) do
          local t = p and block(s.session_id, p, "title")
          if t and t.title and t.title ~= "" then name = t.title break end
        end
      end

      -- An agent tab has a pane reporting a status (OSC 7501); a terminal tab
      -- is running while any pane runs more than a shell.
      local agent, busy = nil, false
      for _, p in ipairs(panes) do
        local st = block(s.session_id, p, "program_status")
        local state
        for _, r in ipairs(st and st.records or {}) do
          if r.id == nil then state = r.state end
        end
        if state then
          if not agent or (urgency[state] or 0) > (urgency[agent] or 0) then agent = state end
        else
          local pr = block(s.session_id, p, "process")
          local fg = pr and pr.foreground and pr.foreground.name
          if fg and not shells[fg] then busy = true end
        end
      end

      local current = s.session_id == ctx.session_id and w.window_id == v.active_window_id
      table.insert(lines, table.concat({
        s.session_id, clean(s.label or "untitled"), w.window_id, clean(name or "untitled"),
        agent and "agent" or "term", agent or (busy and "working" or "idle"),
        current and "1" or "0",
      }, "\t"))
    end
  end
  return table.concat(lines, "\n")
end

function M.setup(opts)
  opts = opts or {}
  for k, v in pairs(defaults) do
    if opts[k] == nil then opts[k] = v end
  end

  rex.action{
    name = "wayfinder",
    title = "Wayfinder: Go to Tab",
    keywords = "tab picker switch jump go session agent",
    run = function(ctx)
      local _, err = rex.session.new_layer{
        bounds = opts.bounds,
        focus = true,
        layout = rex.layout.block{
          flavor = "com.superlogical.terminal.shell",
          label = "Wayfinder",
          options = { command = { "sh", picker, opts.icons, collect(ctx) } },
        },
      }
      if err ~= nil then error(err, 0) end
    end,
  }

  if opts.key then rex.bind(opts.key, "wayfinder") end
end

return M
