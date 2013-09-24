local storyboard = require"storyboard";
local scene = storyboard.newScene();
local screenGroup;

function scene:createScene( event )
    screenGroup = self.view;
    -- Declaire all objects inside here
    -- Make sure you insert all object inside screenGroup
    -- like this screenGroup:insert(object)
end

function scene:enterScene( event )
    -- Call all functions and listeners here
    -- Destroy or remove previous scene here
end

function scene:exitScene( event )
    -- This is where you remove all variables.
    scene:removeEventListener( "createScene", scene );
    scene:removeEventListener( "enterScene", scene );
    scene:removeEventListener( "exitScene", scene );
    scene:removeEventListener( "destroyScene", scene );
end

function scene:destroyScene( event )
    -- I have not yet found any use of this scene.
end

scene:addEventListener( "createScene", scene );
scene:addEventListener( "enterScene", scene );
scene:addEventListener( "exitScene", scene );
scene:addEventListener( "destroyScene", scene );

return scene;



