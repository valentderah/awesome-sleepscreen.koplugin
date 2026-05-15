-- Run from repo root: lua tests/sleep_refresh_default_migration_test.lua
package.path = package.path .. ";./?.lua"

-- Must stay in sync with settings.lua: sleep_refresh_default_if_missing
local function apply_sleep_refresh_default_if_absent(lua, default_sec)
    if lua:readSetting("sleep_refresh_interval_sec") == nil then
        lua:saveSetting("sleep_refresh_interval_sec", default_sec)
    end
end

local function assert_eq(a, b, m)
    if a ~= b then
        error((m or "eq") .. ": " .. tostring(a) .. " vs " .. tostring(b))
    end
end

local function mock_lua(store)
    return {
        readSetting = function(_, k)
            return store[k]
        end,
        saveSetting = function(_, k, v)
            store[k] = v
        end,
        flush = function() end,
    }
end

local s1 = {}
local lua1 = mock_lua(s1)
apply_sleep_refresh_default_if_absent(lua1, 600)
assert_eq(s1.sleep_refresh_interval_sec, 600, "missing key -> 600")

local s2 = { sleep_refresh_interval_sec = 0 }
local lua2 = mock_lua(s2)
apply_sleep_refresh_default_if_absent(lua2, 600)
assert_eq(s2.sleep_refresh_interval_sec, 0, "explicit 0 preserved")

local s3 = { sleep_refresh_interval_sec = 120 }
local lua3 = mock_lua(s3)
apply_sleep_refresh_default_if_absent(lua3, 600)
assert_eq(s3.sleep_refresh_interval_sec, 120, "explicit value preserved")

print("sleep_refresh_default_migration_test: OK")
