local Build = require("banner.widgets.template.build")

local M = {}

function M.attach(Registry)
    Registry.register("template", function(params, ctx)
        return Build.build(params, ctx)
    end)
end

return M
