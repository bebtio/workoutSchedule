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
    drawIndex = 1
    maxBoxesToDraw = 4
    numBoxesToDraw = numWorkouts 
    boxSpacing = 10
    curve = 30
    x0 = 0
    y0 = 0
    rw0 = rw0 * 1.3
    rh0 = (rh0 + curve )  * 1.1
    love.window.setMode(numBoxesToDraw*(boxSpacing+rw0), rh0 + boxSpacing) 
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

    indices = getBoxIndices(drawIndex, numBoxesToDraw, numWorkouts, maxBoxesToDraw )

end

function love.draw()

    local idx = 0
    for k, v in ipairs(indices) do
        e = workouts.workout[v]
        local xPos = x0 + (boxSpacing / 2.0) + (rw0 + boxSpacing) * idx
        local yPos = y0 + (boxSpacing / 2.0)
        drawWorkoutBox(drawIndex+idx, numWorkouts, e.name, e.exercises, xPos, yPos, rw0, rh0)
        idx = idx + 1
    end

end

function love.keypressed(key)
    if love.keyboard.isDown('s') then
        takeScreenShot()
    end

    -- Keep the index in range.
    if love.keyboard.isDown('right') then
        drawIndex = drawIndex + 1
        if drawIndex > #workouts.workout then
            drawIndex = 1
        end
    end
    -- Keep the index in range.
    if love.keyboard.isDown('left') then
        drawIndex = drawIndex - 1
        if drawIndex <= 0 then
            drawIndex = #workouts.workout
        end
    end

    if key >= '1' and key <= tostring(maxBoxesToDraw) then
        if tonumber(key) ~= numBoxesToDraw then
            numBoxesToDraw = tonumber(key)
            if #workouts.workout < numBoxesToDraw then
                numBoxesToDraw = #workouts.workout
            end
            love.window.setMode(numBoxesToDraw*(boxSpacing+rw0), rh0 + boxSpacing) 
        end
    end

    if key == 'q' then
        love.event.quit()
    end
end