local storyboard = require"storyboard"

storyboard.gotoScene("MainMenu", "crossFade", 100)

local function checkmem()
    collectgarbage()
    print( "MemUsage: " .. string.format("%.03f",collectgarbage("count")) .. " KB" ) -- print in KB
    
    local textMem = system.getInfo( "textureMemoryUsed" ) / 1048576
    print( "TexMem:   " .. string.format("%.03f", textMem) .. " MB" ) -- print in MB
end

timer.performWithDelay(3000, checkmem, 0)

