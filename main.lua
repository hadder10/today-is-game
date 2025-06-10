require "scripts.text"
require "libs.push"
require "scripts.moving_pictures"
-- win_width, win_height = love.window.getDesktopDimensions()
-- win_width, win_height = win_width * 0.3, win_height * 0.8

win_width, win_height = 540, 960

function love.load()
    -- В начале функции
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- INITIALIZATION OF WINDOW
    love.window.setMode(win_width, win_height, { fullscreen = false, vsync = true, resizable = true })

    -- Объявляем глобальные переменные для перетаскивания
    is_Dragging = false
    draggable_now_obj = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }

    love.window.setTitle("Today is")
    -- Изменяем размер шрифта с 20 на 40
    chomstick = love.graphics.newFont("libs/Chomsky.otf", 30)
    chomstick:setFilter("nearest", "nearest")
    love.graphics.setFont(chomstick)

    -- IMPORT OF MAIN IMAGE
    main_news = love.graphics.newImage("sprites/paper.png")
    main_new = { x = 40, y = 120, width = main_news:getWidth() * 0.5, height = main_news:getHeight() * 0.5 }

    -- FOR PIVOT
    pivot = {
        x = main_new.x + main_new.width / 2,
        y = main_new.y + main_new.height / 2,
        width = 10,
        height = 10
    }

    -- FOR NEWS BACKGROUNDS INIT
    draggable_cal_1_size = love.graphics.newImage("sprites/2.png")
    draggable_cal_2_size = love.graphics.newImage("sprites/3.png")
    draggable_cal_3_size = love.graphics.newImage("sprites/4.png")
    draggable_cal_4_size = love.graphics.newImage("sprites/1.png")

    -- FOR ICONS
    icon_cal_1 = love.graphics.newImage("sprites/user.png")
    icon_cal_2 = love.graphics.newImage("sprites/user-police.png")
    icon_cal_3 = love.graphics.newImage("sprites/thief.png")
    icon_cal_4 = love.graphics.newImage("sprites/spy.png")

    -- FOR TEXT BLOCKS
    text_1 = TextBlock:new(50, 900, 100, "First new", "center", { 0, 0, 0 })
    text_2 = TextBlock:new(150, 900, 100, "Second new", "center", { 0, 0, 0 })
    text_3 = TextBlock:new(250, 900, 100, "Third new", "center", { 0, 0, 0 })
    text_4 = TextBlock:new(350, 900, 100, "Fourth new", "center", { 0, 0, 0 })

    -- FOR CHECKBOXES
    checkbox_1 = { x = 208, y = 185, width = 200, height = 305, checked = false, stored_icon = nil }
    checkbox_2 = { x = 0, y = 185, width = 200, height = 235, checked = false, stored_icon = nil }
    checkbox_3 = { x = 0, y = 70, width = 200, height = 195, checked = false, stored_icon = nil }
    checkbox_4 = { x = 212, y = 130, width = 200, height = 135, checked = false, stored_icon = nil }
    -- FOR ICONS
    icon_1 = { x = 46, y = 750, width = 200, height = 50, initial_x = 46, initial_y = 750, visible = true }
    icon_2 = { x = 46, y = 850, width = 200, height = 50, initial_x = 46, initial_y = 850, visible = true }
    icon_3 = { x = 292, y = 750, width = 200, height = 50, initial_x = 292, initial_y = 750, visible = true }
    icon_4 = { x = 292, y = 850, width = 200, height = 50, initial_x = 292, initial_y = 850, visible = true }

    -- FOR NEWS BACKGROUNDS INFO
    object_1 = {
        x = 10,
        y = 60,
        width = draggable_cal_1_size:getWidth() * 0.5,
        height = draggable_cal_1_size:getHeight() * 0.5,
        dragging_1 = false
    }
    object_2 = {
        x = 300,
        y = 60,
        width = draggable_cal_2_size:getWidth() * 0.5,
        height = draggable_cal_2_size:getHeight() * 0.5,
        dragging_2 = false
    }
    object_3 = {
        x = 400,
        y = 660,
        width = draggable_cal_3_size:getWidth() * 0.5,
        height = draggable_cal_3_size:getHeight() * 0.5,
        dragging_3 = false
    }
    object_4 = {
        x = 100,
        y = 660,
        width = draggable_cal_4_size:getWidth() * 0.5,
        height = draggable_cal_4_size:getHeight() * 0.5,
        dragging_4 = false
    }


    -- MAIN STATS
    labor_stat = { x = 64, y = 30, width = 0.1, height = 0.1, count = 0 }
    mafia_stat = { x = 183, y = 30, width = 0.1, height = 0.1, count = 0 }
    police_stat = { x = 302, y = 30, width = 0.1, height = 0.1, count = 0 }
    secret_stat = { x = 421, y = 30, width = 0.1, height = 0.1, count = 0 }


    local is_Dragging = false
    local draggable_now_obj

    -- FOR BUTTONS
    button_1 = {
        x = win_width / 4 - 50,
        y = 800,
        width = 100,
        height = 100,
        visible = false
    }

    button_2 = {
        x = (win_width / 4) * 3 - 50,
        y = 800,
        width = 100,
        height = 100,
        visible = false
    }

    -- FOR SIGNS
    signs = {
        [icon_cal_1] = "+",
        [icon_cal_2] = "+",
        [icon_cal_3] = "+",
        [icon_cal_4] = "+"
    }

    -- Генерируем начальные знаки
    randomizeSigns()

    -- Добавляем тексты для каждого объекта
    news_texts = {
        [icon_1] = "Workers protest",
        [icon_2] = "Police operation",
        [icon_3] = "Criminal activity",
        [icon_4] = "Secret meeting"
    }

    -- Добавляем поле для хранения текущего текста в объекты
    object_1.current_text = ""
    object_2.current_text = ""
    object_3.current_text = ""
    object_4.current_text = ""
end

-- Добавим функцию для генерации случайных знаков
function randomizeSigns()
    for icon in pairs(signs) do
        signs[icon] = math.random() < 0.5 and "+" or "-"
    end
end

-- DRAWING Tiles with icons
function drawSomeTiles(x, y, object_2_draw, icon)
    if icon.visible then
        -- Рисуем фоновый прямоугольник
        love.graphics.setColor(love.math.colorFromBytes(208, 208, 193))
        love.graphics.rectangle("fill", x, y, 200, 50)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", x, y, 200, 50)

        -- Рисуем иконку по центру прямоугольника
        love.graphics.setColor(1, 1, 1)
        local iconScale = 0.05
        local iconWidth = object_2_draw:getWidth() * iconScale
        local iconHeight = object_2_draw:getHeight() * iconScale
        local iconX = x + (200 - iconWidth) / 2     -- центрирование по X
        local iconY = y + (50 - iconHeight) / 2 + 2 -- центрирование по Y
        love.graphics.draw(object_2_draw, iconX, iconY, 0, iconScale, iconScale)

        -- Добавляем "+" или "-" справа от иконки используя массив signs
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(signs[object_2_draw], x + 150, y + 10)
        love.graphics.setColor(1, 1, 1)
    end
end

-- MAIN UPDATE FUNCTION
function love.update(dt)
    if is_Dragging == true then
        --is_Dragging = false
        draggable_now_obj.x = love.mouse.getX() - draggable_now_obj.width / 2
        draggable_now_obj.y = love.mouse.getY() - draggable_now_obj.height / 2
    end
end

-- Добавим функцию проверки всех чекбоксов
function checkAllBoxes()
    return checkbox_1.checked and checkbox_2.checked and
        checkbox_3.checked and checkbox_4.checked
end

-- MAIN DRAW FUNCTION
function love.draw()
    love.graphics.clear(0.3, 0.3, 0.3)

    love.graphics.draw(main_news, main_new.x, main_new.y, 0, 0.5, 0.5)
    love.graphics.draw(draggable_cal_1_size, pivot.x - checkbox_1.x, pivot.y - checkbox_1.y, 0, 0.55, 0.55)
    love.graphics.draw(draggable_cal_2_size, pivot.x + checkbox_2.x, pivot.y - checkbox_2.y, 0, 0.46, 0.46)
    love.graphics.draw(draggable_cal_3_size, pivot.x + checkbox_3.x, pivot.y + checkbox_3.y, 0, 0.46, 0.46)
    love.graphics.draw(draggable_cal_4_size, pivot.x - checkbox_4.x, pivot.y + checkbox_4.y, 0, 0.46, 0.46)

    -- Отрисовка иконок со счётчиками
    love.graphics.draw(icon_cal_1, labor_stat.x, labor_stat.y, 0, labor_stat.height, labor_stat.width)
    love.graphics.draw(icon_cal_2, mafia_stat.x, mafia_stat.y, 0, mafia_stat.height, mafia_stat.width)
    love.graphics.draw(icon_cal_3, police_stat.x, police_stat.y, 0, police_stat.height, police_stat.width)
    love.graphics.draw(icon_cal_4, secret_stat.x, secret_stat.y, 0, secret_stat.height, secret_stat.width)

    -- Отрисовка счётчиков
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(": " .. labor_stat.count, labor_stat.x + 50, labor_stat.y + 10)
    love.graphics.print(": " .. mafia_stat.count, mafia_stat.x + 50, mafia_stat.y + 10)
    love.graphics.print(": " .. police_stat.count, police_stat.x + 60, police_stat.y + 10)
    love.graphics.print(": " .. secret_stat.count, secret_stat.x + 60, secret_stat.y + 10)
    love.graphics.setColor(1, 1, 1)

    -- Убираем отрисовку pivot
    -- love.graphics.rectangle("fill", pivot.x, pivot.y, pivot.width, pivot.height)

    -- Устанавливаем прозрачный цвет для границ чекбоксов (альфа = 0)
    love.graphics.setColor(1, 0, 0, 0)
    drawed_rec = love.graphics.rectangle("line", pivot.x - checkbox_1.x, pivot.y - checkbox_1.y,
        checkbox_1.width, checkbox_1.height)
    love.graphics.setColor(0, 0, 1, 0)
    love.graphics.rectangle("line", pivot.x + checkbox_2.x, pivot.y - checkbox_2.y,
        checkbox_2.width, checkbox_2.height)
    love.graphics.setColor(1, 1, 0, 0)
    love.graphics.rectangle("line", pivot.x + checkbox_3.x, pivot.y + checkbox_3.y,
        checkbox_3.width, checkbox_3.height)
    love.graphics.setColor(1, 0, 1, 0)
    love.graphics.rectangle("line", pivot.x - checkbox_4.x, pivot.y + checkbox_4.y,
        checkbox_4.width, checkbox_4.height)





    drawSomeTiles(icon_1.x, icon_1.y, icon_cal_1, icon_1)
    drawSomeTiles(icon_2.x, icon_2.y, icon_cal_2, icon_2)
    drawSomeTiles(icon_3.x, icon_3.y, icon_cal_3, icon_3)
    drawSomeTiles(icon_4.x, icon_4.y, icon_cal_4, icon_4)


    --text_1:draw()
    --text_2:draw()
    --text_3:draw()
    --text_4:draw()

    -- Отрисовка кнопок если все чекбоксы заполнены
    if checkAllBoxes() then
        -- Первая кнопка
        love.graphics.setColor(0.8, 0.2, 0.2) -- красноватый цвет
        love.graphics.rectangle("fill", button_1.x, button_1.y,
            button_1.width, button_1.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", button_1.x, button_1.y,
            button_1.width, button_1.height)

        -- Вторая кнопка
        love.graphics.setColor(0.2, 0.8, 0.2) -- зеленоватый цвет
        love.graphics.rectangle("fill", button_2.x, button_2.y,
            button_2.width, button_2.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", button_2.x, button_2.y,
            button_2.width, button_2.height)
    end

    love.graphics.setColor(1, 1, 1)

    -- Отрисовка текстов на draggable_cal
    love.graphics.setColor(0, 0, 0)
    if object_1.current_text ~= "" then
        love.graphics.print(object_1.current_text, pivot.x - checkbox_1.x + 10, pivot.y - checkbox_1.y + 10)
    end
    if object_2.current_text ~= "" then
        love.graphics.print(object_2.current_text, pivot.x + checkbox_2.x + 10, pivot.y - checkbox_2.y + 10)
    end
    if object_3.current_text ~= "" then
        love.graphics.print(object_3.current_text, pivot.x + checkbox_3.x + 10, pivot.y + checkbox_3.y + 10)
    end
    if object_4.current_text ~= "" then
        love.graphics.print(object_4.current_text, pivot.x - checkbox_4.x + 10, pivot.y + checkbox_4.y + 10)
    end
    love.graphics.setColor(1, 1, 1)
end

-- MOUSE PRESSED FUNCTION
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Проверяем нажатие на кнопки, если все чекбоксы заполнены
        if checkAllBoxes() then
            -- Проверка нажатия на красную кнопку (сброс)
            if x > button_1.x and x < button_1.x + button_1.width and
                y > button_1.y and y < button_1.y + button_1.height then
                object_1.current_text = ""
                object_2.current_text = ""
                object_3.current_text = ""
                object_4.current_text = ""
                -- Возвращаем все объекты в начальное положение
                icon_1.x, icon_1.y = icon_1.initial_x, icon_1.initial_y
                icon_2.x, icon_2.y = icon_2.initial_x, icon_2.initial_y
                icon_3.x, icon_3.y = icon_3.initial_x, icon_3.initial_y
                icon_4.x, icon_4.y = icon_4.initial_x, icon_4.initial_y
                -- Показываем все объекты
                icon_1.visible = true
                icon_2.visible = true
                icon_3.visible = true
                icon_4.visible = true
                -- Снимаем все чекбоксы
                checkbox_1.checked = false
                checkbox_2.checked = false
                checkbox_3.checked = false
                checkbox_4.checked = false
                return
                -- Проверка нажатия на зеленую кнопку (подсчет очков)
            elseif x > button_2.x and x < button_2.x + button_2.width and
                y > button_2.y and y < button_2.y + button_2.height then
                -- Проверяем каждый чекбокс
                if checkbox_1.checked and checkbox_1.stored_icon then
                    local multiplier = signs[getIconCalForIcon(checkbox_1.stored_icon)] == "+" and 1 or -1
                    if checkbox_1.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + (4 * multiplier)
                    elseif checkbox_1.stored_icon == icon_2 then
                        police_stat.count = police_stat.count + (4 * multiplier)
                    elseif checkbox_1.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count + (4 * multiplier)
                    elseif checkbox_1.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + (4 * multiplier)
                    end
                end
                if checkbox_2.checked and checkbox_2.stored_icon then
                    if checkbox_2.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + 2    -- было 3
                    elseif checkbox_2.stored_icon == icon_2 then
                        police_stat.count = police_stat.count - 2   -- было 3
                    elseif checkbox_2.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count - 2    -- было 3
                    elseif checkbox_2.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + 2   -- было 3
                    end
                end
                if checkbox_3.checked and checkbox_3.stored_icon then
                    if checkbox_3.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + 3    -- было 2
                    elseif checkbox_3.stored_icon == icon_2 then
                        police_stat.count = police_stat.count - 3   -- было 2
                    elseif checkbox_3.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count - 3    -- было 2
                    elseif checkbox_3.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + 3   -- было 2
                    end
                end
                if checkbox_4.checked and checkbox_4.stored_icon then
                    if checkbox_4.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + 1
                    elseif checkbox_4.stored_icon == icon_2 then
                        police_stat.count = police_stat.count - 1
                    elseif checkbox_4.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count - 1
                    elseif checkbox_4.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + 1
                    end
                    object_1.current_text = ""
                    object_2.current_text = ""
                    object_3.current_text = ""
                    object_4.current_text = ""
                end

                -- Генерируем новые случайные знаки
                randomizeSigns()

                -- Возвращаем все объекты в начальное положение
                icon_1.x, icon_1.y = icon_1.initial_x, icon_1.initial_y
                icon_2.x, icon_2.y = icon_2.initial_x, icon_2.initial_y
                icon_3.x, icon_3.y = icon_3.initial_x, icon_3.initial_y
                icon_4.x, icon_4.y = icon_4.initial_x, icon_4.initial_y
                -- Показываем все объекты
                icon_1.visible = true
                icon_2.visible = true
                icon_3.visible = true
                icon_4.visible = true
                -- Снимаем все чекбоксы
                checkbox_1.checked = false
                checkbox_2.checked = false
                checkbox_3.checked = false
                checkbox_4.checked = false
                return
            end
        end

        -- Проверяем клик по чекбоксам для возвращения объектов
        if checkbox_1.checked and x > pivot.x - checkbox_1.x and x < pivot.x - checkbox_1.x + checkbox_1.width and
            y > pivot.y - checkbox_1.y and y < pivot.y - checkbox_1.y + checkbox_1.height then
            icon_1.visible = true
            checkbox_1.checked = false
            icon_1.x = x - icon_1.width / 2
            icon_1.y = y - icon_1.height / 2
            is_Dragging = true
            draggable_now_obj = icon_1
        elseif checkbox_2.checked and x > pivot.x + checkbox_2.x and x < pivot.x + checkbox_2.x + checkbox_2.width and
            y > pivot.y - checkbox_2.y and y < pivot.y - checkbox_2.y + checkbox_2.height then
            icon_2.visible = true
            checkbox_2.checked = false
            icon_2.x = x - icon_2.width / 2
            icon_2.y = y - icon_2.height / 2
            is_Dragging = true
            draggable_now_obj = icon_2
        elseif checkbox_3.checked and x > pivot.x + checkbox_3.x and x < pivot.x + checkbox_3.x + checkbox_3.width and
            y > pivot.y + checkbox_3.y and y < pivot.y + checkbox_3.y + checkbox_3.height then
            icon_3.visible = true
            checkbox_3.checked = false
            icon_3.x = x - icon_3.width / 2
            icon_3.y = y - icon_3.height / 2
            is_Dragging = true
            draggable_now_obj = icon_3
        elseif checkbox_4.checked and x > pivot.x - checkbox_4.x and x < pivot.x - checkbox_4.x + checkbox_4.width and
            y > pivot.y + checkbox_4.y and y < pivot.y + checkbox_4.y + checkbox_4.height then
            icon_4.visible = true
            checkbox_4.checked = false
            icon_4.x = x - icon_4.width / 2
            icon_4.y = y - icon_4.height / 2
            is_Dragging = true
            draggable_now_obj = icon_4
            -- Проверяем клик по видимым иконкам
        elseif icon_1.visible and x > icon_1.x and x < icon_1.x + icon_1.width and
            y > icon_1.y and y < icon_1.y + icon_1.height then
            is_Dragging = true
            draggable_now_obj = icon_1
        elseif icon_2.visible and x > icon_2.x and x < icon_2.x + icon_2.width and
            y > icon_2.y and y < icon_2.y + icon_2.height then
            is_Dragging = true
            draggable_now_obj = icon_2
        elseif icon_3.visible and x > icon_3.x and x < icon_3.x + icon_3.width and
            y > icon_3.y and y < icon_3.y + icon_3.height then
            is_Dragging = true
            draggable_now_obj = icon_3
        elseif icon_4.visible and x > icon_4.x and x < icon_4.x + icon_4.width and
            y > icon_4.y and y < icon_4.y + icon_4.height then
            is_Dragging = true
            draggable_now_obj = icon_4
        end
    end
end

-- MOUSE RELEASED FUNCTION
function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 and is_Dragging then
        local inside_checkbox = false

        -- Проверяем, находится ли курсор в границах чекбоксов
        if x > pivot.x - checkbox_1.x and x < pivot.x - checkbox_1.x + checkbox_1.width and
            y > pivot.y - checkbox_1.y and y < pivot.y - checkbox_1.y + checkbox_1.height then
            draggable_now_obj.visible = false
            checkbox_1.checked = true
            checkbox_1.stored_icon = draggable_now_obj
            object_1.current_text = news_texts[draggable_now_obj]
            inside_checkbox = true
        elseif x > pivot.x + checkbox_2.x and x < pivot.x + checkbox_2.x + checkbox_2.width and
            y > pivot.y - checkbox_2.y and y < pivot.y - checkbox_2.y + checkbox_2.height then
            draggable_now_obj.visible = false
            checkbox_2.checked = true
            checkbox_2.stored_icon = draggable_now_obj
            object_2.current_text = news_texts[draggable_now_obj]
            inside_checkbox = true
        elseif x > pivot.x + checkbox_3.x and x < pivot.x + checkbox_3.x + checkbox_3.width and
            y > pivot.y + checkbox_3.y and y < pivot.y + checkbox_3.y + checkbox_3.height then
            draggable_now_obj.visible = false
            checkbox_3.checked = true
            checkbox_3.stored_icon = draggable_now_obj
            object_3.current_text = news_texts[draggable_now_obj]
            inside_checkbox = true
        elseif x > pivot.x - checkbox_4.x and x < pivot.x - checkbox_4.x + checkbox_4.width and
            y > pivot.y + checkbox_4.y and y < pivot.y + checkbox_4.y + checkbox_4.height then
            draggable_now_obj.visible = false
            checkbox_4.checked = true
            checkbox_4.stored_icon = draggable_now_obj
            object_4.current_text = news_texts[draggable_now_obj]
            inside_checkbox = true
        end

        -- Если отпустили вне чекбоксов - возвращаем на начальную позицию и показываем
        if not inside_checkbox then
            draggable_now_obj.x = draggable_now_obj.initial_x
            draggable_now_obj.y = draggable_now_obj.initial_y
            draggable_now_obj.visible = true
        end

        is_Dragging = false
    end
end

-- Добавим вспомогательную функцию для получения icon_cal по icon
function getIconCalForIcon(icon)
    if icon == icon_1 then
        return icon_cal_1
    elseif icon == icon_2 then
        return icon_cal_2
    elseif icon == icon_3 then
        return icon_cal_3
    elseif icon == icon_4 then
        return icon_cal_4
    end
end
