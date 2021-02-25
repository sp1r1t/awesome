-- Standard awesome library
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Vicious
local vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

-- {{{ Wibox
-- Define variables

-- colors
color_green = "#33BD06"
color_yellow = "#DBC900"
color_orange = "#ff7633"
color_red = "#ff0000"

--local highlight = "#3988ff"
local highlight = "#444"
local con = "<span color='" .. highlight .. "'>" -- switch highlight color on
local con_gr = "<span color='" .. color_green .. "'>" -- switch green color on
local con_ye = "<span color='" .. color_yellow .. "'>" -- switch yellow color on
local con_or = "<span color='" .. color_orange .. "'>" -- switch orange color on
local con_re = "<span color='" .. color_red .. "'>" -- switch red color on
local coff = "</span>" -- switch highlight color off
wifi0_on = false
net0_on = false

-- Create a wibox for each screen and add it
mywibox_bottom = {}

for s = 1, screen.count() do

   -- Create my Vicious ip widget for wifi (sets the wifi0_on variable used by the wifi and net usage widgets,
   -- so this need to be run first!)
--[[   ipwidget_wifi = wibox.widget.textbox()
   vicious.register(ipwidget_wifi, vicious.widgets.ip, 
                    function (ipwidget_wifi, args)
                       if args["{up}"] == 1 then
                          wifi0_on = true
                          return "addr: " .. con .. args['{addr}'] .. coff .. " gw:" .. con .. args['{gw}'].. coff .. " "
                       else
                          wifi0_on = false
                          return "wifi0 down ||  "
                       end
                    end
                    , 3, "wifi0")
   
   -- Create my Vicious ip widget for ether
   ipwidget_ether = wibox.widget.textbox()
   vicious.register(ipwidget_ether, vicious.widgets.ip, 
                    function (ipwidget_ether, args)
                       if args["{up}"] == 1 then
                          net0_on = true
                          return "net0 addr:" .. con .. args['{addr}'] .. coff .. " gw:" .. con .. args['{gw}'].. coff .. " "
                       else
                          net0_on = false
                          return "net0 down ||  "
                       end
                    end
                    , 3, "net0")
   

]]--
   -- Create Vicious wifi widget
   wifiwidget = wibox.widget.textbox()
   vicious.register(wifiwidget, vicious.widgets.wifi, 
                    function (wifiwidget, args)
                       -- if not wifi0_on then
                       --    return ""
                       -- end
                       return "wifi0: " .. con .. args['{ssid}']  .. coff .. " "
                    end
                    , 3, "wifi0")

   -- Create a vicious net usage widget for wifi
   netwidget_wifi0 = wibox.widget.textbox()
   vicious.register(netwidget_wifi0, vicious.widgets.net, 
                    function (netwidget_wifi0, args)
                       -- if not wifi0_on then
                       --    return ""
                       -- end
                       
                       local output = ""
                       local values = { args['{wifi0 up_kb}'], args['{wifi0 down_kb}'] }
                       for i, v in pairs(values) do
                          if tonumber(v) > 700 then
                             output = output .. con_re .. v .. coff
                          elseif tonumber(v) > 400 then
                             output = output .. con_or .. v .. coff
                          elseif tonumber(v) > 100 then
                             output = output .. con_ye .. v .. coff
                          elseif tonumber(v) > 0 then
                             output = output .. con_gr .. v .. coff
                          else
                             output = output .. con .. v .. coff
                          end
                          if next(values,i) ~= nil then
                             output = output .. "/"
                          end
                       end
                       return output
                    end
   ,1)

   -- -- Create a vicious net usage widget for ether
   -- netwidget_net0 = wibox.widget.textbox()
   -- vicious.register(netwidget_net0, vicious.widgets.net, 
   --                  function (netwidget_net0, args)
   --                     if not net0_on then
   --                        return ""
   --                     end
                       
   --                     local output = "use: "
   --                     local values = { args['{net0 up_kb}'], args['{net0 down_kb}'] }
   --                     for i, v in pairs(values) do
   --                        if tonumber(v) > 700 then
   --                           output = output .. con_re .. v .. coff
   --                        elseif tonumber(v) > 400 then
   --                           output = output .. con_or .. v .. coff
   --                        elseif tonumber(v) > 100 then
   --                           output = output .. con_ye .. v .. coff
   --                        elseif tonumber(v) > 0 then
   --                           output = output .. con_gr .. v .. coff
   --                        else
   --                           output = output .. con .. v .. coff
   --                        end
   --                        if next(values,i) ~= nil then
   --                           output = output .. "/"
   --                        end
   --                     end
   --                     return output .. " ||  "
   --                  end
   --                  ,1)

   -- new net widget
   netbox = wibox.widget.textbox()
   vicious.register(netbox, vicious.widgets.net, "wifi0: ${wifi0 up_kb}/${wifi0 down_kb}")

   
   -- create Volume widget
   volumewidget = wibox.widget.textbox()
   vicious.register(volumewidget, vicious.widgets.volume,

                    function(volumewidget, args)

                       output = args[1] .. " " .. args[2] .. "  ||  "
                       return output
                    end
                    , 2, "Master")


   -- create hdd temp widget
   tempwidget = wibox.widget.textbox()
   vicious.register(tempwidget, vicious.widgets.hddtemp,
                    function(tempwidget, args)
                       if args['{/dev/sde}'] ~= nil then
                          temp = args['{/dev/sde}']
                       else
                          temp = "N/A"
                       end
                      output = "/dev/sda: " .. con .. temp .. "°" .. coff .. "  ||  "
                      return output
                   end
                   , 10
   )

   -- create fs widget
   fswidget = wibox.widget.textbox()
   vicious.register(fswidget, vicious.widgets.fs,
                   function(fswidget, args)
                      output = "/: " .. con .. args['{/ avail_gb}'] .. "GB" .. coff .. "  ||  "
                      output = output .. "/home: " .. con .. args['{/home avail_gb}'] .. "GB" .. coff .. "  ||  "

                      return output
                   end
                   , 10
   )

   -- create gmail widget
   gmailwidget = wibox.widget.textbox()
   vicious.register(gmailwidget, vicious.widgets.gmail,
                   function(gmailwidget, args)
                      return "mails: " .. con .. args['{count}'] .. coff .. "  ||  "
                   end
                   , 10
   )

   -- create pkg widget
   pkgwidget = wibox.widget.textbox()
   vicious.register(pkgwidget, vicious.widgets.pkg,
                   function(pkgwidget, args)
                      return "updates: " .. con .. args[1] .. coff .. "  ||  "
                   end
                   , 10, "Arch"
   )

   -- create kbd layout widget
--[[   kbdlayoutwidget = wibox.widget.textbox()
   vicious.register(kbdlayoutwidget, vicious.widgets.kbdlayout,
                    function(kbdlayoutwidget, args)
                       return args[1] .. "  ||  "
                    end
                    ,1
   )
]]--
   -- Create the wibox
   mywibox_bottom[s] = awful.wibox({ position = "bottom", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   --left_layout:add(netbox)
   left_layout:add(wifiwidget)   
   --left_layout:add(ipwidget_wifi)
   left_layout:add(netwidget_wifi0)
   --left_layout:add(ipwidget_ether)
   --left_layout:add(netwidget_net0)

   -- Widgets in the middle
   local middle_layout = wibox.layout.fixed.horizontal()

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(tempwidget)
   right_layout:add(fswidget)
   right_layout:add(pkgwidget)
   right_layout:add(gmailwidget)
   right_layout:add(volumewidget)
   --right_layout:add(kbdlayoutwidget)

   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(middle_layout)
   layout:set_right(right_layout)

   mywibox_bottom[s]:set_widget(layout)
end


   -- }}}
