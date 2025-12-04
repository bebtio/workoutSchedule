
function takeScreenShot()
    love.graphics.captureScreenshot(function(image)
        local path = love.filesystem.getWorkingDirectory()
        local file = io.open(path .. "/workout" ..  "_" .. os.date("%Y%m%d_%H%M%S") ..".png", "wb")
        file:write(image:encode("png"):getString())
        file:close()
    end)
end