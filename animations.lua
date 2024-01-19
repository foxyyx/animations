
Animation = {}

-- main

function Animation:create(data)

    if (type(data.start) ~= 'table' or type(data.final) ~= 'table' or type(data.time) ~= 'number' or type(data.easing) ~= 'string') then
        local input = (type(data.start) ~= 'table' and '\'start\' value must a be table, got '..type(data.start)) or (type(data.final) ~= 'table' and '\'final\' value must a be table, got '..type(data.final)) or (type(data.time) ~= 'number' and '\'time\' value must a be number, got '..type(data.time)) or (type(data.easing) ~= 'string' and '\'easing\' value must a be string, got '..type(data.easing)) 
        return error(input)
    end

    local instance = {}
    
    -- fixed
    instance.start = data.start
    instance.final = data.final
    instance.time = data.time
    instance.easing = data.easing
    instance.aditionalValues = data.aditionalValues or {}

    -- others
    instance.values = {
        interpolate = 0,
        tick = getTickCount()
    }
    instance.atributte = {
        toExecute = data.atributte,
        executeState = false,
        timesToExecute = data.atributteTimes or 1,
        timesExecuted = 0
    }

    setmetatable(instance, {
        __index = self
    })

    return instance;
end

function Animation:tryExecuteAtributte()
    if (getTickCount() - self.values.tick >= self.time and type(self.atributte.toExecute) == 'function' and self.atributte.timesExecuted < self.atributte.timesToExecute) then
        self.atributte.executeState = true
        self.atributte.timesExecuted = self.atributte.timesExecuted + 1
        return self.atributte.toExecute();
    end
end

function Animation:executeAnimation()
    self.values.interpolate = {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (getTickCount() - self.values.tick / self.time), self.easing, unpack(self.aditionalValues))}
    return self.values.interpolate;
end

-- custom animation's

local customAnimations = {
    ['Pulse'] = function(self)
        if (getTickCount() - self.values.tick >= self.time) then
            self.values.tick = getTickCount()
        end
        return {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (getTickCount() - self.values.tick) / self.time, self.subEasing or 'Linear', unpack(self.aditionalValues))};
    end,
    ['Floating'] = function(self)
        if (getTickCount() - self.values.tick >= self.time) then
            self:update({
                start = self.final,
                final = self.start
            })
        end
        return {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (getTickCount() - self.values.tick) / self.time, self.subEasing or 'Linear', unpack(self.aditionalValues))};
    end
}

function Animation:executeCustomAnimation()
    self.values.interpolate = customAnimations[self.easing](self)
    return self.values.interpolate;
end

-- misc

function Animation:isFinalized()
    return getTickCount() - self.values.tick >= self.time;
end

function Animation:isStarted()
    return getTickCount() - self.values.tick > 1;
end

function Animation:resetAtributte()
    if (self.atributte.toExecute) then
        self.atributte.executeState = false
        self.atributte.timesExecuted = 0
        return true;
    end
    return false;
end

function Animation:removeAtributte()
    if (self.atributte.toExecute) then
        self.atributte = {
            toExecute = nil,
            executeState = false,
            timesToExecute = 1,
            timesExecuted = 0
        }
        return true;
    end
    return false;
end

function Animation:getData()
    return self;
end

function Animation:update(data)
    
    -- fixed
    self.start = data.start or self.start
    self.final = data.final or self.final
    self.time = data.time or self.time
    self.easing = data.easing or self.easing
    self.aditionalValues = data.aditionalValues or self.aditionalValues

    -- others
    self.values.tick = getTickCount()
    self.atributte.toExecute = data.atributte or self.atributte.toExecute
    self.atributte.timesToExecute = data.atributteTimes or self.atributte.timesToExecute
   
    if (self.atributteReset) then
        self.atributte.executeState = false
        self.atributte.timesExecuted = 0
    end

    return true;
end

function Animation:updateTick()
    if (not customAnimations[self.easing]) then
        self.values.tick = getTickCount()
    end
    return true;
end

function Animation:get()
    self:tryExecuteAtributte()
    
    if (customAnimations[self.easing]) then
        return self:executeCustomAnimation();
    end
    return self:executeAnimation();
end
