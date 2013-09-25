local storyboard = require"storyboard";
local widget = require"widget"
local sound = require"sound"
local database = require"database"
local scene = storyboard.newScene();
local screenGroup;

local button = {}
local str = {}
local num = {}
local func = {}
local text = {}

num._W = display.contentWidth
num._H = display.contentHeight
num._CX = display.contentCenterX
num._CY = display.contentCenterY
num.topscore = database.getScore()

str.sound, str.effect = database.getSettings()
str.soundFile = "images/soundOn.png"
str.effectFile = "images/effectOn.png"

function func.buttonEvent(event)
    local t = event.target
    
    if t.name == "start" then
        sound.playButton(str.effect)
        local options = {
            effect = "crossFade",
            time = 100,
            params = {
                sound = str.sound,
                effect = str.effect,
            }
        }
        storyboard.gotoScene("GameScene", options)
    elseif t.name == "sound" then
        button.sound:removeSelf()
        button.sound = nil
        if str.sound == "off" then
            str.soundFile = "images/soundOn.png"
            str.sound = "on"
        else
            str.soundFile = "images/soundOff.png"
            str.sound = "off"
        end
        database.updateSound(str.sound)
        button.sound = widget.newButton{
            width = 60,
            height = 60,
            defaultFile = str.soundFile,
            onRelease = func.buttonEvent
        }
        button.sound.x = num._W - 160; button.sound.y = 50
        button.sound.name = "sound"
        screenGroup:insert(button.sound)
        
    elseif t.name == "effect" then
        button.effect:removeSelf()
        button.effect = nil
        if str.effect == "off" then
            str.effectFile = "images/effectOn.png"
            str.effect = "on"
        else
            str.effectFile = "images/effectOff.png"
            str.effect = "off"
        end
        database.updateEffect(str.effect)
        button.effect = widget.newButton{
            width = 60,
            height = 60,
            defaultFile = str.effectFile,
            onRelease = func.buttonEvent
        }
        button.effect.x = num._W - 80; button.effect.y = 50
        button.effect.name = "effect"
        screenGroup:insert(button.effect)
        
    end
end

function scene:createScene( event )
    screenGroup = self.view;
    
    if str.sound == "off" then
        str.soundFile = "images/soundOff.png"
    end
    if str.effect == "off" then
        str.effectFile = "images/effectOff.png"
    end
    
    text.title = display.newText(screenGroup, "TILT", 0, 0, native.systemFont, 220)
    text.title.x = num._CX;text.title.y = num._CY - 180;
    
    button.start = widget.newButton{
        width = 250,
        height = 170,
        label = "Start",
        fontSize = 60,
        onRelease = func.buttonEvent
    }
    button.start.name = "start"
    button.start.x = num._CX; button.start.y = num._CY + 140
    screenGroup:insert(button.start)
    
    button.sound = widget.newButton{
        width = 60,
        height = 60,
        defaultFile = str.soundFile,
        onRelease = func.buttonEvent
    }
    button.sound.x = num._W - 160; button.sound.y = 50
    button.sound.name = "sound"
    screenGroup:insert(button.sound)
    
    button.effect = widget.newButton{
        width = 60,
        height = 60,
        defaultFile = str.effectFile,
        onRelease = func.buttonEvent
    }
    button.effect.x = num._W - 80; button.effect.y = 50
    button.effect.name = "effect"
    screenGroup:insert(button.effect)
    
    text.help = display.newText(screenGroup, "Do not let the white square", 0, 0, native.systemFont, 47)
    text.help.x = num._CX;text.help.y = num._CY - 60;
    
    text.help = display.newText(screenGroup, "touch the ball", 0, 0, native.systemFont, 47)
    text.help.x = num._CX;text.help.y = num._CY - 10;
    
    text.topscore = display.newText(screenGroup, "Top score: " .. num.topscore, 0, 0, native.systemFont, 45)
    text.topscore:setReferencePoint(display.TopLeftReferencePoint)
    text.topscore.x = 20;text.topscore.y = num._H - 80;
end

function scene:enterScene( event )
    local prev = storyboard.getPrevious()
    if(prev ~= nil) then
        storyboard.removeScene(prev)
    end
    sound.loadSounds()
end

function scene:exitScene( event )
    -- This is where you remove all variables.
    scene:removeEventListener( "createScene", scene );
    scene:removeEventListener( "enterScene", scene );
    scene:removeEventListener( "exitScene", scene );
    scene:removeEventListener( "destroyScene", scene );
end

function scene:destroyScene( event )
    screenGroup = nil
    widget = nil
    button = nil
    num = nil
    func = nil
    text = nil
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;