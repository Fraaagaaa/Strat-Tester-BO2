#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\menu;
#include scripts\zm\strattester\timers;

init_hud()
{
    register_menu_handler( "hud", ::on_hud_menu );

    foreach (player in getplayers())
        player load_persisted_hud();

    level thread watch_new_players_hud();
}

watch_new_players_hud()
{
    level endon("end_game");

    while(true)
    {
        level waittill( "connected", player );
        if(isdefined(player.has_hud) && player.has_hud)
            continue;

        player load_persisted_hud();
        level thread watermark();
        player thread healthbar();
        player thread sph();
        player thread timer();
        player thread despawnersTimer();
        player thread remaining();
        player thread zone();
        if(!issurvivalmap())
        {
            player thread despawnerCounter();
            player thread anchorLeakCounter();
            player thread zombiesFarAway();
            player thread prevent_hud_overlapping();
        }
        if(istranzit())
        {
            player thread denizensAlive();
            player thread buslocation();
            player thread bustimer();
        }
        else if(isnuketown())
            level thread fast_restart_warning();
        else if(isdierise())
        {
            player thread displayElevatorKills();
            player thread sliquifiretimer();
        }
        else if(ismob())
            player thread traptimer();
        else if(isburied())
            player thread displaysubwooferkills();
        else if(isorigins())
            player thread origins_hud();

        if(issurvivalmap())
        {
            player thread displayBoxHits();
        }

        player.has_hud = true;
    }
}

load_persisted_hud()
{
    self set_menu_hud("st_boxhits",             getDvarInt("st_boxhits"));
    self set_menu_hud("st_busloc",              getDvarInt("st_busloc"));
    self set_menu_hud("st_bustimer",            getDvarInt("st_bustimer"));
    self set_menu_hud("st_despawners",     	    getDvarInt("st_despawners"));
    self set_menu_hud("st_elevatorkills",       getDvarInt("st_elevatorkills"));
    self set_menu_hud("st_healthbar",           getDvarInt("st_healthbar"));
    self set_menu_hud("st_remaining",           getDvarInt("st_remaining"));
    self set_menu_hud("st_remaining_denizens",  getDvarInt("st_remaining_denizens"));
    self set_menu_hud("st_sliquifiretimer",     getDvarInt("st_sliquifiretimer"));
    self set_menu_hud("st_sph",                 getDvarInt("st_sph"));
    self set_menu_hud("st_stafftimer",     	    getDvarInt("st_stafftimer"));
    self set_menu_hud("st_stomp",     		    getDvarInt("st_stomp"));
    self set_menu_hud("st_subwooferkills",      getDvarInt("st_subwooferkills"));
    self set_menu_hud("st_tank",     		    getDvarInt("st_tank"));
    self set_menu_hud("st_tumble",     		    getDvarInt("st_tumble"));
    self set_menu_hud("st_zone",                getDvarInt("st_zone"));
}

get_menu_hud( element )
{
    if ( isdefined( self.st_hud ) && isdefined( self.st_hud[ element ] ) )
        return self.st_hud[ element ];

    switch ( element )
    {
        case "st_busloc":         return 0;
        case "st_bustimer":       return 0;
        case "st_despawners":     return 0;
        case "st_elevatorkills":  return 0;
        case "st_healthbar":      return 0;
        case "st_sliquifiretimer": return 0;
        case "st_subwooferkills": return 0;
    }
    return 1;
}

on_hud_menu( action, args)
{
    switch ( action )
    {
        case "sync":
            foreach ( arg in args )
                self hud_menu_set( arg );
            break;

        case "set":
            if ( args.size > 0 )
                self hud_menu_set( args[0] );
            break;
    }
}

hud_menu_set( arg )
{
    entry = strtok( arg, ":" );
    if ( !isdefined( entry ) || entry.size < 2 )
        return;

    self set_menu_hud( entry[0], int( entry[1] ) );
}

set_menu_hud( element, value )
{
    if ( !isdefined( self.st_hud ) )
        self.st_hud = [];

    self.st_hud[ element ] = value;
}

// GENERAL
watermark()
{
    level endon("end_game");
    self endon("disconnect");

    if(isdefined(level.watermark))
        return;

    level.watermark = createserverfontstring( "objective", 1.4 );
    level.watermark.hidewheninmenu = false;
    level.watermark.alignx = "center";
    level.watermark.horzalign = "user_center";
    level.watermark.vertalign = "user_top";
    level.watermark.aligny = "top";
    level.watermark.alignx = "center";
    level.watermark.horzalign = "user_center";
    level.watermark.label = &"ST_WATERMARK";
    level.watermark.alpha = 0.2;

    r = 1;
    g = 0;
    b = 0;
    step = 0.02;

    while ( true )
    {
        for ( g = 0; g < 1; g += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( r = 1; r > 0; r -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( b = 0; b < 1; b += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( g = 1; g > 0; g -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( r = 0; r < 1; r += step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
        for ( b = 1; b > 0; b -= step )
        {
            level.watermark.color = ( r, g, b );
            wait 0.05;
        }
    }
}

sph()
{
    level endon("end_game");
    self endon("disconnect");
    self.sph = newclienthudelem(self);
    self.sph.fontscale = 1.7;
    self.sph.color = (0.8, 0.8, 0.8);
    self.sph.hidewheninmenu = true;
    self.sph.x = 0;
    self.sph.y = 75;
    if(isorigins())
        self.sph.y += 45;
    self.sph.alpha = self get_menu_hud("st_sph");
    self.sph.label = &"ST_HUD_SPH";
    self.sph.alignx = "left";
    self.sph.aligny = "top";
    self.sph.horzalign = "user_left";
    self.sph.vertalign = "user_top";
    self.sph setvalue(0);

    while(true)
    {
        level waittill("start_of_round");
        self thread sph_round_tracker();
    }
}

sph_round_tracker()
{
    self endon("disconnect");
    self notify("sph_round_tracker");
    self endon("sph_round_tracker");

    self.sph.time_start = gettime() / 1000;
    self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
    self.sph.kills = 0;

    while(true)
    {
        wait 0.1;
        self.sph.alpha = self get_menu_hud("st_sph");
        time = gettime() / 1000;
        time_elapsed = int(time - self.sph.time_start);
        kills = self.sph.zombies_total_start - (get_round_enemy_array().size + level.zombie_total);
        hordas_fraction = kills / 24.0;
        if (hordas_fraction > 0)
            value = time_elapsed / hordas_fraction;
        else
            value = 0;
        self.sph setvalue(value);
    }
}

healthbar()
{
    level endon("end_game");
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");

    self.healthbar = self createprimaryprogressbar();
    self.healthbar_text = self createprimaryprogressbartext();
    self.healthbar.hidewheninmenu = true;
    self.healthbar.bar.hidewheninmenu = true;
    self.healthbar.barframe.hidewheninmenu = true;
    self.healthbar_text.hidewheninmenu = true;


    self.healthbar setpoint(undefined, "BOTTOM", 0, 15);
    self.healthbar_text setpoint(undefined, "BOTTOM", 75, 15);

    self.healthbar.alpha = 0;
    self.healthbar.bar.alpha = 0;
    self.healthbar.barframe.alpha = 0;
    self.healthbar_text.alpha = 0;
    while(true)
    {
        alpha = get_menu_hud("st_healthbar");
        self.healthbar.alpha = alpha;
        self.healthbar.bar.alpha = alpha;
        self.healthbar.barframe.alpha = alpha;
        self.healthbar_text.alpha = alpha;

        self.healthbar updatebar (self.health / self.maxhealth);
        self.healthbar_text setvalue(self.health);
        self.healthbar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
        wait 0.05;
    }
}

remaining()
{
    level endon("end_game");
    self endon("disconnect");

    self.zombie_counter_hud = createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud setPoint( "CENTER", "CENTER", "CENTER", 190 );
    self.zombie_counter_hud.hidewheninmenu = true;
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"ST_HUD_REMAINING";

    while(true)
    {
        self.zombie_counter_hud setValue((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total));
        self.zombie_counter_hud.alpha = get_menu_hud("st_remaining");
        wait 0.05; 
    }
}


zone()
{
    level endon("end_game");
    self endon("disconnect");

    self.st_zone_hud = createFontString( "hudsmall", 1.3 );
    self.st_zone_hud.x = 8;
    self.st_zone_hud.y = -95;
    if(isburied()) self.st_zone_hud.y += 15;
    if(isorigins()) self.st_zone_hud.y += 10;
    self.st_zone_hud.fontscale = 1.3;
    self.st_zone_hud.alignx = "left";
    self.st_zone_hud.horzalign = "user_left";
    self.st_zone_hud.vertalign = "user_bottom";
    self.st_zone_hud.aligny = "bottom";
    self.st_zone_hud.alpha = get_menu_hud("st_zone");
    self.st_zone_hud.hidewheninmenu = true;
    self.st_zone_hud.label = &"";

    flag_wait( "initial_blackscreen_passed" );

    prev_zone = "";
    while(true)
    {
        // Esto se podría simplificar bastante
        self.st_zone_hud.alpha = get_menu_hud("st_zone");

        zone = localize_zone(self get_current_zone());

        if(prev_zone != zone)
        {
            prev_zone = zone;

            self.st_zone_hud fadeovertime(0.2);
            self.st_zone_hud.alpha = 0;
            wait 0.2;

            self.st_zone_hud  settext(zone);

            self.st_zone_hud fadeovertime(0.2);
            self.st_zone_hud.alpha = 1;
            wait 0.15;
        }

        wait 0.05;
    }
}

// Obligado a tenerlos todos igual por culpa de developer 2
despawnerCounter()
{
    level endon("end_game");
    self endon("disconnect");

    if(!isdefined(level.despawners))
        level.despawners = 0;

    self.despawnersCounter = createfontstring( "objective", 1.4);
    self.despawnersCounter.hidewheninmenu = true;
    self.despawnersCounter.y = 0;
    self.despawnersCounter.x = 0;
    self.despawnersCounter.aligny = "top";
    self.despawnersCounter.alignx = "left";
    self.despawnersCounter.label = &"ST_HUD_ZOMBIES_DESPAWNED";
    self.despawnersCounter.horzalign = "user_left";
    self.despawnersCounter.vertalign = "user_top";
    self.despawnersCounter.alpha = 0;
    self.despawnersCounter setvalue(0);

    while(true)
    {
        self.despawnersCounter setvalue(level.despawners);
        self.despawnersCounter.alpha = self get_menu_hud("st_despawners");
        wait 0.1;
    }
}

anchorLeakCounter()
{
    if(!isdefined(level.anchorLeaks))
        level.anchorLeaks = 0;

    while(!isdefined(self.despawnersCounter))
        wait 0.1;

    self.anchorLeakCounter = createfontstring( "objective", 1.4);
    self.anchorLeakCounter.hidewheninmenu = true;
    self.anchorLeakCounter.x = 0;
    self.anchorLeakCounter.aligny = "top";
    self.anchorLeakCounter.alignx = "left";
    self.anchorLeakCounter.horzalign = "user_left";
    self.anchorLeakCounter.vertalign = "user_top";
    self.anchorLeakCounter.label = &"ST_HUD_ANCHOR_LEAKS";
    self.anchorLeakCounter.alpha = 0;
    self.anchorLeakCounter setvalue(0);

    while(true)
    {
        self.anchorLeakCounter setvalue(level.anchorLeaks);
        self.anchorLeakCounter.alpha = self get_menu_hud("st_despawners");
        wait 0.1;
    }
}

displayBoxHits()
{
    level endon("end_game");
    self endon("disconnect");

    if(isdefined(!level.total_chest_accessed))
    {
        level.total_chest_accessed = 0;
        level.total_chest_accessed_ray = 0;
        level.total_chest_accessed_mk2 = 0;
        level.total_mk2 = 0;
        level.total_ray = 0;
    }

    self.boxhits = createfontstring( "objective", 1.3 );
    self.boxhits.hidewheninmenu = true;
    self.boxhits.y = 0;
    self.boxhits.x = 2;
    self.boxhits.fontscale = 1.4;
    self.boxhits.alignx = "center";
    self.boxhits.horzalign = "user_center";
    self.boxhits.vertalign = "user_top";
    self.boxhits.aligny = "top";
    self.boxhits.alpha = 0;
    self.boxhits.label = &"ST_HUD_BOX_HITS";
    self.boxhits setvalue(0);

    if(issurvivalmap())
    {
        self.boxhits.alignx = "left";
        self.boxhits.horzalign = "user_left";

        self.total_ray_display = createfontstring( "objective", 1.3 );
        self.total_ray_display .hidewheninmenu = true;
        self.total_ray_display.y = 26;
        self.total_ray_display.x = 2;
        self.total_ray_display.fontscale = 1.3;
        self.total_ray_display.alignx = "left";
        self.total_ray_display.horzalign = "user_left";
        self.total_ray_display.vertalign = "user_top";
        self.total_ray_display.aligny = "top";
        self.total_ray_display.alpha = 1;

        self.total_mk2_display = createfontstring( "objective", 1.3 );
        self.total_mk2_display.hidewheninmenu = true;
        self.total_mk2_display.y = 14;
        self.total_mk2_display.x = 2;
        self.total_mk2_display.fontscale = 1.3;
        self.total_mk2_display.alignx = "left";
        self.total_mk2_display.horzalign = "user_left";
        self.total_mk2_display.vertalign = "user_top";
        self.total_mk2_display.aligny = "top";
        self.total_mk2_display.alpha = 1;

        self.total_ray_display setvalue(0);
        self.total_mk2_display setvalue(0);
        self thread box_hits_alpha_watcher();
        while(true)
        {
            if(getDvarInt("st_avg"))
            {
                self.total_mk2_display.label = &"ST_HUD_AVG_MK2";
                self.total_ray_display.label = &"ST_HUD_AVG_RAY";
                if(self.total_mk2 != 0) level.total_mk2_display setvalue(level.total_chest_accessed_mk2 / level.total_mk2);
                if(self.total_ray != 0) level.total_ray_display setvalue(level.total_chest_accessed_ray / level.total_ray);
            }
            else
            {
                self.total_mk2_display.label = &"ST_HUD_TOTAL_MK2";
                self.total_ray_display.label = &"ST_HUD_TOTAL_RAY";
                self.total_mk2_display setvalue(level.total_mk2);
                self.total_ray_display setvalue(level.total_ray);
            }
            self waittill( "box_spin_done" );
        }
    }
}

box_hits_alpha_watcher()
{
    level endon("end_game");
    self endon("disconnect");

    while(true)
    {
        alpha = get_menu_hud("st_boxhits");
        self.boxhits.alpha = alpha;
        self.total_mk2_display.alpha = alpha;
        self.total_ray_display.alpha = alpha;
        wait 0.1;
    }
}
// TRANZIT
denizensAlive()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self.denizen_counter = createFontString( "hudsmall" , 1.4 );
    self.denizen_counter setPoint( "CENTER", "CENTER", "CENTER", 205);
    self.denizen_counter.hidewheninmenu = true;
    self.denizen_counter.alpha = 0;
    self.denizen_counter.label = &"ST_HUD_DENIZENS";

    while(true)
    {
        self.denizen_counter setValue(level.zombie_screecher_count);
        self.denizen_counter.alpha = get_menu_hud("st_remaining_denizens");
        wait 0.05; 
    }
}

// Este aún no funciona
buslocation()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self.busloc = createfontstring( "objective", 1.3 );
    self.busloc.hidewheninmenu = true;
    self.busloc.x = 0;
    self.busloc.y = 40;
    self.busloc.fontscale = 1;
    self.busloc.alignx = "center";
    self.busloc.horzalign = "user_center";
    self.busloc.vertalign = "user_top";
    self.busloc.aligny = "top";
    self.busloc.alpha = 1;

    while (!isdefined(level.the_bus))
        wait 0.1;

    prev_zone = "";
    while(true)
    {
        self.busloc.alpha = get_menu_hud("st_busloc");
        zone = localize_zone(level.the_bus get_current_zone());

        if(prev_zone != zone)
        {
            prev_zone = zone;
            self.busloc settext(zone);
            self.busloc.alpha = get_menu_hud("st_busloc");
        }
        wait 0.05;
    }
}

// NUKETOWN
fast_restart_warning()
{
    level.fast_restart_warning = createserverfontstring( "objective", 1.3 );
    level.fast_restart_warning.y = 100;
    level.fast_restart_warning.x = 0;
    level.fast_restart_warning.fontscale = 2;
    level.fast_restart_warning.alignx = "center";
    level.fast_restart_warning.horzalign = "user_center";
    level.fast_restart_warning.vertalign = "user_top";
    level.fast_restart_warning.aligny = "top";
    level.fast_restart_warning.alpha = 1;
    level.fast_restart_warning.hidewheninmenu = true;
    level.fast_restart_warning.label = &"ST_HUD_RESTART_WARNING_NUKETOWN";

    flag_wait("initial_blackscreen_passed");
    level.fast_restart_warning destroy();
}

// DIE RISE
displayElevatorKills()
{
    level endon("end_game");
    self endon("disconnect");

    if(!isdefined(level.zombies_died_to_elevator))
        level.zombies_died_to_elevator = 0;

    self.elevatorkills = createFontString( "objective", 1.3 );
    self.elevatorkills.hidewheninmenu = true;
    self.elevatorkills.y = 0;
    self.elevatorkills.x = 0;
    self.elevatorkills.fontscale = 1.4;
    self.elevatorkills.alignx = "center";
    self.elevatorkills.horzalign = "user_center";
    self.elevatorkills.vertalign = "user_top";
    self.elevatorkills.aligny = "top";
    self.elevatorkills.label = &"ST_HUD_ELEVATOR_KILLS";
    self.elevatorkills.alignx = "left";
    self.elevatorkills.horzalign = "user_left";
    self.elevatorkills.alpha = 1;
    self.elevatorkills setvalue(0);

    while(true)
    {
        self.elevatorkills setvalue(level.zombies_died_to_elevator);
        self.elevatorkills.alpha = get_menu_hud("st_elevatorkills");
        wait 0.1;
    }
}

//BURIED
displaysubwooferkills()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    if(isdefined(level.subwooferkills))
        return;


    level.subwooferkills = 0;

    self.subwooferkills = createfontstring( "objective", 1.3 );
    self.subwooferkills.hidewheninmenu = true;
    self.subwooferkills.y = 0;
    self.subwooferkills.x = 0;
    self.subwooferkills.fontscale = 1.4;
    self.subwooferkills.alignx = "center";
    self.subwooferkills.horzalign = "user_center";
    self.subwooferkills.vertalign = "user_top";
    self.subwooferkills.aligny = "top";
    self.subwooferkills.label = &"ST_HUD_SUBWOOFER_KILLS";
    self.subwooferkills.alignx = "left";
    self.subwooferkills.horzalign = "user_left";
    self.subwooferkills.alpha = 0;
    self.subwooferkills setvalue(0);

    while(true)
    {
        self.subwooferkills setvalue(level.subwooferkills_count);
        self.subwooferkills.alpha = get_menu_hud("st_subwooferkills");
        wait 0.1;
    }
}

// ORIGINS
origins_hud()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self thread icestafftimer();
    self thread windstafftimer();

    self.stomp_hud   = self createHudElem(&"^3Stomp: ^5", 0, -220, 1.6, 0, "left", "bottom");
    self.tank_hud  = self createHudElem(&"^3Tank: ^5", 0, -180, 1.6, 0, "left", "bottom");
    self.tumble_hud  = self createHudElem(&"^3Tumble: ^5", 0, -200, 1.6, 0, "left", "bottom");

    self.stomp_hud.fontscale = 1.4;
    self.tank_hud.fontscale = 1.4;
    self.tumble_hud.fontscale = 1.4;

    if(!isdefined(level.tumbles)) level.tumbles = 0;
    if(!isdefined(level.tankkills)) level.tankkills = 0;
    if(!isdefined(level.stompkills)) level.stompkills = 0;

    flag_wait("initial_blackscreen_passed");
    while(true)
    {
        self.stomp_hud setvalue(level.stompkills);
        self.tank_hud setvalue(level.tankkills);
        self.tumble_hud setvalue(level.tumbles);

        self.stomp_hud.alpha = get_menu_hud("st_stomp");
        self.tumble_hud.alpha = get_menu_hud("st_tumble");
        self.tank_hud.alpha = get_menu_hud("st_tank");

        wait 0.1;
    }
}

zombiesFarAway()
{
    self.zombiesInView = createfontstring("objective", 1.4);
    self.zombiesInView.hidewheninmenu = true;
    self.zombiesInView.x = 0;
    self.zombiesInView.aligny = "top";
    self.zombiesInView.alignx = "left";
    self.zombiesInView.label = &"ST_HUD_ZOMBIES_IN_VIEW";
    self.zombiesInView.horzalign = "user_left";
    self.zombiesInView.vertalign = "user_top";
    self.zombiesInView.alpha = 0;
    self.zombiesInView setvalue(0);

    self.zombiesFar = createfontstring("objective", 1.4);
    self.zombiesFar.hidewheninmenu = true;
    self.zombiesFar.x = 0;
    self.zombiesFar.y = 30;
    self.zombiesFar.aligny = "top";
    self.zombiesFar.alignx = "left";
    self.zombiesFar.label = &"ST_HUD_ZOMBIES_FAR";
    self.zombiesFar.horzalign = "user_left";
    self.zombiesFar.vertalign = "user_top";
    self.zombiesFar.alpha = 0;
    self.zombiesFar setvalue(0);

    if(isdefined(level.zombie_tracking_too_far_dist))
    {
        distance_squared_check = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
    }
    else
    {
        if(istranzit() || isdierise())
            how_close = 1000;

        if(isburied() || isorigins() || ismob())
            how_close = 1500;

        distance_squared_check = how_close * how_close;
    }

    too_far_dist = distance_squared_check * 3;

    if(isdefined(level.zombie_tracking_too_far_dist))
        too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

    can_be_seen_func  = undefined;
    if(isorigins())      can_be_seen_func = getfunction("maps/mp/zm_tomb_distance_tracking", "player_can_see_me");
    else if(isburied())  can_be_seen_func = getfunction("maps/mp/zm_buried_distance_tracking", "player_can_see_me");
    else if(ismob())     can_be_seen_func = getfunction("maps/mp/zm_alcatraz_distance_tracking", "player_can_see_me");
    else if(isdierise()) can_be_seen_func = getfunction("maps/mp/zm_highrise_distance_tracking", "player_can_see_me");
    else if(istranzit()) can_be_seen_func = getfunction("maps/mp/zm_transit_distance_tracking", "player_can_see_me");

    if(!isdefined(can_be_seen_func))
        return;

    while(true)
    {
        self.zombiesFar.alpha = self get_menu_hud("st_despawners");
        self.zombiesInView.alpha = self get_menu_hud("st_despawners");;

        player_far = 0;
        inview = 0;

        zombies = getaiarray("axis");

        foreach(zombie in zombies)
        {
            zombie._inview = false;
            zombie._player_far = true;

            foreach(player in level.players)
            {
                if(player.sessionstate == "spectator")
                    continue;

                if(isdefined(level.only_track_targeted_players))
                    if(!isdefined(zombie.favoriteenemy) || zombie.favoriteenemy != player)
                        continue;

                distance_squared = distancesquared(zombie.origin, player.origin);

                if(!zombie._inview)
                {
                    can_be_seen = zombie [[can_be_seen_func]](player);

                    if(can_be_seen && distance_squared < too_far_dist)
                    {
                        zombie._inview = true;
                        inview++;
                    }
                }

                if(zombie._player_far)
                {
                    if(isorigins() || ismob())
                    {
                        if(distance_squared < distance_squared_check && abs(zombie.origin[2] - player.origin[2]) < 600)
                            zombie._player_far = false;
                    }
                    else if(isburied() || isdierise())
                    {
                        if(distance_squared < distance_squared_check && abs(zombie.origin[2] - player.origin[2]) < 500)
                            zombie._player_far = false;
                    }
                    else if(distance_squared < distance_squared_check)
                        zombie._player_far = false;
                }
            }

            if(zombie._player_far)
                player_far++;
        }

        wait 0.1;

        self.zombiesInView setvalue(inview);
        self.zombiesFar setvalue(player_far);
    }
}

prevent_hud_overlapping()
{
    level endon("end_game");
    self endon("disconnect");

    offset = 15;

    while(true)
    {
        current_y = self.sph.y + offset + 10;

        if(isdefined(self.despawnersCounter))
        {
            self.despawnersCounter.y = current_y;

            if(self.despawnersCounter.alpha > 0)
                current_y = self.despawnersCounter.y + offset;
        }

        if(isdefined(self.anchorLeakCounter))
        {
            self.anchorLeakCounter.y = current_y;

            if(self.anchorLeakCounter.alpha > 0)
                current_y = self.anchorLeakCounter.y + offset;
        }

        if(isdefined(self.zombiesInView))
        {
            self.zombiesInView.y = current_y;

            if(self.zombiesInView.alpha > 0)
                current_y = self.zombiesInView.y + offset;
        }

        if(isdefined(self.zombiesFar))
        {
            self.zombiesFar.y = current_y;

            if(self.zombiesFar.alpha > 0)
                current_y = self.zombiesFar.y + offset;
        }

        if(isburied() && isdefined(self.subwooferkills))
            current_y = self.subwooferkills setHudLocation(current_y, offset);

        if(isdierise() && isdefined(self.elevatorkills))
            current_y = self.elevatorkills setHudLocation(current_y, offset);

        if(isorigins())
        {
            if(isdefined(self.stomp_hud))
                current_y = self.stomp_hud setHudLocation(current_y, offset);

            if(isdefined(self.tank_hud))
                current_y = self.tank_hud setHudLocation(current_y, offset);

            if(isdefined(self.tumble_hud))
                current_y = self.tumble_hud setHudLocation(current_y, offset);
        }

        wait 0.1;
    }
}

setHudLocation(current_y, offset)
{
    if(!isdefined(offset))
        offset = 15;

    if(self.alpha > 0)
    {
        self.y = current_y;
        current_y += offset;
    }
    else
    {
        self.y = current_y;
    }

    return current_y;
}
