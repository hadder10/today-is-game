local currentNews = {}
local dkjson      = require("dkjson")
local news_file   = io.open("E:/Projects/today-is-game/model/headlines_dataset.json", "r")
local factnions   = { "mafia", "public", "intelligence", "police" }


if not news_file then
    error("Соси хуй, файл не найден")
end

local content = news_file:read("*a")
news_file:close()

-- Декодируем JSON
local data, pos, err = dkjson.decode(content, 1, nil)


local Wcounter = 0




local forAWeek = {}
for _, nw in ipairs(data) do
    if nw.factnion == "mafia" then
        table.insert(forAWeek, nw)
    end
end


math.randomseed(os.time())
local random_news_peak = forAWeek[math.random(#forAWeek)]

print(random_news_peak.short)











-- for m = 1, 7 do
--     for j, needed_faction in ipairs(factnions) do
--         print(needed_faction)
--         for i, titles in ipairs(data) do
--             if titles.faction == needed_faction and Wcounter <= 6 then
--                 math.randomseed(os.time())

--                 print("--------------")
--                 print("Short: " .. titles.short)
--                 print("Long: " .. titles.long)
--                 print("--------------")
--                 break
--             end
--         end
--     end
-- end

-- local currentWeek = io.open("CurrentWeek.json", "w")
-- currentWeek:write(forAWeek)
-- currentWeek:close()
