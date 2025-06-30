local love = require("love")


function love.conf(game)
    game.window.width = 1920
    game.window.height = 1080
    game.window.resizable = false
    game.window.title = "Today Is"
    game.window.display = 2

    game.version = "11.5"
    game.console = false
    game.window.vsync = 1
end
