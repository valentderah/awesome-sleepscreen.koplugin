local Build = require("banner.widgets.clock_analog.build")

local M = {}

function M.attach(Registry)
    Registry.register("clock_analog", function(params, ctx)
        return Build.build(params, ctx)
    end, { needs_sleep_refresh = true })
end

return M
