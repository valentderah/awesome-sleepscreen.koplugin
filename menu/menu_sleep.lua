local TextViewer = require("ui/widget/textviewer")
local UIManager = require("ui/uimanager")

local Settings = require("settings")

local MenuLayout = require("menu.menu_layout")
local placeholder_help = require("placeholders")

local _ = require("l10n").gettext

local MenuSleep = {}

function MenuSleep.buildEnableToggleEntry()
    require("l10n").load()
    return {
        text = _("Sleepscreen widgets"),
        help_text = _("When ON, replaces the sleep-screen banner with the 6×3 grid layout when KOReader uses Banner message mode."),
        checked_func = function()
            return Settings:isPluginEnabled()
        end,
        callback = function()
            Settings:setPluginEnabled(not Settings:isPluginEnabled())
        end,
    }
end

function MenuSleep.buildHelpEntry()
    require("l10n").load()
    return {
        text = _("Template widget codes"),
        callback = function()
            local body = placeholder_help(_)
            UIManager:show(TextViewer:new{
                title = _("Template widget codes"),
                text = body,
                justified = false,
                alignment = "left",
            })
        end,
    }
end

--- All plugin entries: enable, grid editor, settings, template help (under one submenu).
function MenuSleep.buildSleepscreenwidgetsSubmenu(_plugin_inst)
    require("l10n").load()
    local items = {
        MenuSleep.buildEnableToggleEntry(),
    }
    local mid = MenuLayout.buildGridAndSettingsEntries()
    for i = 1, #mid do
        table.insert(items, mid[i])
    end
    table.insert(items, MenuSleep.buildHelpEntry())
    return items
end

function MenuSleep.buildSleepscreenwidgetsRootEntry(plugin_inst)
    require("l10n").load()
    return {
        text = _("Sleepscreen widgets"),
        separator = true,
        sub_item_table_func = function()
            return MenuSleep.buildSleepscreenwidgetsSubmenu(plugin_inst)
        end,
    }
end

function MenuSleep.buildFallbackCombinedEntry(plugin_inst)
    return MenuSleep.buildSleepscreenwidgetsRootEntry(plugin_inst)
end

return MenuSleep
