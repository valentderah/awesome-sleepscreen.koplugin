local Register = require("banner.widgets.battery_status.register")

return {
    attach = function(Registry)
        Register.attach(Registry)
    end,
}
