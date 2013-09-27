local storyboard = require"storyboard";
local widget = require"widget"
local physics = require"physics"
local scene = storyboard.newScene();
local sound = require"sound"
local screenGroup;

local button = {}
local num = {}
local func = {}
local text = {}
local img = {}
local bol = {}
local rect = {}
local wall = {}
local str = {}

num._W = display.contentWidth
num._H = display.contentHeight
num._CX = display.contentCenterX
num._CY = display.contentCenterY
num.interval = 1000
num.transSpeed = num.interval
num.make = num.interval
num.rectnum = 1
num.score = 0
num.countDown = 3
num.rand = math.random
num.bgTrack = num.rand(1, 4)
num.lastObj = 1
num.life = 1
bol.remove = false
bol.touch = false
sound.stopSound = false
bol.invincible = false
bol.slowtime = false

physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

function func.onAccelerate( event )
    if str.isPaused == false then
        --        img.ball.x = num._CX + (num._CX * event.yInstant * -1)
        --	img.ball.y = num._CY + (num._CY * event.xInstant * -1)
        img.ball.x = num._CX + (num._CX * event.yGravity * -1)
        img.ball.y = num._CY + (num._CY * event.xGravity * -1)
    end
end

function func.resumeGame()
    sound.playButton(str.effect)
    if num.countDown == 0 then
        text.count:removeSelf()
        text.count = nil
        num.countDown = 3
        str.isPaused = false
        physics.start()
        sound.resumeSound()
        
        button.pause = widget.newButton{
            width = 80,
            height = 80,
            defaultFile = "images/pause.png",
            overFile = "images/pauseOver.png",
            onRelease = func.buttonEvent
        }
        button.pause.x = num._W - 70;button.pause.y = 55
        button.pause.name = "pause"
        screenGroup:insert(button.pause)
        
    else
        if text.count ~= nil then
            text.count.text = num.countDown
            num.countDown = num.countDown - 1
        else
            text.count = display.newText(screenGroup, num.countDown, 0, 0, native.systemFont, 220)
            text.count.x = num._CX;text.count.y = num._CY;
            num.countDown = num.countDown - 1
        end
        timer.performWithDelay(1000, func.resumeGame)
    end
end

function func.alertListener(event)
    local i = event.index
    if 1 == i then
        sound.stopSound = true
        sound.stop()
        bol.remove = true
        physics.stop()
        storyboard.gotoScene("MainMenu", "crossFade", 100)
    else
        
    end
end

function func.buttonEvent(event)
    local t = event.target
    sound.playButton(str.effect)
    if t.name == "pause" then
        if str.isPaused then
            button.pause:removeSelf()
            button.pause = nil
            img.pauseGroup.alpha = 1
            
            if text.pause ~= nil then
                text.pause:removeSelf()
                text.pause = nil
                button.quit:removeSelf()
                button.quit = nil
            end
            func.resumeGame()
        else
            str.isPaused = true
            num.countDown = 3
            if text.count ~= nil then
                text.count:removeSelf()
                text.count = nil
            end
         
            button.pause:removeSelf()
            button.pause = nil
            img.pauseGroup.alpha = 0
            physics.pause()
            sound.pause()
            
            button.pause = widget.newButton{
                width = 80,
                height = 80,
                defaultFile = "images/resume.png",
                overFile = "images/resumeOver.png",
                onRelease = func.buttonEvent
            }
            button.pause.x = num._W - 70;button.pause.y = 55
            button.pause.name = "pause"
            screenGroup:insert(button.pause)
            
            button.quit = widget.newButton{
                width = 80,
                height = 80,
                defaultFile = "images/exit.png",
                overFile = "images/exitOver.png",
                onRelease = func.buttonEvent
            }
            button.quit.x = num._W - 180;button.quit.y = 55
            button.quit.name = "quit"
            screenGroup:insert(button.quit)
            
            text.pause = display.newText("PAUSED", 0, 0, native.systemFont, 220)
            text.pause.x = num._CX;text.pause.y = num._CY;
            screenGroup:insert(text.pause)
            
        end
    elseif t.name == "quit" then
        native.showAlert("Quit game?", "Are you sure?", {"Yes", "No"}, func.alertListener)
    end
end

function func.collide(event)
    local phase = event.phase
    local t = event.object1
    local o = event.object2
    if phase == "began" then
        if t.name == "ball" then
            if bol.invincible then
                
            elseif num.life > 1 then
                local function isHit()
                    local a = 1
                    if t.alpha == 1 then
                        a = 0
                    end
                    transition.to(t, {alpha = a})
                end
                num.life = num.life - 1
                sound.playDeadSound(str.effect)
                timer.performWithDelay(200, isHit, 4)
            else
                sound.stopSound = true
                sound.stop()
                sound.playDeadSound(str.effect)
                o:removeSelf();
                o = nil;
                bol.remove = true
                physics.stop()
                local options = {
                    effect = "crossFade",
                    time = 100,
                    params = {
                        score = func.round(num.score, 0),
                        sound = str.sound,
                        effect = str.effect,
                    }
                }
                storyboard.gotoScene("GameOver", options)
            end
        elseif o.name == "ball" then
            if bol.invincible then
                
            elseif num.life > 1 then
                local function isHit()
                    local a = 1
                    if o.alpha == 1 then
                        a = 0
                    end
                    transition.to(o, {alpha = a})
                end
                num.life = num.life - 1
                sound.playDeadSound(str.effect)
                timer.performWithDelay(100, isHit, 4)
            else
                num.life = num.life - 1
                sound.stopSound = true
                sound.stop()
                sound.playDeadSound(str.effect)
                t:removeSelf();
                t = nil;
                bol.remove = true
                physics.stop()
                local options = {
                    effect = "crossFade",
                    time = 100,
                    params = {
                        score = func.round(num.score, 0),
                        sound = str.sound,
                        effect = str.effect,
                    }
                }
                storyboard.gotoScene("GameOver", options)
            end
            
        elseif t.name == "wallleft" or t.name == "wallright" or t.name == "walltop" or t.name == "wallbuttom" then
            num.lastObj = o.id
            num.score = num.score + 5
            o:removeSelf();
            o = nil;
        elseif o.name == "wallleft" or o.name == "wallright" or o.name == "walltop" or o.name == "wallbuttom" then
            num.lastObj = o.id
            num.score = num.score + 5
            t:removeSelf();
            t = nil;
        end
    elseif phase == "ended" then
        
    end
end

function func.makeShape()
    if bol.remove == false then
        local x
        local y
        local speedx = 0
        local speedy = 0
        local dir = num.rand(1, 4)
        local rectx2 = num.rand(10, 80)
        local recty2 = num.rand(10, 80)
        
        if dir == 1 then
            x = -50
            y = num.rand(50, num._H - 50)
            speedx = num.transSpeed * .25
        elseif dir == 2 then
            x = num._W + 50
            y = num.rand(50, num._H - 50)
            speedx = -num.transSpeed * .25
        elseif dir == 3 then
            x = num.rand(50, num._W - 50)
            y = -50
            speedy = num.transSpeed * .25
        elseif dir == 4 then
            x = num.rand(50, num._W - 50)
            y = num._H + 50
            speedy = -num.transSpeed * .25
        end
        rect[num.rectnum] = display.newRect(img.rectGroup, x, y, rectx2, recty2)
        rect[num.rectnum]:setFillColor(num.rand(100, 255), num.rand(100, 255), num.rand(100, 255))
        rect[num.rectnum].name = "rect"
        rect[num.rectnum].id = num.rectnum
        physics.addBody(rect[num.rectnum], "dynamic", {isSensor = true, bounce = 0, density = 0, friction = 0})
        rect[num.rectnum]:setLinearVelocity( speedx, speedy )
        num.rectnum = num.rectnum + 1
        if num.interval > 100 then
            num.interval = num.interval - 10
            num.transSpeed = num.transSpeed + 5
        end
    end
end

function func.onScreenTouch(event)
    local t = event
    if t.phase == "began" then
        
    elseif t.phase == "ended" then
        if bol.touch then
            screenGroup:scale(2, 2)
            screenGroup.x = 0;screenGroup.y = 0;
            bol.touch = false
        elseif bol.touch == false then
            screenGroup:scale(0.5, 0.5)
            screenGroup.x = num._CX * .5;screenGroup.y = num._CY * .5;
            bol.touch = true
        end
        
    end
end

function func.doubleTap(event)
    if (event.numTaps > 1 ) then
        if str.powerup == "invincibility" then
            bol.invincible = true
        elseif str.powerup == "slowtime" then
            bol.slowtime = true
        end
    end
    return true
end

function func.round(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then 
        return math.floor(num * mult + 0.5) / mult
    else 
        return math.getCeil(num * mult - 0.5) / mult 
    end
end

function func.commaVal(amount)
    local formatted = amount
    local k;
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function func.addScore()
    if str.isPaused == false then
        num.score = num.score + .25
        text.score.text = "Score: " .. func.commaVal(func.round(num.score), 0)
        text.score:setReferencePoint(display.TopLeftReferencePoint)
        text.score.x = 20
        
        if num.make <= 0 then
            func.makeShape()
            num.make = num.interval
        else
            num.make = num.make - 33.3333333
        end
    end
end

function func.onKeyEvent(event)
    local phase = event.phase
    local keyName = event.keyName
    if phase == "up" and keyName == "back" then
        return true
    else
        return false
    end
end

function scene:createScene( event )
    screenGroup = self.view;
    img.pauseGroup = display.newGroup()
    str.params = event.params
    str.sound = str.params.sound
    str.effect = str.params.effect
    str.powerup = str.params.powerup
    num.powerval = str.params.powerval
    sound.loadSounds()
    sound.playBgSound(num.bgTrack,str.sound)
    img.rectGroup = display.newGroup()
    
    img.bg = display.newImageRect(screenGroup, "images/bg.png", num._W, num._H)
    img.bg.x = num._CX; img.bg.y = num._CY;
    
    wall.left = display.newRect(screenGroup, -480, -300, 10, num._H + 600)
    wall.left.name = "wallleft"
    physics.addBody(wall.left, "static", {isSensor = true})
    
    wall.right = display.newRect(screenGroup, num._W + 460, -300, 10, num._H + 600)
    wall.right.name = "wallright"
    physics.addBody(wall.right, "static", {isSensor = true})
    
    wall.top = display.newRect(screenGroup, -440, -320, num._W + 860, 10)
    wall.top.name = "walltop"
    physics.addBody(wall.top, "static", {isSensor = true})
    
    wall.buttom = display.newRect(screenGroup, -440, num._H + 300, num._W + 860, 10)
    wall.buttom.name = "wallbuttom"
    physics.addBody(wall.buttom, "static", {isSensor = true})
    
    img.ball = display.newImageRect("images/greenBall.png", 57, 57)
    img.ball.x = num._CX; img.ball.y = num._CY;
    img.ball.name = "ball"
    physics.addBody(img.ball, "static", {radius = 26})
    
    button.pause = widget.newButton{
        width = 80,
        height = 80,
        defaultFile = "images/pause.png",
        overFile = "images/pauseOver.png",
        onRelease = func.buttonEvent
    }
    button.pause.x = num._W - 70;button.pause.y = 55
    button.pause.name = "pause"
    str.isPaused = false
    
    text.score = display.newText("Score: " .. num.score, 20, 20, native.systemFont, 40)
    img.pauseGroup:insert(img.rectGroup)
    img.pauseGroup:insert(text.score)
    img.pauseGroup:insert(img.ball)
    screenGroup:insert(img.pauseGroup)
    screenGroup:insert(button.pause)
end

function scene:enterScene( event )
    local prev = storyboard.getPrevious()
    if(prev ~= nil) then
        storyboard.removeScene(prev)
    end
    if str.powerup == "extralife" then
        num.life = num.life + num.powerval
    end
    print(num.life)
    system.setTapDelay(0.5)
    Runtime:addEventListener ("accelerometer", func.onAccelerate);
    Runtime:addEventListener("collision", func.collide)
    Runtime:addEventListener("enterFrame", func.addScore)
    Runtime:addEventListener("tap", func.doubleTap)
    Runtime:addEventListener("key", func.onKeyEvent)
    --    Runtime:addEventListener("touch", func.onScreenTouch)
    timer.performWithDelay(num.interval, func.makeShape)
end

function scene:exitScene( event )
    -- This is where you remove all variables.
    system.setTapDelay(0)
    Runtime:removeEventListener ("accelerometer", func.onAccelerate);
    Runtime:removeEventListener("collision", func.collide)
    Runtime:removeEventListener("enterFrame", func.addScore)
    Runtime:removeEventListener("key", func.onKeyEvent)
    Runtime:removeEventListener("tap", func.doubleTap)
    scene:removeEventListener( "createScene", scene );
    scene:removeEventListener( "enterScene", scene );
    scene:removeEventListener( "exitScene", scene );
    scene:removeEventListener( "destroyScene", scene );
end

function scene:destroyScene( event )
    screenGroup = nil
    sound = nil
    physics = nil
    widget = nil
    button = nil
    num = nil
    func = nil
    text = nil
    img = nil
    bol = nil
    rect = nil
    wall = nil
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;