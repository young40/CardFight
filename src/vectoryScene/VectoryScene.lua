module ("src.vectoryScene.VectoryScene",package.seeall)

local currentUser = require "src.data.CurrentUser"
local sceneControl = require "src.common.SceneControl"
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

function tapConfirmButton()
	sceneControl.changeToScene("HomePage")
end

function creatVectoryScene()
    card = currentUser.getNewCard()
    
    print(card)
    
	-- 加载胜利场景
	local vectoryScene = ccs.SceneReader:getInstance():createNodeWithSceneFile("res/VectoryScene/Resources/publish/VectoryScene.json")
	local confirmButton = vectoryScene:getChildByTag(2):getComponent("GUIComponent"):getNode():getChildByTag(7)
	confirmButton:addTouchEventListener(tapConfirmButton)
	
	return vectoryScene
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatVectoryScene()) 
    return sceneGame
end