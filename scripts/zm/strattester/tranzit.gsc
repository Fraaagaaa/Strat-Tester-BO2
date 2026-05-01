#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_bus;

#include scripts\zm\strattester\utility;

replacefunctions()
{
    replaceFunc(maps\mp\zm_transit_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
	replacefunc(maps\mp\zm_transit_bus::busschedule, ::print_busschedule);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_spawning_logic, ::screecher_spawning_logic);
}

screecher_spawning_logic()
{
    level endon( "intermission" );

    if ( level.intermission )
        return;

    if ( level.screecher_spawners.size < 1 )
        return;

    while ( true )
    {
        while ( !isdefined( level.zombie_screecher_locations ) || level.zombie_screecher_locations.size <= 0 )
            wait 0.1;

        while ( level.zombie_screecher_count >= level.zombie_ai_limit_screecher )
            wait 0.1;

        while ( getdvarint( #"scr_screecher_ignore_player" ) )
            wait 0.1;

        if (!flag("spawn_zombies"))
            flag_wait( "spawn_zombies" );

        valid_players_in_screecher_zone = 0;
        valid_players = [];

        while ( valid_players_in_screecher_zone <= 0 )
        {
            players = getplayers();
            valid_players_in_screecher_zone = 0;

            foreach (player in level.players)
            {
                if ( is_player_valid( player ) && player_in_screecher_zone( player ) && !isdefined( player.screecher ) )
                {
                    valid_players_in_screecher_zone++;
                    valid_players[valid_players.size] = player;
                }
            }

            if ( players.size == 1 )
            {
                if ( is_player_valid( players[0] ) && !player_in_screecher_zone( players[0] ) )
                    level.spawn_delay = 1;
            }

            wait 0.1;
        }

        if ( !isdefined( level.zombie_screecher_locations ) || level.zombie_screecher_locations.size <= 0 )
            continue;

        valid_players = array_randomize( valid_players );
        player_left_zone = 0;

        if ( isdefined( level.spawn_delay ) && level.spawn_delay )
        {
            spawn_points = get_array_of_closest( valid_players[0].origin, level.zombie_screecher_locations );
            spawn_point = undefined;

            if ( spawn_points.size >= 3 )
                spawn_point = spawn_points[2];
            else if ( spawn_points.size >= 2 )
                spawn_point = spawn_points[1];
            else if ( spawn_points.size >= 1 )
                spawn_point = spawn_points[0];

            if ( isdefined( spawn_point ) )
                playsoundatposition("zmb_vocals_screecher_spawn", spawn_point.origin);

            delay_time = gettime() + 5000;
            now_zone = getent( "screecher_spawn_now", "targetname" );

            while ( gettime() < delay_time )
            {
                in_zone = 0;

                if (valid_players[0] istouching(now_zone))
                    break;

                if (!is_player_valid( valid_players[0]))
                    break;

                if (player_in_screecher_zone(valid_players[0]))
                    in_zone = 1;

                if (!in_zone)
                {
                    player_left_zone = 1;
                    level.spawn_delay = 1;
                    break;
                }
                wait 0.1;
            }
        }

        if ( isdefined( player_left_zone ) && player_left_zone )
            continue;

        level.spawn_delay = 0;
        spawn_points = get_array_of_closest( valid_players[0].origin, level.zombie_screecher_locations );
        spawn_point = undefined;

        if ( !isdefined( spawn_points ) || spawn_points.size == 0 )
        {
            wait 0.1;
            continue;
        }

        if ( !isdefined( level.last_spawn ) )
        {
            level.last_spawn_index = 0;
            level.last_spawn = [];
            level.last_spawn[level.last_spawn_index] = spawn_points[0];
            level.last_spawn_index = 1;
            spawn_point = spawn_points[0];
        }
        else
        {
            foreach ( point in spawn_points )
            {
                if ( point == level.last_spawn[0] )
                    continue;

                if ( isdefined( level.last_spawn[1] ) && point == level.last_spawn[1] )
                    continue;

                spawn_point = point;
                level.last_spawn[level.last_spawn_index] = spawn_point;
                level.last_spawn_index++;

                if ( level.last_spawn_index > 1 )
                    level.last_spawn_index = 0;

                break;
            }
        }

        if ( !isdefined( spawn_point ) )
            spawn_point = spawn_points[0];

        if ( isdefined( level.screecher_spawners ) )
        {
            spawner = random( level.screecher_spawners );
            ai = spawn_zombie( spawner, spawner.targetname, spawn_point );
        }

        if ( isdefined( ai ) )
        {
            ai.spawn_point = spawn_point;
			strattesterprint("^2Denizen Spawned!", "^2Un denizen apareció!");
            level.zombie_screecher_count++;
        }

        wait( level.zombie_vars["zombie_spawn_delay"] );
        wait 0.1;
    }
}

print_busschedule()
{
    depot = randomintrange( 40, 180 );
    dinner = randomintrange( 40, 180 );
    farm = randomintrange( 40, 180 );
    power = randomintrange( 40, 180 );
    town = randomintrange( 40, 180 );
	if(getDvarInt("st_depart") >= 40 && getDvarInt("st_depart") <= 180)
    farm = getDvarInt("st_depart");

    level.busschedule = busschedulecreate();
    level.busschedule busscheduleadd( "depot", 0, depot, 19, 15 );
    level.busschedule busscheduleadd( "tunnel", 1, 10, 27, 5 );
    level.busschedule busscheduleadd( "diner", 0, dinner, 18, 20 );
    level.busschedule busscheduleadd( "forest", 1, 10, 18, 5 );
    level.busschedule busscheduleadd( "farm", 0, farm, 26, 25 );
    level.busschedule busscheduleadd( "cornfields", 1, 10, 23, 10 );
    level.busschedule busscheduleadd( "power", 0, power, 19, 15 );
    level.busschedule busscheduleadd( "power2town", 1, 10, 26, 5 );
    level.busschedule busscheduleadd( "town", 0, town, 18, 20 );
    level.busschedule busscheduleadd( "bridge", 1, 10, 23, 10 );

    println("Depot: " + depot);
    println("Dinner: " + dinner);
    println("Farm: " + farm);
    println("Power: " + power);
    println("Town: " + town);
}

delete_zombie_noone_looking( how_close )
{
    self endon( "death" );

    if ( !isdefined( how_close ) )
        how_close = 1000;

    distance_squared_check = how_close * how_close;
    too_far_dist = distance_squared_check * 3;

    if ( isdefined( level.zombie_tracking_too_far_dist ) )
        too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

    self.inview = 0;
    self.player_close = 0;
    players = get_players();

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i].sessionstate == "spectator" )
            continue;

        if ( isdefined( level.only_track_targeted_players ) )
        {
            if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
                continue;
        }

        can_be_seen = self player_can_see_me( players[i] );

        if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
            self.inview++;

        if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check )
            self.player_close++;
    }

    wait 0.1;

    if ( self.inview == 0 && self.player_close == 0 )
    {
        if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
            return;

        if ( isdefined( self.electrified ) && self.electrified == 1 )
            return;

        if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
            return;

        zombies = getaiarray( "axis" );

        if ( ( !isdefined( self.damagemod ) || self.damagemod == "MOD_UNKNOWN" ) && self.health < self.maxhealth )
        {
            if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
            {
                level.zombie_total++;
                level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
            }
        }
        else if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
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
        self delete();
        recalc_zombie_array();
    }
}

denizens()
{
    dvar = getDvarInt("st_denizens");
    while(true)
    {
        wait 0.1;
        if(dvar == getDvarInt("st_denizens"))
            continue;
        dvar = getDvarInt("st_denizens");

        if(dvar)
        {
            strattesterprint("Denizens will spawn", "Los denizens aparecerán");
            level.zombie_ai_limit_screecher = 2;
        }
        else
        {
            strattesterprint("Denizens wont spawn", "Denizens desactivados");
            level.zombie_ai_limit_screecher = 0;
        }
    }
}

buildtranzitstuff()
{
    build_buildable("dinerhatch");
    build_buildable("powerswitch");

    busparts = array("bushatch", "busladder", "cattlecatcher");
    buildables = array("jetgun_zm", "electric_trap", "turret", "turbine", "pap", "riotshield_zm");

    if(getDvarInt("st_buildbus"))
        foreach(busbuild in buildables)
            build_buildable(busbuild);
    if(getDvarInt("st_buildbuildables"))
        foreach(buildable in buildables)
            build_buildable(buildable);
}

showDenizenLocation()
{
    if(!getDvarInt("st_showDenizenSpawners"))
        return;
    d_spawners = array((-10130.5, 3694.5, 165.2),
            (-10402.5, 2830.5, 220),
            (-10474.5, 2598.5, 210.1),
            (-10565.5, 1722.5, 220),
            (-10639, -4571, 198.4),
            (-10758, -5677, 198.4),
            (-10783.5, 1444.5, 220),
            (-11059.5, 387.5, 220),
            (-11086, -4886, 198.4),
            (-11182, -4384, 196.7),
            (-11233.5, 1125.5, 220),
            (-1281, -5715.5, -58.6),
            (-1293, -4634.5, -64.8),
            (-1586, -140, -59.9),
            (-1634, -1004, -61.8),
            (-2130, -7319, -131.4),
            (-2274, -5423, -66),
            (-3682, -6663, -38.39),
            (-4052, -6354, -36.3),
            (-4274, -5965, -70.9),
            (-4357, -147, 32.1),
            (-4426, -124, 42.8),
            (-4677, 333, 126.7),
            (-4802, 468, 151.3),
            (-4810, -644, 48.1),
            (-4957, 1157, 193),
            (-4989, -5696, -68.9),
            (-5011, 3351, 30.2),
            (-5045, 1800, 164.99),
            (-5274, -396, 91.7),
            (-5319, -5445, -65.5),
            (-5373, -6231, -51.9),
            (-5501, -267, 130.1),
            (-5514, 4613, -35.7),
            (-5573, 2181, 131.6),
            (-5605, 429, 165.8),
            (-5610, 3717, -4.8),
            (-5653, 2597, 132.7),
            (-5888, -6110, -72.3),
            (-592, -203, -54),
            (-6180, -5698, -34.7),
            (-624, -795, -57.9),
            (-6366, -6381, -40.7),
            (-6878, -6304, -14.2),
            (-7837.5, 5260.5, -41.6),
            (-794, -4938, -66),
            (-8167, -6680, 149),
            (-8448, -7041, 175.9),
            (-8524, 4660, -41.6),
            (-8686, -6440, 198.4),
            (-8780, 5188, -46.4),
            (-9188, 4740, 21.2),
            (-9405, 3755, 125.6),
            (-9600, -5889, 198.4),
            (-9739, -6322, 198.4),
            (10012, -233, -216.2),
            (10235, 6371, -576),
            (10245, 9080, -573),
            (10486, 6917, -563),
            (1054, -3879, -16.5),
            (10844, -1761, -190.7),
            (10878, 48, -231.2),
            (1201, -4206, -62.5),
            (12080, -1284, -176.1),
            (12098, -41, -175.3),
            (12573, -641, -135.4),
            (1294, -3395, 16),
            (1345, -5645, -60.7),
            (1355, -2334, -49.1),
            (1379, 1908, -43.2),
            (1445, -4906, -79.3),
            (1447.5, -4530, -74.3),
            (1474, -2858, 16.3),
            (1474, -2858, 7.8),
            (161, -4909, -66),
            (1623, 2597, -27.6),
            (1734, 1404, -58),
            (1767.5, -5216.5, -60.1),
            (2049, 2065, -59.1),
            (2349, 3641, -56.7),
            (2773.5, -5922.5, -19.5),
            (3520, 4987, -64),
            (3524.5, -5871.5, -58.8),
            (3608, 5467, -64),
            (3640, 3715, -99.6),
            (3680, 5891, -64),
            (4044.5, -5823.5, -65.2),
            (4112, 4651, -95),
            (4256, 5291, -64),
            (4261.5, -5997.5, -60.8),
            (4343, -5967, -71.7),
            (4488, 4107, -87.25),
            (4568, 6163, -64.6),
            (4840, 4963, -64),
            (4950, 5740, -68.8),
            (4992, 7355, -58.8),
            (5088, 4155, -53.9),
            (5256, 8323, -2.7),
            (5270, 5684, -64),
            (5280, -5755, -99.8),
            (5486, 5828, -64),
            (5614, -5834, -123.8),
            (5760, 4987, -85),
            (5824, 7731, -68.3),
            (5936, 6291, -151.9),
            (5959, -5818, -92.2),
            (5959, -5818, -96.2),
            (6053, -6463, -82.8),
            (6064, -5295, -37.7),
            (6070, -5471, -47.1),
            (6106, -5765, -79.8),
            (6164, -5553, -61.5),
            (6184, -5130, -71.7),
            (6192, 7291, -217.4),
            (6263, -4850, -71.7),
            (6374, -3337, -62.1),
            (6512, 8051, -290.1),
            (6530, -6191, -71.7),
            (6664, 6539, -230.4),
            (6868, -3863, -66.6),
            (687, -4265, -38.4),
            (7030, -3349, -87.5),
            (7044, -357, -205.4),
            (7088, 8531, -440),
            (7305, 8229, -423.7),
            (7526, -1358, -204.5),
            (7726, 72, -206.9),
            (7760, 9123, -558.4),
            (7869, -1535, -201),
            (7924, 2468, -64.7),
            (7959, 4264, -240.7),
            (8069, 8592, -569.9),
            (8271, 689, -176.1),
            (829, -4352, -29),
            (8423, -1548, -204.7),
            (8533, 225, -203),
            (8563, 3287, -110.3),
            (8591, 6243, -536.4),
            (8595, 5016, -433),
            (8597, 9288, -575.3),
            (8599, 5067, -446.6),
            (8627, 2303, -46.3),
            (8682, -2501, -214.56),
            (8826, 593, -182),
            (8856, 11, -203.4),
            (8943, 6259, -539.1),
            (8957, -651, -206.6),
            (9005, -1320, -208.4),
            (9219, 5539, -528.2),
            (9237, 8760, -577.2),
            (9675, 6563, -570.1),
            (9787, 5359, -556.5),
            (9797, -1091, -214.8),
            (9853, 8688, -569.4),
            (9856, 6061, -573),
            (9901, 5056, -555.7),
            (9988, 8467, -576.1));
    foreach(origin in d_spawners)
        spawn_turbine(origin);
}



spawn_turbine(origin)
{
	turbine = spawn("script_model", (origin));
	turbine SetModel("p6_zm_buildable_turbine_mannequin");
}