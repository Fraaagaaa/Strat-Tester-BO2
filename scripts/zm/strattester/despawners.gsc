#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

strattesterprint(message, mensaje)
{
	foreach(player in level.players)
	{
		if(getDvar("language") == "spanish" && isdefined(mensaje))
			player iprintln("^5[^6Strat Tester^5]^7 " + mensaje);
		else
			player iprintln("^5[^6Strat Tester^5]^7 " + message);
	}
}

replacefuncs()
{
	replacefunc( getfunction( "maps/mp/zm_tomb_distance_tracking", "delete_zombie_noone_looking" ), ::delete_zombie_noone_looking_origins );
	replacefunc( getfunction( "maps/mp/zm_buried_distance_tracking", "delete_zombie_noone_looking" ), ::delete_zombie_noone_looking_buried );
	replacefunc( getfunction( "maps/mp/zm_alcatraz_distance_tracking", "delete_zombie_noone_looking" ), ::delete_zombie_noone_looking_mob );
	replacefunc( getfunction( "maps/mp/zm_highrise_distance_tracking", "delete_zombie_noone_looking" ), ::delete_zombie_noone_looking_dierise );
	replacefunc( getfunction( "maps/mp/zm_transit_distance_tracking", "delete_zombie_noone_looking" ), ::delete_zombie_noone_looking_tranzit );
}

despawners_init()
{
	level.anchor_deaths = 0;
	
	thread replacefuncs();
	thread zombie_tracking_init();
	
	zombies = getEntArray( "zombie_spawner", "script_noteworthy" );
	array_thread( zombies, ::add_spawn_function, ::custom_zombie_setup );
	
	while (true)
	{
		wait 0.1;
		setdvar( "developer", 0 );
		while(getDvarInt("st_despawners"))
		{

			setdvar( "developer", 2 );
			array = getentarray( "zombie_spawner", "script_noteworthy" );
		
			for ( i = 0; i < array.size; i++ )
			{
				spawner = array[ i ].origin;
			
				debugstar( spawner, 1, ( 1, 1, 1 ), ( 1, 1, 1 ), array[ i ].classname, 5 );
			
				if ( isdefined( level.zombie_tracking_dist ) )
				{
					circle( spawner, level.zombie_tracking_dist, ( 0, 1, 1 ), false, true, 1 );
				
					if ( isdefined( level.zombie_tracking_high ) )
					{
						circle( spawner + ( 0, 0, level.zombie_tracking_high ), level.zombie_tracking_dist, ( 0, 1, 1 ), true, true, 1 );
						circle( spawner - ( 0, 0, level.zombie_tracking_high ), level.zombie_tracking_dist, ( 0, 1, 1 ), true, true, 1 );
					}
				
					too_far = level.zombie_tracking_dist * level.zombie_tracking_dist;
					too_far *= 3;
					too_far = sqrt( too_far );
				
					if ( isdefined( level.zombie_tracking_too_far_dist ) )
					{
						too_far = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
					}
				
					circle( spawner, too_far, ( 0, 0, 1 ), false, true, 1 );
				
					if ( isdefined( level.zombie_tracking_high ) )
					{
						circle( spawner + ( 0, 0, level.zombie_tracking_high ), too_far, ( 0, 0, 1 ), true, true, 1 );
						circle( spawner - ( 0, 0, level.zombie_tracking_high ), too_far, ( 0, 0, 1 ), true, true, 1 );
					}
				}
			}
		
			if ( IsDefined( level.zombie_spawn_locations ) )
			{
				for ( i = 0; i < level.zombie_spawn_locations.size; i++ )
				{
					spawner = level.zombie_spawn_locations[ i ];
					debugstar( spawner.origin, 1, ( 1, 0, 1 ), ( 1, 0, 1 ), spawner.script_noteworthy, 5 );
				}
			}
		
			wait 0.05;
		}
	}
}

zombie_tracking_init()
{
	// buried isnt defined first frame?
	if ( !isdefined( level.zombie_tracking_wait ) )
	{
		c = 0;
		waittillframeend;
		
		while ( !isdefined( level.zombie_tracking_wait ) )
		{
			c++;
			
			if ( c >= 100 )
			{
				strattesterprint( "Map doesnt have distance tracking", "Este mapa no tiene lógica para reapariciones" );
				return;
			}
			
			wait 0.05;
			waittillframeend;
		}
	}
	
	text = createserverfontstring( "Objective", 1 );
	text setpoint( "CENTER", "CENTER", 320, 230 );
	text settimer( level.zombie_tracking_wait );
	text thread checkalpha();
	
	for ( ;; )
	{
		wait level.zombie_tracking_wait;
		
		if(getDvarInt("st_despawners"))
			strattesterprint( "Distance checking zombies...", "Comprobando distancia con los zombis...");
		text settimer( level.zombie_tracking_wait );
	}
}

checkalpha()
{
	while(true)
	{
		wait 0.1;
		self.alpha = getDvarInt("st_despawners");
	}
}

on_zombie_death()
{
	self waittill( "death" );
	anchor = self.anchor;
	
	// wait a bit and see if anchor is still not deleted
	wait 0.25;
	
	if ( isdefined( anchor ) )
	{
		if(getDvarInt("st_despawners"))
			strattesterprint( "Zombie at " + anchor.origin + " has died with an anchor",  "Zombi en " + anchor.origin + " ha muerto dejando una entidad suelta" );
		debugstar( anchor.origin, 20 * 20, ( 1, 0, 0 ), ( 1, 0, 0 ), "ANCHOR", 10 );
		
		level.anchor_deaths++;
		if(getDvarInt("st_despawners"))
			strattesterprint( "Anchor deaths: " + level.anchor_deaths, "Entidades sueltas por zombis: " + level.anchor_deaths);
	}
}

custom_zombie_setup()
{
	self thread on_zombie_death();
	
	while ( isdefined( self ) )
	{
		color = ( 1, 0, 0 );
		
		if ( !isalive( self ) )
		{
			color = ( 0, 1, 0 );
		}
		
		box( self.origin, ( -10, -10, 0 ), ( 10, 10, 67 ), self.angles[ 1 ], color, 1, false, 1 );
		wait 0.05;
	}
}

delete_zombie_noone_looking_origins( how_close, how_high )
{
	self endon( "death" );
	
	if ( !isdefined( how_close ) )
	{
		how_close = 1500;
	}
	
	if ( !isdefined( how_high ) )
	{
		how_high = 600;
	}
	
	// our stuff
	here = self.origin;
	//
	
	distance_squared_check = how_close * how_close;
	too_far_dist = distance_squared_check * 3;
	
	if ( isdefined( level.zombie_tracking_too_far_dist ) )
	{
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}
	
	self.inview = 0;
	self.player_close = 0;
	n_distance_squared = 0;
	n_height_difference = 0;
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].sessionstate == "spectator" )
		{
			continue;
		}
		
		if ( isdefined( level.only_track_targeted_players ) )
		{
			if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[ i ] )
			{
				continue;
			}
		}
		
		can_be_seen = self [[ getfunction( "maps/mp/zm_tomb_distance_tracking", "player_can_see_me" ) ]]( players[ i ] );
		
		if ( can_be_seen && distancesquared( self.origin, players[ i ].origin ) < too_far_dist )
		{
			self.inview++;
		}
		
		n_modifier = 1.0;
		
		if ( isdefined( players[ i ].b_in_tunnels ) && players[ i ].b_in_tunnels )
		{
			n_modifier = 2.25;
		}
		
		n_distance_squared = distancesquared( self.origin, players[ i ].origin );
		n_height_difference = abs( self.origin[ 2 ] - players[ i ].origin[ 2 ] );
		
		if ( n_distance_squared < distance_squared_check * n_modifier && n_height_difference < how_high )
		{
			self.player_close++;
		}
	}
	
	// other maps have a wait 0.1 here
	
	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || self.animname != "zombie" && self.animname != "mechz_zombie" )
		{
			return;
		}
		
		if ( isdefined( self.electrified ) && self.electrified == 1 )
		{
			return;
		}
		
		if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
		{
			return;
		}
		
		zombies = getaiarray( "axis" );
		
		if ( ( !isdefined( self.damagemod ) || self.damagemod == "MOD_UNKNOWN" ) && self.health < self.maxhealth )
		{
			if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
			{
				level.zombie_total++;
				level.zombie_respawned_health[ level.zombie_respawned_health.size ] = self.health;
			}
		}
		else if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
		{
			if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
			{
				level.zombie_total++;
				
				if ( self.health < level.zombie_health )
				{
					level.zombie_respawned_health[ level.zombie_respawned_health.size ] = self.health;
				}
			}
		}
		
		// our stuff
		if(getDvarInt("st_despawners"))
			strattesterprint( "Deleting zombie at " + here + " due to distance tracking",  "Eliminando zombie en " + here + " por estar demasiado lejos" );
		level.despawners++;
		debugstar( here, 20 * 10, ( 1, 1, 0 ), ( 1, 1, 0 ), "DISTANCE", 10 );
		//
		
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		
		if ( isdefined( self.is_mechz ) && self.is_mechz )
		{
			self notify( "mechz_cleanup" );
			level.mechz_left_to_spawn++;
			wait_network_frame();
			level notify( "spawn_mechz" );
		}
		
		// yes, origins doesnt have the buried anchor leak fix
		
		self delete ();
		recalc_zombie_array();
	}
}

delete_zombie_noone_looking_buried( how_close, how_high )
{
	self endon( "death" );
	
	// our stuff
	here = self.origin;
	//
	
	if ( self [[ getfunction( "maps/mp/zm_buried_distance_tracking", "can_be_deleted_from_buried_special_zones" ) ]]() )
	{
		self.inview = 0;
		self.player_close = 0;
	}
	else
	{
		if ( !isdefined( how_close ) )
		{
			how_close = 1000;
		}
		
		if ( !isdefined( how_high ) )
		{
			how_high = 500;
		}
		
		if ( !( isdefined( self.has_legs ) && self.has_legs ) )
		{
			how_close = how_close * 1.5;
		}
		
		distance_squared_check = how_close * how_close;
		height_squared_check = how_high * how_high;
		too_far_dist = distance_squared_check * 3;
		
		if ( isdefined( level.zombie_tracking_too_far_dist ) )
		{
			too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
		}
		
		self.inview = 0;
		self.player_close = 0;
		players = get_players();
		
		foreach ( player in players )
		{
			if ( player.sessionstate == "spectator" )
			{
				continue;
			}
			
			if ( isdefined( player.laststand ) && player.laststand && ( isdefined( self.favoriteenemy ) && self.favoriteenemy == player ) )
			{
				if ( !self [[ getfunction( "maps/mp/zm_buried_distance_tracking", "can_zombie_see_any_player" ) ]]() )
				{
					self.favoriteenemy = undefined;
					self.zombie_path_bad = 1;
					self thread [[ getfunction( "maps/mp/zm_buried_distance_tracking", "escaped_zombies_cleanup" ) ]]();
				}
			}
			
			if ( isdefined( level.only_track_targeted_players ) )
			{
				if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != player )
				{
					continue;
				}
			}
			
			can_be_seen = self [[ getfunction( "maps/mp/zm_buried_distance_tracking", "player_can_see_me" ) ]]( player );
			distance_squared = distancesquared( self.origin, player.origin );
			
			if ( can_be_seen && distance_squared < too_far_dist )
			{
				self.inview++;
			}
			
			if ( distance_squared < distance_squared_check && abs( self.origin[2] - player.origin[2] ) < how_high )
			{
				self.player_close++;
			}
		}
	}
	
	// the aforementioned wait
	wait 0.1;
	
	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
		{
			return;
		}
		
		if ( isdefined( self.electrified ) && self.electrified == 1 )
		{
			return;
		}
		
		zombies = getaiarray( "axis" );
		
		if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
		{
			if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
			{
				level.zombie_total++;
				
				if ( self.health < level.zombie_health )
				{
					level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
				}
			}
		}
		
		// our stuff
		if(getDvarInt("st_despawners"))
			strattesterprint( "Deleting zombie at " + here + " due to distance tracking",  "Eliminando zombie en " + here + " por estar demasiado lejos" );
		level.despawners++;
		debugstar( here, 20 * 10, ( 1, 1, 0 ), ( 1, 1, 0 ), "DISTANCE", 10 );
		//
		
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		
		// buried knew of the leak!
		if ( isdefined( self.anchor ) )
		{
			self.anchor delete ();
		}
		
		self delete ();
		recalc_zombie_array();
	}
}

delete_zombie_noone_looking_mob( how_close, how_high )
{
	self endon( "death" );
	
	if ( !isdefined( how_close ) )
	{
		how_close = 1500;
	}
	
	if ( !isdefined( how_high ) )
	{
		how_close = 600;
	}
	
	// our stuff
	here = self.origin;
	//
	
	distance_squared_check = how_close * how_close;
	too_far_dist = distance_squared_check * 3;
	
	if ( isdefined( level.zombie_tracking_too_far_dist ) )
	{
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}
	
	self.inview = 0;
	self.player_close = 0;
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].sessionstate == "spectator" )
		{
			continue;
		}
		
		if ( isdefined( level.only_track_targeted_players ) )
		{
			if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
			{
				continue;
			}
		}
		
		can_be_seen = self [[ getfunction( "maps/mp/zm_alcatraz_distance_tracking", "player_can_see_me" ) ]]( players[i] );
		
		if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
		{
			self.inview++;
		}
		
		if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check && abs( self.origin[2] - players[i].origin[2] ) < how_high )
		{
			self.player_close++;
		}
	}
	
	wait 0.1;
	
	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
		{
			return;
		}
		
		if ( isdefined( self.electrified ) && self.electrified == 1 )
		{
			return;
		}
		
		if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
		{
			return;
		}
		
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
				{
					level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
				}
			}
		}
		
		// our stuff
		if(getDvarInt("st_despawners"))
			strattesterprint( "Deleting zombie at " + here + " due to distance tracking",  "Eliminando zombie en " + here + " por estar demasiado lejos" );
		level.despawners++;
		debugstar( here, 20 * 10, ( 1, 1, 0 ), ( 1, 1, 0 ), "DISTANCE", 10 );
		//
		
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		self delete ();
		recalc_zombie_array();
	}
}

delete_zombie_noone_looking_dierise( how_close, how_high )
{
	self endon( "death" );
	
	if ( !isdefined( how_close ) )
	{
		how_close = 1000;
	}
	
	if ( !isdefined( how_high ) )
	{
		how_high = 500;
	}
	
	// our stuff
	here = self.origin;
	//
	
	distance_squared_check = how_close * how_close;
	height_squared_check = how_high * how_high;
	too_far_dist = distance_squared_check * 3;
	
	if ( isdefined( level.zombie_tracking_too_far_dist ) )
	{
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}
	
	self.inview = 0;
	self.player_close = 0;
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].sessionstate == "spectator" )
		{
			continue;
		}
		
		if ( isdefined( level.only_track_targeted_players ) )
		{
			if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
			{
				continue;
			}
		}
		
		can_be_seen = self [[ getfunction( "maps/mp/zm_highrise_distance_tracking", "player_can_see_me" ) ]]( players[i] );
		
		if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
		{
			self.inview++;
		}
		
		if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check && abs( self.origin[2] - players[i].origin[2] ) < how_high )
		{
			self.player_close++;
		}
	}
	
	wait 0.1;
	
	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
		{
			return;
		}
		
		if ( isdefined( self.electrified ) && self.electrified == 1 )
		{
			return;
		}
		
		zombies = getaiarray( "axis" );
		
		if ( zombies.size + level.zombie_total > 24 || zombies.size + level.zombie_total <= 24 && self.health >= self.maxhealth )
		{
			if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
			{
				level.zombie_total++;
				
				if ( self.health < level.zombie_health )
				{
					level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
				}
			}
		}
		
		// our stuff
		if(getDvarInt("st_despawners"))
			strattesterprint( "Deleting zombie at " + here + " due to distance tracking",  "Eliminando zombie en " + here + " por estar demasiado lejos" );
		level.despawners++;
		debugstar( here, 20 * 10, ( 1, 1, 0 ), ( 1, 1, 0 ), "DISTANCE", 10 );
		//
		
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		self delete ();
		recalc_zombie_array();
	}
}

delete_zombie_noone_looking_tranzit( how_close )
{
	self endon( "death" );
	
	if ( !isdefined( how_close ) )
	{
		how_close = 1000;
	}
	
	// our stuff
	here = self.origin;
	//
	
	distance_squared_check = how_close * how_close;
	too_far_dist = distance_squared_check * 3;
	
	if ( isdefined( level.zombie_tracking_too_far_dist ) )
	{
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}
	
	// tranzit doesnt have a height check, unlike newer maps
	
	self.inview = 0;
	self.player_close = 0;
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].sessionstate == "spectator" )
		{
			continue;
		}
		
		if ( isdefined( level.only_track_targeted_players ) )
		{
			if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
			{
				continue;
			}
		}
		
		can_be_seen = self [[ getfunction( "maps/mp/zm_transit_distance_tracking", "player_can_see_me" ) ]]( players[i] );
		
		if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
		{
			self.inview++;
		}
		
		if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check )
		{
			self.player_close++;
		}
	}
	
	wait 0.1;
	
	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
		{
			return;
		}
		
		if ( isdefined( self.electrified ) && self.electrified == 1 )
		{
			return;
		}
		
		if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
		{
			return;
		}
		
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
				{
					level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
				}
			}
		}
		
		// our stuff
		if(getDvarInt("st_despawners"))
			strattesterprint( "Deleting zombie at " + here + " due to distance tracking",  "Eliminando zombie en " + here + " por estar demasiado lejos" );
		level.despawners++;
		debugstar( here, 20 * 10, ( 1, 1, 0 ), ( 1, 1, 0 ), "DISTANCE", 10 );
		//
		
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		self delete ();
		recalc_zombie_array();
	}
}