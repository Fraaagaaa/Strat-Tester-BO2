# Strat Tester for Black Ops II

- [**Ler en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20GL.md)
- [**Leer en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20ES.md)
- [**Ler em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/docs/readmes/README%20PT-BR.md)

## Downloads:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Download in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

## How to install

- Unzip the download in `%localappdata%\Plutonium\storage\t6\mods`.

> [!WARNING]
> All users need to have the mod installed. Players who do not have the mod installed will be unable to use the in-game menu and, therefore, will be unable to change their perks or HUD.


> [!WARNING]
> The PT version stands for portuguesse, not plutonium.

# Features
## Game settings
- Change round slider
- Kill horde button
- End round button
- Developer mode (check master spawners and spawn locations)
- Implemented Notarget
- Enable/Disable power-ups
- Enable/Disable fog
- Teleports

## Perks settings
Perks can not be obtain via perk machines, they have to be selected inside the strat tester menu.
## HUD settings
- Game timer
- Round timer
- Healthbar
- Zombie counter
- SPH meter
- Zone display
- Despawners counter by [Guy](https://github.com/ineedbots)
- Zombies in sight counter
- Zombies too far away counter
- Anchor leaks counter
### Tranzit
- Bus timer
- Bus location
- Denizen counter
### Die Rise
- Elevator kills counter
- Sliquifire timer
### Mob of the Dead
- Trap timer
### Buried
- Subwoofer kills per shot counter
### Origins
- Ice and Wind staff timer
- Tank kills counter
- Tumble animation counter
- Stomp counter
### survival maps
- Box hits (survival maps)
## Map specific settings
### Tranzit
- Adjust farm and diner bus depart time
- Disable denizens
- Show denizen spawners
- Turn on/off the bus
- Build the bus at the start
- Build all of the buildables
### Town
- Change door setup
### Die Rise
- Lock elevators
### Mob of the Dead
- Infinite lives
- Build the shield at cafeteria (only shows the trigger, not the model)
### Buried
- Change buildable setup
- Delete Leroy's barricades
### Origins
- On solo, chose the staff
- Stop the walls from moving in the crazy place
- Build the shield at church (only shows the trigger, not the model)
- Spawn with War Machine instead of MP40
- Unlock all generators
## Start settings
- Start round
- Start delay
- Remove all boards from windows
- Turn on power
- Open all doors
- Give weapons

# Loadouts
You can choose the weapons provided by the mod at the start of the game.
In the `zm_strattester\scriptdata\loadouts` folder, you will find the files that the mod reads for each map. To ensure the format is valid, it must follow these rules:

1. First Line: Enter the code for the weapons you wish to receive (e.g., `ray_gun_zm`).
2. Second Line: Enter the weapon you want for the Mule Kick slot (Coz).
3. Third Line: Enter the equipment you wish to receive (everything that requires the D-pad when playing with a controller).
4. Fourth Line: Enter the melee weapon you wish to receive (e.g., `tazer_knuckles_zm`).
5. No line can be left blank: If you do not want a specific item, you must write `undefined`.

# Chat Commands
- `!nuke`          spawns a nuke power up on top of the player.
- `!x2`            spawns a double points power up on top of the player.
- `!max`           spawns a max power up on top of the player.
- `!insta`         spawns a insta kill power up on top of the player.
- `!sale`          spawns a fire sale power up on top of the player.
- `!blood`         spawns a zombie blood power up on top of the player.
- `!perk`          spawns a random perk power up on top of the player.
- `!tp`            teleports player to desired location.
- `!tpc`           teleports player to desired coordinates.
- `!points`        sets the player's score, can be used with `inf` to get infinite points.
- `!remaing`       sets the remaining zombies on the round.
- `!gen x`         activates generator number x on origins.

# For developers
This mods sets `level.strat_tester` to true in `init()`.
To avoid the "Unknown command" message from strat tester, add your commands in `level.chatcommands` or `level.chatcommandsaliases`, for example, use the following code:
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

# Shout out to:
- [NoMoleMan](https://www.twitch.tv/nomoleman) for beeing the main tester and translating the menus into portuguese.
- [Guy](https://github.com/ineedbots) for making the despawner test script.
- [5and5](https://github.com/5and5) for making the original strat tester and helping me 5 years ago when I started modding Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) for making the script to power on afterlife doors.
- [MJ](https://github.com/mjmodz) for helping me with the perk selection menu.
- [Astrox](https://www.twitch.tv/lastroxl) for the No Power setups.
