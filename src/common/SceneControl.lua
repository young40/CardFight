module ("src.common.SceneControl",package.seeall)

local HomePage = require "src.homePage.HomePage"
local SelectCard = require "src.selectCard.SelectCard"

local creatGameScene = 
{
	HomePage      = HomePage.create,
	SelectCard    = SelectCard.create,
}

function changeToScene(scene)
	cc.Director:getInstance():replaceScene(cc.TransitionSlideInR:create(0.5,creatGameScene[scene]()))
end