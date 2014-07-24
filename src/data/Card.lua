module("src.data.Card", package.seeall)

local JSON = require "src.data.JSON"

function cardsForNewUser()
    local cards = {}

    local card = _getNewCard()

    setCardAsFighter(card[1], true)

    return card
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
end

function getNewCard()
    return _getNewCard()
end

function getEnemyCard()
    return _getEnemyCard()
end

function _getCardDatabase()
    local pathData = "res/data/card.json"
    local str = cc.FileUtils:getInstance():getStringFromFile(pathData)
    local data = JSON:decode(str)

    --print(JSON:encode_pretty(data))

    return data
end

function _getNewCard()
    local data = _getCardDatabase()["MyMobilePhone"]
    return data
end

function _getEnemyCard()
    local data = _getCardDatabase()["EnemyMobilePhone"]
    return data
end
