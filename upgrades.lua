local storyboard = require"storyboard";
local widget = require"widget";
local sound = require"sound"
local database = require"database"
local scene = storyboard.newScene();
local screenGroup;

local str = {}
local num = {}
local button = {}
local func = {}
local img = {}
local text = {}
local bol = {}

num._W = display.contentWidth
num._H = display.contentHeight
num._CX = display.contentCenterX
num._CY = display.contentCenterY
str.powerup = {};
bol.powerupselect = false;
str.powerup.name, str.powerup.value, str.powerup.level, str.powerup.maxlevel, str.powerup.type, str.powerup.price = database.getpowerups()
num.powerval = 0

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

function func.convertTime(sSec)
    local nSec = sSec / 1000
    if nSec == 0 then
        --return nil;
        return "00:00:00";
    else
        local nHours = string.format("%02.f", math.floor(nSec/3600));
        local nMins = string.format("%02.f", math.floor(nSec/60 - (nHours*60)));
        local nSecs = string.format("%02.f", math.floor(nSec - nHours*3600 - nMins *60));
        if nMins == "00" then
            return nSecs .. " seconds"
        else
            return nMins..":"..nSecs .. " minutes"
        end
    end
end

function func.getpower()
    for i = 1, #str.powerup.name do
        if str.powerup.name[i] == button.extralife.name then
            button.extralife.text = "Extra life x" .. str.powerup.value[i] .."\nLevel: " .. str.powerup.level[i] .. 
            "\n\nGet hit more than once."
            num.powerval1 = num.powerval + str.powerup.value[i]
        elseif str.powerup.name[i] == button.invincible.name then
            button.invincible.text = "Invincibility\n" .. func.convertTime(str.powerup.value[i]) .."\nLevel: " .. str.powerup.level[i] .. 
            "\n\nObjects will just past through you."
            num.powerval2 = num.powerval + str.powerup.value[i]
        elseif str.powerup.name[i] == button.slowtime.name then
            button.slowtime.text = "Slow time\n" .. func.convertTime(str.powerup.value[i]) .."\nLevel: " .. str.powerup.level[i] .. 
            "\n\nMake everything move slow except you."
            num.powerval3 = num.powerval + str.powerup.value[i]
        end
    end
end

function func.switchpower()
    if str.currentPressed == "extralife" then
        if button.extralife.selected then
            button.extralife:removeSelf()
            button.extralife = nil
            button.extralife = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/extraLife.png",
                onRelease = func.buttonEvent
            }
            button.extralife.x = num._CX + 120; button.extralife.y = num._CY + 100
            button.extralife.name = "extralife"
            button.extralife.selected = false
            screenGroup:insert(button.extralife)
        elseif button.extralife.selected == false then
            button.extralife:removeSelf()
            button.extralife = nil
            button.extralife = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/extraLifeSelected.png",
                onRelease = func.buttonEvent
            }
            button.extralife.x = num._CX + 120; button.extralife.y = num._CY + 100
            button.extralife.name = "extralife"
            button.extralife.selected = true
            screenGroup:insert(button.extralife)
        end
        if button.slowtime.selected then
            button.slowtime:removeSelf()
            button.slowtime = nil
            button.slowtime = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/slowTime.png",
                onRelease = func.buttonEvent
            }
            button.slowtime.x = num._CX - 120; button.slowtime.y = num._CY + 100
            button.slowtime.name = "slowtime"
            button.slowtime.selected = false
            screenGroup:insert(button.slowtime)
        end
        if button.invincible.selected then
            button.invincible = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/invincibility.png",
                onRelease = func.buttonEvent
            }
            button.invincible.x = num._CX; button.invincible.y = num._CY + 100
            button.invincible.name = "invincibility"
            button.invincible.selected = false
            screenGroup:insert(button.invincible)
        end
        if button.slowtime.selected == false and button.extralife.selected == false and button.invincible.selected == false then
            text.power.text = "Tap items bellow to enable power ups."
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10 
        end
    elseif str.currentPressed == "slowtime" then
        if button.slowtime.selected then
            button.slowtime:removeSelf()
            button.slowtime = nil
            button.slowtime = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/slowTime.png",
                onRelease = func.buttonEvent
            }
            button.slowtime.x = num._CX - 120; button.slowtime.y = num._CY + 100
            button.slowtime.name = "slowtime"
            button.slowtime.selected = false
            screenGroup:insert(button.slowtime)
        elseif button.slowtime.selected == false then
            button.slowtime:removeSelf()
            button.slowtime = nil
            button.slowtime = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/slowTimeSelected.png",
                onRelease = func.buttonEvent
            }
            button.slowtime.x = num._CX - 120; button.slowtime.y = num._CY + 100
            button.slowtime.name = "slowtime"
            button.slowtime.selected = true
            screenGroup:insert(button.slowtime)
        end
        if button.extralife.selected then
            button.extralife = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/extraLife.png",
                onRelease = func.buttonEvent
            }
            button.extralife.x = num._CX + 120; button.extralife.y = num._CY + 100
            button.extralife.name = "extralife"
            button.extralife.selected = false
            screenGroup:insert(button.extralife)
            
        end
        if button.invincible.selected then
            button.invincible = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/invincibility.png",
                onRelease = func.buttonEvent
            }
            button.invincible.x = num._CX; button.invincible.y = num._CY + 100
            button.invincible.name = "invincibility"
            button.invincible.selected = false
            screenGroup:insert(button.invincible)
        end
        if button.slowtime.selected == false and button.extralife.selected == false and button.invincible.selected == false then
            text.power.text = "Tap items bellow to enable power ups."
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10 
        end
    elseif str.currentPressed == "invincibility" then
        if button.invincible.selected then
            button.invincible:removeSelf()
            button.invincible = nil
            button.invincible = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/invincibility.png",
                onRelease = func.buttonEvent
            }
            button.invincible.x = num._CX; button.invincible.y = num._CY + 100
            button.invincible.name = "invincibility"
            button.invincible.selected = false
            screenGroup:insert(button.invincible)
        elseif button.invincible.selected == false  then
            button.invincible:removeSelf()
            button.invincible = nil
            button.invincible = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/invincibilitySelected.png",
                onRelease = func.buttonEvent
            }
            button.invincible.x = num._CX; button.invincible.y = num._CY + 100
            button.invincible.name = "invincibility"
            button.invincible.selected = true
            screenGroup:insert(button.invincible)
        end
        if button.extralife.selected then
            button.extralife = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/extraLife.png",
                onRelease = func.buttonEvent
            }
            button.extralife.x = num._CX + 120; button.extralife.y = num._CY + 100
            button.extralife.name = "extralife"
            button.extralife.selected = false
            screenGroup:insert(button.extralife)
        end
        if button.slowtime.selected then
            button.slowtime = widget.newButton{
                width = 90,
                height = 90,
                defaultFile = "images/slowTime.png",
                onRelease = func.buttonEvent
            }
            button.slowtime.x = num._CX - 120; button.slowtime.y = num._CY + 100
            button.slowtime.name = "slowtime"
            button.slowtime.selected = false
            screenGroup:insert(button.slowtime)
        end
        if button.slowtime.selected == false and button.extralife.selected == false and button.invincible.selected == false then
            text.power.text = "Tap items bellow to enable power ups."
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10 
        end
    end
end

function func.buttonEvent(event)
    local t = event.target
    str.currentPressed = t.name
    sound.playButton(str.effect)
    if t.name == "start" then
        local options = {
            effect = "crossFade",
            time = 100,
            params = {
                sound = str.sound,
                effect = str.effect,
                powerup = str.selectedpowerup,
                powerval = num.powerval,
            }
        }
        storyboard.gotoScene("GameScene", options)
    elseif t.name == "extralife" then
        func.getpower()
        if button.extralife.selected == false then
            text.power.text = t.text
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10
            str.selectedpowerup = "extralife"
            num.powerval = num.powerval1
        else
            str.selectedpowerup = ""
            num.powerval = 0
        end
        func.switchpower()
    elseif t.name == "slowtime" then
        func.getpower()
        if button.slowtime.selected == false then
            text.power.text = t.text
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10
            str.selectedpowerup = "slowtime"
            num.powerval = num.powerval3
        else
            str.selectedpowerup = ""
            num.powerval = 0
        end
        func.switchpower()
    elseif t.name == "invincibility" then
        func.getpower()
        if button.invincible.selected == false then
            text.power.text = t.text
            text.power:setReferencePoint(display.TopCenterReferencePoint)
            text.power.y = 10
            str.selectedpowerup = "invincibility"
            num.powerval = num.powerval2
        else
            str.selectedpowerup = ""
            num.powerval = 0
        end
        func.switchpower()
    end
end

function scene:createScene( event )
    screenGroup = self.view;
    str.params = event.params
    str.sound = str.params.sound
    str.effect = str.params.effect
    num.coins = str.params.coins
    sound.loadSounds()
    
    img.scroll = widget.newScrollView{
        top = num._CY - 280,
        left = num._CX - 160,
        width = 320,
        height = 295,
        maskFile = "images/mask.png",
        horizontalScrollDisabled = true,
        hideBackground = true
    }
    img.scroll.isHitTestMasked = true
    
    button.start = widget.newButton{
        width = 350,
        height = 120,
        label = "START",
        fontSize = 100,
        onRelease = func.buttonEvent
    }
    button.start.x = num._CX; button.start.y = num._CY + 230
    button.start.name = "start"
    button.start.selected = false
    screenGroup:insert(button.start)
    
    button.slowtime = widget.newButton{
        width = 90,
        height = 90,
        defaultFile = "images/slowTime.png",
        onRelease = func.buttonEvent
    }
    button.slowtime.x = num._CX - 120; button.slowtime.y = num._CY + 100
    button.slowtime.name = "slowtime"
    button.slowtime.selected = false
    screenGroup:insert(button.slowtime)
    
    button.invincible = widget.newButton{
        width = 90,
        height = 90,
        defaultFile = "images/invincibility.png",
        onRelease = func.buttonEvent
    }
    button.invincible.x = num._CX; button.invincible.y = num._CY + 100
    button.invincible.name = "invincibility"
    button.invincible.selected = false
    screenGroup:insert(button.invincible)
    
    button.extralife = widget.newButton{
        width = 90,
        height = 90,
        defaultFile = "images/extraLife.png",
        onRelease = func.buttonEvent
    }
    button.extralife.x = num._CX + 120; button.extralife.y = num._CY + 100
    button.extralife.name = "extralife"
    button.extralife.selected = false
    screenGroup:insert(button.extralife)
    
    img.coin = display.newImageRect(screenGroup, "images/coin.png", 80, 80)
    img.coin.x = 50; img.coin.y = 40
    
    img.border = display.newImageRect(screenGroup, "images/border.png", 380, 330)
    img.border.x = num._CX; img.border.y = num._CY - 130
    
    text.coins = display.newText(screenGroup, func.commaVal(num.coins), 90, 20, native.systemFont, 38)
    
    text.options = 
    {
        text = "Tap items bellow to enable power ups.",     
        x = 160,
        y = 120,
        width = 220,
        height = 0,
        font = native.systemFont,   
        fontSize = 34,
        align = "center"
    }
    text.power = display.newText(text.options)
    img.scroll:insert(text.power)
    screenGroup:insert(img.scroll)
end

function scene:enterScene( event )
    local prev = storyboard.getPrevious()
    if(prev ~= nil) then
        storyboard.removeScene(prev)
    end
end

function scene:exitScene( event )
    scene:removeEventListener( "createScene", scene );
    scene:removeEventListener( "enterScene", scene );
    scene:removeEventListener( "exitScene", scene );
    scene:removeEventListener( "destroyScene", scene );
end

function scene:destroyScene( event )
    
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;