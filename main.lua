json = require("json")
require("workout")
require("screenshot")


function love.conf(t)
    -- nothing implemented here.
end

function love.load(arg)

    if #arg == 0 then
        workoutFile = "workout_example.json"
    else
        workoutFile = arg[1]
    end

    print("Loading workout: " .. workoutFile)
    file = io.open(workoutFile, "rb")

    workouts = nil
    if file == nil then
        print("Input file is " .. workoutFile .. " is nil. Exiting...")
        love.event.quit() else jsonString = file:read("*a")
        file:close()
        workouts =  json.decode(jsonString)
    end


    numWorkouts, rw0, rh0 = getLongestExerciseString(workouts, love.graphics.getFont())
    drawIndowStartIdx = 1
    highlightIndex = 1
    maxBoxesToDraw = 4

    -- Set num boxes to draw to maxBoxesToDraw at max.
    numBoxesToDraw = numWorkouts 
    if numWorkouts > maxBoxesToDraw then
        numBoxesToDraw = maxBoxesToDraw
    end

    boxSpacing = 10
    curve = 30
    x0 = 0
    y0 = 0
    rw0 = rw0 * 1.3
    rh0 = (rh0 + curve )  * 1.1

    -- Love configurations.
    --love.keyboard.setKeyRepeat(true)
    love.window.setMode(numBoxesToDraw*(boxSpacing+rw0), rh0 + boxSpacing) 
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

    indices = getBoxIndices(drawIndowStartIdx, numBoxesToDraw, numWorkouts, maxBoxesToDraw )

end

function love.draw()

    local idx = 0
    local displayName = ""
    local e
    for k, v in ipairs(indices) do
        e = workouts.workout[v]
        displayName = string.format("%s (%d/%d)", e.name,v,numWorkouts)
        
        local xPos = x0 + (boxSpacing / 2.0) + (rw0 + boxSpacing) * idx
        local yPos = y0 + (boxSpacing / 2.0)

        drawWorkoutBox(displayName, e.exercises, xPos, yPos, rw0, rh0)

        idx = idx + 1
    end

end

function love.keypressed(key, scancode, isrepeat)

    --- Screenshot code start ---
    if love.keyboard.isDown('s') then
        takeScreenShot()
    end
    --- Screenshot code end ---

    --- Workout navigation start ---

    -- Keep the index in range.
    if love.keyboard.isDown('right') then
        drawIndowStartIdx = drawIndowStartIdx + 1
        if drawIndowStartIdx > #workouts.workout then
            drawIndowStartIdx = 1
        end
    end

    -- Keep the index in range.
    if love.keyboard.isDown('left') then
        drawIndowStartIdx = drawIndowStartIdx - 1
        if drawIndowStartIdx <= 0 then
            drawIndowStartIdx = #workouts.workout
        end
    end

    -- Change how many workouts to display.
    if key >= '1' and key <= tostring(maxBoxesToDraw) then
        if tonumber(key) ~= numBoxesToDraw then
            numBoxesToDraw = tonumber(key)

            if numWorkouts < numBoxesToDraw then
                numBoxesToDraw = numWorkouts
            end

            love.window.setMode(numBoxesToDraw*(boxSpacing+rw0), rh0 + boxSpacing) 
        end
    end
    --- Workout navigation end ---

    if key == 'q' then
        love.event.quit()
    end
end