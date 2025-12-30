workout = 
{
    indices = {},
    drawIndowStartIdx = 1,
    highlightIndex = 1,
    maxBoxesToDraw = 4,
    numWorkouts = 0,
    rw0 = 0,
    rh0 = 0,
    boxSpacing = 10,
    curve = 30,
    x0 = 0,
    y0 = 0,
    rw0 = 0,
    rh0 = 0,
    numBoxesToDraw = numWorkouts 
}

function workout:init(workouts, font)

    self.numWorkouts, self.rw0, self.rh0 = getLongestExerciseString(workouts, font)
    self.rw0 = self.rw0 * 1.3
    self.rh0 = (self.rh0 + self.curve )  * 1.1

    -- Set num boxes to draw to maxBoxesToDraw at max.
    self.numBoxesToDraw = self.numWorkouts 
    if self.numWorkouts > self.maxBoxesToDraw then
        self.numBoxesToDraw = self.maxBoxesToDraw
    end
    love.window.setMode(self.numBoxesToDraw*(self.boxSpacing+self.rw0), self.rh0 + self.boxSpacing) 
end

function workout:handleKeyPress(key)

end

function workout:main(workouts)
    local idx = 0
    local displayName = ""
    local e

    for k, v in ipairs(self.indices) do
        e = workouts.workout[v]
        displayname = string.format("%s (%d/%d)", e.name,v,self.numWorkouts)
        
        local xpos = self.x0 + (self.boxSpacing / 2.0) + (self.rw0 + self.boxSpacing) * idx
        local ypos = self.y0 + (self.boxSpacing / 2.0)

        -- initial hightlight code. just highlight the frist thing all the time.
        if idx == 0 then
            drawWorkoutBox(displayname, e.exercises, self.boxSpacing, xpos, ypos, self.rw0, self.rh0, self.curve, true)
        else
            drawWorkoutBox(displayname, e.exercises, self.boxSpacing, xpos, ypos, self.rw0, self.rh0, self.curve, false)
        end
        idx = idx + 1
    end
end

function drawWorkoutBox(displayName, exercises, boxSpacing, x, y, width, height, curve, highlight )
    local rw1 = width  - 2
    local rh1 = height - 2
    local offsetw = (width - rw1)/2.0
    local offseth = (height - rh1)/2.0
    local font = love.graphics.getFont()
    local gw = font:getWidth(displayName)
    local gh = font:getHeight(displayName)

    if highlight then
        -- Eventually want to make this a configuration. Hard code to a pretty blue for now.
        love.graphics.setColor(0,.5,1)
    end
    love.graphics.rectangle("fill",x,y, width, height, curve, curve)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",x+offsetw,y+offseth,rw1,rh1, curve, curve)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",x,y+curve, width, 1)
    love.graphics.print(displayName, x + (width / 2.0) - (gw / 2.0) , y + (curve / 2.0) - (gh/2.0))
    drawExercises(exercises, x + boxSpacing, y + curve, width)
end

function drawExercises(exercises, x, y, boxWidth)
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
            love.graphics.rectangle("fill", x , y + yOffset + gh / 2.0, boxWidth *.9, 1)
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
function workout:update()
    self.indices = getBoxIndices(self.drawIndowStartIdx, self.numBoxesToDraw, self.numWorkouts)
end

function getBoxIndices( drawIndex, numToDraw, numElements)

    local currentIndex = drawIndex

    -- Reset indices
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

function workout:validateInput( workoutData )
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

function workout:navigation(key)
    --- Workout navigation start ---

    -- Keep the index in range.
    if key == "right"
    or key == "l" then -- Allow vim like motions
            self.drawIndowStartIdx = self.drawIndowStartIdx + 1
            if self.drawIndowStartIdx > self.numWorkouts then
                self.drawIndowStartIdx = 1
        end
    end

    -- Keep the index in range.
    if key == "left"
    or key == "h" then -- Allow vim like motions
            self.drawIndowStartIdx = self.drawIndowStartIdx - 1
            if self.drawIndowStartIdx <= 0 then
                self.drawIndowStartIdx = self.numWorkouts
            end
    end

    -- Change how many workouts to display.
    if key >= '1' and key <= tostring(self.maxBoxesToDraw) then
        if tonumber(key) ~= self.numBoxesToDraw then
            self.numBoxesToDraw = tonumber(key)

            if self.numWorkouts < self.numBoxesToDraw then
                self.numBoxesToDraw = self.numWorkouts
            end

            love.window.setMode(self.numBoxesToDraw*(self.boxSpacing+self.rw0), self.rh0 + self.boxSpacing) 
        end
    end
    --- Workout navigation end ---
end