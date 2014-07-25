module ("src.homePage.HomePage",package.seeall)

local homePageUI = nil
local sceneControl = require "src.common.SceneControl"
local currentUser = require "src.data.CurrentUser"

local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

function tapAttackButton(sender,eventType)
	if eventType == ccui.TouchEventType.began then
		sceneControl.changeToScene("FighterScene")
	end
end

function tapAddButton(sender,eventType)
	if eventType == ccui.TouchEventType.began then
		sceneControl.changeToScene("SelectCard")
	end
end

function showFighterCar()
	local fighters = currentUser.getFighters()
	if fighters ~= nil then
		for addPicNum,card in pairs(fighters) do
			if card ~= nil then
				local addPic = homePageUI:getChildByTag(7):getChildByTag(addPicNum)
				addPic:loadTexture("MyMobilePhoneImg/" .. card["big_image"])
			end
		end
	end

	for addPicNum=1,3 do
		local addPic = homePageUI:getChildByTag(7):getChildByTag(addPicNum)
		addPic:addTouchEventListener(tapAddButton)
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

function creatLayerHomePage()
	local homePageLayer = cc.Layer:create()
	-- 加载注册登录界面UI
	homePageUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/HomePageUI/Export/HomePageUI_1.json")
	local addPic1 = homePageUI:getChildByTag(7):getChildByTag(1)
	-- 绑定出击按钮触发事件
	local attackButton = homePageUI:getChildByTag(8)
	attackButton:addTouchEventListener(tapAttackButton)
	-- 更新金币数量
	local goldCoinNum = homePageUI:getChildByTag(6)
	goldCoinNum:setText("" .. currentUser.getGold())
	-- 更新体力值
	local strengthValue = homePageUI:getChildByTag(9):getChildByTag(3)
	strengthValue:setPercent(100)
	-- 显示参战卡牌并绑定按钮事件
	showFighterCar()

	homePageLayer:addChild(homePageUI)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	homePageLayer:addChild(creatReloadLuaButton())
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return homePageLayer
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatLayerHomePage())
    return sceneGame
end


