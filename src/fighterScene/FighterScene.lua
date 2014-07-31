module ("src.fighterScene.FighterScene",package.seeall)

local currentUser = require "src.data.CurrentUser"
local fighterLogic = require "src.fighterScene.FighterLogic"
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

function creatFighterScene()
	-- 加载战斗场景
	local fighterScene = ccs.SceneReader:getInstance():createNodeWithSceneFile("res/FighterScene/Resources/publish/MainFighterScene.json")

	local Checkpoint = currentUser.getCheckpoint()

	local myFighters = currentUser.getFighters()
	local otherFighters = currentUser.getEnemyCard(Checkpoint)
-- local JSON = require "src.data.JSON"

-- 	for _,card in pairs(otherFighters) do
-- 		print(JSON:encode_pretty(card) .. "111111111111")
-- 	end
	
	fighterLogic.creatCards(fighterScene,myFighters,otherFighters)
	
	return fighterScene
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatFighterScene()) 
    return sceneGame
end