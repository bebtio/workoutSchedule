
function love.load(arg)

    x0 = 0
    y0 = 0
    rw0 = 200
    rh0 = 400
    daysOfWeek = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
    love.window.setMode(1460,400) 
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

end

function love.draw()


    for idx, day in ipairs(daysOfWeek) do
        drawWorkoutBox(day, nil, x0 + (rw0 + 10) * (idx -1), y0, rw0, rh0)
    end
end

function drawWorkoutBox( dayOfWeek, workout, x, y, width, height )
    local rw1 = width  - 2
    local rh1 = height - 2
    local offsetw = (width - rw1)/2.0
    local offseth = (height - rh1)/2.0
    local curve = 30
    local font = love.graphics.getFont()
    local gw = font:getWidth(dayOfWeek)
    local gh = font:getHeight(dayOfWeek)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",x,y, width, height, curve, curve)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",x+offsetw,y+offseth,rw1,rh1, curve, curve)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",x,y+curve, width, 1)
    love.graphics.print(dayOfWeek, x + (width / 2.0) - (gw / 2.0) , y + (curve / 2.0) - (gh/2.0))

    drawWorkout()
end

function drawWorkout( workout )
end

function drawExerciseSetsReps( exercise, numSets, numReps )
end

function drawExerciseReps( exercise, numReps )
end

function drawExerciseBigSet( exercises, numReps)
end