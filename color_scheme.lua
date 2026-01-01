json = require("json")

colors = {
    workout_mode = {
        box_background = {0.0, 0.0, 0.0, nil},
        box_border     = {1.0, 1.0, 1.0, nil},
        box_highlight  = {0.0, 0.5, 1.0, nil},
        box_text       = {1.0, 1.0, 1.0, nil}
    },
    background = {
        color = {0.0,0.0,0.0}
    }
}

function colors:init()

end

-- Expects a json file with the same structure as the colors table.
-- Expects values to be in RGB with range of values of 0-255. This function
-- will convert the values to love2d's normalized range.
function colors:load(colorSchemeFile)

    print("Loading color schemes: " .. colorSchemeFile)
    local file = io.open(colorSchemeFile, "rb")

    if file == nil then
        print(string.format("Color file :%s doesn't exist. Using program defaults.", colorSchemeFile))
        return
    end
    local json_colors = json.decode(file:read("*a"))

    -- Iterate over the colors that were read in.
    for k,v in pairs(json_colors.background) do
        -- Make sure that we have a mapping for the keys in our colorSchemes table and
        -- that the values in the loaded colors are not empty.
        -- Set the colors.
        if self.background[k] ~= nil and #v ~= 0 then
            r,g,b,a = love.math.colorFromBytes(v[1], v[2], v[3])
            self.background[k] = {r,g,b,a} 
        end
    end

    -- Repeat the process for box colors.
    for k,v in pairs(json_colors.workout_mode) do
        if self.workout_mode[k] ~= nil and #v ~= 0 then
            r,g,b,a = love.math.colorFromBytes(v[1], v[2], v[3])
            self.workout_mode[k] = {r,g,b,a} 
        end
    end

    -- Repeat for all modes.

    io.close(file)

end