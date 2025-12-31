json = require("json")
require("workout")
require("screenshot")
require("mode")


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

    if not validateInput(workouts) then
        os.exit(0)
    end

    -- Default mode is to show workouts.
    setModeByString("workout")
    local font = love.graphics.getFont()
    workout:init(workouts, font) 


    -- Love configurations.
    love.window.setTitle("Workout Schedule")
end

function love.update(dt)

    workout:update()

end

function love.draw()

    local mode = getCurrentMode()

    if mode == "workout" then
        workout:main(workouts)
    elseif mode == "note" then
        love.graphics.print("NOTE MODE")
    elseif mode == "max" then
        love.graphics.print("MAX MODE")
    end

end

function love.keypressed(key, scancode, isrepeat)

    --- Screenshot code start ---
    if love.keyboard.isDown('s') then
        takeScreenShot()
    end
    --- Screenshot code end ---


    if key == 'q' then
        love.event.quit()
    end

    workout:handleKeyPresses(key)

    -- Change the mode if necessary.
    setModeByKey(key)
end