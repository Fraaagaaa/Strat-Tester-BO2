
replacefunctions()
{
	replacefunc(maps\mp\zm_highrise_elevators::watch_for_elevator_during_faller_spawn, ::watch_for_elevator_during_faller_spawn);
    replaceFunc(maps\mp\zm_highrise_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
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

delete_zombie_noone_looking( how_close, how_high )
{
    self endon( "death" );

    if ( !isdefined( how_close ) )
        how_close = 1000;

    if ( !isdefined( how_high ) )
        how_high = 500;

    distance_squared_check = how_close * how_close;
    height_squared_check = how_high * how_high;
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
		strattesterprint("Zombie Despawned");
        self notify( "zombie_delete" );
        self delete();
        recalc_zombie_array();
    }
}