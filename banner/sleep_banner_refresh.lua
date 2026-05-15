--[[ Single chain of UIManager:scheduleIn to refresh sleep banner content. ]]
local UIManager = require("ui/uimanager")

local M = {}

local tick_action

function M.stop()
    if tick_action then
        UIManager:unschedule(tick_action)
        tick_action = nil
    end
end

---@param opts table { interval_sec = number, screensaver_widget = widget, on_tick = function() }
function M.start(opts)
    M.stop()
    local interval = tonumber(opts.interval_sec) or 0
    if interval <= 0 then
        return
    end
    local ss = opts.screensaver_widget
    local on_tick = opts.on_tick
    tick_action = function()
        if not ss or not UIManager:isWidgetShown(ss) then
            tick_action = nil
            return
        end
        on_tick()
        UIManager:scheduleIn(interval, tick_action)
    end
    UIManager:scheduleIn(interval, tick_action)
end

return M
