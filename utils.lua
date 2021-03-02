local naughty = require("naughty")

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
