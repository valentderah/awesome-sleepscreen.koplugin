local Build = require("banner.widgets.battery_status.build")

local M = {}

function M.attach(Registry)
    Registry.register("battery_status", function(params, ctx)
        return Build.build(params, ctx)
    end, { needs_sleep_refresh = true })
end

return M
