local love = require("love")

local scenes = {
    menu = require "scripts.scenes.menu",
    game = require "scripts.scenes.main-scene"
}

local currentScene = "menu"

function love.errorhandler(msg)
    print("Error: " .. tostring(msg))
    return false
end

function _G.switchScene(sceneName)
    if scenes[sceneName] then
        local success, err = pcall(function()
            currentScene = sceneName
            if scenes[currentScene].load then
                scenes[currentScene].load()
            end
        end)

        if not success then
            print("Error switching scene:", err)
        end
    end
end

function love.load()
    local success, err = pcall(function()
        if scenes[currentScene].load then
            scenes[currentScene].load()
        end
    end)

    if not success then
        print("Error in love.load:", err)
    end
end

function love.update(dt)
    if scenes[currentScene].update then
        scenes[currentScene].update(dt)
    end
end

function love.draw()
    if scenes[currentScene].draw then
        scenes[currentScene].draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if scenes[currentScene].mousepressed then
        scenes[currentScene].mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if scenes[currentScene].mousereleased then
        scenes[currentScene].mousereleased(x, y, button, istouch, presses)
    end
end

function love.keypressed(key)
    if scenes[currentScene].keypressed then
        scenes[currentScene].keypressed(key)
    end
end
