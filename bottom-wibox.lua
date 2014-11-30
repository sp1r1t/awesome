-- Standard awesome library
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Vicious
local vicious = require("vicious")


-- {{{ Wibox
-- Define variables
--local highlight = "#3988ff"
local highlight = "#333333"
local con = "<span color='" .. highlight .. "'>" -- switch highlight color on
local con_gr = "<span color='#83ff73'>" -- switch green color on
local con_ye = "<span color='#ffff33'>" -- switch yellow color on
local con_or = "<span color='#ff7633'>" -- switch orange color on
local con_re = "<span color='#ff0000'>" -- switch red color on
local coff = "</span>" -- switch highlight color off
wifi0_on = false
net0_on = false

-- Create a wibox for each screen and add it
mywibox_bottom = {}

for s = 1, screen.count() do
   -- Create my Vicious ip widget for wifi (sets the wifi0_on variable used by the wifi and net usage widgets,
   -- so this need to be run first!)
   ipwidget_wifi = wibox.widget.textbox()
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
   


   -- Create Vicious wifi widget
   wifiwidget = wibox.widget.textbox()
   vicious.register(wifiwidget, vicious.widgets.wifi, 
                    function (wifiwidget, args)
                       if not wifi0_on then
                          return ""
                       end
                       return "wifi0 ap:" .. con .. args['{ssid}'] .. coff .. " "
                    end
                    , 3, "wifi0")

   -- Create a vicious net usage widget for wifi
   netwidget_wifi0 = wibox.widget.textbox()
   vicious.register(netwidget_wifi0, vicious.widgets.net, 
                    function (netwidget_wifi0, args)
                       if not wifi0_on then
                          return ""
                       end
                       
                       local output = "use: "
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
                       return output .. " ||  "
                    end
   ,1)

   -- Create a vicious net usage widget for ether
   netwidget_net0 = wibox.widget.textbox()
   vicious.register(netwidget_net0, vicious.widgets.net, 
                    function (netwidget_net0, args)
                       if not net0_on then
                          return ""
                       end
                       
                       local output = "use: "
                       local values = { args['{net0 up_kb}'], args['{net0 down_kb}'] }
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
                       return output .. " ||  "
                    end
   ,1)


   -- Create the wibox
   mywibox_bottom[s] = awful.wibox({ position = "bottom", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(wifiwidget)   
   left_layout:add(ipwidget_wifi)
   left_layout:add(netwidget_wifi0)
   left_layout:add(ipwidget_ether)
   left_layout:add(netwidget_net0)

   -- Widgets in the middle
   local middle_layout = wibox.layout.fixed.horizontal()

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()

   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(middle_layout)
   layout:set_right(right_layout)

   mywibox_bottom[s]:set_widget(layout)
end
-- }}}
