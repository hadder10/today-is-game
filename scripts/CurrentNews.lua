local currentNews = {}
local dkjson      = require("dkjson")





function loading_news(filepath)
    local news_file = io.open("E:/Projects/today-is-game/model/headlines_dataset.json", "r")
    local factnions = { "mafia", "public", "intelligence", "police" }
    if not news_file then
        error("Файл не найден")
    end
    local content = news_file:read("*a")
    news_file:close()
    local data, pos, err = dkjson.decode(content, 1, nil)
    return data
end

-- local forAWeek = {}
-- for _, nw in ipairs(data) do
--     if nw.factnion == "mafia" then
--         table.insert(forAWeek, nw)
--     end
-- end


-- math.randomseed(os.time())
-- local random_news_peak = forAWeek[math.random(#forAWeek)]

-- print(random_news_peak.short)



local function getRandomNewsByFaction(newsData, faction)
    local filtered = {}
    for _, item in ipairs(newsData) do
        if item.faction == faction then
            table.insert(filtered, item)
        end
    end

    if #filtered == 0 then
        return nil
    end

    local randomIndex = math.random(1, #filtered)
    return filtered[randomIndex]
end

-- Инициализация random seed один раз:
math.randomseed(os.time())

-- Пример использования:
local newsData = loading_news("E:/Projects/today-is-game/model/headlines_dataset.json")
local randomMafiaNews = getRandomNewsByFaction(newsData, "mafia")

if randomMafiaNews then
    print(randomMafiaNews.short)
else
    print("Нет новостей для указанной фракции")
end
