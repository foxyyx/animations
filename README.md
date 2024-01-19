# Animations
### Um sistema para facilitar o uso do interpolate
V2.0.0

## Funções
Criação
```lua
table Animation:create({
    start = {50, 0, 0}, -- Os três argumentos do interpolate inseridos em uma tabela
    final = {150, 0, 0}, -- Os três argumentos do interpolate inseridos em uma tabela
    time = 1000, -- Tempo de progresso da interpolação
    easing = 'Pulse', -- Tipo da easing da interpolação, aperto as customAnimations
    subEasing = 'InOutQuad', -- Tipo da subEasing para as customAnimations
    --[[
    aditionalValues = {0, 10}, -- Valores adicionais do interpolate
    atributte = function() end, -- Função que será executada ao fim da animação; PS: Algumas customAnimations são infinitas
    atributteTimes = 2 -- O maximo de vezes que a função será iniciada, ao caso de funções infinitas ou updates no interpolate
    ]]
})
```
Atualização de valores
```lua
bool Animation:update({
    start = {0, 0, 0}, -- Os três argumentos do interpolate inseridos em uma tabela
    final = {50, 0, 0}, -- Os três argumentos do interpolate inseridos em uma tabela
    time = 1000, -- Tempo de progresso da interpolação
    easing = 'Floating', -- Tipo da easing da interpolação, aperto as customAnimations
    subEasing = 'InOutQuad', -- Tipo da subEasing para as customAnimations
    --[[
    aditionalValues = {10, 0}, -- Valores adicionais do interpolate
    atributte = function() end, -- Função que será executada ao fim da animação; PS: Algumas customAnimations são infinitas
    atributteTimes = 3, -- O maximo de vezes que a função será iniciada, ao caso de funções infinitas ou updates no interpolate
    atributteReset = true -- Booleano para definir se o numero de vezes que o atributo foi executado vai ser resetado, voltando a 0
    ]]
})
```
Atualização de tick
```lua
bool Animation:updateTick()
```
Pegar o valor do interpolate
```lua
table Animation:get()
```
Pegar informações da animação (data, currentValue, finalized)
```lua
table animation:getData()
```
Desatribuir atributo
```lua
bool Animation:removeAtributte()
```
Resetar contagem de execuções do atributo
```lua
bool Animation:resetAtributte()
```


## Utilização
Utilização basica
```lua
local anim = Animation:create({
    start = {50, 0, 0},
    final = {150, 0, 0},
    time = 1000,
    easing = 'Pulse',
    subEasing = 'InOutQuad'
})

addEventHandler('onClientRender', root, function()
    local value = anim:get()

    dxDrawRectangle(100 - value[1]/2, 100 - value[1]/2, value[1], value[1])
end)
```
