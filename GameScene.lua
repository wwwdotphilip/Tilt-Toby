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
num.transSpeed = 1000
num.rectnum = 1
num.score = 0
num.rand = math.random
num.bgTrack = num.rand(1, 4)
bol.remove = false
bol.touch = false
sound.stopSound = false

physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

function func.onAccelerate( event )
--        img.ball.x = num._CX + (num._CX * event.yInstant * -1)
--	img.ball.y = num._CY + (num._CY * event.xInstant * -1)
        
	img.ball.x = num._CX + (num._CX * event.yGravity * -1)
	img.ball.y = num._CY + (num._CY * event.xGravity * -1)
end

function func.buttonEvent(event)
    local t = event.target
    sound.stopSound = true
    sound.stop()
    sound.playButton(str.effect)
    if t.name == "quit" then
        bol.remove = true
        physics.stop()
        storyboard.gotoScene("MainMenu", "crossFade", 100)
    else
        
    end
end

function func.collide(event)
    local phase = event.phase
    local t = event.object1
    local o = event.object2
    if phase == "began" then
        if t.name == "ball" then
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
        elseif o.name == "ball" then
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
        elseif t.name == "wallleft" or t.name == "wallright" or t.name == "walltop" or t.name == "wallbuttom" then
            num.score = num.score + 5
            o:removeSelf();
            o = nil;
        elseif o.name == "wallleft" or o.name == "wallright" or o.name == "walltop" or o.name == "wallbuttom" then
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
        rect[num.rectnum].name = "rect"
        physics.addBody(rect[num.rectnum], "dynamic", {isSensor = true, bounce = 0, density = 0, friction = 0})
        rect[num.rectnum]:setLinearVelocity( speedx, speedy )
        num.rectnum = num.rectnum + 1
        if num.interval > 100 then
            num.interval = num.interval - 10
            num.transSpeed = num.transSpeed + 5
        end
        print(num.interval)
        timer.performWithDelay(num.interval, func.makeShape)
    end
end

function func.onScreenTouch(event)
    local t = event
    if t.phase == "began" then
        
    elseif t.phase == "ended" then
        if bol.touch then
            print("Restore")
            screenGroup:scale(2, 2)
            screenGroup.x = 0;screenGroup.y = 0;
            bol.touch = false
        elseif bol.touch == false then
            print("Minimize")
            screenGroup:scale(0.5, 0.5)
            screenGroup.x = num._CX * .5;screenGroup.y = num._CY * .5;
            bol.touch = true
        end
        
    end
end

function func.round(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.getCeil(num * mult - 0.5) / mult end
end

function func.addScore()
    num.score = num.score + .25
    text.score.text = "Score: " .. func.round(num.score, 0)
    text.score:setReferencePoint(display.TopLeftReferencePoint)
    text.score.x = 20
end

function scene:createScene( event )
    screenGroup = self.view;
    str.params = event.params
    str.sound = str.params.sound
    str.effect = str.params.effect
    sound.loadSounds()
    sound.playBgSound(num.bgTrack,str.sound)
    img.rectGroup = display.newGroup()
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
    
    img.ball = display.newImageRect(screenGroup, "images/greenBall.png", 57, 57)
    img.ball.x = num._CX; img.ball.y = num._CY;
    img.ball.name = "ball"
    physics.addBody(img.ball, "static", {radius = 26})
    
    button.quit = widget.newButton{
        width = 120,
        height = 80,
        label = "Quit",
        fontSize = 40,
        onRelease = func.buttonEvent
    }
    button.quit.x = num._W - 70;button.quit.y = 55
    button.quit.name = "quit"
    
    text.score = display.newText("Score: " .. num.score, 20, 20, native.systemFont, 40)
    screenGroup:insert(img.rectGroup)
    screenGroup:insert(text.score)
    screenGroup:insert(button.quit)
end

function scene:enterScene( event )
    local prev = storyboard.getPrevious()
    if(prev ~= nil) then
        storyboard.removeScene(prev)
    end
    Runtime:addEventListener ("accelerometer", func.onAccelerate);
    Runtime:addEventListener("collision", func.collide)
    Runtime:addEventListener("enterFrame", func.addScore)
--    Runtime:addEventListener("touch", func.onScreenTouch)
    timer.performWithDelay(num.interval, func.makeShape)
end

function scene:exitScene( event )
    -- This is where you remove all variables.
    Runtime:removeEventListener ("accelerometer", func.onAccelerate);
    Runtime:removeEventListener("collision", func.collide)
    Runtime:removeEventListener("enterFrame", func.addScore)
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



