#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zm_highrise_buildables;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weap_slipgun;

#include scripts\zm\strattester\buildables;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\utility;

init()
{
	replacefunc(getfunction("maps/mp/zm_highrise_elevators", "watch_for_elevator_during_faller_spawn"), ::watch_for_elevator_during_faller_spawn);
	replacefunc(getfunction("maps/mp/zombies/_zm_weap_slipgun", "slip_bolt"), ::slip_bolt);
    replacefunc(getfunction("maps/mp/zombies/_zm_weap_slipgun", "pool_of_goo"), ::pool_of_goo);
	level.zombies_died_to_elevator = 0;
	level thread check_special_round();
    level thread lock_elevators();
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

slip_bolt( player, upgraded )
{
    startpos = player getweaponmuzzlepoint();
    self waittill( "explode", position );
    duration = 24;

    if ( upgraded )
        duration = 36;

    level notify("sliq_fired", duration);

    thread add_slippery_spot( position, duration, startpos );
}

lock_elevators()
{
    lock = getDvarInt("st_lockelevators");
    while(true)
    {

        if(lock == "1")
        {
            level.elevators_stop = 1;
        }
        else
        {
            level.elevators_stop = 0;

            if ( isdefined( level.elevators ) )
                foreach ( elevator in level.elevators )
                    if ( isdefined( elevator.body ) )
                        elevator.body notify( "forcego" );
        }
        level waittill("dvar_st_lockelevators_changed", lock);
    }
}

pool_of_goo( origin, duration, is_recursive )
{
    effect_life = 24;

    if ( !is_true(is_recursive) )
        level notify("sliq_fired", duration);

    if ( duration > effect_life )
    {
        pool_of_goo(origin, duration - effect_life, true);
        duration = effect_life;
    }

    if ( isdefined( level._effect["slipgun_splatter"] ) )
        playfx( level._effect["slipgun_splatter"], origin );

    wait( duration );
}
