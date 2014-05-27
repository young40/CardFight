module("src.data.CurrentUser", package.seeall)

local userlist = require "src.data.User"
local JSON = require "src.data.JSON"
local CARD = require "src.data.Card"

local filenameUserCurrent = "usercurrent.json"

function setCurrentId(id)
    local data = {}
    data["id"] = id

    local str = JSON:encode_pretty(data)

    local fp = io.open(cc.FileUtils:getInstance():getWritablePath() .. filenameUserCurrent, "w")
    fp:write(str)
    fp:close()

    if not _isUserDataFileExist() then
        local data = _getNewUser()
        _updateUserDataFile(data)
    end
end

function getCurrentId()
    local pathUserCurrent = cc.FileUtils:getInstance():getWritablePath() .. filenameUserCurrent

    if cc.FileUtils:getInstance():isFileExist(pathUserCurrent) then
        local str = cc.FileUtils:getInstance():getStringFromFile(pathUserCurrent)
        local data = JSON:decode(str)
        return data["id"]
    end

    return ""
end

function getName()
    return getData()["name"]
end

function getAvatar()
    return getData()["avatar"]
end

function setAvatar(value)
    _setData("avatar", value)
end

function getGold()
    return getData()["gold"]
end

function setGold(value)
    _setData("gold", value)
end

function getLevel()
    return getData()["level"]
end

function setLevel(value)
    _setData("level", value)
end

function getCardList()
    return getData()["cards"]
end

function getFighters()
    local cards =  {}

    for key, card in ipairs(getCardList()) do
        for key_, id in ipairs(getData()["fighter"]) do
            if card["id"] == id then
                cards[#cards + 1] = card
            end
        end
    end

    return cards
end

function setFighters(ids)
    local fIds = {}

    for key, id in ipairs(ids) do
        local card = CARD.getCardById(getCardList(), id)
        if (card) then
            fIds[#fIds + 1] = id
        end
    end

    if #fIds == 0 then
        return false
    end

    local cards = {}
    for key, card in ipairs(getCardList()) do
        CARD.setCardAsFighter(card, false)

        for key_, id in ipairs(fIds) do 
            if (card["id"] == id) then
                CARD.setCardAsFighter(card, true)
            end
        end

        cards[#cards + 1] = card
    end
    
    _setData("fighter", fIds)
    _setData("cards", cards)

    return true
end

function getNewCard()
    local cards = getCardList()

    cards[#cards + 1] = CARD.getNewCard()
    
    _setData("cards", cards)
end

function _getNewUser()
    local user = userlist.getUserById(getCurrentId())
    
    local data = {}

    data["id"]      = user["id"]
    data["name"]    = user["name"]
    data["avatar"]  = "avatar.png" 
    data["gold"]    = 100
    data["level"]   = 1

    local cards = CARD.cardsForNewUser()
    data["cards"]   = cards

    local fighter = {}
    fighter[#fighter + 1] = cards[1]
    data["fighter"] = fighter

    return data
end

function _setData(key, value)
    local data = getData()
    data[key] = value
    --print(JSON:encode_pretty(data))
    _updateUserDataFile(data)
end

function getData()
    return JSON:decode(cc.FileUtils:getInstance():getStringFromFile(_getUserDataFile()))
end

function _getUserDataFile()
    return cc.FileUtils:getInstance():getWritablePath() .. "user_" .. getCurrentId() .. ".json"
end

function _addUser(username)
   local list = _getUserListFileObject()

   local newUser = {}

   newUser["name"] = username
   newUser["id"] = os.time() 

   list[#list + 1] = newUser

   _updateUserListFile(list)

   return newUser["id"]
end

function _isUserDataFileExist()
    return cc.FileUtils:getInstance():isFileExist(_getUserDataFile())
end

function _updateUserDataFile(data)
   local json = JSON:encode_pretty(data)

   local fp = io.open(_getUserDataFile(), "w")
   fp:write(json)
   fp:close()
end
