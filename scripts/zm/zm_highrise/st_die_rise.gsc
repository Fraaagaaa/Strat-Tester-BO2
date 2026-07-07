#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_highrise_buildables;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\buildables;

init_dierise()
{
	replacefunc(getfunction("maps/mp/zm_highrise_elevators", "watch_for_elevator_during_faller_spawn"), ::watch_for_elevator_during_faller_spawn);
    replaceFunc(getfunction("maps/mp/zm_highrise_buildables", "springpadbuildable"), ::springpadbuildable);
	level thread spawn_buildable_trigger((1879, 1354, 3034), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 0);
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
                self [[getfunction("maps/mp/zombies/_zm_ai_leaper", "leaper_cleanup")]]();
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
    level.elevatorkills.label = &"ST_ELEVATOR_KILLS_HUD";
    level.elevatorkills.alignx = "left";
    level.elevatorkills.horzalign = "user_left";
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
        level.elevatorkills.alpha = getDvarInt("st_elevatorkills");
        level.elevatorkills.y = 15 * getDvarInt("st_despawners");
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