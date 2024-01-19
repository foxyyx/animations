
// a

animation = {}
local private = {}

function animation:create(inicial, final, time, easing, func)
    assert(type(inicial) == 'number', 'INICIAL value must be a number, got '..type(inicial))
    assert(type(final) == 'number', 'FINAL value must be a number, got '..type(final))
    assert(type(time) == 'number', 'TIME value must be a number, got '..type(time))

    local instance = {
        inicial = inicial or 0,
        final = final or 0,
        easing = easing or 'Linear',
        time = time or 1000,
        tick = getTickCount(),
        value = 0,
        __atributte = {func = func, executed = false}
    }
    private[instance] = instance

    setmetatable(instance, {__index = self})

    return instance;
end

function animation:updateTick()
    private[self].tick = getTickCount()
end

function animation:updateValues(inicial, final, time, easing, func)
    assert(type(inicial) == 'number', 'INICIAL value must be a number, got '..type(inicial))
    assert(type(final) == 'number', 'FINAL value must be a number, got '..type(final))

    private[self] = {
        inicial = inicial or 0,
        final = final or 0,
        easing = easing or private[self].easing,
        time = time or private[self].time,
        tick = getTickCount(),
        value = private[self].value or 0,
        __atributte = {func = private[self].__atributte.func, executed = false}
    }
end

function animation:get()
    private[self].value = interpolateBetween(private[self].inicial, 0, 0, private[self].final, 0, 0, (getTickCount() - private[self].tick) / private[self].time, private[self].easing)
    if (self.__atributte.func and self:getValues().finalized and not private[self].__atributte.executed) then
        self.__atributte.func()
        private[self].__atributte.executed = true
    end
    return private[self].value or 0
end    

function animation:getValues()
    return {
        data = private[self], 
        currentValue = (private[self].value or 0),
        finalized = getTickCount() - private[self].final >= private[self].time
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
