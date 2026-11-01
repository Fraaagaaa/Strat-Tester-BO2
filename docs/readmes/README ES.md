# Strat Tester para Black Ops II

- [**Read in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README.md)
- [**Ler en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20GL.md)
- [**Ler em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20PT-BR.md)

## [Historial de cambios](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/CHANGELOG.md)

## Descargas:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Download in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**日本語をダウンロード**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Japanese.rar), 翻訳は[AzRy](https://www.twitch.tv/azry_s)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

> [!WARNING]
> Para usar la versión en japonés tu juego debe estar en japonés.

> [!WARNING]
> Para usar la versión en español, gallego o portugués tu juego no puede estar ni en japonés ni en polaco.

## Como instalar

- Descomprime la descarga en `%localappdata%\Plutonium\storage\t6\mods`.

> [!CAUTION]
> Todos los jugadores beden tener el mod instalado. Los jugadores que no tengan el mod instalado no podrán usar el menu del juego y, por lo tanto, no podrán cambiar sus perks o HUD.


> [!WARNING]
> La versión PT referencia la portuguesa, no Plutonium

# Funcionalidades

> [!TIP]
> Todos los ajustes se pueden configurar desde el menú de pausa

> [!WARNING]
> Los jugadores que no tengan el mod no podrán ver el menú

> [!TIP]
> Los elementos de la interfaz no dependen del host, cada jugador puede tener una interfaz distinta

## Ajustes de partida
- Deslizador para cambiar de ronda
- Botón para matar la horda actual
- Botón para terminar la ronda actual
- Modo desarrollo (para ver las zonas de aparición de zombis)
- Notarget implementado (similar al de Black Ops)
- Activar/Descativar los Power-Ups
- Activar/Descativar la niebla
- Teletransportes

## Ajustes de ventajas
Las ventajas no pueden ser obtenidas de forma tradicional, se tienen que selecccionar desde el menú de Strat Tester.

## Ajustes de interfaz
- Temporizador de partida
- Temporizador de ronda
- Barra de vida
- Contador de zombis
- Medidor de segundos por horda
- Visualizador de zona
- Contador de reapariciones de zombi, creado por [Guy](https://github.com/ineedbots)
- Contador de zombis a la vista
- Contador de zombis demasiado lejos
- Contador de fugas de anclaje
### Tranzit
- Temporizador del bus
- Localización del bus
- Contador de denizens
### Die Rise
- Contador de zombis muertos por ascensores
- Temporizador de Sliquifire
### Mob of the Dead
- Temporizador de trampa
### Buried
- Contador de muertes por disparo de resonador
### Origins
- Temporizador de los bastones de hielo y viento
- Contador de muertes por el tanque
- Contador de zombis apisotonados
- Contador de zombis tambaleados
### Mapas de supervivencia
- Contador de tiradas de caja
## Ajustes por mapa
### Tranzit
- Escoger el tiempo que para el bus en granja.
- Activar/Desactivar denizens
- Mostrar los spawners de los denizens
- Activar/Descactivar el bus
- Construir todo el bus automáticamente
- Construit todos los construibles automáticamente
### Town
- 2 formas de iniciar la partida
    - Puerta de titán abierta y de prestidigitación cerrada
    - Puerta de prestidigitación abierta y de titán cerrada
### Die Rise
- Se pueden bloquear los ascensores
- El trampolín está creado desde el principio

### Mob of the Dead
- Escudo construido en la cafeteria
- Vidas de afterlife infinitas

### Buried
- La caja está bloqueada
- Se pueden destruir las barricadas de Leroy al principio de la partida

### Origins
- En individual, se puede escoger el bastón
- El jugador blanco empieza con pala y casco dorado
- Desactivar las paredes mágicas de agartha
- Escudo construido en la iglesia y en el portal de viento
- Todos los jugadores reciben la recompensa de activar los 6 generadores
- Todos los bastones están construidos en agartha
- Todos los portales están abiertos
- Escoger empezar con una MP40 o una máquina de guerra
- Desbloquear todos los generadores

## Ajustes de inicio
- Ronda inicial
- Retardo inicial
- Quitar todas las barreras de las ventanas
- Activar la luz
- Abrir todas las puertas
- Dar armas, [mirar arsenales](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20ES.md#arsenales)

# Arsenales
Se puede escoger las armas que dará el mod al empezar.
En `zm_strattester\scriptdata\loadouts` tienes los archivos que lee el mod en cada mapa, para que sea un formato válido tiene que seguir estas reglas:
1. En la primera línea debes poner el código de las armas que quieras recibir, e.g. `ray_gun_zm`.
2. En la segunda línea debes poner el arma que quieras en el slot de Coz.
3. En la tercera línea debes poner el equipamiento que quieras recibir (todo lo que jugando con mando requiere usar las flechas).
4. En la cuarta línea debes poner el arma cuerpo a cuerpo que quieras recibir e.g. `tazer_knuckles_zm`
5. Ninguna linea puede estar en blanco, si no se quiere cualquier cosa se ha de escribir `undefined`

# Comandos del chat

- `!nuke`          genera un power-up de la bomba encima del jugador.
- `!x2`            genera un power-up de doble puntuacón encima del jugador.
- `!max`           genera un power-up de munición máxima encima del jugador.
- `!insta`         genera un power-up de baja instantánea encima del jugador.
- `!sale`          genera un power-up de rebajas encima del jugador.
- `!blood`         genera un power-up de sangre zombi encima del jugador
- `!perk`          genera un power-up de perk aleatório encima del jugador.
- `!tp`            teletransporta al jugador en el lugar deseado.
- `!tpc`           teletransporta al jugador en las coordenadas deseadas.
- `!points`        cambia la puntuación del jugador, puede ser usada con `inf` para obtener puntuación infinita.
- `!remaining`      cambia los zombis restantes de la ronda.
- `!gen x`       activa o desactiva el generador número x en origins.

# Para desarrolladores
Este mod pone `level.strat_tester` a true en `init()`, aunque una mejor forma de comprobar si se está usando el mod, es comprobando la dvar `fs_game`.

Para que no salga el mensaje "Comando desconocido" de Strat Tester, añada sus comandos en `level.chatcommands` o `level.chatcommandsaliases`, puede usar el siguiente código como referencia:
``` cpp
addCommands(commands, alias)
{
    if(!isdefined(alias))
        alias = false;

    if(!alias)
    {
	    foreach(command in commands)
		    level.chatcommands[level.chatcommands.size] = "!" + command;
    }
    else
    {
	    foreach(command in commands)
		    level.chatcommandsaliases[level.chatcommandsaliases.size] = "!" + command;
    }
}

f()
{
    if(!isdefined(level.chatcommands))
	    level.chatcommands = [];
    if(!isdefined(level.chatcommandsaliases))
	    level.chatcommandsaliases = [];

    addCommands(array("zc", "tzc"), true);
    addCommands(array("zombiecount", "totalzombiecount"), false);
}
```

# Un especial saludo a:
- [NoMoleMan](https://www.twitch.tv/nomoleman) Por ser el principal tester del mod y traducir los menús al portugués.
- [Guy](https://github.com/ineedbots) Por hacer el script para la reaparición de los zombis.
- [5and5](https://github.com/5and5) Por hacer el Strat Tester original y ayudarme hace 5 años cuando empecé a moddear Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) Por hacer el script que abre las puertas en modo afterlife.
- [MJ](https://github.com/mjmodz) Por ayudar con el menu de las perks.
- [Astrox](https://www.twitch.tv/lastroxl) Por explicarme los setups en no power.
- [AzRy](https://www.twitch.tv/azry_s) Por traducir el mod al japonés:
- [Jbleezy](https://github.com/Jbleezy) Por crear el código para mostrar el sobrecalentamiento de la Jetgun y la paralizadora en su mod [BO2 Reimagined](https://github.com/Jbleezy/BO2-Reimagined).