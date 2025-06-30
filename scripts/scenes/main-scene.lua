local main_game = {}
local headlines = {}
-- local gen = require("client.server_gen")
local love = require("love")
-- local currentNews = require("scripts.CurrentNews")
local round = 0
local min, max = math.min, math.max

local headline_font = love.graphics.newFont("Chomsky.otf", 20)
love.graphics.setFont(headline_font)



----------------------------------------------------------

function randomizeSigns()
    for icon in pairs(signs) do
        signs[icon] = math.random() < 0.5 and "+" or "-"
    end
end

function drawSomeTiles(x, y, object_2_draw, icon)
    if icon.visible then
        local offsetX = (icon.scale - 1) * 100
        local offsetY = (icon.scale - 1) * 25

        love.graphics.setColor(love.math.colorFromBytes(208, 208, 193))
        love.graphics.rectangle("fill",
            x - offsetX, y - offsetY,
            200 * icon.scale, 50 * icon.scale)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line",
            x - offsetX, y - offsetY,
            200 * icon.scale, 50 * icon.scale)

        love.graphics.setColor(1, 1, 1)
        local iconScale = 0.05 * icon.scale
        local iconWidth = object_2_draw:getWidth() * iconScale
        local iconHeight = object_2_draw:getHeight() * iconScale
        local iconX = x + (200 - iconWidth) / 2 - offsetX
        local iconY = y + (50 - iconHeight) / 2 + 2 - offsetY
        love.graphics.draw(object_2_draw, iconX, iconY, 0, iconScale, iconScale)

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(signs[object_2_draw],
            x + 150 * icon.scale - offsetX,
            y + 10 * icon.scale - offsetY)
        love.graphics.setColor(1, 1, 1)
    end
end

function checkAllBoxes()
    return checkbox_1.checked and checkbox_2.checked and
        checkbox_3.checked and checkbox_4.checked
end

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

function checkGameOver()
    if labor_stat.count <= -20 then
        game_over_popup.visible = true
        game_over_popup.title = "Public Unrest!"
        game_over_popup.text = "Civil disorder has reached critical levels.\nThe city has fallen into chaos."
        return true
    elseif police_stat.count <= -20 then
        game_over_popup.visible = true
        game_over_popup.title = "Law Enforcement Collapse!"
        game_over_popup.text = "Police forces have lost control.\nCrime runs rampant in the streets."
        return true
    elseif mafia_stat.count <= -20 then
        game_over_popup.visible = true
        game_over_popup.title = "Criminal Uprising!"
        game_over_popup.text = "The criminal underworld has been destroyed.\nNew, more violent gangs take their place."
        return true
    elseif secret_stat.count <= -20 then
        game_over_popup.visible = true
        game_over_popup.title = "Intelligence Failure!"
        game_over_popup.text = "Secret services have been compromised.\nState secrets are leaked to foreign powers."
        return true
    end
    return false
end

----------------------------------------------------------

function main_game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")


    love.window.setMode(win_width, win_height, { fullscreen = false, vsync = true, resizable = true })
    love.window.setTitle("Today is")


    is_Dragging = false

    draggable_now_obj = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }

    main_news = love.graphics.newImage("sprites/paper.png")
    main_new = { x = 40, y = 120, width = main_news:getWidth() * 0.5, height = main_news:getHeight() * 0.5 }

    pivot = {
        x = main_new.x + main_new.width / 2,
        y = main_new.y + main_new.height / 2,
        width = 10,
        height = 10
    }
    menu_button = {
        image = love.graphics.newImage("sprites/menu.png"),
        x = 55,
        y = 150,
        width = 50,
        height = 50,
        scale = 1.0
    }

    draggable_cal_1_size = love.graphics.newImage("sprites/2.png")
    draggable_cal_2_size = love.graphics.newImage("sprites/3.png")
    draggable_cal_3_size = love.graphics.newImage("sprites/4.png")
    draggable_cal_4_size = love.graphics.newImage("sprites/1.png")

    icon_cal_1 = love.graphics.newImage("sprites/user.png")
    icon_cal_2 = love.graphics.newImage("sprites/user-police.png")
    icon_cal_3 = love.graphics.newImage("sprites/thief.png")
    icon_cal_4 = love.graphics.newImage("sprites/spy.png")

    checkbox_1 = { x = 208, y = 185, width = 200, height = 305, checked = false, stored_icon = nil }
    checkbox_2 = { x = 0, y = 185, width = 200, height = 235, checked = false, stored_icon = nil }
    checkbox_3 = { x = 0, y = 70, width = 200, height = 195, checked = false, stored_icon = nil }
    checkbox_4 = { x = 212, y = 130, width = 200, height = 135, checked = false, stored_icon = nil }

    labor_stat = { x = 64, y = 30, width = 0.1, height = 0.1, count = 0 }
    mafia_stat = { x = 183, y = 30, width = 0.1, height = 0.1, count = 0 }
    police_stat = { x = 302, y = 30, width = 0.1, height = 0.1, count = 0 }
    secret_stat = { x = 421, y = 30, width = 0.1, height = 0.1, count = 0 }

    icon_1 = {
        x = 46,
        y = 750,
        width = 200,
        height = 50,
        initial_x = 46,
        initial_y = 750,
        visible = true,
        scale = 1.0
    }
    icon_2 = {
        x = 46,
        y = 850,
        width = 200,
        height = 50,
        initial_x = 46,
        initial_y = 850,
        visible = true,
        scale = 1.0
    }
    icon_3 = {
        x = 292,
        y = 750,
        width = 200,
        height = 50,
        initial_x = 292,
        initial_y = 750,
        visible = true,
        scale = 1.0
    }
    icon_4 = {
        x = 292,
        y = 850,
        width = 200,
        height = 50,
        initial_x = 292,
        initial_y = 850,
        visible = true,
        scale = 1.0
    }

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


    local is_Dragging = false
    local draggable_now_obj

    -- FOR BUTTONS
    button_1 = {
        x = 70,
        y = 800,
        width = 180,
        height = 100,
        visible = false,
        scale = 1.0,
        text = "Reset"
    }

    button_2 = {
        x = win_width - 250,
        y = 800,
        width = 180,
        height = 100,
        visible = false,
        scale = 1.0,
        text = "Next day"
    }

    -- FOR SIGNS
    signs = {
        [icon_cal_1] = "+",
        [icon_cal_2] = "-",
        [icon_cal_3] = "+",
        [icon_cal_4] = "-"
    }

    randomizeSigns()

    menu_overlay = {
        visible = false,
        alpha = 0.7,
        color = { 0.1, 0.1, 0.1 }
    }

    menu_exit_button = {
        text = "Exit to menu",
        width = 200,
        height = 60,
        x = win_width / 2 - 100,
        y = win_height / 2 - 30,
        scale = 1.0
    }

    local initial_headlines = {
        { icon = icon_1, desc_obj = object_1 },
        { icon = icon_2, desc_obj = object_2 },
        { icon = icon_3, desc_obj = object_3 },
        { icon = icon_4, desc_obj = object_4 }
    }

    local factions = { "public", "police", "mafia", "intelligence" }
    news_texts = {}

    for i, data in ipairs(initial_headlines) do
        local prompt = { faction = factions[i] }
        -- local headline, description = gen.generate(prompt)

        -- if headline and description then
        --     headline = headline:gsub("Generate news headline about this faction:", "")
        --     headline = headline:gsub("Current situation:", "")
        --     headline = headline:gsub("Faction: ", "")
        --     headline = headline:gsub("State: ", "")

        --     headline = headline:gsub("^%s*(.-)%s*$", "%1")
        --     description = description:gsub("^%s*(.-)%s*$", "%1")

        --     news_texts[data.icon] = headline
        --     data.desc_obj.current_text = description
        -- else
        news_texts[data.icon] = "Breaking News"
        data.desc_obj.current_text = "Situation continues to develop."
        -- end
    end

    info_window = {
        x = win_width / 2 - 200,
        y = win_height / 2 - 150,
        width = 400,
        height = 300,
        visible = false,
        text = ""
    }

    game_over_popup = {
        visible = false,
        x = win_width / 2 - 300,
        y = win_height / 2 - 200,
        width = 600,
        height = 400,
        text = "",
        title = ""
    }
end

function main_game.update(dt)
    if is_Dragging == true then
        draggable_now_obj.x = love.mouse.getX() - draggable_now_obj.width / 2
        draggable_now_obj.y = love.mouse.getY() - draggable_now_obj.height / 2
    end

    local mx, my = love.mouse.getPosition()

    for _, icon in ipairs({ icon_1, icon_2, icon_3, icon_4 }) do
        if icon.visible and mx > icon.x and mx < icon.x + icon.width and
            my > icon.y and my < icon.y + icon.height then
            icon.scale = min(icon.scale + dt * 4, 1.1)
        else
            icon.scale = max(icon.scale - dt * 4, 1.0)
        end
    end

    if checkAllBoxes() then
        if mx > button_1.x and mx < button_1.x + button_1.width and
            my > button_1.y and my < button_1.y + button_1.height then
            button_1.scale = min(button_1.scale + dt * 4, 1.1)
        else
            button_1.scale = max(button_1.scale - dt * 4, 1.0)
        end

        if mx > button_2.x and mx < button_2.x + button_2.width and
            my > button_2.y and my < button_2.y + button_2.height then
            button_2.scale = min(button_2.scale + dt * 4, 1.1)
        else
            button_2.scale = max(button_2.scale - dt * 4, 1.0)
        end
    end

    if mx > menu_button.x and mx < menu_button.x + menu_button.width and
        my > menu_button.y and my < menu_button.y + menu_button.height then
        menu_button.scale = min(menu_button.scale + dt * 4, 1.1)
    else
        menu_button.scale = max(menu_button.scale - dt * 4, 1.0)
    end

    if menu_overlay.visible then
        if mx > menu_exit_button.x and mx < menu_exit_button.x + menu_exit_button.width and
            my > menu_exit_button.y and my < menu_exit_button.y + menu_exit_button.height then
            menu_exit_button.scale = min(menu_exit_button.scale + dt * 4, 1.1)
        else
            menu_exit_button.scale = max(menu_exit_button.scale - dt * 4, 1.0)
        end
    end
end

function main_game.draw()
    love.graphics.clear(0.3, 0.3, 0.3)

    love.graphics.draw(main_news, main_new.x, main_new.y, 0, 0.5, 0.5)

    local offsetX = (menu_button.scale - 1) * menu_button.width / 2
    local offsetY = (menu_button.scale - 1) * menu_button.height / 2

    love.graphics.setColor(0, 0, 0)
    for dx = -1, 1 do
        for dy = -1, 1 do
            love.graphics.draw(menu_button.image,
                menu_button.x - offsetX + dx,
                menu_button.y - offsetY + dy,
                0,
                menu_button.scale * 0.3,
                menu_button.scale * 0.3
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(menu_button.image,
        menu_button.x - offsetX,
        menu_button.y - offsetY,
        0,
        menu_button.scale * 0.3,
        menu_button.scale * 0.3
    )

    love.graphics.draw(draggable_cal_1_size, pivot.x - checkbox_1.x, pivot.y - checkbox_1.y, 0, 0.55, 0.55)
    love.graphics.draw(draggable_cal_2_size, pivot.x + checkbox_2.x, pivot.y - checkbox_2.y, 0, 0.46, 0.46)
    love.graphics.draw(draggable_cal_3_size, pivot.x + checkbox_3.x, pivot.y + checkbox_3.y, 0, 0.46, 0.46)
    love.graphics.draw(draggable_cal_4_size, pivot.x - checkbox_4.x, pivot.y + checkbox_4.y, 0, 0.46, 0.46)

    love.graphics.draw(icon_cal_1, labor_stat.x, labor_stat.y, 0, labor_stat.height, labor_stat.width)
    love.graphics.draw(icon_cal_2, mafia_stat.x, mafia_stat.y, 0, mafia_stat.height, mafia_stat.width)
    love.graphics.draw(icon_cal_3, police_stat.x, police_stat.y, 0, police_stat.height, police_stat.width)
    love.graphics.draw(icon_cal_4, secret_stat.x, secret_stat.y, 0, secret_stat.height, secret_stat.width)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(": " .. labor_stat.count, labor_stat.x + 50, labor_stat.y + 10)
    love.graphics.print(": " .. mafia_stat.count, mafia_stat.x + 50, mafia_stat.y + 10)
    love.graphics.print(": " .. police_stat.count, police_stat.x + 60, police_stat.y + 10)
    love.graphics.print(": " .. secret_stat.count, secret_stat.x + 60, secret_stat.y + 10)
    love.graphics.setColor(1, 1, 1)


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


    if checkAllBoxes() then
        love.graphics.setColor(0.8, 0.2, 0.2)
        local offsetX1 = (button_1.scale - 1) * button_1.width / 2
        local offsetY1 = (button_1.scale - 1) * button_1.height / 2
        love.graphics.rectangle("fill",
            button_1.x - offsetX1,
            button_1.y - offsetY1,
            button_1.width * button_1.scale,
            button_1.height * button_1.scale)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line",
            button_1.x - offsetX1,
            button_1.y - offsetY1,
            button_1.width * button_1.scale,
            button_1.height * button_1.scale)
        love.graphics.push()
        love.graphics.translate(button_1.x + button_1.width / 2, button_1.y + button_1.height / 2)
        love.graphics.scale(button_1.scale)
        love.graphics.translate(-button_1.width / 2, -button_1.height / 2)
        love.graphics.printf(button_1.text,
            0,
            (button_1.height - 30) / 2,
            button_1.width,
            "center")
        love.graphics.pop()

        love.graphics.setColor(0.2, 0.8, 0.2)
        local offsetX2 = (button_2.scale - 1) * button_2.width / 2
        local offsetY2 = (button_2.scale - 1) * button_2.height / 2
        love.graphics.rectangle("fill",
            button_2.x - offsetX2,
            button_2.y - offsetY2,
            button_2.width * button_2.scale,
            button_2.height * button_2.scale)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line",
            button_2.x - offsetX2,
            button_2.y - offsetY2,
            button_2.width * button_2.scale,
            button_2.height * button_2.scale)
        love.graphics.push()
        love.graphics.translate(button_2.x + button_2.width / 2, button_2.y + button_2.height / 2)
        love.graphics.scale(button_2.scale)
        love.graphics.translate(-button_2.width / 2, -button_2.height / 2)
        love.graphics.printf(button_2.text,
            0,
            (button_2.height - 30) / 2,
            button_2.width,
            "center")
        love.graphics.pop()
    end

    if menu_overlay.visible then
        love.graphics.setColor(menu_overlay.color[1], menu_overlay.color[2], menu_overlay.color[3], menu_overlay.alpha)
        love.graphics.rectangle("fill", 0, 0, win_width, win_height)

        local offsetX = (menu_exit_button.scale - 1) * menu_exit_button.width / 2
        local offsetY = (menu_exit_button.scale - 1) * menu_exit_button.height / 2

        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill",
            menu_exit_button.x - offsetX,
            menu_exit_button.y - offsetY,
            menu_exit_button.width * menu_exit_button.scale,
            menu_exit_button.height * menu_exit_button.scale)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line",
            menu_exit_button.x - offsetX,
            menu_exit_button.y - offsetY,
            menu_exit_button.width * menu_exit_button.scale,
            menu_exit_button.height * menu_exit_button.scale)

        love.graphics.push()
        love.graphics.translate(menu_exit_button.x + menu_exit_button.width / 2,
            menu_exit_button.y + menu_exit_button.height / 2)
        love.graphics.scale(menu_exit_button.scale)
        love.graphics.translate(-menu_exit_button.width / 2, -menu_exit_button.height / 2)
        love.graphics.printf(menu_exit_button.text,
            0,
            menu_exit_button.height / 2 - 15,
            menu_exit_button.width,
            "center")
        love.graphics.pop()
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0, 0, 0)
    if checkbox_1.checked and object_1.current_text ~= "" then
        love.graphics.print(object_1.current_text, pivot.x - checkbox_1.x + 10, pivot.y - checkbox_1.y + 10)
    end
    if checkbox_2.checked and object_2.current_text ~= "" then
        love.graphics.print(object_2.current_text, pivot.x + checkbox_2.x + 10, pivot.y - checkbox_2.y + 10)
    end
    if checkbox_3.checked and object_3.current_text ~= "" then
        love.graphics.print(object_3.current_text, pivot.x + checkbox_3.x + 10, pivot.y + checkbox_3.y + 10)
    end
    if checkbox_4.checked and object_4.current_text ~= "" then
        love.graphics.print(object_4.current_text, pivot.x - checkbox_4.x + 10, pivot.y + checkbox_4.y + 10)
    end
    love.graphics.setColor(1, 1, 1)

    if info_window.visible then
        love.graphics.setColor(0.9, 0.9, 0.9, 0.95)
        love.graphics.rectangle("fill", info_window.x, info_window.y,
            info_window.width, info_window.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", info_window.x, info_window.y,
            info_window.width, info_window.height)
        love.graphics.printf(info_window.text, info_window.x + 10,
            info_window.y + 10, info_window.width - 20, "center")
        love.graphics.setColor(1, 1, 1)
    end

    if game_over_popup.visible then
        love.graphics.setColor(0.8, 0.8, 0.8, 0.95)
        love.graphics.rectangle("fill", game_over_popup.x, game_over_popup.y,
            game_over_popup.width, game_over_popup.height)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", game_over_popup.x, game_over_popup.y,
            game_over_popup.width, game_over_popup.height)

        love.graphics.setColor(1, 0, 0)
        love.graphics.printf(game_over_popup.title, game_over_popup.x + 10,
            game_over_popup.y + 10, game_over_popup.width - 20, "center")

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(game_over_popup.text .. "\n\nClick anywhere to continue...",
            game_over_popup.x + 50,
            game_over_popup.y + 150, game_over_popup.width - 100, "center")
    end
end

function main_game.mousepressed(x, y, button, istouch, presses)
    if game_over_popup.visible then
        _G.switchScene("menu")
        return
    end

    local mx, my = love.mouse.getPosition()

    if button == 2 then
        if icon_1.visible and x > icon_1.x and x < icon_1.x + icon_1.width and
            y > icon_1.y and y < icon_1.y + icon_1.height then
            info_window.visible = true
            info_window.text = object_1.current_text -- используем long описание
        elseif icon_2.visible and x > icon_2.x and x < icon_2.x + icon_2.width and
            y > icon_2.y and y < icon_2.y + icon_2.height then
            info_window.visible = true
            info_window.text = object_2.current_text
        elseif icon_3.visible and x > icon_3.x and x < icon_3.x + icon_3.width and
            y > icon_3.y and y < icon_3.y + icon_3.height then
            info_window.visible = true
            info_window.text = object_3.current_text
        elseif icon_4.visible and x > icon_4.x and x < icon_4.x + icon_4.width and
            y > icon_4.y and y < icon_4.y + icon_4.height then
            info_window.visible = true
            info_window.text = object_4.current_text
        else
            info_window.visible = false
        end
    end

    if button == 1 then
        if mx > menu_button.x and mx < menu_button.x + menu_button.width and
            my > menu_button.y and my < menu_button.y + menu_button.height then
            menu_overlay.visible = not menu_overlay.visible
            return
        end

        if menu_overlay.visible and
            x > menu_exit_button.x and x < menu_exit_button.x + menu_exit_button.width and
            y > menu_exit_button.y and y < menu_exit_button.y + menu_exit_button.height then
            _G.switchScene("menu")
            menu_overlay.visible = false
            return
        end

        if menu_overlay.visible then
            menu_overlay.visible = false
            return
        end

        info_window.visible = false
        if checkAllBoxes() then
            if x > button_1.x and x < button_1.x + button_1.width and
                y > button_1.y and y < button_1.y + button_1.height then
                object_1.current_text = ""
                object_2.current_text = ""
                object_3.current_text = ""
                object_4.current_text = ""
                icon_1.x, icon_1.y = icon_1.initial_x, icon_1.initial_y
                icon_2.x, icon_2.y = icon_2.initial_x, icon_2.initial_y
                icon_3.x, icon_3.y = icon_3.initial_x, icon_3.initial_y
                icon_4.x, icon_4.y = icon_4.initial_x, icon_4.initial_y
                icon_1.visible = true
                icon_2.visible = true
                icon_3.visible = true
                icon_4.visible = true
                checkbox_1.checked = false
                checkbox_2.checked = false
                checkbox_3.checked = false
                checkbox_4.checked = false
                return
            elseif x > button_2.x and x < button_2.x + button_2.width and
                y > button_2.y and y < button_2.y + button_2.height then
                if checkGameOver() then
                    button_1.visible = false
                    button_2.visible = false
                    return
                end
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
                    local multiplier = signs[getIconCalForIcon(checkbox_2.stored_icon)] == "+" and 1 or -1
                    if checkbox_2.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + (2 * multiplier)
                    elseif checkbox_2.stored_icon == icon_2 then
                        police_stat.count = police_stat.count + (2 * multiplier)
                    elseif checkbox_2.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count + (2 * multiplier)
                    elseif checkbox_2.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + (2 * multiplier)
                    end
                end
                if checkbox_3.checked and checkbox_3.stored_icon then
                    local multiplier = signs[getIconCalForIcon(checkbox_3.stored_icon)] == "+" and 1 or -1
                    if checkbox_3.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + (3 * multiplier)
                    elseif checkbox_3.stored_icon == icon_2 then
                        police_stat.count = police_stat.count + (3 * multiplier)
                    elseif checkbox_3.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count + (3 * multiplier)
                    elseif checkbox_3.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + (3 * multiplier)
                    end
                end
                if checkbox_4.checked and checkbox_4.stored_icon then
                    local multiplier = signs[getIconCalForIcon(checkbox_4.stored_icon)] == "+" and 1 or -1
                    if checkbox_4.stored_icon == icon_1 then
                        labor_stat.count = labor_stat.count + (1 * multiplier)
                    elseif checkbox_4.stored_icon == icon_2 then
                        police_stat.count = police_stat.count + (1 * multiplier)
                    elseif checkbox_4.stored_icon == icon_3 then
                        mafia_stat.count = mafia_stat.count + (1 * multiplier)
                    elseif checkbox_4.stored_icon == icon_4 then
                        secret_stat.count = secret_stat.count + (1 * multiplier)
                    end

                    object_1.current_text = ""
                    object_2.current_text = ""
                    object_3.current_text = ""
                    object_4.current_text = ""

                    round = round + 1

                    local factions_data = {
                        { faction = "public",       icon = icon_1, obj = object_1 },
                        { faction = "police",       icon = icon_2, obj = object_2 },
                        { faction = "mafia",        icon = icon_3, obj = object_3 },
                        { faction = "intelligence", icon = icon_4, obj = object_4 }
                    }

                    -- for _, data in ipairs(factions_data) do
                    --     local prompt = {
                    --         faction = data.faction
                    --     }

                    --     local headline, description = gen.generate(prompt)

                    --     if headline and description then
                    --         headline = headline:gsub("Generate news headline about this faction:", "")
                    --         headline = headline:gsub("Current situation:", "")
                    --         headline = headline:gsub("Faction: ", "")

                    --         headline = headline:gsub("^%s*(.-)%s*$", "%1")
                    --         description = description:gsub("^%s*(.-)%s*$", "%1")

                    --         if headline ~= "" then
                    --             news_texts[data.icon] = headline
                    --             data.obj.current_text = description
                    --         end
                    --     end
                    -- end
                end

                randomizeSigns()

                icon_1.x, icon_1.y = icon_1.initial_x, icon_1.initial_y
                icon_2.x, icon_2.y = icon_2.initial_x, icon_2.initial_y
                icon_3.x, icon_3.y = icon_3.initial_x, icon_3.initial_y
                icon_4.x, icon_4.y = icon_4.initial_x, icon_4.initial_y
                icon_1.visible = true
                icon_2.visible = true
                icon_3.visible = true
                icon_4.visible = true
                checkbox_1.checked = false
                checkbox_2.checked = false
                checkbox_3.checked = false
                checkbox_4.checked = false
                return
            end
        end

        if checkbox_1.checked and x > pivot.x - checkbox_1.x and x < pivot.x - checkbox_1.x + checkbox_1.width and
            y > pivot.y - checkbox_1.y and y < pivot.y - checkbox_1.y + checkbox_1.height then
            icon_1.visible = true
            checkbox_1.checked = false
            checkbox_1.stored_icon = nil
            object_1.current_text = ""
            icon_1.x = x - icon_1.width / 2
            icon_1.y = y - icon_1.height / 2
            is_Dragging = true
            draggable_now_obj = icon_1
        elseif checkbox_2.checked and x > pivot.x + checkbox_2.x and x < pivot.x + checkbox_2.x + checkbox_2.width and
            y > pivot.y - checkbox_2.y and y < pivot.y - checkbox_2.y + checkbox_2.height then
            icon_2.visible = true
            checkbox_2.checked = false
            checkbox_2.stored_icon = nil
            object_2.current_text = ""
            icon_2.x = x - icon_2.width / 2
            icon_2.y = y - icon_2.height / 2
            is_Dragging = true
            draggable_now_obj = icon_2
        elseif checkbox_3.checked and x > pivot.x + checkbox_3.x and x < pivot.x + checkbox_3.x + checkbox_3.width and
            y > pivot.y + checkbox_3.y and y < pivot.y + checkbox_3.y + checkbox_3.height then
            icon_3.visible = true
            checkbox_3.checked = false
            checkbox_3.stored_icon = nil
            object_3.current_text = ""
            icon_3.x = x - icon_3.width / 2
            icon_3.y = y - icon_3.height / 2
            is_Dragging = true
            draggable_now_obj = icon_3
        elseif checkbox_4.checked and x > pivot.x - checkbox_4.x and x < pivot.x - checkbox_4.x + checkbox_4.width and
            y > pivot.y + checkbox_4.y and y < pivot.y + checkbox_4.y + checkbox_4.height then
            icon_4.visible = true
            checkbox_4.checked = false
            checkbox_4.stored_icon = nil
            object_4.current_text = ""
            icon_4.x = x - icon_4.width / 2
            icon_4.y = y - icon_4.height / 2
            is_Dragging = true
            draggable_now_obj = icon_4
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

function main_game.mousereleased(x, y, button, istouch, presses)
    if button == 1 and is_Dragging then
        local inside_checkbox = false

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

        if not inside_checkbox then
            draggable_now_obj.x = draggable_now_obj.initial_x
            draggable_now_obj.y = draggable_now_obj.initial_y
            draggable_now_obj.visible = true
        end

        is_Dragging = false
    end
end

----------------------------------------------------------

return main_game
