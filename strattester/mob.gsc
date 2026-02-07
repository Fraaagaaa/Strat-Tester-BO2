#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;


replacefunctions()
{
    replaceFunc(maps\mp\zm_alcatraz_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
}

speeddoor()
{
	if(!getDvarInt("doors"))
		return;
	if(!getDvarInt("power"))
		return;
	flag_wait( "afterlife_start_over" );
	wait 1;
	self takeWeapon("raygun_mark2_upgraded_zm");
	self giveweapon("lightning_hands_zm");
	self switchToWeapon("lightning_hands_zm");
	self setOrigin((-536, 9513, 1336));
	self setPlayerAngles((0, 0, 0));
	wait 3;
	self setOrigin((3851, 9791, 1704));
	wait 0.5;
	self setOrigin((-1504, 5480, -71));
	self setPlayerAngles((0, -77, 0));
	wait 0.5;
	self setOrigin((-1064, 6263, 64));
	self setPlayerAngles((0, 10, 0));
	wait 0.5;
	self setOrigin((-316, 6886, 64));
	wait 0.5;
	self setOrigin((-530, 6545, 72));
	wait 0.5;
	self setOrigin((2127, 9552, 1450));
	wait 0.5;
	self setOrigin((-359, 9077, 1450));
	self setPlayerAngles((0, -170, 0));
	wait 0.5;
	self setOrigin((800, 8403, 1544));
	self setPlayerAngles((0, -90, 0));
	wait 0.5;
	self setOrigin((2050, 9566, 1336)); // cafe key
	wait 1.5;
	self setOrigin((-277, 9107, 1336));// office key
	wait 1.5;
	self setOrigin((1195, 10613, 1336));
	self TakeWeapon("lightning_hands_zm");
	self giveweapon("raygun_mark2_upgraded_zm");
}

infinite_afterlifes()
{
	self endon( "disconnect" );
	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		if(getDvarInt("lives"))
			self.lives++;
	}
}

delete_zombie_noone_looking( how_close, how_high )
{
    self endon( "death" );

    if ( !isdefined( how_close ) )
        how_close = 1500;

    if ( !isdefined( how_high ) )
        how_close = 600;

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

        if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check && abs( self.origin[2] - players[i].origin[2] ) < how_high )
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