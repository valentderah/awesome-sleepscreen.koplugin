local Build = require("banner.widgets.highlight.build")

local M = {}

function M.attach(Registry)
    Registry.register("highlight", function(params, ctx)
        return Build.build(params, ctx)
    end)
end

return M
