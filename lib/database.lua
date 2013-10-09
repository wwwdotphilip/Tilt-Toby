local db
local path
local M = {}

local gameTable = "gameTable"
local topscore = "topscore"
local effect = "effect"
local sound = "sound"
local coins = "coins"

local powerUps = "powerUps"

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

function M.getData()
    local temp_score;
    local temp_coins;
    local temp_sound;
    local temp_effect;
    local row
    
    for row in db:nrows("SELECT * FROM " .. gameTable) do
        local rowData1 = row.topscore;
        local rowData2 = row.coins;
        local rowData3 = row.sound;
        local rowData4 = row.effect;
        temp_score = rowData1;
        temp_coins = rowData2;
        temp_sound = rowData3;
        temp_effect = rowData4;
    end
    
    return temp_score, temp_coins, temp_sound, temp_effect;
end

function M.getpowerups()
    local temp_name = {};
    local temp_value = {};
    local temp_level = {};
    local temp_maxlevel = {};
    local temp_type = {};
    local temp_price = {};
    local temp_usability = {};
    local row
    
    for row in db:nrows("SELECT * FROM " .. powerUps) do
        local rowData1 = row.name;
        local rowData2 = row.value;
        local rowData3 = row.level;
        local rowData4 = row.maxlevel;
        local rowData5 = row.type;
        local rowData6 = row.price;
        local rowData7 = row.usability;
        temp_name[#temp_name+1] = rowData1;
        temp_value[#temp_value+1] = rowData2;
        temp_level[#temp_level+1] = rowData3;
        temp_maxlevel[#temp_maxlevel+1] = rowData4;
        temp_type[#temp_type+1] = rowData5;
        temp_price[#temp_price+1] = rowData6;
        temp_usability[#temp_usability+1] = rowData7;
        print(rowData7)
    end
    
    return temp_name, temp_value, temp_level, temp_maxlevel, temp_type, temp_price, temp_usability;
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

