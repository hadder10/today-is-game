local menu = {}

win_width, win_height = 540, 960

function love.conf(t)
    t.window.width = win_width
    t.window.height = win_height
    t.window.resizable = false
end

function menu.load()
    -- Загрузка и настройка шрифтов
    chomstick = love.graphics.newFont("Chomsky.otf", 30)
    chomstick:setFilter("nearest", "nearest")
    love.graphics.setFont(chomstick)

    -- Добавляем шрифт для заголовка (больше размером)
    title_font = love.graphics.newFont("Chomsky.otf", 60)
    title_font:setFilter("nearest", "nearest")

    -- Загружаем спрайт для кнопки About
    about_sprite = love.graphics.newImage("sprites/about.png")

    -- Параметры для кнопок
    menu.buttons = {
        {
            text = "New Game",
            width = 200,
            height = 60,
            x = win_width / 2 - 100,
            y = win_height / 2 - 100,
            scale = 1.0,
            type = "text"
        },
        {
            sprite = about_sprite,
            width = 600,
            height = 180,
            x = win_width / 2 - 300,
            y = win_height / 2,
            scale = 1.0,
            type = "sprite"
        },
        {
            text = "Exit",
            width = 200,
            height = 60,
            x = win_width / 2 - 100,
            y = win_height / 2 + 240
            ,
            scale = 1.0,
            type = "text"
        }
    }
end

function menu.update(dt)
    local mx, my = love.mouse.getPosition()

    -- Обновляем масштаб кнопок при наведении
    for _, button in ipairs(menu.buttons) do
        if mx > button.x and mx < button.x + button.width and
            my > button.y and my < button.y + button.height then
            button.scale = math.min(button.scale + dt * 4, 1.1)
        else
            button.scale = math.max(button.scale - dt * 4, 1.0)
        end
    end
end

function menu.draw()
    -- Рисуем заголовок
    love.graphics.setFont(title_font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Today Is", 0, win_height / 2 - 250, win_width, "center")

    -- Возвращаем шрифт для кнопок
    love.graphics.setFont(chomstick)

    -- Рисуем кнопки
    for _, button in ipairs(menu.buttons) do
        -- Смещение для масштабирования
        local offsetX = (button.scale - 1) * button.width / 2
        local offsetY = (button.scale - 1) * button.height / 2

        if button.type == "text" then
            -- Фон кнопки
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill",
                button.x - offsetX,
                button.y - offsetY,
                button.width * button.scale,
                button.height * button.scale)

            -- Обводка кнопки
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line",
                button.x - offsetX,
                button.y - offsetY,
                button.width * button.scale,
                button.height * button.scale)

            -- Текст кнопки
            love.graphics.push()
            love.graphics.translate(button.x + button.width / 2, button.y + button.height / 2)
            love.graphics.scale(button.scale)
            love.graphics.translate(-button.width / 2, -button.height / 2)
            love.graphics.printf(button.text,
                0,
                button.height / 2 - 15,
                button.width,
                "center")
            love.graphics.pop()
        else
            -- Рисуем спрайт
            love.graphics.setColor(1, 1, 1)
            local spriteScale = math.min(
                (button.width * button.scale) / button.sprite:getWidth(),
                (button.height * button.scale) / button.sprite:getHeight()
            )
            love.graphics.draw(button.sprite,
                button.x - offsetX + (button.width * button.scale - button.sprite:getWidth() * spriteScale) / 2,
                button.y - offsetY + (button.height * button.scale - button.sprite:getHeight() * spriteScale) / 2,
                0, spriteScale, spriteScale)
        end
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then -- левая кнопка мыши
        for i, btn in ipairs(menu.buttons) do
            if x > btn.x and x < btn.x + btn.width and
                y > btn.y and y < btn.y + btn.height then
                if i == 1 then     -- New Game
                    _G.switchScene("game")
                elseif i == 2 then -- About
                    -- Здесь можно добавить показ информации об игре
                elseif i == 3 then -- Exit
                    love.event.quit()
                end
            end
        end
    end
end

function menu.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

return menu
