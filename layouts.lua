local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
