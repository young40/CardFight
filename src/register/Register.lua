module ("Register",package.seeall)

local user = require "src.data.User"

local registerUI = nil
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- 用于CCLuaEngine追溯
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

function tapLoginButton(sender,eventType)
	local userNameText = registerUI:getChildByTag(3)
	if eventType == ccui.TouchEventType.began and userNameText:getStringValue()~= "" then
		--写入到json文件
		local userId = user.reg(userNameText:getStringValue())
	end
end

function tapLoginHistory(sender,eventType)
	if eventType == ccui.TouchEventType.began and sender:isVisible() then
		local userId = user.reg(sender:getTitleText())
	end
end

-- 显示登录历史列表
function showUserLoginHistory()
	local loginHistory = {}
	for i=1,3,1 do
		local userName = registerUI:getChildByTag(6):getChildByTag(i)
		userName:setVisible(false)
		userName:addTouchEventListener(tapLoginHistory)
		loginHistory[i] = userName
	end

	local userList = user.getUserList()
	for i=1,3,1 do
		if userList[#userList+1-i] ~= nil and userList[#userList+1-i]["name"] ~= nil then
		 	loginHistory[i]:setVisible(true)
		 	loginHistory[i]:setTitleText(userList[#userList+1-i]["name"])
		end
	end
end

--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
function creatReloadLuaButton()
	local reloadButton = ccui.Button:create("res/reloadLua.png","res/reloadLua.png","res/reloadLua.png")
	reloadButton:addTouchEventListener(reloadLua)
	reloadButton:setPosition(cc.p(origin.x + visibleSize.width * 0.03,origin.y + visibleSize.height * 0.98))

	return reloadButton
end

function reloadLua(sender,eventType)
	if eventType == ccui.TouchEventType.began then
		
		package.loaded["src.register.Register.lua"] = nil  
    	require("src.register.Register.lua")
    	
	end
end
--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------

function creatLayerRegister()
	local registerLayer = cc.Layer:create()
	-- 加载注册登录界面UI
	registerUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/RegisterUI_1/RegisterUI_1.json")
	local loginButton = registerUI:getChildByTag(4)
	loginButton:addTouchEventListener(tapLoginButton)

	-- 显示登录历史列表
	showUserLoginHistory()

	registerLayer:addChild(registerUI)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	registerLayer:addChild(creatReloadLuaButton())
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return registerLayer
end 

function main()
    collectgarbage("collect")
    -- 防止内存泄露
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	cc.FileUtils:getInstance():addSearchResolutionsOrder("src")
	cc.FileUtils:getInstance():addSearchResolutionsOrder("res")

    -- 运行场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatLayerRegister())
	
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(sceneGame)
	else
		cc.Director:getInstance():runWithScene(sceneGame)
	end

end

xpcall(main, __G__TRACKBACK__)


