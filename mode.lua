-- Mapping of the key press ot the mode identifier.
local modes = {
    w = "workout", 
    m = "max",
    n = "note"
}

-- Will hold the current mode to render to the screen.
local currentMode = "workout"

function setModeByString( modeString )
    -- Check each of the modes and update currentMode if any in the dictionary match.
    for k,v in pairs(modes) do
        if v == modeString then
            currentMode = modeString
            -- Exit early if found early.
            break;
        end
    end
end

function setModeByKey( key )

    -- Only update the current mode if its in the list of valid ones.
    if modes[key] then
        currentMode = mode
    end

end

function getCurrentMode()
    return currentMode
end