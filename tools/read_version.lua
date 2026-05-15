--[[ Reads semver from _meta.lua in the current working directory (repo root). Prints one line to stdout. ]]
local path = "_meta.lua"
local f, err = io.open(path, "rb")
if not f then
    io.stderr:write("read_version: " .. (err or path) .. "\n")
    os.exit(1)
end
local text = assert(f:read("*a"))
f:close()
local v = text:match('version%s*=%s*"([^"]+)"')
print(v or "0.0.0")
