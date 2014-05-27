module("src.data.Card", package.seeall)

local JSON = require "src.data.JSON"

function cardsForNewUser()
    local cards = {}

    local card = _getNewCard(0)

    setCardAsFighter(card, true)

    cards[#cards + 1] = card
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

function setCardAsFighter(card, flag)
    card["fighter"] = flag
    return card
end

function getNewCard()
    return _getNewCard(0)
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
    data["fighter"] = false

    return data
end
