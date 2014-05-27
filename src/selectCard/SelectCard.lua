module ("src.selectCard.SelectCard",package.seeall)

local sceneControl = require "src.common.SceneControl"
local currentUser = require "src.data.CurrentUser"
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()
local selectCardUI = nil
local listSelectView = nil

function tapConfirmButton(sender,eventType)
	if eventType == ccui.TouchEventType.began then
		sceneControl.changeToScene("HomePage")
	end
end

function touchListViewEvent(sender, eventType)
    if eventType == ccui.ListViewEventType.onsSelectedItem then
        --cclog("select child index = ",sender:getCurSelectedIndex())
    end
end

function selectedEvent(sender,eventType)
    if eventType == ccui.CheckBoxEventType.selected then
        --self._displayValueLabel:setText("Selected")
        --cclog("%d",sender.id)
    elseif eventType == ccui.CheckBoxEventType.unselected then
        --self._displayValueLabel:setText("Unselected")
    end
end  

function addSelectCard(texture,power,cpu,name,star,selected,id)
	local selectCardCellUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/SelectCardCellUI_1/SelectCardCellUI_1.json")
	local cardThumbnail    = selectCardCellUI:getChildByTag(2)
	local powerValue       = selectCardCellUI:getChildByTag(4)
	local cpuValue         = selectCardCellUI:getChildByTag(6)
	local nameValue        = selectCardCellUI:getChildByTag(8)
	local starValue        = selectCardCellUI:getChildByTag(10)
	local checkBox         = selectCardCellUI:getChildByTag(11)

	cardThumbnail:loadTexture(texture)
	powerValue:setText(power)
	cpuValue:setText(cpu)
	nameValue:setText(name)
	starValue:setText(star)
	checkBox:setSelectedState(selected)
	checkBox:addEventListenerCheckBox(selectedEvent)
	checkBox.id = id

    listSelectView:pushBackCustomItem(selectCardCellUI) 
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

function creatLayerSelectCard()
	local selectCardLayer = cc.Layer:create()
	-- 加载注册登录界面UI
	selectCardUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/SelectCardUI_1/SelectCardUI_1.json")

	-- 确定按钮
	local confirmButton = selectCardUI:getChildByTag(3)
	confirmButton:addTouchEventListener(tapConfirmButton)

	-- 添加卡牌列表项
	listSelectView = selectCardUI:getChildByTag(2)
	listSelectView:addEventListenerListView(touchListViewEvent)

	for i=1,10 do
		addSelectCard("",80,"1GHZ","大米手机","1",false,2175021)
	end
	local cardList = currentUser.getCardList()
	if cardList ~= nil then
		for _,card in pairs(cardList) do
		--addSelectCard(cardList["icon_image"],cardList["life"],cardList["attack"],cardList["name"],cardList["star"],false,cardList["id"])
	end
	end

	selectCardLayer:addChild(selectCardUI)
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	selectCardLayer:addChild(creatReloadLuaButton())
	--------------------------------重新加载脚本函数，测试使用，发布版本删除-----------------------------------------
	
	return selectCardLayer
end 

function create()
    -- 创建场景
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(creatLayerSelectCard())
    return sceneGame
end