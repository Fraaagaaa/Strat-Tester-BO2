#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\menu;
#include scripts\zm\strattester\timers;

init_hud()
{
    register_menu_handler("hud", ::on_hud_menu);

    foreach (player in getplayers())
        player load_persisted_hud();

    level thread watchNewPLayersHUD();
}

watchNewPLayersHUD()
{
    level endon("end_game");
    while(true)
    {
        level waittill("connected", player);
        if(isdefined(player.has_hud) && player.has_hud)
            continue;

        player load_persisted_hud();
        level thread watermark();
        player thread resetSPHTracker();
        player thread timer();
        player thread despawnersTimer();
        if(istranzit())
            player thread busTimer();
        else if(isnuketown())
            level thread fastrestartWarning();
        else if(isdierise())
            player thread sliquifireTimer();
        else if(ismob())
            player thread trapTimer();
        else if(isorigins())
        {
            player thread icestaffTimer();
            player thread windstaffTimer();
            if(!isdefined(level.tumbles)) level.tumbles = 0;
            if(!isdefined(level.tankkills)) level.tankkills = 0;
            if(!isdefined(level.stompkills)) level.stompkills = 0;
            if(!isdefined(level.generatorKills)) level.generatorKills = 0;
            if(!isdefined(level.generatorKillsThisRound)) level.generatorKillsThisRound = 0;
            player thread restartGeneratorKillsAtRoundEnd();
        }

        player.has_hud = true;
        player startEnabledMenuHUDs();
        if(!issurvivalmap())
            player thread preventHUDOverlap();
    }
}

// GENERAL
watermark()
{
    level endon("end_game");

    if(isdefined(level.watermark))
        return;

    level.watermark = createserverfontstring("objective", 1.4);
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

    while (true)
    {
        for (g = 0; g < 1; g += step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
        for (r = 1; r > 0; r -= step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
        for (b = 0; b < 1; b += step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
        for (g = 1; g > 0; g -= step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
        for (r = 0; r < 1; r += step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
        for (b = 1; b > 0; b -= step)
        {
            level.watermark.color = (r, g, b);
            wait 0.05;
        }
    }
}

resetSPHTracker()
{
    level endon("end_game");
    self endon("disconnect");

    while(true)
    {
        level waittill_any("start_of_round", "st_sph_restart");
        self.st_sph_time_start = gettime() / 1000;
        self.st_sph_zombies_start = level.zombie_total + get_round_enemy_array().size;
    }
}

sph()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("st_hud_stop_st_sph");

    self.sph = newclienthudelem(self);
    self.sph.fontscale = 1.7;
    self.sph.color = (0.8, 0.8, 0.8);
    self.sph.hidewheninmenu = true;
    self.sph.x = 0;
    self.sph.y = 75;
    if(isorigins()) self.sph.y += 45;
    self.sph.label = &"ST_HUD_SPH";
    self.sph.alignx = "left";
    self.sph.aligny = "top";
    self.sph.horzalign = "user_left";
    self.sph.vertalign = "user_top";
    self.sph setvalue(0);

    while(true)
    {
        value = 0;
        if(isdefined(self.st_sph_time_start) && isdefined(self.st_sph_zombies_start))
        {
            time_elapsed = int(gettime() / 1000 - self.st_sph_time_start);
            kills = self.st_sph_zombies_start - (get_round_enemy_array().size + level.zombie_total);
            hordes = kills / 24.0;
            if(hordes > 0) value = time_elapsed / hordes;
        }

        value = roundTo(value, 2);
        self.sph setvalue(value);

        wait 0.1;
    }
}

healthbar()
{
    self endon("st_hud_stop_st_healthbar");
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

    self.healthbar.alpha = 1;
    self.healthbar.bar.alpha = 1;
    self.healthbar.barframe.alpha = 1;
    self.healthbar_text.alpha = 1;
    while(true)
    {

        self.healthbar updatebar (self.health / self.maxhealth);
        self.healthbar_text setvalue(self.health);
        self.healthbar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
        wait 0.05;
    }
}

remaining()
{
    self endon("st_hud_stop_st_remaining");
    level endon("end_game");
    self endon("disconnect");

    self.zombie_counter_hud = createFontString("hudsmall" , 1.4);
    self.zombie_counter_hud setPoint("CENTER", "CENTER", "CENTER", 190);
    self.zombie_counter_hud.hidewheninmenu = true;
    self.zombie_counter_hud.alpha = 1;
    self.zombie_counter_hud.label = &"ST_HUD_REMAINING";

    while(true)
    {
        self.zombie_counter_hud setValue((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total));
        wait 0.05; 
    }
}


zone()
{
    self endon("st_hud_stop_st_zone");
    level endon("end_game");
    self endon("disconnect");

    self.st_zone_hud = createFontString("hudsmall", 1.3);
    self.st_zone_hud.x = 8;
    self.st_zone_hud.y = -95;
    if(isburied()) self.st_zone_hud.y += 15;
    if(isorigins()) self.st_zone_hud.y += 10;
    self.st_zone_hud.fontscale = 1.3;
    self.st_zone_hud.alignx = "left";
    self.st_zone_hud.horzalign = "user_left";
    self.st_zone_hud.vertalign = "user_bottom";
    self.st_zone_hud.aligny = "bottom";

    self.st_zone_hud.alpha = 1;
    self.st_zone_hud.hidewheninmenu = true;
    self.st_zone_hud.label = &"";

    flag_wait("initial_blackscreen_passed");

    prev_zone = "";
    while(true)
    {
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

despawnerCounter()
{
    self endon("st_hud_stop_st_despawners");
    level endon("end_game");
    self endon("disconnect");

    if(!isdefined(level.despawners))
        level.despawners = 0;

    self.despawnersCounter = createfontstring("objective", 1.4);
    self.despawnersCounter.hidewheninmenu = true;
    self.despawnersCounter.y = 0;
    self.despawnersCounter.x = 0;
    self.despawnersCounter.aligny = "top";
    self.despawnersCounter.alignx = "left";
    self.despawnersCounter.label = &"ST_HUD_ZOMBIES_DESPAWNED";
    self.despawnersCounter.horzalign = "user_left";
    self.despawnersCounter.vertalign = "user_top";
    self.despawnersCounter.alpha = 1;
    self.despawnersCounter setvalue(0);

    while(true)
    {

        self.despawnersCounter setvalue(level.despawners);
        wait 0.1;
    }
}

anchorLeakCounter()
{
    self endon("st_hud_stop_st_despawners");
    if(!isdefined(level.anchorLeaks))
        level.anchorLeaks = 0;


    self.anchorLeakCounter = createfontstring("objective", 1.4);
    self.anchorLeakCounter.hidewheninmenu = true;
    self.anchorLeakCounter.x = 0;
    self.anchorLeakCounter.aligny = "top";
    self.anchorLeakCounter.alignx = "left";
    self.anchorLeakCounter.horzalign = "user_left";
    self.anchorLeakCounter.vertalign = "user_top";
    self.anchorLeakCounter.label = &"ST_HUD_ANCHOR_LEAKS";
    self.anchorLeakCounter.alpha = 1;
    self.anchorLeakCounter setvalue(0);

    while(true)
    {
        self.anchorLeakCounter setvalue(level.anchorLeaks);

        wait 0.1;
    }
}

displayBoxHits()
{
    self endon("st_hud_stop_st_boxhits");
    level endon("end_game");
    self endon("disconnect");

    if(!isdefined(level.total_chest_accessed)) level.total_chest_accessed = 0;
    if(!isdefined(level.total_chest_accessed_ray)) level.total_chest_accessed_ray = 0;
    if(!isdefined(level.total_chest_accessed_mk2)) level.total_chest_accessed_mk2 = 0;
    if(!isdefined(level.total_mk2)) level.total_mk2 = 0;
    if(!isdefined(level.total_ray)) level.total_ray = 0;

    self.boxhits = createfontstring("objective", 1.3);
    self.boxhits.hidewheninmenu = true;
    self.boxhits.y = 0;
    self.boxhits.x = 2;
    self.boxhits.fontscale = 1.4;
    self.boxhits.alignx = "center";
    self.boxhits.horzalign = "user_center";
    self.boxhits.vertalign = "user_top";
    self.boxhits.aligny = "top";
    self.boxhits.alpha = 1;
    self.boxhits.label = &"ST_HUD_BOX_HITS";
    self.boxhits setvalue(0);

    if(issurvivalmap())
    {
        self.boxhits.alignx = "left";
        self.boxhits.horzalign = "user_left";

        self.total_ray_display = createfontstring("objective", 1.3);
        self.total_ray_display .hidewheninmenu = true;
        self.total_ray_display.y = 26;
        self.total_ray_display.x = 2;
        self.total_ray_display.fontscale = 1.3;
        self.total_ray_display.alignx = "left";
        self.total_ray_display.horzalign = "user_left";
        self.total_ray_display.vertalign = "user_top";
        self.total_ray_display.aligny = "top";
        self.total_ray_display.alpha = 1;

        self.total_mk2_display = createfontstring("objective", 1.3);
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

        while(true)
        {
            if(getDvarInt("st_avg"))
            {
                self.total_mk2_display.label = &"ST_HUD_AVG_MK2";
                self.total_ray_display.label = &"ST_HUD_AVG_RAY";
                if(level.total_mk2 != 0) self.total_mk2_display setvalue(roundTo(level.total_chest_accessed_mk2 / level.total_mk2, 2));
                else self.total_mk2_display setvalue(0);
                if(level.total_ray != 0) self.total_ray_display setvalue(roundTo(level.total_chest_accessed_ray / level.total_ray, 2));
                else self.total_ray_display setvalue(0);
            }
            else
            {
                self.total_mk2_display.label = &"ST_HUD_TOTAL_MK2";
                self.total_ray_display.label = &"ST_HUD_TOTAL_RAY";
                self.total_mk2_display setvalue(level.total_mk2);
                self.total_ray_display setvalue(level.total_ray);
            }
            wait 0.1;
        }
    }
}

// TRANZIT
denizensAlive()
{
    self endon("st_hud_stop_st_remaining_denizens");
    level endon("end_game");
    self endon("disconnect");

    self.denizen_counter = createFontString("hudsmall" , 1.4);
    self.denizen_counter setPoint("CENTER", "CENTER", "CENTER", 205);
    self.denizen_counter.hidewheninmenu = true;
    self.denizen_counter.alpha = 1;
    self.denizen_counter.label = &"ST_HUD_DENIZENS";

    while(true)
    {
        self.denizen_counter setValue(level.zombie_screecher_count);

        wait 0.05; 
    }
}

// Este aún no funciona
buslocation()
{
    self endon("st_hud_stop_st_busloc");
    level endon("end_game");
    self endon("disconnect");

    self.busloc = createfontstring("objective", 1.3);
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
        wait 0.1;

        zone = localize_zone(level.the_bus get_current_zone());
    
        if(!isdefined(zone))
            continue;

        if(prev_zone != zone)
        {
            prev_zone = zone;
            self.busloc settext(zone);

        }
    }
}

// NUKETOWN
fastrestartWarning()
{
    level endon("endgame");

    level.fast_restart_warning = createserverfontstring("objective", 1.3);
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
    self endon("st_hud_stop_st_elevatorkills");
    level endon("end_game");
    self endon("disconnect");

    if(!isdefined(level.zombies_died_to_elevator))
        level.zombies_died_to_elevator = 0;

    self.elevatorkills = createFontString("objective", 1.3);
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

        wait 0.1;
    }
}

//BURIED
displaySubwooferKills()
{
    self endon("st_hud_stop_st_subwooferkills");
    level endon("end_game");
    self endon("disconnect");

    self.subwooferKills = createfontstring("objective", 1.3);
    self.subwooferKills.hidewheninmenu = true;
    self.subwooferKills.y = 0;
    self.subwooferKills.x = 0;
    self.subwooferKills.fontscale = 1.4;
    self.subwooferKills.vertalign = "user_top";
    self.subwooferKills.aligny = "top";
    self.subwooferKills.label = &"ST_HUD_SUBWOOFER_KILLS";
    self.subwooferKills.alignx = "left";
    self.subwooferKills.horzalign = "user_left";
    self.subwooferKills.alpha = 1;
    self.subwooferKills setvalue(0);

    while(true)
    {
        self.subwooferKills setvalue(level.subwooferKillsLastShot);

        wait 0.1;
    }
}

displaySubwooferKillsAvg()
{
    self endon("st_hud_stop_st_subwooferkills");
    level endon("end_game");
    self endon("disconnect");

    self.subwooferKillsAvg = createfontstring("objective", 1.3);
    self.subwooferKillsAvg.hidewheninmenu = true;
    self.subwooferKillsAvg.y = 0;
    self.subwooferKillsAvg.x = 0;
    self.subwooferKillsAvg.fontscale = 1.4;
    self.subwooferKillsAvg.vertalign = "user_top";
    self.subwooferKillsAvg.aligny = "top";
    self.subwooferKillsAvg.label = &"ST_HUD_SUBWOOFER_KILLS_AVG";
    self.subwooferKillsAvg.alignx = "left";
    self.subwooferKillsAvg.horzalign = "user_left";
    self.subwooferKillsAvg.alpha = 1;
    self.subwooferKillsAvg setvalue(0);

    while(true)
    {
        if(level.subwooferShots > 0)
            self.subwooferKillsAvg setvalue(roundTo(level.subwooferKillsTotal / level.subwooferShots, 2));
        else
            self.subwooferKillsAvg setvalue(0);

        wait 0.1;
    }
}

displayTurbineBattery()
{
    self endon("st_hud_stop_st_turbinehbattery");
    level endon("end_game");
    self endon("disconnect");

    self.turbineBattery = createfontstring("objective", 1.3);
    self.turbineBattery.hidewheninmenu = true;
    self.turbineBattery.y = 0;
    self.turbineBattery.x = 0;
    self.turbineBattery.fontscale = 1.4;
    self.turbineBattery.vertalign = "user_top";
    self.turbineBattery.aligny = "top";
    self.turbineBattery.label = &"ST_HUD_TURBINE_POWER";
    self.turbineBattery.alignx = "left";
    self.turbineBattery.horzalign = "user_left";
    self.turbineBattery.alpha = 1;
    self.turbineBattery setvalue(0);

    while(true)
    {
        if (isdefined(self.buildableturbine) && isdefined(self.turbine_health) && self.turbine_health > 0)
        {
            health = self.turbine_health / 1200 * 100;
            health = roundTo(health, 2);
            self.turbineBattery setvalue(health);
        }
        else
            self.turbineBattery setvalue(0);
        wait 0.05;
    }
}

// ORIGINS
origins_counter(element)
{
    level endon("end_game");
    self endon("disconnect");
    self endon("st_hud_stop_" + element);

    if(element == "st_stomp")
    {
        self.stomp_hud = createfontstring("objective", 1.4);
        hud = self.stomp_hud;
        hud.label = &"ST_HUD_STOMP_ORIGINS";
    }
    else if(element == "st_tank")
    {
        self.tank_hud = createfontstring("objective", 1.4);
        hud = self.tank_hud;
        hud.label = &"ST_HUD_TANK_ORIGINS";
    }
    else
    {
        self.tumble_hud = createfontstring("objective", 1.4);
        hud = self.tumble_hud;
        hud.label = &"ST_HUD_TUMBLE_ORIGINS";
    }

    hud.hidewheninmenu = true;
    hud.alignx = "left";
    hud.horzalign = "user_left";
    hud.alpha = 1;
    hud setvalue(0);

    while(true)
    {
        if(element == "st_stomp") hud setvalue(level.stompkills);
        else if(element == "st_tank") hud setvalue(level.tankkills);
        else hud setvalue(level.tumbles);
        wait 0.1;
    }
}

generatorKillsThisRound()
{
    self endon("st_hud_stop_st_generatorkills");
    self.generatorKillsThisRound = createfontstring("objective", 1.4);
    self.generatorKillsThisRound.hidewheninmenu = true;
    self.generatorKillsThisRound.x = 0;
    self.generatorKillsThisRound.aligny = "top";
    self.generatorKillsThisRound.alignx = "left";
    self.generatorKillsThisRound.label = &"ST_HUD_GENERATOR_KILLS_ROUND";
    self.generatorKillsThisRound.horzalign = "user_left";
    self.generatorKillsThisRound.vertalign = "user_top";
    self.generatorKillsThisRound.alpha = 1;
    self.generatorKillsThisRound setvalue(0);

    while(true)
    {
        self.generatorKillsThisRound setvalue(level.generatorKillsThisRound);
        wait 0.1;
    }
}

generatorKills()
{
    self endon("st_hud_stop_st_generatorkills");
    self.generatorKills = createfontstring("objective", 1.4);
    self.generatorKills.hidewheninmenu = true;
    self.generatorKills.x = 0;
    self.generatorKills.aligny = "top";
    self.generatorKills.alignx = "left";
    self.generatorKills.label = &"ST_HUD_GENERATOR_KILLS";
    self.generatorKills.horzalign = "user_left";
    self.generatorKills.vertalign = "user_top";
    self.generatorKills.alpha = 1;
    self.generatorKills setvalue(0);

    while(true)
    {
        self.generatorKills setvalue(level.generatorKills);
        wait 0.1;
    }
}

restartGeneratorKillsAtRoundEnd()
{
    self notify("restartGeneratorKillsAtRoundEnd_called");
    self endon("restartGeneratorKillsAtRoundEnd_called");
    while(true)
    {
        level waittill("end_of_round");
        level.generatorKillsThisRound = 0;
    }
}

// GENERAL
zombiesFarAway()
{
    self endon("st_hud_stop_st_despawners");
    self.zombiesInView = createfontstring("objective", 1.4);
    self.zombiesInView.hidewheninmenu = true;
    self.zombiesInView.x = 0;
    self.zombiesInView.aligny = "top";
    self.zombiesInView.alignx = "left";
    self.zombiesInView.label = &"ST_HUD_ZOMBIES_IN_VIEW";
    self.zombiesInView.horzalign = "user_left";
    self.zombiesInView.vertalign = "user_top";
    self.zombiesInView.alpha = 1;
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
    self.zombiesFar.alpha = 1;
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

preventHUDOverlap()
{
    level endon("end_game");
    self endon("disconnect");
    offset = 15;

    while(true)
    {
        current_y = 75;
        if(isorigins()) current_y += 45;
        current_y += offset + 10;

        if(isdefined(self.despawnersCounter)) current_y = self.despawnersCounter setHudLocation(current_y, offset);
        if(isdefined(self.anchorLeakCounter)) current_y = self.anchorLeakCounter setHudLocation(current_y, offset);
        if(isdefined(self.zombiesInView)) current_y = self.zombiesInView setHudLocation(current_y, offset);
        if(isdefined(self.zombiesFar)) current_y = self.zombiesFar setHudLocation(current_y, offset);
        if(isburied())
        {
            if(isdefined(self.turbineBattery)) current_y = self.turbineBattery setHudLocation(current_y, offset);
            if(isdefined(self.subwooferKills)) current_y = self.subwooferKills setHudLocation(current_y, offset);
            if(isdefined(self.subwooferKillsAvg)) current_y = self.subwooferKillsAvg setHudLocation(current_y, offset);
        }
        if(isdierise() && isdefined(self.elevatorkills)) current_y = self.elevatorkills setHudLocation(current_y, offset);
        if(isorigins())
        {
            if(isdefined(self.generatorKills)) current_y = self.generatorKills setHudLocation(current_y, offset);
            if(isdefined(self.generatorKillsThisRound)) current_y = self.generatorKillsThisRound setHudLocation(current_y, offset);
            if(isdefined(self.tank_hud)) current_y = self.tank_hud setHudLocation(current_y, offset);
            if(isdefined(self.tumble_hud)) current_y = self.tumble_hud setHudLocation(current_y, offset);
            if(isdefined(self.stomp_hud)) current_y = self.stomp_hud setHudLocation(current_y, offset);
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

get_menu_hud(element)
{
    if (isdefined(self.st_hud) && isdefined(self.st_hud[ element ]))
        return self.st_hud[ element ];

    switch (element)
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

on_hud_menu(action, args)
{
    switch (action)
    {
        case "sync":
            foreach (arg in args)
                self hud_menu_set(arg);
            break;


        case "set":
            if (args.size > 0)
                self hud_menu_set(args[0]);
            break;

    }
}

hud_menu_set(arg)
{
    entry = strtok(arg, ":");
    if (!isdefined(entry) || entry.size < 2)
        return;

    self set_menu_hud(entry[0], int(entry[1]));
}

set_menu_hud(element, value)
{
    if(!isdefined(self.st_hud))
        self.st_hud = [];

    old_value = self get_menu_hud(element);
    self.st_hud[element] = value;

    if(!isdefined(self.has_hud) || !self.has_hud || old_value == value)
        return;

    if(value)
        self start_menu_hud(element);
    else
        self stop_menu_hud(element);
}

startEnabledMenuHUDs()
{
    elements = array("st_boxhits", "st_despawners", "st_healthbar", "st_remaining", "st_sph", "st_zone");
    if(istranzit())
    {
        elements[elements.size] = "st_busloc";
        elements[elements.size] = "st_remaining_denizens";
    }
    else if(isdierise())
    {
        elements[elements.size] = "st_elevatorkills";
    }
    else if(isburied())
    {
        elements[elements.size] = "st_turbinebattery";
        elements[elements.size] = "st_subwooferkills";
    }
    else if(isorigins())
    {
        elements[elements.size] = "st_generatorkills";
        elements[elements.size] = "st_stomp";
        elements[elements.size] = "st_tank";
        elements[elements.size] = "st_tumble";
    }

    foreach(element in elements)
        if(self get_menu_hud(element))
            self start_menu_hud(element);
}

start_menu_hud(element)
{
    switch(element)
    {
        case "st_boxhits":
            if(issurvivalmap()) self thread displayBoxHits();
            break;

        case "st_busloc":
            if(istranzit()) self thread buslocation();
            break;

        case "st_despawners":
            if(!issurvivalmap())
            {
                self thread despawnerCounter();
                self thread anchorLeakCounter();
                self thread zombiesFarAway();
            }
            break;

        case "st_elevatorkills":
            if(isdierise()) self thread displayElevatorKills();
            break;

        case "st_healthbar": self thread healthbar(); break;

        case "st_remaining": self thread remaining(); break;

        case "st_remaining_denizens":
            if(istranzit()) self thread denizensAlive();
            break;

        case "st_sph": self thread sph(); break;

        case "st_stomp":
            if(isorigins()) self thread origins_counter("st_stomp");
            break;

        case "st_turbinebattery":
            if(isburied())
            {
                self thread displayTurbineBattery();
            }

        case "st_subwooferkills":
            if(isburied())
            {
                self thread displaySubwooferKills();
                self thread displaySubwooferKillsAvg();
            }
            break;

        case "st_generatorkills":
            if(isorigins())
            {
                self thread generatorKills();
                self thread generatorKillsThisRound();
            }
            break;

        case "st_tank":
            if(isorigins()) self thread origins_counter("st_tank");
            break;

        case "st_tumble":
            if(isorigins()) self thread origins_counter("st_tumble");
            break;

        case "st_zone": self thread zone(); break;

    }
}

stop_menu_hud(element)
{
    self notify("st_hud_stop_" + element);
    switch(element)
    {
        case "st_boxhits":
            if(isdefined(self.boxhits))
            {
                self.boxhits destroy();
                self.boxhits = undefined;
            }
            if(isdefined(self.total_ray_display))
            {
                self.total_ray_display destroy();
                self.total_ray_display = undefined;
            }
            if(isdefined(self.total_mk2_display))
            {
                self.total_mk2_display destroy();
                self.total_mk2_display = undefined;
            }
            	break;

        case "st_busloc": if(isdefined(self.busloc))
            {
                self.busloc destroy();
                self.busloc = undefined;
            }
			break;

        case "st_despawners":
            if(isdefined(self.despawnersCounter))
            {
                self.despawnersCounter destroy();
                self.despawnersCounter = undefined;
            }
            if(isdefined(self.anchorLeakCounter))
            {
                self.anchorLeakCounter destroy();
                self.anchorLeakCounter = undefined;
            }
            if(isdefined(self.zombiesInView))
            {
                self.zombiesInView destroy();
                self.zombiesInView = undefined;
            }
            if(isdefined(self.zombiesFar))
            {
                self.zombiesFar destroy();
                self.zombiesFar = undefined;
            }
            	break;

        case "st_elevatorkills": if(isdefined(self.elevatorkills))
            {
                self.elevatorkills destroy();
                self.elevatorkills = undefined;
            }
			break;

        case "st_healthbar":
            if(isdefined(self.healthbar))
            {
                if(isdefined(self.healthbar.bar)) self.healthbar.bar destroy();
                if(isdefined(self.healthbar.barframe)) self.healthbar.barframe destroy();
                self.healthbar destroy();
                self.healthbar = undefined;
            }
            if(isdefined(self.healthbar_text))
            {
                self.healthbar_text destroy();
                self.healthbar_text = undefined;
            }
            	break;

        case "st_remaining": if(isdefined(self.zombie_counter_hud))
            {
                self.zombie_counter_hud destroy();
                self.zombie_counter_hud = undefined;
            }
			break;

        case "st_remaining_denizens": if(isdefined(self.denizen_counter))
            {
                self.denizen_counter destroy();
                self.denizen_counter = undefined;
            }
			break;

        case "st_sph": if(isdefined(self.sph))
            {
                self.sph destroy();
                self.sph = undefined;
            }
			break;

        case "st_stomp": if(isdefined(self.stomp_hud))
            {
                self.stomp_hud destroy();
                self.stomp_hud = undefined;
            }
			break;

        case "st_subwooferkills":
            if(isdefined(self.subwooferKills))
            {
                self.subwooferKills destroy();
                self.subwooferKills = undefined;
            }
            if(isdefined(self.subwooferKillsAvg))
            {
                self.subwooferKillsAvg destroy();
                self.subwooferKillsAvg = undefined;
            }
            	break;

        case "st_generatorkills":
            if(isdefined(self.generatorKills))
            {
                self.generatorKills destroy();
                self.generatorKills = undefined;
            }
            if(isdefined(self.generatorKillsThisRound))
            {
                self.generatorKillsThisRound destroy();
                self.generatorKillsThisRound = undefined;
            }
            	break;

        case "st_tank": if(isdefined(self.tank_hud))
            {
                self.tank_hud destroy();
                self.tank_hud = undefined;
            }
			break;

        case "st_tumble": if(isdefined(self.tumble_hud))
            {
                self.tumble_hud destroy();
                self.tumble_hud = undefined;
            }
			break;

        case "st_zone": if(isdefined(self.st_zone_hud))
            {
                self.st_zone_hud destroy();
                self.st_zone_hud = undefined;
            }
			break;
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
    self set_menu_hud("st_turbinebattery",      getDvarInt("st_turbinebattery"));
    self set_menu_hud("st_subwooferkills",      getDvarInt("st_subwooferkills"));
    self set_menu_hud("st_generatorkills",      getDvarInt("st_generatorkills"));
    self set_menu_hud("st_tank",     		    getDvarInt("st_tank"));
    self set_menu_hud("st_tumble",     		    getDvarInt("st_tumble"));
    self set_menu_hud("st_zone",                getDvarInt("st_zone"));
}