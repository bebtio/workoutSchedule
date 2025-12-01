json = require("json")
require("workout")
require("debounce")
require("screenshot")

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

    drawIndex = 1
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

   
    if debounce(dt) then
        if love.keyboard.isDown('s') then
            takeScreenShot()
        end

        if love.keyboard.isDown('right') then
            drawIndex = drawIndex + 1
            if drawIndex > #workouts.workout then
                drawIndex = 1
            end
        end

        if love.keyboard.isDown('left') then
            drawIndex = drawIndex - 1
            if drawIndex <= 0 then
                drawIndex = #workouts.workout
            end
        end
    end

end

function love.draw()

    --local idx = 0
    --for k, v in pairs(workouts.workout) do
        --local xPos = x0 + (boxSpacing / 2.0) + (rw0 + boxSpacing) * idx
        --local yPos = y0 + (boxSpacing / 2.0)
        --drawWorkoutBox(v.day, v.exercises, xPos, yPos, rw0, rh0)
        --idx = idx + 1
    --end

    local xPos = x0 + (boxSpacing / 2.0) + (rw0 + boxSpacing)
    local yPos = y0 + (boxSpacing / 2.0)
    print(drawIndex)
    drawWorkoutBox(workouts.workout[drawIndex].day, workouts.workout[drawIndex].exercises, xPos, yPos, rw0, rh0)

end


