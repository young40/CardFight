module ("src.fighterScene.FighterLogic",package.seeall)

local visibleSize       = cc.Director:getInstance():getVisibleSize()
local origin            = cc.Director:getInstance():getVisibleOrigin()
local myFighters        = {}--静态初始我方的卡牌参展阵容
local otherFighters     = {}--静态初始敌方的卡牌参展阵容
local tempMyFighters    = {}--战斗中动态我方的卡牌参展阵容
local tempOtherFighters = {}--战斗中动态敌方的卡牌参展阵容
local scriptHandle      = nil--预约函数的句柄
local myFightTime       = nil--目前处于我方出战的时间段
local myFightNum        = nil--战斗中我方卡牌的战斗次序
local otherFightNum     = nil--战斗中敌方卡牌的战斗次序
local currentMy         = nil--战斗中当前正在出战的我方卡牌
local currentOther      = nil--战斗中当前正在出战的敌方卡牌
local moveVectorBack    = nil--卡牌播放完攻击动画时需要回归到初始位置

--攻击动画帧事件的回调
function onFrameEvent( bone,evt,originFrameIndex,currentFrameIndex)
	--根据出战卡牌敌我不同计算归位坐标
	if myFightTime then
		moveVectorBack = cc.pAdd(moveVectorBack,cc.p(0,60))
	elseif not  myFightTime then
		moveVectorBack = cc.pSub(moveVectorBack,cc.p(0,60))
	end
	--卡牌归位，之后触发fightRound函数，进行下回合的战斗
	local moveBackAction = cc.MoveBy:create(0.5,moveVectorBack)
	local callFunBack  = cc.CallFunc:create(fightRound)
 	local actionArray = {moveBackAction,callFunBack}
 	local sequece = cc.Sequence:create(actionArray)

 	if myFightTime then
		currentMy:runAction(sequece)
		currentMy:getParent():getParent():reorderChild(currentMy:getParent(),1)
		--如果我方卡牌全部出战一次，则置myFightTime为false，myFightNum重新归为1
		if myFightNum > table.getn(tempMyFighters) then
 			myFightTime = false
 			myFightNum = 1
 		end
	elseif not  myFightTime then
		currentOther:runAction(sequece)
		currentOther:getParent():getParent():reorderChild(currentOther:getParent(),1)
		--如果我敌卡牌全部出战一次，则置myFightTime为true，otherFightNum重新归为1
		if otherFightNum > table.getn(tempOtherFighters) then
 			myFightTime = true
 			otherFightNum = 1
 		end
	end
end

--当卡牌移动到目标卡牌位置的回调，当前卡牌播放攻击动画
function attackEnemyBack()
	if myFightTime then
		currentMy:getAnimation():play("attack")
		--计算伤害血量值，更新相关数据
		local myBlood = currentOther.cardInfo.blood - currentMy.cardInfo.attack
		if myBlood <= 0 then
			currentOther:setVisible(false)
		else
			local currentPercent = currentOther:getChildByTag(101):getPercent()
			local subPercent = currentPercent - ((currentMy.cardInfo.attack)/(currentOther.cardInfo.blood))*100
			currentOther:getChildByTag(101):setPercent(subPercent)
			currentOther.cardInfo.blood = currentOther.cardInfo.blood - currentMy.cardInfo.attack
		end
	elseif not myFightTime then
		currentOther:getAnimation():play("attack")
		--计算伤害血量值，更新相关数据
		local otherBlood = currentMy.cardInfo.blood - currentOther.cardInfo.attack
		if otherBlood <= 0 then
			currentMy:setVisible(false)
		else
			local currentPercent = currentMy:getChildByTag(101):getPercent()
			local subPercent = currentPercent - ((currentOther.cardInfo.attack)/(currentMy.cardInfo.blood))*100
			cclog("%f     %f     %f ",currentPercent,currentOther.cardInfo.attack,currentMy.cardInfo.blood)
			currentMy:getChildByTag(101):setPercent(subPercent)
			currentMy.cardInfo.blood = currentMy.cardInfo.blood - currentOther.cardInfo.attack
		end
	end
end

--每一回合判断游戏的结果，是胜利还是失败
function jugleGame()
	--tempMyFighters保存我方Visible为true的卡牌数组，即没有死亡的卡牌
	tempMyFighters = {}
    for _,card in pairs(myFighters) do
    	if card:isVisible() then
    		tempMyFighters[#tempMyFighters+1] = card
    	end
    end
    --tempOtherFighters保存敌方Visible为true的卡牌数组，即没有死亡的卡牌
    tempOtherFighters = {}
    for _,card in pairs(otherFighters) do
    	if card:isVisible() then
    		tempOtherFighters[#tempOtherFighters+1] = card
    	end
    end

    if table.getn(myFighters) == 0 then
    	cclog("您胜利了！")
    	return nil
    elseif table.getn(tempOtherFighters) == 0 then
    	cclog("您失败了！")
    	return nil
    end
    return tempMyFighters,tempOtherFighters
end

--每一回合的战斗逻辑
function fightRound()
	--首先判断游戏结果
    local tempMyFighters,tempOtherFighters = jugleGame()
    if tempMyFighters == nil then
    	return
    end

	if myFightTime then 
		--我方使用随机数，随机选择战斗目标
    	math.randomseed(os.time())  
 		local attackTarget = math.random(table.getn(tempOtherFighters))
 		currentMy = tempMyFighters[myFightNum]
 		currentOther = tempOtherFighters[attackTarget]
 		--计算相关位置坐标信息
 		local enemyPosition = tempOtherFighters[attackTarget]:convertToWorldSpaceAR(cc.p(0,0))
 		local myPosition = tempMyFighters[myFightNum]:convertToWorldSpaceAR(cc.p(0,0))
 		local moveVectorTo = cc.pSub(enemyPosition,myPosition)
 		moveVectorTo = cc.pSub(moveVectorTo,cc.p(0,60))
 		moveVectorBack = cc.pSub(myPosition,enemyPosition)
 		--创建动作序列
 		local moveToAction = cc.MoveBy:create(0.5,moveVectorTo)
 		local callFunBack  = cc.CallFunc:create(attackEnemyBack)
 		local actionArray = {moveToAction,callFunBack}
 		local sequece = cc.Sequence:create(actionArray)
 		currentMy:getParent():getParent():reorderChild(currentMy:getParent(),2)
 		currentMy:runAction(sequece)
 		--出战顺序加1
 		myFightNum = myFightNum + 1
 	elseif not myFightTime then
 		--敌方使用随机数，随机选择战斗目标
 		math.randomseed(os.time())  
 		local attackTarget = math.random(table.getn(tempMyFighters))
 		currentMy = tempMyFighters[attackTarget]
 		currentOther = tempOtherFighters[otherFightNum]
 		--计算相关位置坐标信息
 		local enemyPosition = tempOtherFighters[otherFightNum]:convertToWorldSpaceAR(cc.p(0,0))
 		local myPosition = tempMyFighters[attackTarget]:convertToWorldSpaceAR(cc.p(0,0))
 		local moveVectorTo = cc.pSub(myPosition,enemyPosition)
 		moveVectorTo = cc.pAdd(moveVectorTo,cc.p(0,60))
 		moveVectorBack = cc.pSub(enemyPosition,myPosition)
 		--创建动作序列
 		local moveToAction = cc.MoveBy:create(0.5,moveVectorTo)
 		local callFunBack  = cc.CallFunc:create(attackEnemyBack)
 		local actionArray = {moveToAction,callFunBack}
 		local sequece = cc.Sequence:create(actionArray)
 		currentOther:getParent():getParent():reorderChild(currentOther:getParent(),2)
 		currentOther:runAction(sequece)
 		--出战顺序加1
 		otherFightNum = otherFightNum + 1
 	end
end

function beginFight()
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scriptHandle)
	--初始化数据
	myFightTime = true
	myFightNum = 1
	otherFightNum = 1
	--调用方法，进行每一回合的战斗
 	fightRound()
end 

function creatCards(fighterScene,cardsArray,enemyArray)
	if cardsArray ~= nil and enemyArray ~= nil then
		--myFighters
		-- for i=1,3 do
		-- 	local fighterCard = fighterScene:getChildByTag(i):getComponent("CCArmature"):getNode()
		-- 	local cardBlood = ccui.LoadingBar:create("res/CardFighterScene/Power.png",100)
		-- 	cardBlood:setDirection(ccui.LoadingBarType.left)
		-- 	cardBlood:setPosition(cc.p(10,140))
		-- 	fighterCard:addChild(cardBlood,10,101)
		-- 	fighterCard:setVisible(false)
		-- end

		-- local cardNum = 0
		-- myFighters = {}
		-- for _,card in pairs(cardsArray) do
		-- cardNum = cardNum + 1
		-- local cardNode = fighterScene:getChildByTag(cardNum):getComponent("CCArmature"):getNode()
		-- cardNode.card = card
		-- cardNode:getAnimation():setFrameEventCallFunc(onFrameEvent)
		-- myFighters[#myFighters+1] = cardNode
		-- local skin = ccs.Skin:createWithSpriteFrameName(card["big_image"])
		-- cardNode:setVisible(true)
  --       cardNode:getBone("Card"):addDisplay(skin,1)
  --       cardNode:getBone("Card"):changeDisplayWithIndex(1,true)
		-- end

		--otherFighters
		-- for i=4,6 do
		-- 	local fighterCard = fighterScene:getChildByTag(i):getComponent("CCArmature"):getNode()
		-- 	local cardBlood = ccui.LoadingBar:create("res/CardFighterScene/Power.png",100)
		-- 	cardBlood:setDirection(ccui.LoadingBarType.left)
		-- 	cardBlood:setPosition(cc.p(10,140))
		-- 	fighterCard:addChild(cardBlood,10,101)
		-- 	fighterCard:setVisible(false)
		-- end

		-- local cardNum = 4
		-- otherFighters = {}
		-- for _,card in pairs(enemyArray) do
		-- cardNum = cardNum + 1
		-- local cardNode = fighterScene:getChildByTag(cardNum):getComponent("CCArmature"):getNode()
		-- cardNode.card = card
		-- cardNode:getAnimation():setFrameEventCallFunc(onFrameEvent)
		-- otherFighters[#otherFighters+1] = cardNode
		-- local skin = ccs.Skin:createWithSpriteFrameName(card["big_image"])
		-- cardNode:setVisible(true)
  --       cardNode:getBone("Card"):addDisplay(skin,1)
  --       cardNode:getBone("Card"):changeDisplayWithIndex(1,true)
		-- end


----------------以下为测试代码，正式资源给了之后去除----------------------
		myFighters = {}
		for i=1,3 do
			local card = fighterScene:getChildByTag(i):getComponent("CCArmature"):getNode()
			card.cardInfo = {attack = 20, blood = 100}
			card:getAnimation():setFrameEventCallFunc(onFrameEvent)
			local cardBlood = ccui.LoadingBar:create("res/CardFighterScene/Power.png",100)
			cardBlood:setDirection(ccui.LoadingBarType.left)
			cardBlood:setPosition(cc.p(10,140))
			card:addChild(cardBlood,10,101)
			myFighters[#myFighters+1] = card
		end

		otherFighters = {}
		for i=4,6 do
			local card = fighterScene:getChildByTag(i):getComponent("CCArmature"):getNode()
			card.cardInfo = {attack = 20, blood = 100}
			card:getAnimation():setFrameEventCallFunc(onFrameEvent)
			local cardBlood = ccui.LoadingBar:create("res/CardFighterScene/Power.png",100)
			cardBlood:setDirection(ccui.LoadingBarType.left)
			cardBlood:setPosition(cc.p(10,140))
			card:addChild(cardBlood,10,101)
			otherFighters[#otherFighters+1] = card
		end
----------------以上为测试代码，正式资源给了之后去除----------------------

		--进入战斗场景延迟1秒开始战斗流程
		scriptHandle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(beginFight, 1.0, false)
	end
end