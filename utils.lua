local naughty = require("naughty")

-- Prints a naughtify dialog without timeout (for debugging)
function note(s)
    naughty.notify(
        {
            preset = naughty.config.presets.debug,
            title = "Test Suit",
            text = tostring(s)
        }
    )
end
--]]
