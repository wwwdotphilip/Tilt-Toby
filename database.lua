local db
local path
local M = {}

local gameTable = "gameTable"
local topscore = "topscore"
local effect = "effect"
local sound = "sound"

function M.opendatabase()
    local sqlite3 = require "sqlite3"
    path = system.pathForFile ( "data.db", system.DocumentsDirectory )
    local function copyFile( srcName, srcPath, dstName, dstPath )
        local results = true 
        local rfilePath = system.pathForFile( srcName, srcPath )
        local wfilePath = system.pathForFile( dstName, dstPath )
        
        local rfh = io.open( rfilePath, "rb" )              
        local wfh = io.open( wfilePath, "wb" )
        
        if  not wfh then
            results = false
        else
            local data = rfh:read( "*a" )
            
            if not data then
                results = false
            else
                if not wfh:write( data ) then
                    results = false
                end
            end
        end
        rfh:close()
        wfh:close()
        return results  
    end
    
    local fh, errStr = io.open( path, "r" )
    
    if not fh then
        copyFile( "data.db", system.ResourceDirectory, "data.db", system.DocumentsDirectory )
        db = sqlite3.open ( path )
    else
        db = sqlite3.open ( path )
    end
    
    local function onSystemEvent ( event )
        if event.type == "applicationExit" then
            if db and db:isopen() then
                Runtime:removeEventListener( "system", onSystemEvent )
                db:close()
                system.setIdleTimer(true)
            end
        end
    end
    
    Runtime:addEventListener( "system", onSystemEvent )
end

function M.getScore()
    local temp_score;
    local row
    
    for row in db:nrows("SELECT * FROM " .. gameTable) do
        local rowData1 = row.topscore;
        temp_score = rowData1;
    end
    
    return temp_score;
end

function M.getSettings()
    local temp_sound;
    local temp_effect;
    local row
    
    for row in db:nrows("SELECT * FROM " .. gameTable) do
        local rowData1 = row.sound;
        local rowData2 = row.effect;
        temp_sound = rowData1;
        temp_effect = rowData2;
    end
    
    return temp_sound, temp_effect;
end

function M.updateScore(score)
    local updatescore = [[ UPDATE ]] .. gameTable .. [[ SET ]] .. topscore .. [[ = ]] .. score .. [[; ]]
    db:exec ( updatescore )
end

function M.updateSound(val)
    local updateSound = [[ UPDATE ]] .. gameTable .. [[ SET ]] .. sound .. [[ = ']] .. val .. [['; ]]
    db:exec ( updateSound )
end

function M.updateEffect(val)
    local updateEffect = [[ UPDATE ]] .. gameTable .. [[ SET ]] .. effect .. [[ = ']] .. val .. [['; ]]
    db:exec ( updateEffect )
end

return M -- We must return the variable M in order to call its functions.

