--[[ Grid layout + banner appearance + plugin flags in LuaSettings (sleepscreenwidgets.lua). ]]
local DataStorage = require("datastorage")
local LuaSettings = require("luasettings")
local util = require("util")

local Config = require("config")
local GridModel = require("grid.grid_model")
local Registry = require("banner.widgets.registry")

local SETTINGS_FILE = "sleepscreenwidgets.lua"

--- Types no longer supported (e.g. removed widgets); stripped whenever grid is read or saved.
local STALE_WIDGET_TYPES = { sleep_stats = true }

local Settings = {}
Settings._lua = nil

local function strip_stale_widgets(placements)
    if type(placements) ~= "table" then
        return {}
    end
    local out = {}
    for _, p in ipairs(placements) do
        if type(p) == "table" and type(p.type) == "string" and not STALE_WIDGET_TYPES[p.type] then
            table.insert(out, p)
        end
    end
    return out
end

local function sleep_refresh_default_if_missing(lua)
    if lua:readSetting("sleep_refresh_interval_sec") == nil then
        lua:saveSetting("sleep_refresh_interval_sec", Config.SLEEP_REFRESH_INTERVAL.default_sec)
    end
end

--- Span for GridModel; ensures widget types are registered first.
local function grid_span(type_id)
    Registry.ensure_registered()
    return Registry.default_col_span(type_id)
end

local function migrate_stored_settings(lua)
    local stored_version = lua:readSetting("schema_version") or 0
    if stored_version >= Config.SCHEMA_VERSION then
        return
    end
    Registry.ensure_registered()
    local raw = lua:readSetting("grid")
    local placements
    if raw == nil then
        placements = GridModel.normalizePlacements(Config.DEFAULT_GRID_PLACEMENTS, grid_span)
    else
        placements = strip_stale_widgets(GridModel.parseSaved(raw, grid_span))
    end
    lua:saveSetting("grid", GridModel.wrapSaved(placements))
    lua:saveSetting("schema_version", Config.SCHEMA_VERSION)
    sleep_refresh_default_if_missing(lua)
    lua:flush()
end

local function ensure_default_grid(lua)
    if lua:readSetting("grid") ~= nil then
        return
    end
    local placements = GridModel.normalizePlacements(Config.DEFAULT_GRID_PLACEMENTS, grid_span)
    lua:saveSetting("grid", GridModel.wrapSaved(placements))
    lua:flush()
end

function Settings:open()
    if self._lua then
        return self._lua
    end
    local dir = DataStorage:getSettingsDir()
    self._lua = LuaSettings:open(dir .. "/" .. SETTINGS_FILE)
    migrate_stored_settings(self._lua)
    ensure_default_grid(self._lua)
    return self._lua
end

function Settings:flush()
    if self._lua then
        self._lua:flush()
    end
end

function Settings:isPluginEnabled()
    return self:open():readSetting("plugin_enabled") ~= false
end

function Settings:setPluginEnabled(enabled)
    self:open():saveSetting("plugin_enabled", enabled and true or false)
    self:flush()
end

function Settings:effectiveBanner()
    local b = {}
    util.tableMerge(b, Config.DEFAULT_BANNER)
    util.tableMerge(b, self:open():readSetting("banner") or {})
    return b
end

function Settings:getGridPlacements()
    local raw = self:open():readSetting("grid")
    return strip_stale_widgets(GridModel.parseSaved(raw, grid_span))
end

function Settings:saveGridPlacements(placements)
    placements = strip_stale_widgets(placements)
    local norm = GridModel.normalizePlacements(placements, grid_span)
    self:open():saveSetting("grid", GridModel.wrapSaved(norm))
    self:flush()
end

function Settings:rawSleepRefreshIntervalSec()
    local v = self:open():readSetting("sleep_refresh_interval_sec")
    if v == nil then
        return 0
    end
    return math.floor(tonumber(v) or 0)
end

function Settings:effectiveSleepRefreshIntervalSec()
    local n = self:rawSleepRefreshIntervalSec()
    if n <= 0 then
        return 0
    end
    local L = Config.SLEEP_REFRESH_INTERVAL
    return math.max(L.min_sec, math.min(L.max_sec, n))
end

function Settings:setSleepRefreshIntervalSec(n)
    n = math.floor(tonumber(n) or 0)
    if n < 0 then
        n = 0
    end
    local L = Config.SLEEP_REFRESH_INTERVAL
    if n > 0 then
        n = math.min(L.max_sec, n)
    end
    self:open():saveSetting("sleep_refresh_interval_sec", n)
    self:flush()
end

return Settings
