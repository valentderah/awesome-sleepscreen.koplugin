local Build = require("banner.widgets.reading_now.build")

local M = {}

function M.attach(Registry)
    Registry.register("reading_now", function(params, ctx)
        return Build.build(params, ctx)
    end)
end

return M
