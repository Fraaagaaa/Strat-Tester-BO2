#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_ai_sloth;

#include scripts\zm\strattester\buildables;
#include scripts\zm\strattester\buried;

main()
{
    replacefunctions();

	flag_wait("initial_blackscreen_passed");
	setDvar("magic_chest_movable", 0); // Make sure this is set to 1 if the player changes maps
	level thread displaysubwooferkills();
    if(getDvarInt("st_setupBuried") == -1)
		return;
		
	if(getDvarInt("st_setupBuried") == 0)
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer"); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_springpad_zm", "^3Press &&1 for ^5Springpad"); // saloon
	    level thread spawn_buildable_trigger((-135, 946, 19), "equip_turbine_zm", "^3Press &&1 for ^5Turbine"); // church
	}
	if(getDvarInt("st_setupBuried") == 1)
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_springpad_zm", "^3Press &&1 for ^5Springpad"); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer"); // saloon
	    level thread spawn_buildable_trigger((-135, 946, 19), "equip_turbine_zm", "^3Press &&1 for ^5Turbine"); // church
	}

	if(getDvarInt("st_deleteBarricades"))
		deletebarricades();
}