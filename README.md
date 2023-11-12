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
