# 2.8 - Buildable refactor
Features added:
- Buildables in Buried can now be toggled inside the menu.
- Buildables models now appear in the benches.
- Removed base game triggers for adding pieces since they sometimes overlapped with the new ones and prevented players from picking up buildables.
- Display the overheat % of Jetgun and Paralyzer, idea by [Santos](https://www.twitch.tv/santoilsignore_), implementation from [BO2 Reimagined](https://github.com/Jbleezy/BO2-Reimagined/commit/6337a23ad93c10d6b7dfd384863d1f3ce0916491)

Fixes:
- Fixed Leroy not spawning after a `fast_restart` inside the initial spawn delay.
- Leroy will no longer spawn dead.

Changes:
- Leroy will now start walking without the player giving him the initial booze.

# 2.7.1
- Uncap rounds
- Fix elevators not activiating by power
- Fix changing round not working in round transitions
# 2.7
Features added:
- Wind and Ice Staff timer
- Sliquifire timer
- Zombies in sight counter
- Zombies too far from the player
- Lock elevators on die rise
- Diner depart time picker

Fixes:
- Staff clip ammo is now filled with max ammos
- Minijug perman perk will be awarded by `!perma` after round 15
- Bus timer
- `!remaining` now resets the SPH meter.

Changes:
- All timers will stack under the others
- The despawner option will not show on survival maps as they dont have distance tracking
- In Origins, the air strike special grenade will be given instead of monkeys
- The new `Developer` will display the spawner locations, master spawner and the distance rings related to the master spawner, the `Despawners` option will only add the HUD stats

# 2.6.1
Fixes:
- HUD counters not updating

Features:
- Despawners timer

Changes
- the `developer` dvar is no longer changed when switching the despawner settings

# 2.6
Features added:
- !remaining command to set the zombies left in the round
- Boxhits and raygun average display toggle
- Origins mooving walls toggle
- Players can have independant HUD from the host
- Players now also get claymores and galvaknuckles on nuketown

Fixes:
- Strat Tester welcome is only printed once
- Zone location overlapping between players
- Trade average
- Perk menu on depot
- HUD desapears when in pause menu
- Shield hint string

# 2.5.1
- Fixed not getting the mulekick weapon back
- Force the revive trigger radious to be the default one