---------------------------
--   Basic Steel Theme   --
---------------------------
local config = require("../config")

theme = {}

theme.font = " NotoSansMono Nerd Font 14"

theme.bg_normal = "#080C18"
theme.fg_normal = "#F0F2FA"

theme.bg_focus = "#334DA0"
theme.fg_focus = theme.fg_normal

theme.bg_urgent = "#EF946C"
theme.fg_urgent = "#dddddd"

theme.bg_minimize = "#b6aefd" -- #A3C3D9"
theme.fg_minimize = "#0f0283" -- "#214697"

theme.bg_systray = theme.bg_normal

theme.border_normal = "#333333"
theme.border_focus = theme.bg_focus
theme.border_width = 3
theme.border_marked = "#91231c"

theme.taglist_fg = theme.fg_focus
theme.taglist_bg_empty = "#D1DDF5"
theme.taglist_bg_occupied = "#678CDE"

theme.taglist_bg_hover = theme.fg_normal

--theme.taglist_fg_empty = "#cccccc"
--theme.taglist_fg_occupied = "#A2E3C4"

-- theme.taglist_circle = "#f9b3a0"

-- Status colors (cpu, mem, net use)
color_relax = "#33BD06"
color_walk = "#DBC900"
color_run = "#ff7633"
color_limit = "#ff0000"

color_relax_ = "33BD06"
color_walk_ = "DBC900"
color_run_ = "ff7633"
color_limit_ = "ff0000"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
--theme.tasklist_bg_focus = "#ff0000"

-- Display the taglist squares
-- theme.taglist_squares_sel = "/usr/share/awesome/themes/default/taglist/squarefw.png"
-- theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 15
theme.menu_width = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive =
    "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive =
    "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive =
    "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

--theme.wallpaper = "/usr/share/awesome/themes/default/backgund.png"
--theme.wallpaper = "/home/jinn/medien/pix/walls/1432698902716.jpg"
--theme.wallpaper = "/home/jinn/medien/pix/walls/1432452362423.jpg"
--theme.wallpaper = "/home/jinn/medien/pix/walls/1432686359104.jpg"
theme.wallpaper = config.home .. ".walls/blue-tiger.jpg"
theme.wallpaper_vertical = config.home .. ".walls/moon_vertical.png"

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.icon = {}
theme.icon.mail = config.iconPath .. "mail.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
