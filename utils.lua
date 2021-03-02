local naughty = require("naughty")
local gears = require("gears")

--- Prints a naughtify dialog without timeout (for debugging)
function note(s)
    naughty.notify(
        {
            preset = naughty.config.presets.debug,
            text = tostring(s)
        }
    )
end

--- Return the size of a table
function tsize(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

--- Colorize
function col(text, color)
    return "<span color='#" .. color .. "'>" .. text .. "</span>"
end

--- Create rounded rectangle shape
function rrect(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end
