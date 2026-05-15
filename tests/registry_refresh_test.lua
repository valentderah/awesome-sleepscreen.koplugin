-- Run from repo root: lua tests/registry_refresh_test.lua
package.path = package.path .. ";./?.lua"

package.loaded["logger"] = { warn = function() end }

local function assert_eq(a, b, m)
    if a ~= b then
        error((m or "eq") .. ": " .. tostring(a) .. " vs " .. tostring(b))
    end
end

local Reg = assert(require("banner.widgets.registry"))
local noop = function() end
Reg.register("clock", noop, { needs_sleep_refresh = true })
Reg.register("highlight", noop, {})
Reg.register("header_datetime", noop, { default_col_span = 3, needs_sleep_refresh = true })

assert_eq(Reg.placements_want_refresh({}), false, "empty")

assert_eq(Reg.placements_want_refresh({
    { type = "highlight", params = {}, row = 1, col = 1 },
}), false, "static only")

assert_eq(Reg.placements_want_refresh({
    { type = "clock", params = {}, row = 1, col = 1 },
}), true, "clock")

assert_eq(Reg.placements_want_refresh({
    { type = "header_datetime", params = {}, row = 1, col = 1 },
}), true, "header_datetime")

print("registry_refresh_test: OK")
