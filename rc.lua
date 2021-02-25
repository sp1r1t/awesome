-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults.font             = beautiful.font or "Verdana 13"
naughty.config.defaults.position         = "top_right"
naughty.config.defaults.max_height = 200
naughty.config.defaults.icon_size = 50

local menubar = require("menubar")

-- Vicious
local vicious = require("vicious")

-- Filehandle
--local filehandle = require("filehandle")

-- Load configuration file
-- local config = require('config')

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened in rc.lua!",
                                              text = err })
                             in_error = false
   end)
end


---[[ Helper function definitions
function col (text, color)
   return "<span color='#" .. color .. "'>" .. text .. "</span>"
end

-- Prints a naughtify dialog without timeout (for debugging)
function note (s)
   naughty.notify({ preset = naughty.config.presets.debug,
                    title = "Test Suit",
                    text = tostring(s)
   })
end
--]]



---[[ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/sky/theme.lua")
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("~/.config/awesome/themes/easy-rise-theme.lua")
--beautiful.init("~/.config/awesome/themes/done-and-there.lua")
--beautiful.init("~/.config/awesome/themes/ghost-theme.lua")

-- App folders define where the menubar (strg+p) searches for applications
app_folders = {"/usr/share/applications/", "~/.local/share/applications/"}


-- require('wallpaper')

-- start composition manager
--awful.spawn_with_shell("xcompmgr -cF &")

-- This is used later as the default terminal and editor to run.
terminal = "uxterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
   {
      --awful.layout.suit.floating,
      awful.layout.suit.tile,
      --awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      --awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      --awful.layout.suit.fair.horizontal,
      --awful.layout.suit.spiral,
      --awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      --awful.layout.suit.max.fullscreen,
      --awful.layout.suit.magnifier
   }

-- }}}



---[[ Tags
-- Define a tag table which hold all screen tags.
tags = {}

-- individual tag settings
names = {"`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "<-"}
-- names = {"", "", "", "", "", ""};
-- icons = {"tiger64.png", "world.svg", "edit64.png", "coding64.png", "coding64.png", "music64.png"}


for s = 1, screen.count() do
   -- Each screen has its own tag table.
   -- orig: tags[s] = awful.tag.new({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
   -- tags[s] = awful.tag.new({ "`", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "=", "<-" }, s, layouts[1])
   tags[s] = {}
   for t = 1, # names do
      options = {
         layout = awful.layout.suit.tile,
         --icon = config.iconPath .. icons[t],
         screen = s,
         gap_single_client = false,
         gap = 5,
         selected = t == 1 or false
      }

      tags[s][t] = awful.tag.add(names[t], options)
   end
end

swap_screens = function ()
   if (screen.count() == 2) then
      note(screen.count())
      t = client.focus and client.focus.first_tag or nil
      if t then
         if (t.screen == screen[1]) then
            t.screen = screen[2]
         elseif (t.screen == screen[2]) then
            t.screen = screen[1]
         end
      end
   end
end

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({
   items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{ Bottom wibox
-- require("bottom-wibox")
--}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
                   if c == client.focus then
                      c.minimized = true
                   else
                      -- Without this, the following
                      -- :isvisible() makes no sense
                      c.minimized = false
                      if not c:isvisible() then
                         awful.tag.viewonly(c:tags()[1])
                      end
                      -- This will also un-minimize
                      -- the client, if needed
                      client.focus = c
                      c:raise()
                   end
   end),
   awful.button({ }, 3, function ()
                   if instance then
                      instance:hide()
                      instance = nil
                   else
                      instance = awful.menu.clients({
                                                       theme = { width = 250 }
                      })
                   end
   end),
   awful.button({ }, 4, function ()
                   awful.client.focus.byidx(1)
                   if client.focus then client.focus:raise() end
   end),
   awful.button({ }, 5, function ()
                   awful.client.focus.byidx(-1)
                   if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create a vicious mem usage widget
   memwidget = wibox.widget.textbox()
      vicious.register(memwidget, vicious.widgets.mem,
                    function (memwidget, args)
                       local output = "M: "
                       local m = args[1]
                       if m > 90 then
                          output = output .. "<span color='" .. color_limit .. "'>" .. m .. "</span>"
                       elseif m > 50 then
                          output = output .. "<span color='" .. color_run .. "'>" .. m .. "</span>"
                       elseif m > 30 then
                          output = output .. "<span color='" .. color_walk .. "'>" .. m .. "</span>"
                       else
                          output = output .. "<span color='" .. color_relax .. "'>" .. m .. "</span>"
                       end
                       output = output .. "%  "
                       return output
                    end
                    , 13)

   -- Create a vicious cpu usage widget
   cpuwidget = wibox.widget.textbox()
   vicious.register(cpuwidget, vicious.widgets.cpu,
                    function (cpuwidget, args)
                       local output = "C: "
                       for i, c in pairs(args) do
                          if i == 1 then
                          elseif c > 90 then
                             output = output .. "<span color='".. color_limit .. "'>" .. c .. "</span> "
                          elseif c > 50 then
                             output = output .. "<span color='" .. color_run .. "'>" .. c .. "</span> "
                          elseif c > 30 then
                             output = output .. "<span color='" .. color_walk .. "'>" .. c .. "</span> "
                          else
                             output = output .. "<span color='" .. color_relax .. "'>" .. c .. "</span> "

                          end
                       end
                       output = output .. "  "
                       return output
                    end
   )

   -- Create a vicous battery widget
   batwidget = wibox.widget.textbox()
   vicious.register(batwidget, vicious.widgets.bat,
                    function (batwidget, args)
                       local state = args[1]
                       local bat = args[2]
                       local time = args[3]
                       local output = "B: " .. state .. ", "
                       local color
                       if state ~= "−" then
                         color = "3988ff"
                       elseif bat > 60 then
                          color = color_relax_
                       elseif bat > 40 then
                          color = color_walk_
                       elseif bat > 20 then
                          color = color_run_
                       else
                          color = color_limit_
                       end
                       output = output .. col(bat, color) .. ", " ..
                          col(time, color)

                       return output
                    end
                    , 10, "BAT0")

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   --left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   right_layout:add(cpuwidget)
   right_layout:add(memwidget)
   right_layout:add(batwidget)
   right_layout:add(mytextclock)
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(mytasklist[s])
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                awful.button({ }, 3, function () mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({ modkey,           }, "j",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "Tab",
             function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
   end),

   awful.key({ modkey,           }, "k",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey, "Shift"   }, "Tab",
             function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
   end),

   awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Shift"   }, "n", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Shift"   }, "p", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   --    awful.key({ modkey,           }, "Tab",
   --        function ()
   --            awful.client.focus.history.previous()
   --            if client.focus then
   --                client.focus:raise()
   --            end
   --        end),

   -- Standard program
   awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end),
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
   awful.key({ modkey, "Shift"   }, "s",      swap_screens),

   awful.key({ modkey, "Control" }, "n", awful.client.restore),

   -- Prompt
   awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen.index]:run() end),

   awful.key({ modkey }, "x",
             function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                                 mypromptbox[mouse.screen.index].widget,
                                 awful.util.eval, nil,
                                 awful.util.getdir("cache") .. "/history_eval")
   end),

   -- Menubar
   awful.key({ modkey }, "p", function() menubar.show() end),

   -- bind PrintScrn to capture a screen
   awful.key({ modkey }, "Print", function () awful.spawn("capscr",false) end),

   -- Search vor $(primary selection) in firefox
   awful.key({ modkey }, "e", function ()
      note('opening in ff')
      awful.spawn("open_primary_selection_in_ff.sh")
   end),
   -- Switch keyboard layout
   awful.key({ modkey }, "s", function () awful.spawn("swkb.sh") end)

)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey, "Shift"   }, "m",      awful.client.movetoscreen                        ),
   awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
             function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
   end),
   awful.key({ modkey,           }, "m",
             function (c)
                if c.maximized then
                   c.maximized = false
                   c.maximized_horizontal = false
                   c.maximized_vertical = false
                   c.floating = false
                else
                   c.maximized = true
                   c.maximized_horizontal = true
                   c.maximized_vertical = true
                   c.floating = true
                end
   end),
   awful.key({ modkey }, "b",
             function ()
                awful.util.spawn_with_shell("btcon.sh")
                -- mywibox[mouse.screen.index].visible = not mywibox[mouse.screen.index].visible
                -- mywibox_bottom[mouse.screen.index].visible = not mywibox_bottom[mouse.screen.index].visible
                -- naughty.notify{
                --    title = "this",
                --    text = "screen is " .. tostring(mouse.screen) .. "\n object is " ..
                --       tostring(mouse.object_under_pointer ()),
                -- }

   end)

)

-- Create tag bindings for 13 tags.
local keys = { "#49", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "#20", "#21", "#22" }
for i = 1, 14 do
   globalkeys =
      awful.util.table.join(globalkeys,
                            -- View tag only.
                            awful.key({ modkey }, keys[i],
                                      function ()
                                         local screen = mouse.screen
                                         local tag = awful.tag.gettags(screen)[i]
                                         if tag then
                                            awful.tag.viewonly(tag)
                                         end
                            end),
                            -- Toggle tag.
                            awful.key({ modkey, "Control" }, keys[i],
                                      function ()
                                         local screen = mouse.screen
                                         local tag = awful.tag.gettags(screen)[i]
                                         if tag then
                                            awful.tag.viewtoggle(tag)
                                         end
                            end),
                            -- Move client to tag.
                            awful.key({ modkey, "Shift" }, keys[i],
                                      function ()
                                         if client.focus then
                                            local tag = awful.tag.gettags(client.focus.screen)[i]
                                            if tag then
                                               awful.client.movetotag(tag)
                                            end
                                         end
                            end),
                            -- Toggle tag.
                            awful.key({ modkey, "Control", "Shift" }, keys[i],
                                      function ()
                                         if client.focus then
                                            local tag = awful.tag.gettags(client.focus.screen)[i]
                                            if tag then
                                               awful.client.toggletag(tag)
                                            end
                                         end
                            end)
)
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- load rules
require('rules')

function tsize(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- If the next client is non floating it is returned.
-- If the next client is floating, the next non floating client is returned.
function nexttiledc(client)
   client = awful.client.next(1,client)
   while awful.client.floating.get(client) do
      note ("nexttiledc: got a floater")
      client = awful.client.next(1,client)
   end
   return client
end

-- If the client is non floating it is returned.
-- If the client is floating, the next non floating client is returned.
function tiledc(client)
   while awful.client.floating.get(client) do
      note ("tiledc: got a floater")
      client = awful.client.next(1,client)
   end
   return client
end

-- {{ run or raise
local ror = require("aweror")

-- generate and add the 'run or raise' key bindings to the globalkeys table
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

root.keys(globalkeys)
-- }}

-- {{{ Signals
function manageclient(c, startup)
   naughty.notify{
      text = starup
    }
   if not startup then
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      -- awful.client.movetoscreen(c, client.focus.screen)
      awful.client.setslave(c)
      client.focus = c

      -- Put windows in a smart way, only if they do not set an initial position.
      if not c.size_hints.user_position and not c.size_hints.program_position then
         awful.placement.no_overlap(c)
         awful.placement.no_offscreen(c)
      end
   end

   --[[
   if not startup and tiledc(client.focus) then -- @2: don't run if there are no windows on the current screen
      Client Spawn Mage: spawn terminal where current focus lies and push down the rest.
      awful.client.focus.history.previous() -- reset focus to the client that was focused when spawning the new client
      local focusedc = tiledc(client.focus)

      local idx = {}
      local col = {}
      local cnt = 1
      idx[cnt] = awful.client.idx(focusedc)['idx']
      idx[2] = 0 -- for debug
      idx[3] = 0 -- for debug
      idx[4] = 0 -- for debug
      idx[5] = 0 -- for debug
      col[cnt] = awful.client.idx(focusedc)['col']
      col[2] = 9 -- for debug
      col[3] = 9 -- for debug
      col[4] = 9 -- for debug
      col[5] = 9 -- for debug

      local column = col[1]

      --local nc = awful.client.next(1,focusedc)
      local nc = nexttiledc(focusedc)

      while column == awful.client.idx(nc)['col'] and cnt < 100 do
         cnt = cnt + 1
         col[cnt] = awful.client.idx(nc)['col'] -- for debug
         idx[cnt] = awful.client.idx(nc)['idx'] -- for debug
         nc = awful.client.next(1,nc)
         --nc = nexttiledc(nc)
      end

      -- When a master column client is focused, put the newly spawned client there
      -- only if it is not the second client on the screen.
      -- In other words: If there is just one client on the screen, don't put the
      -- second one master.
      local current_screen = awful.tag.getscreen(awful.tag.selected(1))
      if column == 0 and tsize(awful.client.visible(current_screen)) > 2 then
         awful.client.setmaster(c)
      -- In the second column, new clients are spawned below the focused one.
      elseif column == 1 and cnt > 2 then
         local swt = cnt - 2

         while swt > 0 do
            awful.client.swap.bydirection("up",c)
            swt = swt - 1
         end
      end

      client.focus = c
      --]
      --[[ Debugging notes
      note ("idx: " .. idx[1] .. " " .. idx[2] .. " " .. idx[3] ..  " " .. idx[4] .. " " .. idx[5] ..
                          "\ncol: " .. col[1] .. " " .. col[2] .. " " .. col[3] ..  " " .. col[4] .. " " .. col[5] ..
                          "\ncnt: " .. cnt ..
                          "\ntsize: " .. tsize(awful.client.visible(current_screen))
      )
   end
   --]]

   -- Enable sloppy focus ( = switch focus with mouse without click )
   c:connect_signal("mouse::enter", function(c)
                       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                       and awful.client.focus.filter(c) then
                          client.focus = c
                       end
   end)

   local titlebars_enabled = false
   if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
      -- buttons for the titlebar
      local buttons = awful.util.table.join(
         awful.button({ }, 1, function()
                         client.focus = c
                         c:raise()
                         awful.mouse.client.move(c)
         end),
         awful.button({ }, 3, function()
                         client.focus = c
                         c:raise()
                         awful.mouse.client.resize(c)
         end)
      )

      -- Widgets that are aligned to the left
      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(awful.titlebar.widget.iconwidget(c))
      left_layout:buttons(buttons)

      -- Widgets that are aligned to the right
      local right_layout = wibox.layout.fixed.horizontal()
      right_layout:add(awful.titlebar.widget.floatingbutton(c))
      right_layout:add(awful.titlebar.widget.maximizedbutton(c))
      right_layout:add(awful.titlebar.widget.stickybutton(c))
      right_layout:add(awful.titlebar.widget.ontopbutton(c))
      right_layout:add(awful.titlebar.widget.closebutton(c))

      -- The title goes in the middle
      local middle_layout = wibox.layout.flex.horizontal()
      local title = awful.titlebar.widget.titlewidget(c)
      title:set_align("center")
      middle_layout:add(title)
      middle_layout:buttons(buttons)

      -- Now bring it all together
      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_right(right_layout)
      layout:set_middle(middle_layout)

      awful.titlebar(c):set_widget(layout)
   end
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", manageclient)

client.connect_signal("focus", function(c)
                         c.border_color = beautiful.border_focus
                         c.opacity = 1
end)
client.connect_signal("unfocus", function(c)
                         c.border_color = beautiful.border_normal
                         c.opacity = 0.8
end)
-- }}}

-- mcabber notification profiles
naughty.config.presets.msg = {
   bg = "#000000",
   fg = "#ffffff",
   timeout = 10,
   hover_timeout = 0,
}
naughty.config.presets.online = {
   bg = "#1f880e80",
   fg = "#ffffff",
}
naughty.config.presets.chat = naughty.config.presets.online
naughty.config.presets.away = {
    bg = "#eb4b1380",
    fg = "#ffffff",
}
naughty.config.presets.xa = {
    bg = "#65000080",
    fg = "#ffffff",
}
naughty.config.presets.dnd = {
    bg = "#65340080",
    fg = "#ffffff",
}
naughty.config.presets.invisible = {
    bg = "#ffffff80",
    fg = "#000000",
}
naughty.config.presets.offline = {
    bg = "#64636380",
    fg = "#ffffff",
}
naughty.config.presets.requested = naughty.config.presets.offline
naughty.config.presets.error = {
    bg = "#ff000080",
    fg = "#ffffff",
}

-- mcabber notification handler
muc_nick = "ree5"

function mcabber_event_hook(kind, direction, jid, msg)
    if kind == "MSG" then
        if direction == "IN" or direction == "MUC" then
            local filehandle = io.open(msg)
            local txt = filehandle:read("*all")
            filehandle:close()
            awful.spawn("rm "..msg)
            if direction == "MUC" and txt:match("^<" .. muc_nick .. ">") then
                return
            end
            naughty.notify{
               preset = naughty.config.presets.msg,
               icon = "chat_msg_recv",
               text = awful.util.escape(txt),
               title = jid
            }
        end
    elseif kind == "STATUS" then
        local mapping = {
            [ "O" ] = "online",
            [ "F" ] = "chat",
            [ "A" ] = "away",
            [ "N" ] = "xa",
            [ "D" ] = "dnd",
            [ "I" ] = "invisible",
            [ "_" ] = "offline",
            [ "?" ] = "error",
            [ "X" ] = "requested"
        }
        local status = mapping[direction]
        local iconstatus = status
        if not status then
            status = "error"
        end
        if jid:match("icq") then
            iconstatus = "icq/" .. status
        end
        naughty.notify{
            preset = naughty.config.presets[status],
            text = jid .. " went " .. status,
            icon = iconstatus
        }
    end
end

-- Autorun programs
autorun = true

autorunApps =
   {
      "dropbox",
      "barrier",
      "emacs --daemon",
      -- "/usr/bin/bash " .. config.home .. ".xinitrc",
      -- "firefox",
      -- "code"
      --      "dropbox",
      --      "barrier",
      -- "emacs --daemon",
   }

if autorun then
   for app = 1, #autorunApps do
      awful.spawn.once(autorunApps[app], nil, nil, nil)
      naughty.notify{
         text = autorunApps[app] .. " started",
      }
   end
end
