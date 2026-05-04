# Strat Tester para Black Ops II

## Descargas:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Download in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traducido por [NoMoleMan](https://www.twitch.tv/nomoleman)

## Como instalar

- Descomprime a descarga en `%localappdata%\Plutonium\storage\t6\mods`.

## Cambios xerais
- Vantaxes outorgadas ao aparecer
- Armas outorgadas ao aparecer
- Todas as portas abertas (excepto as necesarias para certas estratexias).
- A partida empeza na rolda 100
- Temporizadores de partida, rolda e trampas
- Barra de vida
- Contador de zombies vivos
- Visualización da zona na que estás
- Medidor de segundos por hordada
- A caixa pode ser forzada a cambiar de posición
- Os power-ups pódense desactivar
- Engadido Notarget
- Pódese quitar a néboa
- Rastreador das reaparicións dos zombies, feito por [Guy](https://github.com/ineedbots)

## Cambios por mapa
### Tranzit
- Temporizador das voltas do bus
- Visualización da zona do bus
- Notifícase aos xogadores cando aparece un denizen
- Pódese escoller o tempo que para o bus na granxa

### Town
- 2 formas de iniciar a partida
    - Porta de titán aberta e de prestidixitación pechada
    - Porta de prestidixitación aberta e de titán pechada

### Nuketown
- Todas as vantaxes caen do ceo ao principio da partida
- Pódese reiniciar automaticamente para o Pack A Punch na casa verde

### Die Rise
- O trampolín está creado desde o principio
- Contador de zombies mortos por ascensores

### MOTD
- Escudo construído na cafetaría
- Vidas de afterlife infinitas
- Todas as pezas recollidas ao principio da partida

### Buried
- Dúas formas de establecer os equipamentos:
    - Resonador en titán, Turbina na igrexa e Trampolín no saloon (modo por defecto)
    - Resonador no saloon, Turbina na igrexa e Trampolín en titán
- Contador de baixas por disparo de resonador

### Origins
- O xogador branco empeza con pala e casco dourado
- Os xogadores poden chamar ao tanque desde o xerador 2 sen usalo primeiro no xerador 6
- Escudo construído na igrexa
- Todos os xogadores reciben a recompensa de activar os 6 xeradores
- Todos os bastóns están no Crazy Place
- Todos os portais están abertos
- Contador de zombies apisoados e tombados polos robots
- Contador de zombies mortos polo tanque

## Arsenais
Pódese escoller as armas que dará o mod ao empezar.
En `zm_strattester\scriptdata\loadouts` tes os arquivos que le o mod en cada mapa, para que sexa un formato válido ten que seguir estas regras:
1. Na primeira liña debes poñer o código das armas que queiras recibir, e.g. `ray_gun_zm`.
2. Na segunda liña debes poñer o arma que queiras no slot de Coz (Mule Kick).
3. Na terceira liña debes poñer o equipamento que queiras recibir (todo o que xogando con mando require usar as frechas).
4. Na cuarta liña debes poñer o arma corpo a corpo que queiras recibir e.g. `tazer_knuckles_zm`
5. Ningunha liña pode estar en branco, se non se quere calquera cousa tense que escribir `undefined`

## Comandos do chat

### Xeral
- `!nuke`         xera un power-up da bomba enriba do xogador 
- `!x2`           xera un power-up de dobre puntuación enriba do xogador 
- `!max`          xera un power-up de munición máxima enriba do xogador 
- `!insta`        xera un power-up de baixa instantánea enriba do xogador
- `!sale`         xera un power-up de rebaixas enriba do xogador 
- `!blood`        xera un power-up de sangue zombie enriba do xogador
- `!perk`         xera un power-up de perk aleatoria enriba do xogador 
- `!tp`           teletransporta ao xogador ao lugar desexado
- `!tpc`          teletransporta ao xogador ás coordenadas desexadas

### Origins
- `!gen x`        activa ou desactiva o xerador número x

# Un saúdo especial a:
- [NoMoleMan](https://www.twitch.tv/nomoleman) Por ser o principal tester do mod e traducir os menús ao portugués.
- [Guy](https://github.com/ineedbots) Por facer o script para a reaparición dos zombies.
- [5and5](https://github.com/5and5) Por facer o Strat Tester orixinal e axudarme hai 5 anos cando empecei a moddear Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) Por facer o script que abre as portas en modo afterlife.
- MJ Por axudar co menú das perks.