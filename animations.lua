
animation = {}
local private = {}

-->> animation:create(100, 200, 1000, 'Linear', func) | Fora do render
function animation:create(inicial, final, time, type, func)
    assert(type(inicial) == 'number', 'INICIAL value must be a number, got '..type(inicial))
    assert(type(final) == 'number', 'FINAL value must be a number, got '..type(final))
    assert(type(time) == 'number', 'TIME value must be a number, got '..type(time))
    assert(type(type) == 'string', 'INICIAL value must be a number, got '..type(type))

    local instance = {
        inicial = tonumber(inicial) or 0,
        final = tonumber(final) or 0,
        type = type or 'Linear',
        time = tonumber(time) or 1000,
        tick = getTickCount(),
        value = 0,
        __func = func
    }

    setmetatable(instance, {__index = self})

    return instance;
end

-->> animation:updateTick() | Fora do render ou dentro
function animation:updateTick()
    private[self].tick = getTickCount()
end

-->> animation:updateValues(200, 100, 1000, 'Linear') | Fora do render
function animation:updateValues(inicial, final, time, type)
    assert(type(inicial) == 'number', 'INICIAL value must be a number, got '..type(inicial))
    assert(type(final) == 'number', 'FINAL value must be a number, got '..type(final))
    assert(type(time) == 'number', 'TIME value must be a number, got '..type(time))
    assert(type(type) == 'string', 'INICIAL value must be a number, got '..type(type))

    private[self] = {
        inicial = tonumber(inicial) or 0,
        final = tonumber(final) or 0,
        type = type or 'Linear',
        time = tonumber(time) or 1000,
        tick = getTickCount()
    }
end

-->> animation:get() | Dentro do render para pegar o valor
function animation:get()
    private[self].value = interpolateBetween(private[self].inicial, 0, 0, private[self].final, 0, 0, (getTickCount() - private[self].tick)private[self].time, private[self].type)
    if (self:getValues().finalized) then
        self.__func()
    end
    return private[self].value or 0
end    

-->> animation:getValues() | Fora do render ou dentro
function animation:getValues()
    return {
        data = private[self], 
        currentValue = (private[self].value or 0),
        finalized = private[self].value >= private[self].final
    }
end

-->> animation:destroy() | Fora do render
function animation:destroy()
    private[self] = nil
end

-->> animation:destroyAll() | Fora do render
function animation:destroyAll()
    private = {}
end
