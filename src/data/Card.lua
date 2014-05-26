module("src.data.Card", package.seeall)

local JSON = require "src.data.JSON"

function cardsForNewUser()
    local cards = {}

    cards[#cards + 1] = _getNewCard(0)

--    print(JSON:encode_pretty(cards))

    return cards
end

function getCardById(list, id)
    for key, card in ipairs(list) do
        if card["id"] == id then
            return card
        end
    end

    return nil
end

function _getCardDatabase()
    local pathData = "res/data/card.json"
    local str = cc.FileUtils:getInstance():getStringFromFile(pathData)
    local data = JSON:decode(str)

    --print(JSON:encode_pretty(data))

    return data
end

function _getNewCard(id_offset)
    local data = _getCardDatabase()[1]

    local id = id_offset + os.time() - 1400000000;

    data["id"] = id

    return data
end
