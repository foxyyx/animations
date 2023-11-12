# animations
### Um sistema para facilitar o uso do interpolate

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
    end
end

panelControl('open')
```
