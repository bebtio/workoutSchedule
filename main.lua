json = require("json")
require("workout")

function love.load(arg)

    if #arg == 0 then
        workoutFile = "workout.json"
    else
        workoutFile = arg[1]
    end

    file = io.open(workoutFile, "rb")

    workouts = nil
    if file == nil then
        print("Input file is " .. workoutFile .. " is nil. Exiting...")
        love.event.quit()
    else
        jsonString = file:read("*a")
        file:close()
        workouts =  json.decode(jsonString)
    end


    boxSpacing = 10
    curve = 30
    x0 = 0
    y0 = 0
    numWorkouts, rw0, rh0 = getLongestExerciseString(workouts, love.graphics.getFont())
    rw0 = rw0 * 1.3
    rh0 = (rh0 + curve )  * 1.1
    daysOfWeek = {"Monday",  "Friday", "Saturday", "Sunday"}
    love.window.setMode(numWorkouts*(boxSpacing+rw0), rh0 + boxSpacing) 
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

    if love.keyboard.isDown('s') then
        love.graphics.captureScreenshot(function(image)
            local path = love.filesystem.getWorkingDirectory()
            local file = io.open(path .. "/workout.png", "wb")
            file:write(image:encode("png"):getString())
            file:close()
        end)

        love.event.quit()
    end
    
end

function love.draw()

    local idx = 0
    for k, v in pairs(workouts.workout) do
        local xPos = x0 + (boxSpacing / 2.0) + (rw0 + boxSpacing) * idx
        local yPos = y0 + (boxSpacing / 2.0)
        drawWorkoutBox(v.day, v.exercises, xPos, yPos, rw0, rh0)
        idx = idx + 1
    end

end


