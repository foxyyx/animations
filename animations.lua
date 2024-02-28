Animation = {}
local currentTick = getTickCount()

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
    instance.customize = data.customize or {}

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
    if (currentTick - self.values.tick >= self.time and type(self.atributte.toExecute) == 'function' and self.atributte.timesExecuted < self.atributte.timesToExecute and not self.atributte.executeState) then
        if (self.atributte.timesExecuted >= self.atributte.timesToExecute) then
            self.atributte.executeState = true
        end
        self.atributte.timesExecuted = self.atributte.timesExecuted + 1
        return self.atributte.toExecute();
    end
end

function Animation:executeAnimation()
    self.values.interpolate = {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (currentTick - self.values.tick) / self.time, self.easing, self.aditionalValues and unpack(self.aditionalValues))}
    return self.values.interpolate;
end

-- custom animation's

local customAnimations = {
    ['Pulse'] = function(self)
        if (self:isFinalized()) then
            self:updateTick(true)
        end
        return {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (currentTick - self.values.tick) / self.time, self.subEasing or 'Linear', self.aditionalValues and unpack(self.aditionalValues))};
    end,
    ['Floating'] = function(self)
        if (self:isFinalized()) then
            self:update({
                start = self.final,
                final = self.start
            })
        end
        return {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (currentTick - self.values.tick) / self.time, self.subEasing or 'Linear', self.aditionalValues and unpack(self.aditionalValues))};
    end,
    ['Shake'] = function(self)        
        if (not self.customProperties) then
            self.customProperties = {
                count = 0,
                state = true
            }
        end

        if (self:isFinalized() and self.customProperties.state) then
            self.customProperties.count = self.customProperties.count + 1;

            self:update({
                start = self.final,
                final = {-self.start[1], self.start[2], self.start[3]}
            })
        end

        if (self.customProperties.count >= (self.customize.count or 10) and self.customProperties.state) then
            self.customProperties.state = false;

            local ip = ((self.customize.count or 10) % 2 ~= 0)
            self:update({
                start = (not ip and self.final or self.start),
                final = (not ip and self.start or self.final)
            })
        end
        return {interpolateBetween(self.start[1], self.start[2], self.start[3], self.final[1], self.final[2], self.final[3], (currentTick - self.values.tick) / self.time, self.subEasing or 'Linear', self.aditionalValues and unpack(self.aditionalValues))};
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

function Animation:updateTick(force)
    if (customAnimations[self.easing]) then
        self.customProperties = nil
    end

    if (not customAnimations[self.easing] or force) then
        self.values.tick = getTickCount()
    end
    return true;
end

function Animation:changeTime(time)
    self.time = time
end

function Animation:get()
    self:tryExecuteAtributte()
    
    if (customAnimations[self.easing]) then
        return self:executeCustomAnimation();
    end
    return self:executeAnimation();
end

function updateGlobalTick(tick)
    currentTick = tick or getTickCount()
end
