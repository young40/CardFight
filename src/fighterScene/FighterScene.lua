module ("src.fighterScene.FighterScene",package.seeall)

local currentUser = require "src.data.CurrentUser"
local fighterLogic = require "src.fighterScene.FighterLogic"
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

function creatFighterScene()
	-- 加载战斗场景
	local fighterScene = ccs.SceneReader:getInstance():createNodeWithSceneFile("res/CardFighterScene/publish/MainFighterScene.json")
	local myFighters = currentUser.getFighters()
	----------------以下为测试代码，正式资源给了之后去除----------------------
	local otherFighters = {1}
	----------------以上为测试代码，正式资源给了之后去除----------------------
	--currentUser.getFighters()

	fighterLogic.creatCards(fighterScene,myFighters,otherFighters)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	fighterScene:addChild(creatReloadLuaButton(),10)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return fighterScene
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatFighterScene()) 
    return sceneGame
end