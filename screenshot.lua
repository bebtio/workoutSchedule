
function takeScreenShot()
    love.graphics.captureScreenshot(function(image)
        local screenshotsPath = love.filesystem.getWorkingDirectory() .. "/screenshots"

        -- Create the output dir.
        os.execute("mkdir -p " .. screenshotsPath)

        -- Create the output file string.
        local path = string.format( "%s/workout_%s.png", screenshotsPath, os.date("%Y%m%d_%H%M%S") )
        print("Saving file to " .. path)

        -- Create the output file.
        local file = io.open(path, "wb")
        file:write(image:encode("png"):getString())
        file:close()
    end)
end