local Build = require("banner.widgets.header_datetime.build")

local M = {}

function M.attach(Registry)
    Registry.register("header_datetime", function(params, ctx)
        return Build.build(params, ctx)
    end, { default_col_span = 3, needs_sleep_refresh = true })
end

return M
