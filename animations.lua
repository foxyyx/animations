
animation = {}
local private = {}

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
        __func = {func = func, executed = false}
    }

    setmetatable(instance, {__index = self})

    return instance;
end

function animation:updateTick()
    private[self].tick = getTickCount()
end

function animation:updateValues(inicial, final, time, type, func)
    assert(type(inicial) == 'number', 'INICIAL value must be a number, got '..type(inicial))
    assert(type(final) == 'number', 'FINAL value must be a number, got '..type(final))

    private[self] = {
        inicial = tonumber(inicial) or 0,
        final = tonumber(final) or 0,
        type = type or private[self].type,
        time = tonumber(time) or private[self].time,
        tick = getTickCount(),
        __func = {func = private[self].__func, executed = false}
    }
end

function animation:get()
    private[self].value = interpolateBetween(private[self].inicial, 0, 0, private[self].final, 0, 0, (getTickCount() - private[self].tick)private[self].time, private[self].type)
    if (self.__func and self:getValues().finalized and not private[self].__func.executed) then
        self.__func()
        private[self].__func.executed = true
    end
    return private[self].value or 0
end    

function animation:getValues()
    return {
        data = private[self], 
        currentValue = (private[self].value or 0),
        finalized = private[self].value >= private[self].final
    }
end

function animation:destroy()
    private[self] = nil
end

function animation:removeFunction()
    private[self].__func = nil
end

function destroyAllAnimations()
    private = {}
end
