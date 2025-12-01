
local debounceTime = 0.1
local timer = 0

function debounce(dt) 
    timer = timer + dt
    if timer >= debounceTime then
        timer = 0
        return true
    end
    return false
end