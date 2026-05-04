# Strat Tester for Black Ops II

[**Ler em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README%20PT-BR.md)
[**Ler en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README%20GL.md)
[**Leer en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/blob/main/README%20ES.md)

## Downloads:

- [**Descargar en español**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Espanol.rar)
- [**Donwload in english**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)
- [**Descargar en galego**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.Galego.rar)
- [**Baixar em português**](https://github.com/Fraaagaaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.PT-BR.rar), traduzido por [NoMoleMan](https://www.twitch.tv/nomoleman)

## How to install

- Unzip the download in `%localappdata%\Plutonium\storage\t6\mods`.

## General changes
- Perks are given on spawn
- Weapons are given on spawn
- All doors are oppened (except the ones needed for a certain strat)
- Game starts at round 100
- Game, round and trap timers
- Healthbar
- Zombie counter
- Zone display
- Seconds per horde meter
- Box can be moved on most maps
- Power-Ups can be desabled
- Implemented notarget
- Fog can be desabled
- Zombie despawner tracker by [Guy](https://github.com/ineedbots)

## Changes by map
### Tranzit
- Added a third timer for the bus (use !bustimer)
- Added a display for the bus location (use !busloc)
- Players will get a notification when a denizen spawns
- Can choose the depart time for farm

### Town
- 2 game setups
- Jug opened
- Speed cola opened

### Nuketown
- All perks fall from the sky at the start of the game
- Can automatically restart for pap on green house with `!perkrng`

### Die Rise
- Spawned trample steam buildable
- Elevator kills tracker with `!elevator`

### MOTD
- Spawned shield buildable at cafeteria
- Infinite afterlives, can be switched off with !lives
- All pieces are collected at the start of the game

### Buried
- Two buildable setups:
    - Resonator at jug, Turbine at church and Springpad at saloon (default)
    - Resonator at saloon, Turbine at church and Springpad at jug
- Subwoofer kill counter

### Origins
- White player starts with shovel and golden helmet
- Players are able to call tank from gen 2 for the first time
- Spawned shield buildable at church
- Awarded max ammo reward for each player
- Staffs are placed in the crazy place
- All portals are oppened
- Trackers for zombies stopmpt and tumbled
- Tracker for tank kills

## Loadouts
You can choose the weapons provided by the mod at the start of the game.
In the `zm_strattester\scriptdata\loadouts` folder, you will find the files that the mod reads for each map. To ensure the format is valid, it must follow these rules:

1. First Line: Enter the code for the weapons you wish to receive (e.g., `ray_gun_zm`).
2. Second Line: Enter the weapon you want for the Mule Kick slot (Coz).
3. Third Line: Enter the equipment you wish to receive (everything that requires the D-pad when playing with a controller).
4. Fourth Line: Enter the melee weapon you wish to receive (e.g., `tazer_knuckles_zm`).
5. No line can be left blank: If you do not want a specific item, you must write `undefined`.

## Chat Commands

### General
- `!nuke`          spawns a nuke power up on top of the player
- `!x2`            spawns a double points power up on top of the player
- `!max`           spawns a max power up on top of the player
- `!insta`           spawns a insta kill power up on top of the player
- `!sale`          spawns a fire sale power up on top of the player
- `!blood`         spawns a zombie blood power up on top of the player
- `!perk`          spawns a random perk power up on top of the player
- `!tp`            teleports player to desired location
- `!tpc`           teleports player to desired coordinates

### Origins
- `!gen x`       activates generator number x

# Shout out to:
- [NoMoleMan](https://www.twitch.tv/nomoleman) for beeing the main tester and translating the menus into portuguese.
- [Guy](https://github.com/ineedbots) for making the despawner test script.
- [5and5](https://github.com/5and5) for making the original strat tester and helping me 5 years ago when I started modding Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) for making the script to power on afterlife doors.
- MJ for helping me with the perk selection menu.
