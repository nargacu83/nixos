---------------------------
-- Default awesome theme --
---------------------------

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local theme = {}

theme.font          = "Cantarell Bold 10"

theme.bg_normal     = "#282a36BF"
theme.bg_focus      = "#bd93f9"
theme.bg_urgent     = "#f8f8f2"
theme.bg_occupied   = "#44475a"
theme.bg_minimize   = "#44475a"
theme.bg_systray    = "#44475a"
theme.systray_icon_spacing = 5

theme.fg_normal     = "#f8f8f2"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#f8f8f2"
theme.fg_minimize   = "#f8f8f2"

theme.taglist_shape_border_width = 2
theme.taglist_shape_border_color_focus = theme.bg_focus
theme.taglist_bg_empty = "#00000000"
theme.taglist_shape_border_color = theme.bg_occupied

theme.taglist_bg_normal = theme.bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_bg_occupied = theme.bg_occupied
theme.taglist_bg_urgent = theme.bg_urgent

theme.tasklist_bg_normal = "#00000000"
theme.tasklist_bg_focus = "#00000000"
theme.tasklist_bg_occupied = "#00000000"
theme.tasklist_bg_urgent = "#00000000"
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = false

theme.gap_single_client = true
theme.useless_gap   = dpi(2)
theme.border_width  = 2
theme.border_normal = theme.bg_occupied
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent

theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- theme.wallpaper = "~/.config/wallpaper/background.jpg"
theme.icon_theme = nil

return theme
