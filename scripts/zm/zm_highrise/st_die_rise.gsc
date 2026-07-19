#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zm_highrise_buildables;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\buildables;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\utility;

init()
{
	replacefunc(getfunction("maps/mp/zm_highrise_elevators", "watch_for_elevator_during_faller_spawn"), ::watch_for_elevator_during_faller_spawn);
	level.zombies_died_to_elevator = 0;
	level thread displayElevatorKills();
	level thread check_special_round();
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
                if(getDvarInt("st_elevatorkills"))
				    strattesterprint("Zombie died to elevator", "Un zombi ha muerto por el ascensor");
				level.zombies_died_to_elevator++;
                self delete();
            }

            break;
        }

        wait 0.1;
    }
}


check_special_round()
{
    level endon("end_game");

    while(!isdefined(level.next_leaper_round))
        wait 0.1;

    while(true)
    {
        if(level.next_leaper_round < level.round_number)
            level.next_leaper_round = level.round_number + randomintrange( 4, 6 );
        if(level.next_leaper_round > (level.round_number + 6))
            level.next_leaper_round = level.round_number + randomintrange( 4, 6 );
        wait 1;
    }
}