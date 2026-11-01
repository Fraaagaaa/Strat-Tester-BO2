# Strat Tester para Black Ops II

- [**Read in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README.md)
- [**Leer en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20ES.md)
- [**Ler em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20PT-BR.md)

Este mod está deseñado para utilizarse xunto con [Plutonium](https://plutonium.pw/) e non ofrece soporte fóra deste cliente. Se tes problemas para cargar o mod, proba a actualizar Plutonium executando o `plutonium.exe`, que podes descargar desde a súa páxina web oficial.

## [Historial de cambios](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/CHANGELOG.md)

## Descargas:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Download in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traducido por [NoMoleMan](https://www.twitch.tv/nomoleman)

> [!WARNING]
> Para usar a versión en xaponés o xogo ten que estar en xaponés.

> [!WARNING]
> Para usar a versión en español, galego ou portugués o xogo non pode estar en xaponés ou polaco.
## Como instalar

- Descomprime a descarga en `%localappdata%\Plutonium\storage\t6\mods`.

> [!CAUTION]
> Todos os xogadores precisan ter o mod instalado. Os xogadores que non teñan o mod instalado non poderán usar o menu do xogo e, polo tanto, non poderán cambiar as suas perks ou o HUD.

> [!WARNING]
> A versión PT fai referencia á portuguesa, non a Plutonium

# Funcionalidades

> [!TIP]
> Todos os axustes podense configurar dende o menú de pausa

> [!WARNING]
> Os xogadores que non teñan o mod non verán o menú

> [!TIP]
> Os elementos da interfaz non dependen do host, cada xogador pode tener unha interfaz distinta

## Axustes de partida
- Deslizador para cambiar de ronda
- Botón para matar a horda actual
- Botón para rematar a ronda actual
- Modo desarrollo (para ver as zonas de aparición de zombis)
- Notarget implementado (similar ao de Black Ops)
- Activar/Descativar os Power-Ups
- Activar/Descativar á néboa
- Teletransportes

## Axustes de vantaxes
As vantaxes non poden ser obtidas de forma tradicional, teñen que seleccionarse dende o menú de Strat Tester.

## Axustes de interfaz
- Temporizador de partida
- Temporizador de ronda
- Barra de vida
- Contador de zombis
- Medidor de segundos por horda
- Visualizador de zona
- Contador de reapariciones de zombi, creado por [Guy](https://github.com/ineedbots)
- Contador de zombis á vista
- Contador de zombis demasiado lonxe
- Contador de fugas de anclaxe
### Tranzit
- Temporizador del bus
- Localización del bus
- Contador de denizens
### Die Rise
- Contador de zombis mortos por ascensores
- Temporizador de Sliquifire
### Mob of the Dead
- Temporizador de trampa
### Buried
- Contador de mortes por disparo de resonador
### Origins
- Temporizador de los bastones de xeo e vento
- Contador de mortes polo tanque
- Contador de zombis apisotonados
- Contador de zombis tambaleados
### Mapas de supervivencia
- Contador de tiradas de caixa
## Axustes por mapa
### Tranzit
- Escoller o tempo que para o bus na granxa.
- Activar/Desactivar denizens
- Mostrar os spawners dos denizens
- Activar/Descactivar o bus
- Construir todo o bus automáticamente
- Construit todos os construibles automáticamente
### Town
- 2 formas de iniciar a partida
    - Porta de titán abierta e de prestidigitación cerrada
    - Porta de prestidigitación abierta e de titán cerrada
### Die Rise
- Pódense bloquear os ascensores
- O trampolín está creado dende o principio

### Mob of the Dead
- Escudo construido na cafeteria
- Vidas de afterlife infinitas

### Buried
- A caixa está bloqueada
- Pódense destruir as barricadas de Leroy ao principio da partida

### Origins
- En individual, pódese escoller o bastón
- O xogador branco comeza con pá e casco dourado
- Desactivar as paredes máxicas de agartha
- Escudo construido na igrexa e no portal de vento
- Todos os xogadores reciben a recompensa de activar os 6 xeradores
- Todos os bastóns están construidos en agartha
- Todos os portales están abertos
- Escoller empezar cunha MP40 ou unha máquina de guerra
- Desbloquear todos os xeradores

## Axustes de inicio
- Ronda inicial
- Retardo inicial
- Quitar todas as barreiras das ventás
- Activar a luz
- Abrir todas as portas
- Dar armas, [mirar arsenais](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20GL.md#arsenais)

# Arsenais
Pódese escoller as armas que dará o mod ao empezar.
En `zm_strattester\scriptdata\loadouts` tes os arquivos que le o mod en cada mapa, para que sexa un formato válido ten que seguir estas regras:
1. Na primeira liña debes poñer o código das armas que queiras recibir, e.g. `ray_gun_zm`.
2. Na segunda liña debes poñer o arma que queiras no slot de Coz (Mule Kick).
3. Na terceira liña debes poñer o equipamento que queiras recibir (todo o que xogando con mando require usar as frechas).
4. Na cuarta liña debes poñer o arma corpo a corpo que queiras recibir e.g. `tazer_knuckles_zm`
5. Ningunha liña pode estar en branco, se non se quere calquera cousa tense que escribir `undefined`

## Comandos do chat

### Xeral
- `!nuke`         xera un power-up da bomba enriba do xogador.
- `!x2`           xera un power-up de dobre puntuación enriba do xogador. 
- `!max`          xera un power-up de munición máxima enriba do xogador.
- `!insta`        xera un power-up de baixa instantánea enriba do xogador.
- `!sale`         xera un power-up de rebaixas enriba do xogador 
- `!blood`        xera un power-up de sangue zombie enriba do xogador.
- `!perk`         xera un power-up de perk aleatoria enriba do xogador.
- `!tp`           teletransporta ao xogador ao lugar desexado
- `!tpc`          teletransporta ao xogador ás coordenadas desexadas.
- `!points`       cambia a puntuación do xogador, pode ser usada con `inf` para obter puntuación infinita.
- `!remaining`      cambia os zombis restantes da ronda.
- `!gen x`        activa ou desactiva o xerador número x

# Para desarrolladores
Este mod pon `level.strat_tester` a true en `init()`, aunque unha mellor forma de comprobar se estase utilizando o mod, é comprobando a dvar `fs_game`.

Para que non saia a mensaxe "Comando desconocido" de Strat Tester, añada os seus comandos en `level.chatcommands` ou `level.chatcommandsaliases`, pode usar o siguiente código como referencia:
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

# Compilar desde o código fonte

Dependencias:
- [Open Asset Tools](https://openassettools.dev/)
- [WinRAR](https://www.rarlab.com/download.htm)

Requisitos previos:
- Ter OAT instalado en `C:\OAT`.
- Ter `WinRAR.exe` instalado en `C:\Program Files\WinRAR\WinRAR.exe`.
- Ter Plutonium instalado en `%LOCALAPPDATA%`.
- **ALTERNATIVAMENTE**, podes modificar [estas liñas do builder.bat](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/builder.bat#L3-L5).

Compilación:
1. Crea o directorio `english\localizedstrings`.
2. Desde `localized\language`, copia os ficheiros do idioma que prefiras a `english\localizedstrings`.
3. Engade o ficheiro `localized\st_watermark.str` ao directorio `english\localizedstrings`.
4. Executa `builder.bat`.

# Un saúdo especial a:
- [NoMoleMan](https://www.twitch.tv/nomoleman) Por ser o principal tester do mod e traducir os menús ao portugués.
- [Guy](https://github.com/ineedbots) Por facer o script para a reaparición dos zombies.
- [5and5](https://github.com/5and5) Por facer o Strat Tester orixinal e axudarme hai 5 anos cando empecei a moddear Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) Por facer o script que abre as portas en modo afterlife.
- [MJ](https://github.com/mjmodz) Por axudar co menú das perks.
- [Astrox](https://www.twitch.tv/lastroxl) Por explicarme os setups en no power.
- [AzRy](https://www.twitch.tv/azry_s) Por traducir o mod ao xaponés:
- [Jbleezy](https://github.com/Jbleezy) Por crear o código para mostrar o sobrequencemento da Jetgun e a paralizadora no seu mod [BO2 Reimagined](https://github.com/Jbleezy/BO2-Reimagined).