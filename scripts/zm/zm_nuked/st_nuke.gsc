#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_nuked_perks;

#include scripts\zm\strattester\box;

init()
{
	replacefunc(getfunction("maps/mp/zm_nuked_perks", "perks_from_the_sky"), ::perks_from_the_sky);
    level.total_chest_accessed = 0;
    level thread checkpaplocation();
    level thread boxhits();
	level thread raygun_counter();
    level thread fast_restart_warning();
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
    // flag_wait( "initial_blackscreen_passed" );
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

checkpaplocation()
{
	wait 0.1;
	pap = getent( "specialty_weapupgrade", "script_noteworthy" );
	jug = getent( "vending_jugg", "targetname" );
	if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
		cmdexec("fast_restart");
}

fast_restart_warning()
{
    level.fast_restart_warning = createserverfontstring( "objective", 1.3 );
    level.fast_restart_warning.y = 100;
    level.fast_restart_warning.x = 2;
    level.fast_restart_warning.fontscale = 2;
    level.fast_restart_warning.alignx = "center";
    level.fast_restart_warning.horzalign = "user_center";
    level.fast_restart_warning.vertalign = "user_top";
    level.fast_restart_warning.aligny = "top";
    level.fast_restart_warning.alpha = 1;
	level.fast_restart_warning.hidewheninmenu = true;
    level.fast_restart_warning.label = &"ST_RESTART_WARNING_NUKETOWN";

	flag_wait("initial_blackscreen_passed");
    level.fast_restart_warning destroy();
}