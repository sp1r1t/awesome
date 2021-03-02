local awful = require("awful")
local ror = require("aweror")
local menubar = require("menubar")
require("utils")
require("layouts")

-- {{{ global mouse bindings
globalbuttons =
    awful.util.table.join(
    awful.button(
        {},
        3,
        function()
            mymainmenu:toggle()
        end
    ),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
)

-- {{{ global key bindings
globalkeys =
    awful.util.table.join(
    awful.key({modkey}, "Left", awful.tag.viewprev),
    awful.key({modkey}, "Right", awful.tag.viewnext),
    awful.key({modkey}, "Escape", awful.tag.history.restore),
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end
    ),
    awful.key(
        {modkey},
        "Tab",
        function()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "Tab",
        function()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end
    ),
    awful.key(
        {modkey},
        "w",
        function()
            mymainmenu:show()
        end
    ),
    -- Layout manipulation
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "n",
        function()
            awful.screen.focus_relative(1)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "p",
        function()
            awful.screen.focus_relative(-1)
        end
    ),
    awful.key({modkey}, "u", awful.client.urgent.jumpto),
    --    awful.key({ modkey,           }, "Tab",
    --        function ()
    --            awful.client.focus.history.previous()
    --            if client.focus then
    --                client.focus:raise()
    --            end
    --        end),

    -- Standard program
    awful.key(
        {modkey, "Shift"},
        "Return",
        function()
            awful.spawn(terminal)
        end
    ),
    awful.key({modkey, "Control"}, "r", awesome.restart),
    awful.key({modkey, "Shift"}, "q", awesome.quit),
    awful.key(
        {modkey},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1)
        end
    ),
    awful.key(
        {modkey, "Control"},
        "h",
        function()
            awful.tag.incncol(1)
        end
    ),
    awful.key(
        {modkey, "Control"},
        "l",
        function()
            awful.tag.incncol(-1)
        end
    ),
    awful.key(
        {modkey},
        "space",
        function()
            awful.layout.inc(layouts, 1)
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "space",
        function()
            awful.layout.inc(layouts, -1)
        end
    ),
    awful.key({modkey, "Shift"}, "s", swap_screens),
    awful.key({modkey, "Control"}, "n", awful.client.restore),
    -- Prompt
    awful.key(
        {modkey},
        "r",
        function()
            mypromptbox[mouse.screen.index]:run()
        end
    ),
    awful.key(
        {modkey},
        "x",
        function()
            awful.prompt.run(
                {prompt = "Run Lua code: "},
                mypromptbox[mouse.screen.index].widget,
                awful.util.eval,
                nil,
                awful.util.getdir("cache") .. "/history_eval"
            )
        end
    ),
    -- Menubar
    awful.key(
        {modkey},
        "p",
        function()
            menubar.show()
        end
    ),
    -- bind PrintScrn to capture a screen
    awful.key(
        {modkey},
        "Print",
        function()
            awful.spawn("capscr", false)
        end
    ),
    -- Search vor $(primary selection) in firefox
    awful.key(
        {modkey},
        "e",
        function()
            note("opening in ff")
            awful.spawn("open_primary_selection_in_ff.sh")
        end
    ),
    -- Switch keyboard layout
    awful.key(
        {modkey},
        "s",
        function()
            awful.spawn("swkb.sh")
        end
    ),
    -- Paste primary selection
    awful.key(
        {modkey, "Control"},
        "p",
        function()
            awful.spawn("paste-primary-selection.sh")
        end
    ),
    awful.key(
        {modkey},
        "b",
        function()
            note("running btcon")
            awful.util.spawn_with_shell("btcon")
            -- mywibox[mouse.screen.index].visible = not mywibox[mouse.screen.index].visible
            -- mywibox_bottom[mouse.screen.index].visible = not mywibox_bottom[mouse.screen.index].visible
        end
    )
)

-- add run or raise key bindings
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

-- add tag key bindings for 13 tags.
local keys = {"#49", 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "#20", "#21", "#22"}
for i = 1, 14 do
    globalkeys =
        awful.util.table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            keys[i],
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end
        ),
        -- Toggle tag.
        awful.key(
            {modkey, "Control"},
            keys[i],
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            keys[i],
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
            end
        ),
        -- Toggle tag.
        awful.key(
            {modkey, "Control", "Shift"},
            keys[i],
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.toggletag(tag)
                    end
                end
            end
        )
    )
end

-- {{{ client mouse bindings
clientbuttons =
    awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            client.focus = c
            c:raise()
        end
    ),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize)
)

-- {{{ client key bindings
clientkeys =
    awful.util.table.join(
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
        end
    ),
    awful.key(
        {modkey, "Shift"},
        "c",
        function(c)
            c:kill()
        end
    ),
    awful.key(
        {modkey},
        "q",
        function(c)
            c:kill()
        end
    ),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle),
    awful.key(
        {modkey},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end
    ),
    awful.key({modkey, "Shift"}, "m", awful.client.movetoscreen),
    awful.key(
        {modkey, "Shift"},
        "t",
        function(c)
            c.ontop = not c.ontop
        end
    ),
    awful.key(
        {modkey, "Control"},
        "s",
        function(c)
            c.sticky = not c.sticky
        end
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end
    ),
    awful.key(
        {modkey},
        "m",
        function(c)
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
        end
    )
)

-- Set keys
root.buttons(globalbuttons)
root.keys(globalkeys)
-- client keys are set via aweful.rules in clientrules.lua
