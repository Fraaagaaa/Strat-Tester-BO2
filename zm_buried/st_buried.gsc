#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_ai_sloth;

#include scripts\zm\strattester\buildables;

init()
{
	level thread spawn_buildable_trigger((-135, 946, 19), "equip_turbine_zm", "^3Press &&1 for ^5Turbine"); // church
	if(getDvarInt("SetupBuried") == 1)
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer", 0); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 1); // saloon
	}
	else if(getDvarInt("SetupBuried") == 2)
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 0); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer", 1); // saloon
	}

    
	flag_wait("initial_blackscreen_passed");
	deleteSlothBarricade( "juggernaut_alley" );
}

main()
{
	wait 1;
	foreach(ent in getentarray())
	{
		if(ent.classname == "trigger_multiple" || ent.classname == "trigger_radious" || ent.classname == "trigger_radious_use" || ent.classname == "trigger_use")
		println(ent.classname + "\t" + ent.origin);
	}
}