module ("src.register.Register",package.seeall)

local user = require "src.data.User"
local currentUser = require "src.data.CurrentUser"
local sceneControl = require "src.common.SceneControl"

local registerScene = nil
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

-- cclog
_G.cclog = function(...)
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
	local userNameText = registerScene:getChildByTag(1):getComponent("GUIComponent"):getNode():getChildByTag(3)
	if eventType == ccui.TouchEventType.began and userNameText:getStringValue()~= "" then
		--写入到json文件
		local userId = user.reg(userNameText:getStringValue())
		currentUser.setCurrentId(userId)
		sceneControl.changeToScene("HomePage")
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
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
        local _f = cc.FileUtils:getInstance():fullPathForFilename("json.lua")

        local f = io.popen("dirname " .. _f, "r")
        local _target = f:read('*a')
        f:close()
        _target = string.gsub(_target, "\n", "")
    
        local _cmd = "cp -R " .. _target .. "/../../../../../src " .. _target
        os.execute(_cmd)
    end

	if eventType == ccui.TouchEventType.began then
		local loadedModule = package.loaded

		for moduleName,path in pairs(loadedModule) do
			if string.find(moduleName,"src.") ~= nil then
				package.loaded[moduleName] = nil  
    			require(moduleName)
    		end
    	end
	end
end
--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------

function creatLayerRegister()
	local registerLayer = cc.Layer:create()
	-- 加载注册登录界面UI
	registerScene = ccs.SceneReader:getInstance():createNodeWithSceneFile("res/RegisterScene/Resources/publish/RegisterScene.json")
	local loginButton = registerScene:getChildByTag(1):getComponent("GUIComponent"):getNode():getChildByTag(4)
	loginButton:addTouchEventListener(tapLoginButton)

    --[[
    --local id = user.reg("xxx" .. os.time())
    local id = user.reg("usr1111")
    currentUser.setCurrentId(id)
    --currentUser.getNewCard()
    local ids = {currentUser.getCardList()[2]["id"], currentUser.getCardList()[4]["id"], currentUser.getCardList()[5]["id"]}
    --currentUser.setFighters(ids)
    local oo = currentUser.getFighters() 
    print("----------+++++++++++------")
    --]]

	registerLayer:addChild(registerScene)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	registerLayer:addChild(creatReloadLuaButton(),1)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return registerLayer
end 

function main()
    collectgarbage("collect")
    -- 防止内存泄露
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

	cc.FileUtils:getInstance():addSearchPath("res")
	cc.FileUtils:getInstance():addSearchPath("res/FighterScene/Resources")
	cc.FileUtils:getInstance():addSearchPath("res/RegisterScene/Resources")
	cc.FileUtils:getInstance():addSearchPath("res/VectoryScene/Resources")
	cc.FileUtils:getInstance():addSearchPath("res/SelectCardCellUI/Resources")
	
	cc.FileUtils:getInstance():addSearchPath("src")
	cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640,1136,0);

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


