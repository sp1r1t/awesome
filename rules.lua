local awful = require('awful')
local beautiful = require('beautiful')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false -- https://stackoverflow.com/questions/28369999/awesome-wm-terminal-window-doesnt-take-full-space
                     ,} },

    { rule = { class = "MPlayer" },
      properties = { floating = true, switchtotag=true } },

      -- { rule = { class = "Emacs" },
      -- properties = { tag = tags[1][3], switchtotag=true } },

      -- { rule = { class = "Firefox" },
      -- properties = { tag = tags[1][2], swtichtotag=true} },

      -- { rule = { class = "Code" },
      -- properties = { tag = tags[2][4], swtichtotag=true} },

    --   { rule = { class = "pinentry" },
    --     properties = { floating = true, switchtotag=true } },

    -- { rule = { class = "Thunderbird" },
    --   properties = { tag = tags[1][3], switchtotag=true } },

    -- { rule = { class = "Nemo" },
    --   properties = { tag = tags[1][4], switchtotag=true} },

    -- { rule = { class = "libreoffice-calc" },
    --   properties = { tag = tags[1][5], switchtotag=true } },

    -- { rule = { class = "Gimp-2.8" },
    --   properties = { tag = tags[1][6], floating = true, switchtotag=true } },

    -- { rule = { class = "rootTerm" },
    --   properties = { tag = tags[1][13], switchtotag=true } },

    -- { rule = { class = "luakit" },
    --   properties = { tag = tags[1][6], switchtotag=true } },
    --   { rule = { class = "Chromium" },
    --     properties = { tag = tags[1][3], switchtotag=true } },
    --   { rule = { class = "chromium" },
    --     properties = { tag = tags[1][3], switchtotag=true } },
 }