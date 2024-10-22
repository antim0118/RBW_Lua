require("Vector2")
require("Field")

local function sleep(a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

local field = Field:init() -- заполняем поле
local input
while true do
    while true do
        field:tick() -- тик
        field:dump() -- визуализируем после каждого тика
        sleep(0.2)
        if field:containsEmptyCells() == false then
            break
        end
    end
    
    io.write('Command: ')
    input = io.read():gmatch("%w+")
    
    local inputs = {}
    for i in input do table.insert(inputs, i) end
    
    if #inputs >= 1 then
        local command = inputs[1]
        if command == 'm' and #inputs >= 4 then --move
            local from = Vector2:new(tonumber(inputs[2]), tonumber(inputs[3]))
            local d = inputs[4]
            local to = Vector2:new(from.x, from.y)

            if d == 'u' then
                to.y = to.y - 1
            elseif d == 'd' then
                to.y = to.y + 1
            elseif d == 'l' then
                to.x = to.x - 1
            elseif d == 'r' then
                to.x = to.x + 1
            end

            field:move(from, to)
        end
        if command == 'mix' then
            field:mix()
        end
    end
end
