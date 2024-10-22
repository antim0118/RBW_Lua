require("Vector2")

Field = {}
Field.__index = Field

local letters = { 'A', 'B', 'C', 'D', 'E', 'F' } -- буквы
local rowsNumber = 10 -- количество строк
local columnsNumber = 10 -- количество столбцов
local score = 0

function Field:init() -- создание поля
    local field = {}
    for c = 1, columnsNumber do
        field[c] = {}
        for r = 1, rowsNumber do
            field[c][r] = letters[math.random(#letters)]
        end
    end

    local obj = { field = field }
    setmetatable(obj, self)
    return obj
end

function Field:checkCells(pos, dir) --pos/dir = Vector2
    -- вовращает сколько одинаковых символов идёт подряд
    local symbol = self.field[pos.x][pos.y]
    if symbol == nil or symbol == '-' then
        return 0
    end

    local count = 0
    local checkPos = Vector2:new(pos.x, pos.y)
    local checkSymbol
    while true do
        checkPos.x = checkPos.x + dir.x
        checkPos.y = checkPos.y + dir.y
        if checkPos.x > columnsNumber or checkPos.y > rowsNumber then
            break
        end

        checkSymbol = self.field[checkPos.x][checkPos.y]
        if checkSymbol == nil or checkSymbol ~= symbol then
            break
        end

        count = count + 1
    end

    return count
end

function Field:containsEmptyCells() -- содержит ли поле пустые ячейки
    for c = 1, columnsNumber do
        for r = 1, rowsNumber do
            if self.field[c][r] == '-' then
                return true
            end
        end
    end
    return false
end

function Field:containsMutualCells() -- содержит ли ячейки три или более подряд
    for r = 1, rowsNumber do
        for c = 1, columnsNumber do
            local pos = Vector2:new(c, r)
            local horNum = self:checkCells(pos, Vector2:new(1, 0))  -- проверка по горизонтали
            local vertNum = self:checkCells(pos, Vector2:new(0, 1)) -- проверка по вертикали

            if horNum >= 2 or vertNum >= 2 then
                return true
            end
        end
    end
    return false
end

function Field:tick() -- выполнение действий на поле
    -- делаем проверку на три или более одинаквых символов в ряд
    for r = 1, rowsNumber do
        for c = 1, columnsNumber do
            local pos = Vector2:new(c, r)
            local horNum = self:checkCells(pos, Vector2:new(1, 0)) -- проверка по горизонтали 
            local vertNum = self:checkCells(pos, Vector2:new(0, 1)) -- проверка по вертикали
            
            if horNum >= 2 or vertNum >= 2 then
                self.field[pos.x][pos.y] = '-'
                score = score + 1
            end
            
            if horNum >= 2 then
                for row = 1, horNum do
                    self.field[pos.x + row][pos.y] = '-'
                    score = score + 1
                end
            end
            
            if vertNum >= 2 then
                for col = 1, vertNum do
                    self.field[pos.x][pos.y + col] = '-'
                    score = score + 1
                end
            end
        end
    end
    
    -- заполняем освободившиеся ячейки
    for r = 1, rowsNumber do
        for c = 1, columnsNumber do
            local symbol = self.field[c][r]
            if symbol == '-' then
                if r == 1 then
                    self.field[c][r] = letters[math.random(#letters)]
                else
                    self.field[c][r] = self.field[c][r - 1]
                    self.field[c][r - 1] = '-'
                end
            end
        end
    end
end

function Field:move(from, to) -- выполнение хода игрока
    if from.x >= 0 and from.x < columnsNumber
    and from.y >= 0 and from.y < rowsNumber
    and to.x >= 0 and to.x < columnsNumber
    and to.y >= 0 and to.y < rowsNumber then
        local m1 = self.field[from.x+1][from.y+1]
        self.field[from.x+1][from.y+1] = self.field[to.x+1][to.y+1]
        self.field[to.x+1][to.y+1] = m1
    end
end

function Field:mix() -- перемешивание поля
    repeat
        -- переводим поле в одномерный массив
        local field1d = {}
        for c = 1, columnsNumber do
            for r = 1, rowsNumber do
                table.insert(field1d, self.field[r][c])
            end
        end
        
        -- перемешиваем
        for c = 1, columnsNumber do
            for r = 1, rowsNumber do
                local idx = math.random(#field1d)
                self.field[r][c] = table.remove(field1d, idx)
            end
        end
    until self:containsMutualCells() == false
end

function Field:dump() -- вывод поля на экран
    -- отрисовка номеров столбцов
    io.write('\n    ')
    for c = 1, columnsNumber do
        io.write(c-1 .. ' ')
    end
    io.write('\n')
    for r = 1, columnsNumber + 2 do
        io.write('- ')
    end
    io.write('\n')
    -- отрисовка значений
    for r = 1, rowsNumber do
        io.write(r - 1 .. ' | ')
        for c = 1, columnsNumber do
            io.write(self.field[c][r] .. ' ')
        end
        io.write('\n')
    end
    io.write('Score: ' .. score .. '\n')
end