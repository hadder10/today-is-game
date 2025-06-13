local json = require("dkjson")

local M = {}

function M.generate(prompt)
    -- Get absolute path to Python script with correct folder structure
    local basePath = love.filesystem.getSourceBaseDirectory()
    local scriptPath = basePath .. "/lua_game/model/local_generator.py"

    -- Debug output for path verification
    print("Base path:", basePath)
    print("Script path:", scriptPath)

    -- Create input data
    local input = json.encode({
        faction = prompt.faction or "public"
    })

    -- Create temp file for input
    local tmpFile = os.tmpname()
    local f = io.open(tmpFile, "w")
    f:write(input)
    f:close()

    -- Build command with proper Windows path formatting
    local command = string.format('python "%s" < "%s"',
        scriptPath:gsub("/", "\\"),
        tmpFile:gsub("/", "\\"))

    print("Executing command:", command)

    -- Execute and capture output
    local handle = io.popen(command, "r")
    if not handle then
        print("Failed to execute Python script")
        return "Error", "Failed to generate news"
    end

    local output = handle:read("*a")
    handle:close()

    -- Clean up
    os.remove(tmpFile)

    -- Parse response
    local success, response = pcall(json.decode, output)
    if success and response then
        return response.headline, response.description
    else
        print("Failed to parse response:", output)
        return "Error", "Failed to process generation results"
    end
end

return M
