# Animations
### Um sistema para facilitar o uso do interpolate
V2.0.0

# IMPORTANTE
```lua
-- Dentro do seu render utilize
updateGlobalTick()
-- Para o script não ficar executando varias vezes a função getTickCount()
```

## Custom Animations - Easing
```lua
-- Pulse, Floating, Shake

-- As customAnimations estão abertas para os desenvolvedores adicionarem mais tipos ao decorrer de suas necessidades, em breve no branch main sera adicionado mais diversidades de animações
```

## Funções
Criação
```lua
Animation:create({
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
Animation:update({
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
Animation:updateTick()
```
Pegar o valor do interpolate
```lua
Animation:get()
```
Pegar informações da animação
```lua
Animation:getData()
```
Desatribuir atributo
```lua
Animation:removeAtributte()
```
Resetar contagem de execuções do atributo
```lua
Animation:resetAtributte()
```


## Utilização
Utilização basica
```lua
local anim = Animation:create({
    start = {50, 0, 0},
    final = {150, 0, 0},
    time = 1000,
    easing = 'Floating',
    subEasing = 'InOutQuad'
})


addEventHandler('onClientRender', root, function()
    local value = anim:get()

    dxDrawRectangle(100 - value[1]/2, 100 - value[1]/2, value[1], value[1])

    updateGlobalTick() -- Para otimização do codigo em geral, não ficar executando varias funções ao mesmo tempo ( IMPORTANTE PARA O FUNCIONAMENTO!!!! )
end)
```
