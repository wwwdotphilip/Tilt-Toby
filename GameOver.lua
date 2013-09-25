local storyboard = require"storyboard";
local sound = require"sound"
local widget = require"widget"
local database = require"database"
local scene = storyboard.newScene();
local screenGroup;

local button = {}
local num = {}
local func = {}
local text = {}
local str = {}

num._W = display.contentWidth
num._H = display.contentHeight
num._CX = display.contentCenterX
num._CY = display.contentCenterY
num.topscore = database.getScore()

function func.buttonEvent(event)
    local t = event.target
    sound.playButton(str.effect)
    print(str.effect)
    if t.name == "retry" then
        storyboard.gotoScene("GameScene", "crossFade", 100)
    else
        storyboard.gotoScene("MainMenu", "crossFade", 100)
    end
end

function scene:createScene( event )
    screenGroup = self.view;
    str.params = event.params
    str.sound = str.params.sound
    str.effect = str.params.effect
    text.shout = display.newText(screenGroup, "OUCH!!!", 0, 0, native.systemFont, 220)
    text.shout.x = num._CX;text.shout.y = num._CY - 180;
    
    button.retry = widget.newButton{
        width = 140,
        height = 100,
        label = "Retry",
        fontSize = 40,
        onRelease = func.buttonEvent
    }
    button.retry.x = num._CX - 100; button.retry.y = num._CY + 160
    button.retry.name = "retry"
    
    screenGroup:insert(button.retry)
    
    button.quit = widget.newButton{
        width = 140,
        height = 100,
        label = "Quit",
        fontSize = 40,
        onRelease = func.buttonEvent
    }
    button.quit.x = num._CX + 100; button.quit.y = num._CY + 160
    button.quit.name = "quit"
    screenGroup:insert(button.quit)
end

function scene:enterScene( event )
    local prev = storyboard.getPrevious()
    if(prev ~= nil) then
        storyboard.removeScene(prev)
    end
    num.score = str.params.score
    
    if num.score > num.topscore then
        num.topscore = num.score
        database.updateScore(num.topscore)
    end
    
    text.score = display.newText(screenGroup, "Your score: " .. num.score, 0, 0, native.systemFont, 45)
    text.score.x = num._CX;text.score.y = num._CY;
    text.topscore = display.newText(screenGroup, "Top score: " .. num.topscore, 0, 0, native.systemFont, 45)
    text.topscore.x = num._CX;text.topscore.y = num._CY + 60;
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
    widget = nil
    screenGroup = nil
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

