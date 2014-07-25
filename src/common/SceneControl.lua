module ("src.common.SceneControl",package.seeall)

local HomePage      = require "src.homePage.HomePage"
local SelectCard    = require "src.selectCard.SelectCard"
local FighterScene  = require "src.fighterScene.FighterScene"
local VectoryScene  = require "src.vectoryScene.VectoryScene"

--场景表，新增加一个切换场景要在这里添加一项
local creatGameScene = 
{
	HomePage      = HomePage.create,
	SelectCard    = SelectCard.create,
	FighterScene  = FighterScene.create,
	VectoryScene  = VectoryScene.create,
}

function changeToScene(scene)
	cc.Director:getInstance():replaceScene(cc.TransitionSlideInR:create(0.5,creatGameScene[scene]()))
end