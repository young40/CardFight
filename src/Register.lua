local schedulerID = 0
local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- 用于CCLuaEngine追溯
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

local function creatLayerRegister()
	local registerLayer = cc.Layer:create()
	-- 加载注册登录界面UI
	local registerUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/RegisterUI_1/RegisterUI_1.ExportJson")
	registerLayer:addChild(registerUI)
	
	return registerLayer
end 

local function main()
    collectgarbage("collect")
    -- 防止内存泄露
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	cc.FileUtils:getInstance():addSearchResolutionsOrder("src")
	cc.FileUtils:getInstance():addSearchResolutionsOrder("res")

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
