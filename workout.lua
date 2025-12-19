function drawWorkoutBox(displayName, exercises, x, y, width, height )
    local rw1 = width  - 2
    local rh1 = height - 2
    local offsetw = (width - rw1)/2.0
    local offseth = (height - rh1)/2.0
    local font = love.graphics.getFont()
    local gw = font:getWidth(displayName)
    local gh = font:getHeight(displayName)

    love.graphics.rectangle("fill",x,y, width, height, curve, curve)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",x+offsetw,y+offseth,rw1,rh1, curve, curve)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",x,y+curve, width, 1)
    love.graphics.print(displayName, x + (width / 2.0) - (gw / 2.0) , y + (curve / 2.0) - (gh/2.0))


    width = drawExercises(exercises, x + boxSpacing, y + curve)
end

function drawExercises(exercises, x, y)
    local font = love.graphics.getFont()
    local gh = font:getHeight()
    local yOffset = 0

    for _,v in ipairs(exercises) do
        type = v.type
        if type == "setsreps" then
            drawExerciseSetsReps(v.name, v.sets, v.reps, x, y + yOffset )
            yOffset = yOffset + gh
        elseif type == "reps" then
            drawExerciseReps(v.name, v.reps, x, y + yOffset)
            yOffset = yOffset + gh
        elseif type == "bigset" then
            yOffset = yOffset + drawExerciseBigSet(v.exercises, v.sets, x, y + yOffset)
        elseif type == "spacebreak" then
            -- Does nothing, just applies the yOffset.
            yOffset = yOffset + gh
        elseif type == "linebreak" then
            love.graphics.rectangle("fill", x , y + yOffset + gh / 2.0, rw0 *.9, 1)
            yOffset = yOffset + gh
        elseif type == "text" then
            love.graphics.print(v.text, x, y + yOffset)
            yOffset = yOffset + gh
        else
            -- If the next thing selected wasn't anything valid, do nothing.
        end
    end

end

function drawExerciseSetsReps(exercise, numSets, numReps, x, y)
    love.graphics.print(string.format("%s: %dx%d",exercise, numSets, numReps), x, y)
end

function drawExerciseReps(exercise, numReps, x, y)
    love.graphics.print(string.format("%s: %d", exercise, numReps), x, y)
end

function drawExerciseBigSet(exercises, numSets, x, y)
    local font = love.graphics.getFont()
    local gh = font:getHeight()
    local yOffset = 0
    local largestWidth = 0

    for k,v in pairs(exercises) do
        local strLen = 0
        exerciseStr = string.format("%s %s", v.reps, v.name)
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

    return yOffset
end

--[[
    Computes the string with the largest width in text pixels and
    Computes the height of the largest workout box in text pixels.
    Computes the number of workouts.

    These values will be used to draw all workouts uniformally based on the largest of these
    dimensions.
--]]
function getLongestExerciseString(workoutData, font)
    local maxWidth = 0
    local maxHeight = 0
    local fontHeight = font:getHeight()
    local numWorkouts = #workoutData.workout -- Built-in Lua length operator

    for _, day in ipairs(workoutData.workout) do
        local workoutHeight = 0
        -- Initial width is the name of the workout day
        local workoutWidth = font:getWidth(day.name)

        for _, v in ipairs(day.exercises) do
            local type = v.type or ""
            local lineWeight = 1 -- How many "lines" high this exercise is
            local exerciseWidth = 0

            if type == "setsreps" then
                local str = string.format("%s: %s x %s", v.name or "", v.sets or 0, v.reps or 0)
                exerciseWidth = font:getWidth(str)

            elseif type == "text" then
                exerciseWidth = font:getWidth(v.text or "")

            elseif type == "bigset" then
                -- Height is the number of exercises + 1 for the "Sets" header
                lineWeight = #v.exercises + 1 
                
                -- Check width for every exercise in the BigSet
                for _, exer in ipairs(v.exercises) do
                    local str = string.format("%s %s %s", v.sets or 0, exer.name or "", exer.reps or 0)
                    exerciseWidth = math.max(exerciseWidth, font:getWidth(str) + 50)
                end
            
            elseif type == "linebreak" or type == "spacebreak" then
                lineWeight = 1
                exerciseWidth = 0
            end

            -- Update the current workout's max width and total height
            workoutWidth = math.max(workoutWidth, exerciseWidth)
            workoutHeight = workoutHeight + lineWeight
        end

        -- Compare this workout's totals to the global maximums
        maxWidth = math.max(maxWidth, workoutWidth)
        maxHeight = math.max(maxHeight, workoutHeight)
    end

    return numWorkouts, maxWidth, maxHeight * fontHeight
end

-- Returns indices of which workouts to draw. Makes sure to 
-- iterate as a circular buffer.
function getBoxIndices( drawIndex, numToDraw, numElements )

    local currentIndex = drawIndex

    local indices = {}

    for i = drawIndex, drawIndex+numToDraw - 1, 1 do

        
        if currentIndex > numElements then
            currentIndex = 1
        end

        table.insert(indices, currentIndex)

        currentIndex = currentIndex + 1
    end

    return indices
end

local validKeys = {
    setsreps = true,
    bigset = true,
    text = true,
    reps = true,
    spacebreak = true,
    linebreak = true
}

function validateInput( workoutData )
    returnVal = true
    for _, day in ipairs(workoutData.workout) do
        for _, v in ipairs(day.exercises) do
            local type = v.type or ""
            if not validKeys[type] then 
                print(string.format("Key (%s) for workout (%s) is not a valid key.", type, day.name))
                print("Exiting.")
                returnVal = false
            end
        end
    end

    -- We want to iterate over the entire structure and print out errors
    -- for each invalid key. Then we return false if there was any or return true
    -- if there were no invalid keys.
    return returnVal

end