local love = require("love")


function love.conf(game)
    game.window.width = 720
    game.window.height = 1280
    game.window.resizable = false
    game.window.title = "Today Is"

    game.version = "11.5"
    game.console = false
    game.window.vsync = 1
end
