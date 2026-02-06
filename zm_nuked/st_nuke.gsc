#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\box;

main()
{
	replacefunc(maps\mp\zm_nuked_perks::perks_from_the_sky, ::perks_from_the_sky);
    level.total_chest_accessed = 0;
    level thread checkpaplocation();
    level thread boxhits();
	level thread raygun_counter();
    // level thread bring_perks();
}

checkpaplocation()
{
	if(!getDvarInt("perkrng"))
	{
		wait 1;
		if(level.players.size > 1)
		wait 4;
		pap = getent( "specialty_weapupgrade", "script_noteworthy" );
		jug = getent( "vending_jugg", "targetname" );
		if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
			level.players[0] notify ("menuresponse", "", "restart_level_zm");
	}
}

perks_from_the_sky()
{
    level thread turn_perks_on();
    top_height = 300;
    machines = [];
    machine_triggers = [];
    machines[0] = getent( "vending_revive", "targetname" );

    if ( !isdefined( machines[0] ) )
        return;

    machine_triggers[0] = getent( "vending_revive", "target" );
    move_perk( machines[0], top_height, 5.0, 0.001 );
    machine_triggers[0] trigger_off();
    machines[1] = getent( "vending_doubletap", "targetname" );
    machine_triggers[1] = getent( "vending_doubletap", "target" );
    move_perk( machines[1], top_height, 5.0, 0.001 );
    machine_triggers[1] trigger_off();
    machines[2] = getent( "vending_sleight", "targetname" );
    machine_triggers[2] = getent( "vending_sleight", "target" );
    move_perk( machines[2], top_height, 5.0, 0.001 );
    machine_triggers[2] trigger_off();
    machines[3] = getent( "vending_jugg", "targetname" );
    machine_triggers[3] = getent( "vending_jugg", "target" );
    move_perk( machines[3], top_height, 5.0, 0.001 );
    machine_triggers[3] trigger_off();
    machine_triggers[4] = getent( "specialty_weapupgrade", "script_noteworthy" );
    machines[4] = getent( machine_triggers[4].target, "targetname" );
    move_perk( machines[4], top_height, 5.0, 0.001 );
    machine_triggers[4] trigger_off();
    flag_wait( "initial_blackscreen_passed" );
    // wait( randomfloatrange( 5.0, 15.0 ) );
    players = get_players();

    bring_perks();
}

bring_perks()
{
    machines = [];
    machine_triggers = [];
    machines[0] = getent( "vending_revive", "targetname" );
    machine_triggers[0] = getent( "vending_revive", "target" );
    machines[1] = getent( "vending_doubletap", "targetname" );
    machine_triggers[1] = getent( "vending_doubletap", "target" );
    machines[2] = getent( "vending_sleight", "targetname" );
    machine_triggers[2] = getent( "vending_sleight", "target" );
    machines[3] = getent( "vending_jugg", "targetname" );
    machine_triggers[3] = getent( "vending_jugg", "target" );
    machine_triggers[4] = getent( "specialty_weapupgrade", "script_noteworthy" );
    machines[4] = getent( machine_triggers[4].target, "targetname" );

	for(i = 0; i < machines.size; i++)
		bring_perk(machines[i], machine_triggers[i]);
}