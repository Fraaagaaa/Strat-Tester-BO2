#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


replacefunctions()
{
    replaceFunc(maps\mp\zm_buried_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
    replaceFunc(maps\mp\zm_buried_buildables::piece_maker_unitrigger, ::piece_maker_unitrigger);
}

delete_zombie_noone_looking( how_close, how_high )
{
    self endon( "death" );

    if ( self can_be_deleted_from_buried_special_zones() )
    {
        self.inview = 0;
        self.player_close = 0;
    }
    else
    {
        if ( !isdefined( how_close ) )
            how_close = 1000;

        if ( !isdefined( how_high ) )
            how_high = 500;

        if ( !( isdefined( self.has_legs ) && self.has_legs ) )
            how_close = how_close * 1.5;

        distance_squared_check = how_close * how_close;
        height_squared_check = how_high * how_high;
        too_far_dist = distance_squared_check * 3;

        if ( isdefined( level.zombie_tracking_too_far_dist ) )
            too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

        self.inview = 0;
        self.player_close = 0;
        players = get_players();

        foreach ( player in players )
        {
            if ( player.sessionstate == "spectator" )
                continue;

            if ( isdefined( player.laststand ) && player.laststand && ( isdefined( self.favoriteenemy ) && self.favoriteenemy == player ) )
            {
                if ( !self can_zombie_see_any_player() )
                {
                    self.favoriteenemy = undefined;
                    self.zombie_path_bad = 1;
                    self thread escaped_zombies_cleanup();
                }
            }

            if ( isdefined( level.only_track_targeted_players ) )
            {
                if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != player )
                    continue;
            }

            can_be_seen = self player_can_see_me( player );
            distance_squared = distancesquared( self.origin, player.origin );

            if ( can_be_seen && distance_squared < too_far_dist )
                self.inview++;

            if ( distance_squared < distance_squared_check && abs( self.origin[2] - player.origin[2] ) < how_high )
                self.player_close++;
        }
    }

    wait 0.1;

    if ( self.inview == 0 && self.player_close == 0 )
    {
        if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
            return;

        if ( isdefined( self.electrified ) && self.electrified == 1 )
            return;

        zombies = getaiarray( "axis" );

        if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;

                if ( self.health < level.zombie_health )
                    level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }

        self maps\mp\zombies\_zm_spawner::reset_attack_spot();
        self notify( "zombie_delete" );

        if ( isdefined( self.anchor ) )
            self.anchor delete();

        if(getDvarInt("despawners"))
        {
            strattesterprint("Zombie despawned");
            level.despawners++;
        }
        self delete();
        recalc_zombie_array();
    }
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}


piece_maker_unitrigger( name, prompt_fn, think_fn )
{
    return;
    // unitrigger_stub = spawnstruct();
    // unitrigger_stub.origin = self.origin;

    // if ( isdefined( self.script_angles ) )
    //     unitrigger_stub.angles = self.script_angles;
    // else if ( isdefined( self.angles ) )
    //     unitrigger_stub.angles = self.angles;
    // else
    //     unitrigger_stub.angles = ( 0, 0, 0 );

    // unitrigger_stub.script_angles = unitrigger_stub.angles;

    // if ( isdefined( self.script_length ) )
    //     unitrigger_stub.script_length = self.script_length;
    // else
    //     unitrigger_stub.script_length = 32;

    // if ( isdefined( self.script_width ) )
    //     unitrigger_stub.script_width = self.script_width;
    // else
    //     unitrigger_stub.script_width = 32;

    // if ( isdefined( self.script_height ) )
    //     unitrigger_stub.script_height = self.script_height;
    // else
    //     unitrigger_stub.script_height = 64;

    // if ( isdefined( self.radius ) )
    //     unitrigger_stub.radius = self.radius;
    // else
    //     unitrigger_stub.radius = 32;

    // if ( isdefined( self.script_unitrigger_type ) )
    //     unitrigger_stub.script_unitrigger_type = self.script_unitrigger_type;
    // else
    // {
    //     unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    //     unitrigger_stub.origin = unitrigger_stub.origin - anglestoright( unitrigger_stub.angles ) * ( unitrigger_stub.script_length / 2 );
    // }

    // unitrigger_stub.cursor_hint = "HINT_NOICON";
    // unitrigger_stub.targetname = name;
    // maps\mp\zombies\_zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, 1 );
    // unitrigger_stub.prompt_and_visibility_func = prompt_fn;
    // maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, think_fn );
    // return unitrigger_stub;
}