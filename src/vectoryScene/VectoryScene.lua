module ("src.vectoryScene.VectoryScene",package.seeall)

local currentUser = require "src.data.CurrentUser"
local sceneControl = require "src.common.SceneControl"
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
function creatReloadLuaButton()
	local reloadButton = ccui.Button:create("res/reloadLua.png","res/reloadLua.png","res/reloadLua.png")
	reloadButton:addTouchEventListener(reloadLua)
	reloadButton:setPosition(cc.p(origin.x + visibleSize.width * 0.03,origin.y + visibleSize.height * 0.98))

	return reloadButton
end

function reloadLua(sender,eventType)
	if eventType == ccui.TouchEventType.began then
		local loadedModule = package.loaded
		
		for moduleName,_ in pairs(loadedModule) do
			if string.find(moduleName,"src.") ~= nil then
				package.loaded[moduleName] = nil  
    			require(moduleName)
    		end
    	end
	end
end
--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------

function tapConfirmButton()
	sceneControl.changeToScene("HomePage")
end

function creatVectoryScene()
	-- 加载胜利场景
	local vectoryScene = ccs.SceneReader:getInstance():createNodeWithSceneFile("res/VectoryScene/Resources/publish/VectoryScene.json")
	local confirmButton = vectoryScene:getChildByTag(2):getComponent("GUIComponent"):getNode():getChildByTag(7)
	confirmButton:addTouchEventListener(tapConfirmButton)

	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	vectoryScene:addChild(creatReloadLuaButton(),10)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return vectoryScene
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatVectoryScene()) 
    return sceneGame
end