local gears = require("gears")
local beautiful = require("beautiful")
require("utils")

-- {{{ Wallpaper
local function set_wallpaper()
   -- Wallpaper
   if beautiful.wallpaper then
      for s = 1, screen.count() do
         note("doing wallpaper for screen " .. s)
         local wallpaper
         if screen[s].geometry.width >= screen[s].geometry.height then
            wallpaper = beautiful.wallpaper
         else
            wallpaper = beautiful.wallpaper_vertical
         end
         -- If wallpaper is a function, call it with the screen
         if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
         end
         gears.wallpaper.maximized(wallpaper, s, true)
      end
   end
end

set_wallpaper()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}
