local media = require"media";
local M = {}
local soundSet

function M.loadSounds()
    soundSet = {
        audio.loadStream("sounds/bg.mp3"),
        audio.loadStream("sounds/bg2.mp3"),
        audio.loadStream("sounds/bg3.mp3"),
        audio.loadStream("sounds/bg4.mp3"),
        audio.loadSound("sounds/button.mp3"),
        audio.loadSound("sounds/dead.mp3"),
    };
    return soundSet
end

function M.closeSound()
    M.stopSound = true;
    audio.stop()
    media.stopSound()
    for i = 1, #soundSet do
        audio.dispose( soundSet[i] )
        soundSet[i] = nil
    end
    soundSet = nil
end

function M.playBgSound(sound,val)
    
    if M.stopSound then
        
    else
        if val == "on" then
            audio.play(soundSet[sound],{onComplete=function()M.playBgSound(sound, val)end});
        end
    end
end

function M.playButton(val)
    if val == "on" then
        audio.play(soundSet[5]);
    end
end

function M.playDeadSound(val)
    if val == "on" then
        audio.play(soundSet[6]);
    end
end

function M.stop()
    audio.stop()
end

function M.play()
    audio.play()
end

function M.pause()
    audio.pause()
end

function M.resume()
    audio.resume()
end

return M;
