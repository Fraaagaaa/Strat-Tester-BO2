# Strat Tester para Black Ops II

## Descargas:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Donwload in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

## Como instalar

- Descomprime la descarga en `%localappdata%\Plutonium\storage\t6\mods`.

## General changes
- Ventajas otorgadas al aparecer
- Armas otorgadas al aparecer
- Todas las puertas abiertas (excepto las necesarias para ciertas estrategias).
- La partida empieza en la ronda 100
- Temporizadores de partida, ronda y trampas
- Barra de vida
- Contador de zombis vivos
- Visualización de la zona en la que estás
- Meidior de segundos por holeada
- La caja puede ser forzada a cambiar de posición
- Los power-ups se pueden desactivar
- Añadido Notarget
- Se puede quitar la niebla
- Rastreador de las reapariciones de los zombis, hecho por [Guy](https://github.com/ineedbots)

## Cambios por mapa
### Tranzit
- Temporizador de las vueltas del bus
- Visualización de la zona del bus
- Se notifica a los jugadores cuando aparece un denizen
- Se puede escoger el tiempo que para el bus en granja

### Town
- 2 formas de iniciar la partida
    - Puerta de titán abierta y de prestidigitación cerrada
    - Puerta de prestidigitación abierta y de titán cerrada

### Nuketown
- Todas las ventajas caen del cielo al principio de la partida
- Se puede reiniciar automáticamente para el Pack A Punch en la casa verde

### Die Rise
- El trampolín está creado desde el principio
- Contador de zombis muertos por ascensores

### MOTD
- Escudo construido en la cafeteria
- Vidas de afterlife infinitas
- Todas las piezas recogidas al principio de la partida

### Buried
- Dos formas de establecer los equipamientos:
    - Resonador en titán, Turbina en la iglesia y Trampolín en el saloon (modo por defecto)
    - Resonador en el saloon, Turbina en la iglesia y Trampolín en titán
- Contador de bajas por disparo de resonador

### Origins
- El jugador blanco empieza con pala y casco dorado
- Los jugadores pueden llamar al tanque desde el generador 2 sin usarlo primero en el generador 6
- Escudo construido en la iglesia
- Todos los jugadores reciben la recompensa de activar los 6 generadores
- Todos los bastones están en el Crazy Place
- Todos los portales están abiertos
- Contador de zombis apisotonados y tumbados por los robots
- Contador de zombis muertos por el tanque

## Arsenales
Se puede escoger las armas que dará el mod al empezar.
En `zm_strattester\scriptdata\loadouts` tienes los archivos que lee el mod en cada mapa, para que sea un formato válido tiene que seguir estas reglas:
1. En la primera línea debes poner el código de las armas que quieras recibir, e.g. `ray_gun_zm`.
2. En la segunda línea debes poner el arma que quieras en el slot de Coz.
3. En la tercera línea debes poner el equipamiento que quieras recibir (todo lo que jugando con mando requiere usar las flechas).
4. En la cuarta línea debes poner el arma cuerpo a cuerpo que quieras recibir e.g. `tazer_knuckles_zm`
5. Ninguna linea puede estar en blanco, si no se quiere cualquier cosa se ha de escribir `undefined`

## Comandos del chat

### General
- `!nuke`          genera un power-up de la bomba encima del jugador 
- `!x2`            genera un power-up de doble puntuacón encima del jugador 
- `!max`           genera un power-up de munición máxima encima del jugador 
- `!insta`         genera un power-up de baja instantánea encima del jugador
- `!sale`          genera un power-up de rebajas encima del jugador 
- `!blood`         genera un power-up de sangre zombi encima del jugador
- `!perk`          genera un power-up de perk aleatório encima del jugador 
- `!tp`            teletransporta al jugador en el lugar deseado
- `!tpc`           teletransporta al jugador en las coordenadas deseadas

### Origins
- `!gen x`       activa o desactiva el generador número x

# Un especial saludo a:
- [NoMoleMan](https://www.twitch.tv/nomoleman) Por ser el principal tester del mod y traducir los menús al portugués.
- [Guy](https://github.com/ineedbots) Por hacer el script para la reaparición de los zombis.
- [5and5](https://github.com/5and5) Por hacer el Strat Tester original y ayudarme hace 5 años cuando empecé a moddear Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) Por hacer el script que abre las puertas en modo afterlife.
- MJ Por ayudar con el menu de las perks.
