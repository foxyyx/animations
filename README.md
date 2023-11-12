# Aurora Animations
### Um sistema para facilitar o uso do interpolate

## Funções
Criação
```lua
animation:create(100, 200, 1000, 'Linear', function() end) -- O ultimo argumento não é necessario
```
Atualização de valores
```lua
animation:updateValues(200, 100, 1000, 'Linear', function() end) -- O ultimo argumento não é necessario
```
Atualização de tick
```lua
animation:updateTick()
```
Pegar o valor do interpolate
```lua
animation:get()
```
Pegar informações da animação (data, currentValue, finalized)
```lua
animation:getValues()
```
Destruir animação
```lua
animation:destroy()
```
Destruir todas as animações
```lua
destroyAllAnimations()
```
Desatribuir função
```lua
animation:removeFunction()
```


## Utilização
Utilização basica
```lua
local anim = animation:create(0, 200, 'Linear')

addEventHandler('onClientRender', root, function()
    local value = anim:get()

    dxDrawRectangle(value, 0, 100, 100)
end)
```
Utilização com funções atribuidas na finalização da animação
```lua
local anim;

function render()
    local value = anim:get()
    
    dxDrawRectangle(value, 0, 100, 100)
end

function panelControl(type)
    if (type == 'open') then
        addEventHandler('onClientRender', root, render)
        anim = animation:create(0, 200, 'Linear', panelControl('close'))
    elseif (type == 'close') then
        removeEventHandler('onClientRender', root, render)
        anim:destroy()
    end
end

panelControl('open')
```
Utilização do updateValues
```lua
local anim;

function render()
    local value = anim:get()
    
    dxDrawRectangle(value, 0, 100, 100)
end

function panelControl(type)
    if (type == 'open') then
        addEventHandler('onClientRender', root, render)
        anim = animation:create(0, 200, 1000, 'Linear', panelControl('close'))
    elseif (type == 'close') then
        anim:updateValues(200, 0)
        Timer(function()
            removeEventHandler('onClientRender', root, render)
            anim:destroy()
        end, 1000, 1)
    end
end

panelControl('open')
```
