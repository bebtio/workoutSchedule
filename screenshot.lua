
function takeScreenShot()
    love.graphics.captureScreenshot(function(image)
        local path = love.filesystem.getWorkingDirectory()
        local file = io.open(path .. "/workout" ..  "_" .. os.date("%Y%m%d") ..".png", "wb")
        file:write(image:encode("png"):getString())
        file:close()
    end)

    love.event.quit()
end