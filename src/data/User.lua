module("src.data.User", package.seeall)

local JSON = (loadfile "src/data/JSON.lua")()

local filenameUserList = "userlist.json"

function reg(username)
    local userId = _findUserIdByName(username)

    if userId ~= 0 then
        return userId
    end

    return _addUser(username)
end

function getUserList()
    return _getUserListFileObject()
end

function getUserById(id)
    local users = getUserList()

    for i=1, #(users) do
        local user = users[i]
        if user["id"] == id then
           return user
        end
    end

    return {}
end

function _getUserListFile()
    return cc.FileUtils:getInstance():getWritablePath() .. filenameUserList;
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

function _findUserIdByName(username)
    local users = _getUserListFileObject()

    for i=1, #(users) do
        local user = users[i]
        if user["name"] == username then
           return user["id"]
        end
    end

    return 0
end

function _isUserListFileExist()
    return cc.FileUtils:getInstance():isFileExist(_getUserListFile())
end

function _getUserListFileString()
    if _isUserListFileExist() then
        return cc.FileUtils:getInstance():getStringFromFile(_getUserListFile())
    else
        return ""
    end
end

function _getUserListFileObject()
    local str = _getUserListFileString()

    if str == "" then
        return {}
    else
        return JSON:decode(str)
    end
end

function _updateUserListFile(data)
   local json = JSON:encode_pretty(data)

   local fp = io.open(_getUserListFile(), "w")
   fp:write(json)
   fp:close()
end
