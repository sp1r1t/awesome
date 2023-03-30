local awful = require('awful')
local beautiful = require('beautiful')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- all clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false -- https://stackoverflow.com/questions/28369999/awesome-wm-terminal-window-doesnt-take-full-space
                     ,} },

    { rule = { class = "mplayer" },
      properties = { floating = true, switchtotag=true } },

    { rule = { class = "Guake",  },
      properties = {
        floating = true,
      },
    },
    {
      rule = { class = "kdeconnect.app" },
      properties = {
        tag = "0",
        screen = 2
      }
    },
    {
      rule = { class = "kdeconnect.sms" },
      properties = {
        tag = "0",
        screen = 2
      }
    },
    {
      rule = { class = "firefox" },
      properties = {
        tag = "1",
        screen = 1
      }
    },
    {
      rule = { class = "thunderbird" },
      properties = {
        tag = "5",
        screen = 3
      }
    },

    -- { rule = { class = "emacs" },
      -- properties = { tag = tags[1][3], switchtotag=true } },


      -- { rule = { class = "code" },
      -- properties = { tag = tags[2][4], swtichtotag=true} },

    --   { rule = { class = "pinentry" },
    --     properties = { floating = true, switchtotag=true } },

    -- { rule = { class = "thunderbird" },
    --   properties = { tag = tags[1][3], switchtotag=true } },

    -- { rule = { class = "nemo" },
    --   properties = { tag = tags[1][4], switchtotag=true} },

    -- { rule = { class = "libreoffice-calc" },
    --   properties = { tag = tags[1][5], switchtotag=true } },

    -- { rule = { class = "gimp-2.8" },
    --   properties = { tag = tags[1][6], floating = true, switchtotag=true } },

    -- { rule = { class = "rootterm" },
    --   properties = { tag = tags[1][13], switchtotag=true } },

    -- { rule = { class = "luakit" },
    --   properties = { tag = tags[1][6], switchtotag=true } },
    --   { rule = { class = "chromium" },
    --     properties = { tag = tags[1][3], switchtotag=true } },
    --   { rule = { class = "chromium" },
    --     properties = { tag = tags[1][3], switchtotag=true } },
 }
