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
local img = {}

num._W = display.contentWidth
num._H = display.contentHeight
num._CX = display.contentCenterX
num._CY = display.contentCenterY
num.topscore, num.coins, str.sound, str.effect = database.getData()

str.soundFile = "images/soundOn.png"
str.effectFile = "images/effectOn.png"
str.currentPressed = ""

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
                powerup = str.powerup,
                coins = num.coins,
            }
        }
        storyboard.gotoScene("upgrades", options)
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
    
    text.title = display.newText(screenGroup, "Tilt Toby", 0, 0, native.systemFont, 120)
    text.title.x = num._CX - 105;text.title.y = num._CY - 130;
    text.title.rotation = -25
    
    button.start = widget.newButton{
        width = 230,
        height = 230,
        defaultFile = "images/play.png",
        overFile = "images/playOver.png",
        onRelease = func.buttonEvent
    }
    button.start.name = "start"
    button.start.x = num._CX; button.start.y = num._CY + 60
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
    
    button.fb = widget.newButton{
        width = 90,
        height = 90,
        defaultFile = "images/fb.png",
        overFile = "images/fbOver.png",
        label = "Like us",
        fontSize = 25,
        labelYOffset = 60,
        labelColor = {
            default = {255, 255, 255},
            over = {100, 100, 100},
        },
        onRelease = func.buttonEvent
    }
    button.fb.x = 90; button.fb.y = num._H - 80
    button.fb.name = "fb"
    screenGroup:insert(button.fb)
    
    button.twitter = widget.newButton{
        width = 90,
        height = 90,
        defaultFile = "images/twitter.png",
        overFile = "images/twitterOver.png",
        label = "Follow us",
        fontSize = 25,
        labelYOffset = 60,
        labelColor = {
            default = {255, 255, 255},
            over = {100, 100, 100},
        },
        onRelease = func.buttonEvent
    }
    button.twitter.x = 220; button.twitter.y = num._H - 80
    button.twitter.name = "twitter"
    screenGroup:insert(button.twitter)
    
    button.store = widget.newButton{
        width = 140,
        height = 140,
        defaultFile = "images/store.png",
        overFile = "images/storeOver.png",
        label = "Store",
        fontSize = 34,
        labelYOffset = -10,
        onRelease = func.buttonEvent
    }
    button.store.x = num._W - 100; button.store.y = num._H - 100
    button.store.name = "store"
    screenGroup:insert(button.store)
    
    img.top = display.newImageRect(screenGroup, "images/top.png", 80, 80)
    img.top.x = 40; img.top.y = 40

    text.topscore = display.newText(screenGroup, func.commaVal(num.topscore), 70, 20, native.systemFont, 38)
    
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