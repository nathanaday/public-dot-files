local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local is_windows = os.getenv("OS") and os.getenv("OS"):lower():find("windows")
local is_macos = wezterm.target_triple:lower():find("darwin") ~= nil

config.color_scheme = "rose-pine-moon"

-- Invert the selection: rose-pine-moon's default selection background sits
-- too close to the window background to see. Use the scheme's text color as
-- the highlight and its base color for the selected glyphs.
config.colors = {
  selection_bg = "#e0def4",
  selection_fg = "#232136",
}
config.max_fps = 120
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  font = wezterm.font("Hack Nerd Font", { weight = "Bold" }),
}
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.7,
}

if is_windows then
  config.win32_system_backdrop = "Acrylic"
  config.window_background_opacity = 0.7
  config.window_frame.font_size = 10.0
end

if is_macos then
  config.window_background_opacity = 0.8
  config.macos_window_background_blur = 50
  config.font_size = 15.0
  config.window_frame.font_size = 13.0
end

-- Leader key: Ctrl-A, tmux-style. Held for up to 1 second after you press it.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
 
config.keys = {
  -- Splits: | for side-by-side, - for stacked (matches the tmux mental model)
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
 
  -- Move between panes with leader + h/j/k/l
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
 
  -- Close the current pane (asks to confirm)
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
 
  -- Bonus: leader + z zooms the pane fullscreen, leader + z again restores it
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
 
  -- Bonus: resize with leader + Shift + h/j/k/l
  { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
 
  -- Because Ctrl-A is now the leader, press it twice to send a real Ctrl-A
  -- (jump to start of line) to your shell.
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
}

-- PuTTY-style mouse: selecting text copies it, right-click pastes it.
-- These entries merge with WezTerm's defaults; only the matching default
-- bindings are replaced.
config.mouse_bindings = {
  -- Drag-select, then release: copy to the clipboard. The "OrOpenLink"
  -- variant keeps Ctrl-click link opening on a plain click.
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection',
  },
  -- Double-click (word) and triple-click (line) selections copy too.
  {
    event = { Up = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  {
    event = { Up = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- Right-click pastes. Bound on the press so it feels immediate.
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  -- Swallow the matching release so it does not reach the application.
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.Nop,
  },
}

return config

