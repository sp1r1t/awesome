-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
require("utils")
require("helper")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults.font = beautiful.font or "Verdana 13"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.max_height = 200
naughty.config.defaults.icon_size = 50

local menubar = require("menubar")

-- Vicious
local vicious = require("vicious")

-- Filehandle
--local filehandle = require("filehandle")

-- Load configuration file
local config = require("config")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify(
      {
         preset = naughty.config.presets.critical,
         title = "Oops, there were errors during startup!",
         text = awesome.startup_errors
      }
   )
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal(
      "debug::error",
      function(err)
         -- Make sure we don't go into an endless error loop
         if in_error then
            return
         end
         in_error = true

         naughty.notify(
            {
               preset = naughty.config.presets.critical,
               title = "Oops, an error happened in rc.lua!",
               text = err
            }
         )
         in_error = false
      end
   )
end


---[[ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/sky/theme.lua")
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--beautiful.init("~/.config/awesome/themes/done-and-there.lua")
-- beautiful.init("~/.config/awesome/themes/easy-rise-theme.lua")
--beautiful.init("~/.config/awesome/themes/ghost-theme.lua")
beautiful.init("~/.config/awesome/themes/basic-steel.lua")

-- Setup screens
awful.spawn.with_shell("~/.config/awesome/scripts/screensetup.sh")

-- Autostart
awful.spawn.with_shell("picom")

-- Wallpaper
awful.spawn.with_shell("nitrogen --restore")
-- require("wallpaper")

-- App folders define where the menubar (strg+p) searches for applications
app_folders = {"/usr/share/applications/", "~/.local/share/applications/", "~/skripte", "~/.bin", "~/bin"}


-- start composition manager
--awful.spawn_with_shell("xcompmgr -cF &")


-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "emacsclient -c"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- load layouts
require("layouts")

---[[ Tags
-- Define a tag table which hold all screen tags.
tags = {}

-- individual tag settings
tagnames = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
-- names = {"", "", "", "", "", ""};
icons = {
   "world.svg",
   "coding64.png",
   "edit64.png",
   "terminal.png",
   "",
   "",
   "",
   "",
   "",
   "",
   "mail.png",
}

for s = 1, screen.count() do
   -- Each screen has its own tag table.
   -- orig: tags[s] = awful.tag.new({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
   -- tags[s] = awful.tag.new({ "`", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "=", "<-" }, s, layouts[1])
   tags[s] = {}
   local layout = function(s)
      if screen[s].geometry.width >= screen[s].geometry.height then
         return awful.layout.suit.tile
      else
         return awful.layout.suit.tile.bottom
      end
   end

   for t = 1, #tagnames do
      options = {
         layout = layout(s),
         icon = icons[t] and config.iconPath .. icons[t],
         screen = s,
         gap_single_client = false,
         gap = 5,
         selected = t == 1 or false
      }

      tags[s][t] = awful.tag.add(tagnames[t], options)
   end
end

swap_screens = function()
   local screencount = screen.count()
   local mousecoords = mouse.coords()

   if (screencount == 2) then
      local tagActive = client.focus and client.focus.first_tag or nil
      local clientsActive = tagActive:clients()

      if tagActive then
         local tagInactive
         local clientsInactive
         if (tagActive.screen == screen[1]) then
            tagInactive = screen[2].selected_tag
            clientsInactive = tagInactive:clients()
         elseif (tagActive.screen == screen[2]) then
            tagInactive = screen[1].selected_tag
            clientsInactive = tagInactive:clients()
         end

         for idx, client in pairs(clientsActive) do
            client:move_to_screen() -- cycle to next screen
         end
         for idx, client in pairs(clientsInactive) do
            client:move_to_screen()
         end

         mouse.coords(mousecoords) -- keep mouse where it is
      end
   end
end

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   {"manual", terminal .. " -e man awesome"},
   {"edit config", editor_cmd .. " " .. awesome.conffile},
   {"restart", awesome.restart},
   {"quit", awesome.quit}
}

mymainmenu =
   awful.menu(
   {
      items = {
         {"awesome", myawesomemenu, beautiful.awesome_icon},
         {"open terminal", terminal}
      }
   }
)

mylauncher =
   awful.widget.launcher(
   {
      image = beautiful.awesome_icon,
      menu = mymainmenu
   }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{ Bottom wibox
-- require("bottom-wibox")
--}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
mytextclock:connect_signal(
   "button::press",
   function()
      local client = awful.spawn.raise_or_spawn('thunderbird', {class = 'thunderbird'})
   end
)


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons =
   awful.util.table.join(
   awful.button({}, 1, awful.tag.viewonly),
   awful.button({modkey}, 1, awful.client.movetotag),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({modkey}, 3, awful.client.toggletag),
   awful.button(
      {},
      4,
      function(t)
         awful.tag.viewnext(awful.tag.getscreen(t))
      end
   ),
   awful.button(
      {},
      5,
      function(t)
         awful.tag.viewprev(awful.tag.getscreen(t))
      end
   )
)
mytasklist = {}
mytasklist.buttons =
   awful.util.table.join(
   awful.button(
      {},
      1,
      function(c)
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
      end
   ),
   awful.button(
      {},
      3,
      function()
         if instance then
            instance:hide()
            instance = nil
         else
            instance =
               awful.menu.clients(
               {
                  theme = {width = 250}
               }
            )
         end
      end
   ),
   awful.button(
      {},
      4,
      function()
         awful.client.focus.byidx(1)
         if client.focus then
            client.focus:raise()
         end
      end
   ),
   awful.button(
      {},
      5,
      function()
         awful.client.focus.byidx(-1)
         if client.focus then
            client.focus:raise()
         end
      end
   )
)

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(
      awful.util.table.join(
         awful.button(
            {},
            1,
            function()
               awful.layout.inc(layouts, 1)
            end
         ),
         awful.button(
            {},
            3,
            function()
               awful.layout.inc(layouts, -1)
            end
         ),
         awful.button(
            {},
            4,
            function()
               awful.layout.inc(layouts, 1)
            end
         ),
         awful.button(
            {},
            5,
            function()
               awful.layout.inc(layouts, -1)
            end
         )
      )
   )

   -- Create a taglist widget
   mytaglist[s] =
      awful.widget.taglist(
      {
         screen = s,
         filter = awful.widget.taglist.filter.all,
         style = {
            shape = gears.shape.rounded_rect
         },
         layout = {
            spacing = 10,
            spacing_widget = {
               color = beautiful.bg_systray,
               shape = gears.shape.rounded_rect,
               widget = wibox.widget.separator
            },
            layout = wibox.layout.fixed.horizontal
         },
         widget_template = {
            {
               {
                  {
                     {
                        {
                           id = "index_role",
                           valign = "center",
                           align = "left",
                           widget = wibox.widget.textbox
                        },
                        left = 5,
                        right = 5,
                        widget = wibox.container.margin
                     },
                     bg = beautiful.taglist_circle,
                     shape = gears.shape.circle,
                     widget = wibox.container.background
                  },
                  {
                     {
                        id = "icon_role",
                        widget = wibox.widget.imagebox
                     },
                     margins = 2,
                     widget = wibox.container.margin
                  },
                  -- {
                  --    id = "text_role",
                  --    widget = wibox.widget.textbox
                  -- },
                  layout = wibox.layout.fixed.horizontal
               },
               left = 18,
               right = 18,
               top = 5,
               bottom = 5,
               widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
               self:get_children_by_id("index_role")[1].markup =
                  "<b><span  color='" .. beautiful.taglist_fg .. "'>" .. tagnames[index] .. "</span></b>"
               self:connect_signal(
                  "mouse::enter",
                  function()
                     if self.bg ~= beautiful.taglist_bg_hover then
                        self.backup = self.bg
                        self.backup_original = self.bg
                        self.has_backup = true
                     end
                     self.bg = beautiful.taglist_bg_hover
                  end
               )
               self:connect_signal(
                  "mouse::leave",
                  function()
                     if self.has_backup then
                        self.bg = self.backup
                        self.has_backup = false
                     end
                  end
               )
               self:connect_signal(
                  "button::press",
                  function(widget, x, y, button)
                     if button == 1 then
                        if self.backup == gears.color(beautiful.bg_focus) then
                           self.backup = self.backup_original
                        else
                           self.backup = beautiful.bg_focus
                        end
                     end
                     if button == 3 then
                        self.has_backup = false
                     end
                  end
               )
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
               self:get_children_by_id("index_role")[1].markup =
                  "<b><span  color='" .. beautiful.taglist_fg .. "'>" .. tagnames[index] .. "</span></b>"
            end
         },
         buttons = mytaglist.buttons
      }
   )

   -- Create a tasklist widget
   mytasklist[s] =
      awful.widget.tasklist {
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = mytasklist.buttons,
      style = {
         shape_border_width = 1,
         shape_border_color = "#777777",
         shape = gears.shape.rounded_bar
      },
      layout = {
         spacing = 15,
         spacing_widget = {
            {
               forced_width = 5,
               shape = gears.shape.circle,
               widget = wibox.widget.separator
            },
            valign = "center",
            halign = "center",
            widget = wibox.container.place
         },
         layout = wibox.layout.flex.horizontal
      },
      -- Notice that there is *NO* wibox.wibox prefix, it is a template,
      -- not a widget instance.
      widget_template = {
         {
            {
               {
                  {
                     id = "icon_role",
                     widget = wibox.widget.imagebox
                  },
                  top = 1,
                  bottom = 4,
                  right = 5,
                  widget = wibox.container.margin
               },
               {
                  id = "text_role",
                  widget = wibox.widget.textbox
               },
               layout = wibox.layout.fixed.horizontal
            },
            left = 10,
            right = 10,
            top = 4,
            widget = wibox.container.margin
         },
         id = "background_role",
         widget = wibox.container.background
      }
   }
   --   awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)


   -- Create a vicious mem usage widget
   memwidget = wibox.widget.textbox()
   vicious.register(
      memwidget,
      vicious.widgets.mem,
      function(memwidget, args)
         local output = "M: "
         local m = args[1]
         if m > 90 then
            output = output .. "<span color='" .. color_limit .. "'>" .. lpad(m, 2) .. "</span>"
         elseif m > 50 then
            output = output .. "<span color='" .. color_run .. "'>" .. lpad(m, 2) .. "</span>"
         elseif m > 30 then
            output = output .. "<span color='" .. color_walk .. "'>" .. lpad(m, 2) .. "</span>"
         else
            output = output .. "<span color='" .. color_relax .. "'>" .. lpad(m, 2) .. "</span>"
         end
         output = output .. "%  "
         return output
      end,
      13
   )

   -- Create a vicious cpu usage widget
   cpuwidget = wibox.widget.textbox()
   vicious.register(
      cpuwidget,
      vicious.widgets.cpu,
      function(cpuwidget, args)
         local output = "C: "
         for i, c in pairs(args) do
            if i == 1 then
            elseif c > 90 then
               output = output .. "<span color='" .. color_limit .. "'>" .. lpad(c, 3) .. "</span> "
            elseif c > 50 then
               output = output .. "<span color='" .. color_run .. "'>" .. lpad(c, 3)  .. "</span> "
            elseif c > 30 then
               output = output .. "<span color='" .. color_walk .. "'>" .. lpad(c, 3) .. "</span> "
            else
               output = output .. "<span color='" .. color_relax .. "'>" .. lpad(c, 3) .. "</span> "
            end
         end
         output = output .. "  "
         return output
      end
   )

   -- Create a vicous battery widget
   batwidget = wibox.widget.textbox()
   vicious.register(
      batwidget,
      vicious.widgets.bat,
      function(batwidget, args)
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

         if bat > 0 then
            output = output .. col(bat, color) .. ", " .. col(time, color)
         else
            output = ""
         end
         return output
      end,
      10,
      "BAT0"
   )

   -- Create a vicous notmuch widget
   notmuchwidget = wibox.widget.textbox()
   vicious.register(
      notmuchwidget,
      vicious.widgets.notmuch,
      function(widget, args)
         return tostring(args.count)
      end,
      100,
      "tag:unread"
   )

   notmuchicon = wibox.widget.imagebox(beautiful.icon.mail)
   notmuchicon:connect_signal(
      "button::press",
      function(c)
         local notmuchrunning = false
         for s = 1, screen.count() do
            for k, c in pairs(screen[s].all_clients) do
               if c.name == "notmuch" then
                  notmuchrunning = true
                  awful.tag.viewtoggle(c.first_tag)
               end
            end
         end
         if not notmuchrunning then
            awful.spawn(
               "emacs -f notmuch",
               {
                  name = "notmuch",
                  tag = screen[1].tags[11]
               }
            )
         end
      end
   )

   -- Create a vicous net widget
   netwidget = wibox.widget.textbox()
   vicious.register(
      netwidget,
      vicious.widgets.net,
      " ↑${" .. config.netInterface .. " up_kb} ↓${" .. config.netInterface .. " down_kb} "
   )

   -- Create a vicous weather widget
   weatherwidget = wibox.widget.textbox()
   vicious.register(
      weatherwidget,
      vicious.widgets.weather,
      function(widget, args)
         return " " .. args["{tempc}"] .. "° "
      end,
      1200,
      "LOWW"
   )

   -- Create the wibox
   mywibox[s] =
      awful.wibox({position = "top", screen = s, border_width = "5", border_color = beautiful.bg_normal, height = 35})

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   --left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(mypromptbox[s])

   -- Widgets that are aligned to the center
   local center_layout = wibox.layout.align.horizontal()
   center_layout.expand = "outside"

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()

   -- Add info widgets only to primary screen
   if screen[s] == screen.primary then
      center_layout:set_middle(mytextclock)
      right_layout:add(cpuwidget)
      right_layout:add(memwidget)
      right_layout:add(batwidget)
      right_layout:add(netwidget)
      -- right_layout:add(notmuchicon)
      -- right_layout:add(notmuchwidget)
      right_layout:add(weatherwidget)
      right_layout:add(wibox.widget.systray())
   end
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(center_layout)
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)

   -- bottom tasklist
   mywibox_bottom = {}
   mywibox_bottom[s] = awful.wibox({position = "bottom", screen = s, height = 30, bg = "##"})
   mywibox_bottom[s]:set_widget(mytasklist[s])
end
-- }}}

-- set keybindings
require("keybindings")

-- set client rules
--   also set client keybindings
require("clientrules")

-- {{{ Signals
function manageclient(c, startup)
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

   -- Enable sloppy focus ( = switch focus with mouse without click )
   c:connect_signal(
      "mouse::enter",
      function(c)
         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
            client.focus = c
         end
      end
   )

   local titlebars_enabled = false
   if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
      -- buttons for the titlebar
      local buttons =
         awful.util.table.join(
         awful.button(
            {},
            1,
            function()
               client.focus = c
               c:raise()
               awful.mouse.client.move(c)
            end
         ),
         awful.button(
            {},
            3,
            function()
               client.focus = c
               c:raise()
               awful.mouse.client.resize(c)
            end
         )
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

client.connect_signal(
   "focus",
   function(c)
      c.border_color = beautiful.border_focus
      c.opacity = 1
   end
)
client.connect_signal(
   "unfocus",
   function(c)
      c.border_color = beautiful.border_normal
      c.opacity = 0.8
   end
)
-- }}}

-- Apply rounded corners to clients if needed
-- if beautiful.border_radius and beautiful.border_radius > 0 then
--    note("rounding corners")
--    -- No rounded corners if there is only one client
--    screen.connect_signal(
--       "arrange",
--       function(s)
--          local only_one_tiled = #s.tiled_clients == 1
--          for _, c in pairs(s.clients) do
--             if (only_one_tiled or c.maximized or c.fullscreen) and not c.floating then
--                c.shape = gears.shape.rectangle
--             else
--                c.shape = rrect(beautiful.border_radius)
--             end
--          end
--       end
--    )

--    beautiful.snap_shape = rrect(beautiful.border_radius * 2)
-- else
--    beautiful.snap_shape = gears.shape.rectangle
-- end

-- mcabber notification profiles
naughty.config.presets.msg = {
   bg = "#000000",
   fg = "#ffffff",
   timeout = 10,
   hover_timeout = 0
}
naughty.config.presets.online = {
   bg = "#1f880e80",
   fg = "#ffffff"
}
naughty.config.presets.chat = naughty.config.presets.online
naughty.config.presets.away = {
   bg = "#eb4b1380",
   fg = "#ffffff"
}
naughty.config.presets.xa = {
   bg = "#65000080",
   fg = "#ffffff"
}
naughty.config.presets.dnd = {
   bg = "#65340080",
   fg = "#ffffff"
}
naughty.config.presets.invisible = {
   bg = "#ffffff80",
   fg = "#000000"
}
naughty.config.presets.offline = {
   bg = "#64636380",
   fg = "#ffffff"
}
naughty.config.presets.requested = naughty.config.presets.offline
naughty.config.presets.error = {
   bg = "#ff000080",
   fg = "#ffffff"
}

-- mcabber notification handler
muc_nick = "ree5"

function mcabber_event_hook(kind, direction, jid, msg)
   if kind == "MSG" then
      if direction == "IN" or direction == "MUC" then
         local filehandle = io.open(msg)
         local txt = filehandle:read("*all")
         filehandle:close()
         awful.spawn("rm " .. msg)
         if direction == "MUC" and txt:match("^<" .. muc_nick .. ">") then
            return
         end
         naughty.notify {
            preset = naughty.config.presets.msg,
            icon = "chat_msg_recv",
            text = awful.util.escape(txt),
            title = jid
         }
      end
   elseif kind == "STATUS" then
      local mapping = {
         ["O"] = "online",
         ["F"] = "chat",
         ["A"] = "away",
         ["N"] = "xa",
         ["D"] = "dnd",
         ["I"] = "invisible",
         ["_"] = "offline",
         ["?"] = "error",
         ["X"] = "requested"
      }
      local status = mapping[direction]
      local iconstatus = status
      if not status then
         status = "error"
      end
      if jid:match("icq") then
         iconstatus = "icq/" .. status
      end
      naughty.notify {
         preset = naughty.config.presets[status],
         text = jid .. " went " .. status,
         icon = iconstatus
      }
   end
end

-- Autorun programs
autorun = true

autorunApps = {
   {"dropbox", { class = ""}},
   {"guake --hide", {class = "Guake"}},
   -- {"emacsclient -c", { class = "Emacs" }},
   -- "/usr/bin/bash " .. config.home .. ".xinitrc",
   {"firefox", { class = "firefox"}},
   {"kdeconnect-app", { class = "kdeconnect.app" }},
   {"kdeconnect-sms", { class = "kdeconnect.sms" }},
   -- "code"
}

if autorun then
   for index = 1, #autorunApps do
      local app = autorunApps[index]
      local rules = { class = "" }
      if type(app) == "table" then
         rules = app[2]
         app = app[1]
      end

      local matcher = function (c)
         return awful.rules.match(c, rules)
      end,

      awful.spawn.single_instance(app, awful.rules.rules, matcher, nil)

      naughty.notify {
         text = app .. " started "
      }
   end
end


awful.util.spawn_with_shell("~/.config/awesome/scripts/autorun.sh")
