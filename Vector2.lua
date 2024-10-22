Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(X, Y)
    local obj = { x = X, y = Y }
    setmetatable(obj, self)
    return obj
end