local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")

local M = {}

function M.generate(prompt)
    local body = json.encode({faction = prompt.faction or "public"})
    local response = {}
    local res, code = http.request{
        url = "http://localhost:5000/generate",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#body)
        },
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response)
    }
    if code ~= 200 then
        print("Server error:", code)
        return "Error", "Failed to generate news"
    end
    local result = table.concat(response)
    local data = json.decode(result)
    return data.headline or "Error", data.description or "Failed to generate news"
end

return M
