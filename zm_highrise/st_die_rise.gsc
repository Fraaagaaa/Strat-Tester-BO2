#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\buildables;
#include scripts\zm\strattester\dierise;

init()
{
    replacefunctions();
	level thread spawn_buildable_trigger((1879, 1354, 3034), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 0);
	level.zombies_died_to_elevator = 0;
	level thread displayElevatorKills();
}
