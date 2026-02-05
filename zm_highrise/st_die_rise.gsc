#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\buildables;

init()
{
	replacefunc(maps\mp\zm_highrise_elevators::watch_for_elevator_during_faller_spawn, ::watch_for_elevator_during_faller_spawn);
	level thread spawn_buildable_trigger((1879, 1354, 3034), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 0);
	level.zombies_died_to_elevator = 0;
	level thread displayElevatorKills();
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}

watch_for_elevator_during_faller_spawn()
{
    self endon( "death" );
    self endon( "risen" );
    self endon( "spawn_anim" );

    while ( true )
    {
        should_gib = 0;

        foreach ( elevator in level.elevators )
        {
            if ( self istouching( elevator.body ) )
                should_gib = 1;
        }

        if ( should_gib )
        {
            playfx( level._effect["zomb_gib"], self.origin );

            if ( !( isdefined( self.has_been_damaged_by_player ) && self.has_been_damaged_by_player ) && !( isdefined( self.is_leaper ) && self.is_leaper ) )
                level.zombie_total++;

            if ( isdefined( self.is_leaper ) && self.is_leaper )
            {
                self maps\mp\zombies\_zm_ai_leaper::leaper_cleanup();
                self dodamage( self.health + 100, self.origin );
            }
            else
            {
				strattesterprint("Zombie died to elevator");
				level.zombies_died_to_elevator++;
                self delete();
            }

            break;
        }

        wait 0.1;
    }
}


displayElevatorKills()
{
	level thread displayWatcher();
	level.elevatorkills.hidewheninmenu = true;
    level.elevatorkills = createserverfontstring( "objective", 1.3 );
    level.elevatorkills.y = 0;
    level.elevatorkills.x = 0;
    level.elevatorkills.fontscale = 1.4;
    level.elevatorkills.alignx = "center";
    level.elevatorkills.horzalign = "user_center";
    level.elevatorkills.vertalign = "user_top";
    level.elevatorkills.aligny = "top";
    level.elevatorkills.label = &"^3Elevator Kills: ^5";
    level.total_chest_accessed_mk2 = 0;
    level.total_chest_accessed_ray = 0;
    level.elevatorkills.alignx = "left";
    level.elevatorkills.horzalign = "user_left";
    level.elevatorkills.x = 2;
    level.elevatorkills.alpha = 1;
    level.elevatorkills setvalue(0);

    while(true)
    {
    	level.elevatorkills setvalue(level.zombies_died_to_elevator);
        wait 0.1;
    }
}

displayWatcher()
{
    while(true)
    {
        wait 0.1;
        level.elevatorkills.alpha = getDvarInt("elevatorkills");
    }
}