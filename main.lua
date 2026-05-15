local WidgetContainer = require("ui/widget/container/widgetcontainer")

local Sleepscreenwidgets = WidgetContainer:extend{
    name = "sleepscreenwidgets",
    is_doc_only = false,
}

function Sleepscreenwidgets:init()
    require("l10n").load()
    local MenuHook = require("menu.menu_hook")
    local Banner = require("banner")
    MenuHook.install(self)
    Banner.install()
end

return Sleepscreenwidgets
