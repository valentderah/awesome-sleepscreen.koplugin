local Build = require("banner.widgets.today_reading.build")

local M = {}

function M.attach(Registry)
    Registry.register("today_reading", function(params, ctx)
        return Build.build(params, ctx)
    end)
end

return M
