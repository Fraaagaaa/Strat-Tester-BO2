# Strat Tester for Black Ops II

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

## Chat Commands

### General
- `!despawners`    toggles despawners tracker
- `!boards`        toggles opening window's boards
- `!delay`         changes delat at the start of the round
- `!doors`         toggles oppening all necesary doors
- `!drops`         enables drops
- `!endround`      ends current round
- `!changeround`   changes the round
- `!fog`           toggles fog
- `!healthbar`     toggles healthbar
- `!killhorde`     kills current horde
- `!notarget`      zombies will ignore player
- `!perks`         toggles spawning with perks / reviving with perks
- `!power`         toggles between power and no power
- `!remaining`     toggles zombie counter
- `!round`         changes initial round
- `!sph`           toggles seconds per horde display
- `!timer`         changes timer position or hides it
- `!tp`            teleports player to desired location
- `!tpc`           teleports player to desired coordinates
- `!weapons`       toggles spawning with weapons
- `!zone`          toggles zone name

### Tranzit
- `!denizen`     toggles denizens spawns
- `!buson / !busoff` stops/starts the bus
- `!perma`       awards perman perks to player
- `!depart`      changes bus depart time on farm
- `!busloc`      displays the bus location
- `!bustimer`    displays a bus timer

### Town
- `!jug`         changes game set up in town

### Die Rise
- `!elevator`    displays the ammount of zombies killed by elevators    

### Mob
- `!traptimer`   toggles traptimer on mob
- `!shield`      toggles starting with shield equipped and built
- `!lives`       toggles infinite afterlives

### Buried
- `!buried`      toggles buildable setup on buried
- `!sub`         toggles subwofer kills per shot

### Origins
- `!cherry`      toggles getting cherry in origins
- `!gen x`       activates generator number x
- `!shield`      toggles starting with shield equipped and built
- `!stomp`       toggles stomp counter on origins
- `!staff`       toggles ice/wind staff on solo
- `!tank`        toggles tank kill counter on origins
- `!templars`    starts a templar round if more than 3 generator are on
- `!tumble`      toggles tumble counter on origins
- `!wm`          toggles getting war machine on origins
- `!unlockgens`  unlocks all generators

# Shout out to:
- [NoMoleMan](https://www.twitch.tv/nomoleman) for beeing the main tester and translating the menus into portuguese.
- [Guy](https://github.com/ineedbots) for making the despawner test script.
- [5and5](https://github.com/5and5) for making the original strat tester and helping me 5 years ago when I started modding Black Ops.
- [Hadi77KSA](https://github.com/Hadi77KSA) for making the script to power on afterlife doors.
