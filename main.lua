json = require("json")

function love.load(arg)
    file = io.open("workout.json", "rb")
    jsonString = file:read("*a")
    file:close()
    workouts =  json.decode(jsonString)

    boxSpacing = 10
    x0 = 0
    y0 = 0
    numWorkouts, rw0, rh0 = getLongestExerciseString(workouts, love.graphics.getFont())
    rw0 = rw0 * 1.3
    rh0 = rh0 * 1.3
    daysOfWeek = {"Monday",  "Friday", "Saturday", "Sunday"}
    love.window.setMode(numWorkouts*(boxSpacing+rw0), rh0 + boxSpacing) 
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

    if love.keyboard.isDown('s') then
        print("SCREEN SHOT " .. love.filesystem.getSaveDirectory() )
        love.graphics.captureScreenshot(function(image)
            local path = love.filesystem.getWorkingDirectory()
            local file = io.open(path .. "/workout.png", "wb")
            file:write(image:encode("png"):getString())
            file:close()
        end)

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


function drawWorkoutBox( dayOfWeek, exercises, x, y, width, height )
    local rw1 = width  - 2
    local rh1 = height - 2
    local offsetw = (width - rw1)/2.0
    local offseth = (height - rh1)/2.0
    local curve = 30
    local font = love.graphics.getFont()
    local gw = font:getWidth(dayOfWeek)
    local gh = font:getHeight(dayOfWeek)

    love.graphics.rectangle("fill",x,y, width, height, curve, curve)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",x+offsetw,y+offseth,rw1,rh1, curve, curve)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",x,y+curve, width, 1)
    love.graphics.print(dayOfWeek, x + (width / 2.0) - (gw / 2.0) , y + (curve / 2.0) - (gh/2.0))

    width = drawExercises(exercises, x+10, y + curve)
end

function drawExercises(exercises, x, y)
    local font = love.graphics.getFont()
    local gh = font:getHeight()
    local yOffset = 0

    for k,v in pairs(exercises) do
        if v.type == "SetsReps" then
            drawExerciseSetsReps(v.name, v.sets, v.reps, x, y + yOffset )
        elseif v.type == "Reps" then
            drawExerciseReps(v.name, v.reps, x, y + yOffset)
        elseif v.type == "BigSet" then
            drawExerciseBigSet(v.exercises, v.sets, x, y + yOffset)
        elseif v.type == "Spacebreak" then
            -- Does nothing, just applies the yOffset.
        elseif v.type == "Linebreak" then
            love.graphics.rectangle("fill", x, y + yOffset - gh / 2.0, 10, 1)
        elseif v.type == "Text" then
            love.graphics.print(v.text, x, y + yOffset)
        else
            -- If the next thing selected wasn't anything valid, remove a yOffset so we don't have blank space.
            yOffset = yOffset - gh
        end
        yOffset = yOffset + gh
    end
end

function drawExerciseSetsReps(exercise, numSets, numReps, x, y)
    love.graphics.print(exercise .. ": " .. numSets .. "x" .. numReps, x, y)
end

function drawExerciseReps(exercise, numReps, x, y)
    love.graphics.print(exercise .. ": " .. numReps, x, y)
end

function drawExerciseBigSet(exercises, numSets, x, y)
    local font = love.graphics.getFont()
    local gh = font:getHeight()
    local yOffset = 0
    local largestWidth = 0

    for k,v in pairs(exercises) do
        local strLen = 0
        exerciseStr = v.reps .. " " .. v.name
        love.graphics.print(exerciseStr, x, y + yOffset)
        strLen = font:getWidth(exerciseStr)

        if strLen > largestWidth then
            largestWidth = strLen
        end

        yOffset = yOffset + gh
    end


    -- Draw line from first exercise
    love.graphics.rectangle("fill", x + largestWidth    , y + gh /2, 10, 1)
    -- Draw the line from the last exercise
    love.graphics.rectangle("fill", x + largestWidth     , y + gh * #exercises - gh/2, 11, 1)
    -- Draw the line connecting the two.
    love.graphics.rectangle("fill", x + largestWidth + 10   , y + gh /2, 1, gh * #exercises - gh )
    -- Draw the midpoint line
    love.graphics.rectangle("fill", x + largestWidth + 10, y  + (gh * #exercises)/2.0, 10, 1)
    -- Draw the numSets 
    love.graphics.print(numSets, x + largestWidth + 20, y + (gh * #exercises)/2.0 - gh /2.0)
end

function getLongestExerciseString(workoutData, font)
    local maxWidth = 0
    local maxHeight = 0
    local numWorkouts = 0

    for _, day in ipairs(workoutData.workout) do
        local currentHeight = 0
        local currentWidth = 0
        numWorkouts = numWorkouts+1
        for _, exercise in ipairs(day.exercises) do

            -- This SetReps and Text are likely to be the longest strings so used those
            -- to compute the width.
            if exercise.type == "SetsReps" then
                local sets = tostring(exercise.sets)
                local reps = tostring(exercise.reps)
                local str = exercise.name .. ": " .. sets .. " x " .. reps

                local currentWidth = font:getWidth(str)

                if currentWidth > maxWidth then
                    maxWidth = currentWidth 
                end

                currentHeight = currentHeight + 1
            elseif exercise.type == "Text" then
                currentWdith = font:getWidth(exercise.text)
                if currentWidth > maxWidth then
                    maxWidth = currentWidth 
                end

                currentHeight = currentHeight + 1
            elseif exercise.type == "BigSet" then
                -- Big set exercises will always be stacked so measure how
                -- many there are and add them to the running height.
                currentHeight = currentHeight + #exercise.exercises
            else
                currentHeight = currentHeight + 1
            end  

            if currentHeight > maxHeight then
                maxHeight = currentHeight
            end
        end
    end

    return numWorkouts, maxWidth, maxHeight * font:getHeight()
end
