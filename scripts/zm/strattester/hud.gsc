#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;

st_sph()
{
	self.sph = newclienthudelem(self);
	self.sph.fontscale = 1.7;
	self.sph.color = (0.8, 0.8, 0.8);
	self.sph.hidewheninmenu = 1;
	self.sph.x = 2;
	self.sph.y = 75;
	self.sph.alpha = getDvarInt("st_sph");
	self.sph.label = &"ST_SPH_HUD";
	self.sph.alignx = "left";
	self.sph.aligny = "top";
	self.sph.horzalign = "user_left";
	self.sph.vertalign = "user_top";
	self.sph setvalue(0);

	level waittill("start_of_round");
	while(isdefined(level.countdown_hud))
		wait 0.1;
	self.sph.time_start = gettime() / 1000;
	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	self.sph.kills = 0;
	foreach(player in level.players)
		player.last_kills_check = 0;
    self thread updateSPH();

	while (true) 
	{
		level waittill("start_of_round");
		self.sph.time_start = gettime() / 1000;
    	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	}
}

updateSPH()
{
    while (true) 
	{
        wait 0.1;
        time = gettime() / 1000;
        self.sph.time_elapsed = int(time - self.sph.time_start);
		self.sph.kills = self.sph.zombies_total_start - (maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total);
        self.sph.hordas_fraction = self.sph.kills / 24.0;
        if (self.sph.hordas_fraction > 0)
            self.sph.sph_value = self.sph.time_elapsed / self.sph.hordas_fraction;
        else
            self.sph.sph_value = 0;
        self.sph setvalue(self.sph.sph_value);
		self.sph.alpha = getDvarInt("st_sph");
    }
}

health_bar_hud()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	self.health_bar = self createprimaryprogressbar();
	self.health_bar.hidewheninmenu = 1;
	self.health_bar.bar.hidewheninmenu = 1;
	self.health_bar.barframe.hidewheninmenu = 1;
	self.health_bar_text = self createprimaryprogressbartext();
	self.health_bar_text.hidewheninmenu = 1;
	
	self.health_bar setpoint(undefined, "BOTTOM", 0, 15);
	self.health_bar_text setpoint(undefined, "BOTTOM", 75, 15);

	while(true)
	{
		if(!getDvarInt("st_healthbar"))
		{
			self.health_bar.alpha = 0;
			self.health_bar.bar.alpha = 0;
			self.health_bar.barframe.alpha = 0;
			self.health_bar_text.alpha = 0;
			while(!getDvarInt("st_healthbar"))
				wait 0.1;
		}
		if (isDefined(self.e_afterlife_corpse))
		{
			if (self.health_bar.alpha != 0)
			{
				self.health_bar.alpha = 0;
				self.health_bar.bar.alpha = 0;
				self.health_bar.barframe.alpha = 0;
				self.health_bar_text.alpha = 0;
			}
			
			wait 0.05;
			continue;
		}

		if (self.health_bar.alpha != 1)
		{
			self.health_bar.alpha = 1;
			self.health_bar.bar.alpha = 1;
			self.health_bar.barframe.alpha = 1;
			self.health_bar_text.alpha = 1;
		}

		self.health_bar updatebar (self.health / self.maxhealth);
		self.health_bar_text setvalue(self.health);
		self.health_bar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
		wait 0.05;
	}
}


denizens_alive()
{
	self endon( "disconnect" );
	level endon( "end_game" );

    self.denizen_counter = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.denizen_counter maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 205);
	self.denizen_counter.hidewheninmenu = 1;
    self.denizen_counter.alpha = 0;
    self.denizen_counter.label = &"ST_DENIZENS_HUD";

    while(true)
    {
        self.denizen_counter setValue(level.zombie_screecher_count);
		self.denizen_counter.alpha = getDvarInt("st_remaining_denizens");
        wait 0.05; 
    }
}

zombies_remaining()
{
	self endon( "disconnect" );
	level endon( "end_game" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 190 );
	self.zombie_counter_hud.hidewheninmenu = 1;
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"ST_REMAINING_HUD";

    while(true)
    {
        self.zombie_counter_hud setValue((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total));
		self.zombie_counter_hud.alpha = getDvarInt("st_remaining");
        wait 0.05; 
    }
}

zone_hud()
{
	self endon("disconnect");

    self.st_zone_hud = createserverfontstring( "objective", 1.3 );
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

	flag_wait( "initial_blackscreen_passed" );

	self thread zone_hud_watcher();
}

zone_hud_watcher()
{	
	self endon("disconnect");
	level endon( "end_game" );

	prev_zone = "";
	while(true)
	{
		wait 0.05;

		while( getDvarInt("st_zone") )
		{
			self.zone_hud.alpha = 1;

			zone = self get_zone_name();
			if(prev_zone != zone)
			{
				prev_zone = zone;

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 0;
				wait 0.2;

				self.zone_hud settext(zone);

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 1;
				wait 0.15;
			}

			wait 0.05;
		}
		self.zone_hud.alpha = 0;
	}
}

get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
		return "";

	name = "^3";
	if(isorigins())
		switch (zone)
		{
			case "zone_start": self.st_zone_hud.label = &"ZONE_LOWER_LABORATORY"; break;
			case "zone_start_a": self.st_zone_hud.label = &"ZONE_UPPER_LABORATORY"; break;
			case "zone_start_b": self.st_zone_hud.label = &"ZONE_GENERATOR_1"; break;
			case "zone_bunker_1a": self.st_zone_hud.label = &"ZONE_GENERATOR_3_BUNKER_1"; break;
			case "zone_fire_stairs": self.st_zone_hud.label = &"ZONE_FIRE_TUNNEL"; break;
			case "zone_bunker_1": self.st_zone_hud.label = &"ZONE_GENERATOR_3_BUNKER_2"; break;
			case "zone_bunker_3a": self.st_zone_hud.label = &"ZONE_GENERATOR_3"; break;
			case "zone_bunker_3b": self.st_zone_hud.label = &"ZONE_GENERATOR_3_BUNKER_3"; break;
			case "zone_bunker_2a": self.st_zone_hud.label = &"ZONE_GENERATOR_2_BUNKER_1"; break;
			case "zone_bunker_2": self.st_zone_hud.label = &"ZONE_GENERATOR_2_BUNKER_2"; break;
			case "zone_bunker_4a": self.st_zone_hud.label = &"ZONE_GENERATOR_2"; break;
			case "zone_bunker_4b": self.st_zone_hud.label = &"ZONE_GENERATOR_2_BUNKER_3"; break;
			case "zone_bunker_4c": self.st_zone_hud.label = &"ZONE_TANK_STATION"; break;
			case "zone_bunker_4d": self.st_zone_hud.label = &"ZONE_ABOVE_TANK_STATION"; break;
			case "zone_bunker_tank_c": self.st_zone_hud.label = &"ZONE_GENERATOR_2_TANK_ROUTE_1"; break;
			case "zone_bunker_tank_c1": self.st_zone_hud.label = &"ZONE_GENERATOR_2_TANK_ROUTE_2"; break;
			case "zone_bunker_4e": self.st_zone_hud.label = &"ZONE_GENERATOR_2_TANK_ROUTE_3"; break;
			case "zone_bunker_tank_d": self.st_zone_hud.label = &"ZONE_GENERATOR_2_TANK_ROUTE_4"; break;
			case "zone_bunker_tank_d1": self.st_zone_hud.label = &"ZONE_GENERATOR_2_TANK_ROUTE_5"; break;
			case "zone_bunker_4f": self.st_zone_hud.label = &"ZONE_ZONE_BUNKER_4F"; break;
			case "zone_bunker_5a": self.st_zone_hud.label = &"ZONE_WORKSHOP_DOWNSTAIRS"; break;
			case "zone_bunker_5b": self.st_zone_hud.label = &"ZONE_WORKSHOP_UPSTAIRS"; break;
			case "zone_nml_2a": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_WALKWAY"; break;
			case "zone_nml_2": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_ENTRANCE"; break;
			case "zone_bunker_tank_e": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TANK_ROUTE_1"; break;
			case "zone_bunker_tank_e1": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TANK_ROUTE_2"; break;
			case "zone_bunker_tank_e2": self.st_zone_hud.label = &"ZONE_ZONE_BUNKER_TANK_E2"; break;
			case "zone_bunker_tank_f": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TANK_ROUTE_3"; break;
			case "zone_nml_1": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TANK_ROUTE_4"; break;
			case "zone_nml_4": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TANK_ROUTE_5"; break;
			case "zone_nml_0": self.st_zone_hud.label = &"ZONE_GENERATOR_5_LEFT_FOOTSTEP"; break;
			case "zone_nml_5": self.st_zone_hud.label = &"ZONE_GENERATOR_5_RIGHT_FOOTSTEP_WALKWAY"; break;
			case "zone_nml_farm": self.st_zone_hud.label = &"ZONE_GENERATOR_5"; break;
			case "zone_nml_celllar": self.st_zone_hud.label = &"ZONE_GENERATOR_5_CELLAR"; break;
			case "zone_bolt_stairs": self.st_zone_hud.label = &"ZONE_LIGHTNING_TUNNEL"; break;
			case "zone_nml_3": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_1ST_RIGHT_FOOTSTEP"; break;
			case "zone_nml_2b": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_STAIRS"; break;
			case "zone_nml_6": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_LEFT_FOOTSTEP"; break;
			case "zone_nml_8": self.st_zone_hud.label = &"ZONE_NO_MANS_LAND_2ND_RIGHT_FOOTSTEP"; break;
			case "zone_nml_10a": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_1"; break;
			case "zone_nml_10": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_2"; break;
			case "zone_nml_7": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_3"; break;
			case "zone_bunker_tank_a": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_4"; break;
			case "zone_bunker_tank_a1": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_5"; break;
			case "zone_bunker_tank_a2": self.st_zone_hud.label = &"ZONE_ZONE_BUNKER_TANK_A2"; break;
			case "zone_bunker_tank_b": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TANK_ROUTE_6"; break;
			case "zone_nml_9": self.st_zone_hud.label = &"ZONE_GENERATOR_4_LEFT_FOOTSTEP"; break;
			case "zone_air_stairs": self.st_zone_hud.label = &"ZONE_WIND_TUNNEL"; break;
			case "zone_nml_11": self.st_zone_hud.label = &"ZONE_GENERATOR_4"; break;
			case "zone_nml_12": self.st_zone_hud.label = &"ZONE_GENERATOR_4_RIGHT_FOOTSTEP"; break;
			case "zone_nml_16": self.st_zone_hud.label = &"ZONE_EXCAVATION_SITE_FRONT_PATH"; break;
			case "zone_nml_17": self.st_zone_hud.label = &"ZONE_EXCAVATION_SITE_BACK_PATH"; break;
			case "zone_nml_18": self.st_zone_hud.label = &"ZONE_EXCAVATION_SITE_LEVEL_3"; break;
			case "zone_nml_19": self.st_zone_hud.label = &"ZONE_EXCAVATION_SITE_LEVEL_2"; break;
			case "ug_bottom_zone": self.st_zone_hud.label = &"ZONE_EXCAVATION_SITE_LEVEL_1"; break;
			case "zone_nml_13": self.st_zone_hud.label = &"ZONE_GENERATOR_5_TO_GENERATOR_6_PATH"; break;
			case "zone_nml_14": self.st_zone_hud.label = &"ZONE_GENERATOR_4_TO_GENERATOR_6_PATH"; break;
			case "zone_nml_15": self.st_zone_hud.label = &"ZONE_GENERATOR_6_ENTRANCE"; break;
			case "zone_village_0": self.st_zone_hud.label = &"ZONE_GENERATOR_6_LEFT_FOOTSTEP"; break;
			case "zone_village_5": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_1"; break;
			case "zone_village_5a": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_2"; break;
			case "zone_village_5b": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_3"; break;
			case "zone_village_1": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_4"; break;
			case "zone_village_4b": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_5"; break;
			case "zone_village_4a": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_6"; break;
			case "zone_village_4": self.st_zone_hud.label = &"ZONE_GENERATOR_6_TANK_ROUTE_7"; break;
			case "zone_village_2": self.st_zone_hud.label = &"ZONE_CHURCH"; break;
			case "zone_village_3": self.st_zone_hud.label = &"ZONE_GENERATOR_6_RIGHT_FOOTSTEP"; break;
			case "zone_village_3a": self.st_zone_hud.label = &"ZONE_GENERATOR_6"; break;
			case "zone_ice_stairs": self.st_zone_hud.label = &"ZONE_ICE_TUNNEL"; break;
			case "zone_bunker_6": self.st_zone_hud.label = &"ZONE_ABOVE_GENERATOR_3_BUNKER"; break;
			case "zone_nml_20": self.st_zone_hud.label = &"ZONE_ABOVE_NO_MANS_LAND"; break;
			case "zone_village_6": self.st_zone_hud.label = &"ZONE_BEHIND_CHURCH"; break;
			case "zone_chamber_0": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_LIGHTNING_CHAMBER"; break;
			case "zone_chamber_1": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_LIGHTNING_ICE"; break;
			case "zone_chamber_2": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_ICE_CHAMBER"; break;
			case "zone_chamber_3": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_FIRE_LIGHTNING"; break;
			case "zone_chamber_4": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_CENTER"; break;
			case "zone_chamber_5": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_ICE_WIND"; break;
			case "zone_chamber_6": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_FIRE_CHAMBER"; break;
			case "zone_chamber_7": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_WIND_FIRE"; break;
			case "zone_chamber_8": self.st_zone_hud.label = &"ZONE_THE_CRAZY_PLACE_WIND_CHAMBER"; break;
			case "zone_robot_head": self.st_zone_hud.label = &"ZONE_ROBOTS_HEAD"; break;
		}
	if(name != "^3")
		return name;
	if(isburied())
		switch (zone)
		{
			case "zone_start": self.st_zone_hud.label = &"ZONE_PROCESSING"; break;
			case "zone_start_lower": self.st_zone_hud.label = &"ZONE_LOWER_PROCESSING"; break;
			case "zone_tunnels_center": self.st_zone_hud.label = &"ZONE_CENTER_TUNNELS"; break;
			case "zone_tunnels_north": self.st_zone_hud.label = &"ZONE_COURTHOUSE_TUNNELS_2"; break;
			case "zone_tunnels_north2": self.st_zone_hud.label = &"ZONE_COURTHOUSE_TUNNELS_1"; break;
			case "zone_tunnels_south": self.st_zone_hud.label = &"ZONE_SALOON_TUNNELS_3"; break;
			case "zone_tunnels_south2": self.st_zone_hud.label = &"ZONE_SALOON_TUNNELS_2"; break;
			case "zone_tunnels_south3": self.st_zone_hud.label = &"ZONE_SALOON_TUNNELS_1"; break;
			case "zone_street_lightwest": self.st_zone_hud.label = &"ZONE_OUTSIDE_GENERAL_STORE_BANK"; break;
			case "zone_street_lightwest_alley": self.st_zone_hud.label = &"ZONE_OUTSIDE_GENERAL_STORE_BANK_ALLEY"; break;
			case "zone_morgue_upstairs": self.st_zone_hud.label = &"ZONE_MORGUE"; break;
			case "zone_underground_jail": self.st_zone_hud.label = &"ZONE_JAIL_DOWNSTAIRS"; break;
			case "zone_underground_jail2": self.st_zone_hud.label = &"ZONE_JAIL_UPSTAIRS"; break;
			case "zone_general_store": self.st_zone_hud.label = &"ZONE_GENERAL_STORE"; break;
			case "zone_stables": self.st_zone_hud.label = &"ZONE_STABLES"; break;
			case "zone_street_darkwest": self.st_zone_hud.label = &"ZONE_OUTSIDE_GUNSMITH"; break;
			case "zone_street_darkwest_nook": self.st_zone_hud.label = &"ZONE_OUTSIDE_GUNSMITH_NOOK"; break;
			case "zone_gun_store": self.st_zone_hud.label = &"ZONE_GUNSMITH"; break;
			case "zone_bank": self.st_zone_hud.label = &"ZONE_BANK"; break;
			case "zone_tunnel_gun2stables": self.st_zone_hud.label = &"ZONE_STABLES_TO_GUNSMITH_TUNNEL_2"; break;
			case "zone_tunnel_gun2stables2": self.st_zone_hud.label = &"ZONE_STABLES_TO_GUNSMITH_TUNNEL"; break;
			case "zone_street_darkeast": self.st_zone_hud.label = &"ZONE_OUTSIDE_SALOON_TOY_STORE"; break;
			case "zone_street_darkeast_nook": self.st_zone_hud.label = &"ZONE_OUTSIDE_SALOON_TOY_STORE_NOOK"; break;
			case "zone_underground_bar": self.st_zone_hud.label = &"ZONE_SALOON"; break;
			case "zone_tunnel_gun2saloon": self.st_zone_hud.label = &"ZONE_SALOON_TO_GUNSMITH_TUNNEL"; break;
			case "zone_toy_store": self.st_zone_hud.label = &"ZONE_TOY_STORE_DOWNSTAIRS"; break;
			case "zone_toy_store_floor2": self.st_zone_hud.label = &"ZONE_TOY_STORE_UPSTAIRS"; break;
			case "zone_toy_store_tunnel": self.st_zone_hud.label = &"ZONE_TOY_STORE_TUNNEL"; break;
			case "zone_candy_store": self.st_zone_hud.label = &"ZONE_CANDY_STORE_DOWNSTAIRS"; break;
			case "zone_candy_store_floor2": self.st_zone_hud.label = &"ZONE_CANDY_STORE_UPSTAIRS"; break;
			case "zone_street_lighteast": self.st_zone_hud.label = &"ZONE_OUTSIDE_COURTHOUSE_CANDY_STORE"; break;
			case "zone_underground_courthouse": self.st_zone_hud.label = &"ZONE_COURTHOUSE_DOWNSTAIRS"; break;
			case "zone_underground_courthouse2": self.st_zone_hud.label = &"ZONE_COURTHOUSE_UPSTAIRS"; break;
			case "zone_street_fountain": self.st_zone_hud.label = &"ZONE_FOUNTAIN"; break;
			case "zone_church_graveyard": self.st_zone_hud.label = &"ZONE_GRAVEYARD"; break;
			case "zone_church_main": self.st_zone_hud.label = &"ZONE_CHURCH_DOWNSTAIRS"; break;
			case "zone_church_upstairs": self.st_zone_hud.label = &"ZONE_CHURCH_UPSTAIRS"; break;
			case "zone_mansion_lawn": self.st_zone_hud.label = &"ZONE_MANSION_LAWN"; break;
			case "zone_mansion": self.st_zone_hud.label = &"ZONE_MANSION"; break;
			case "zone_mansion_backyard": self.st_zone_hud.label = &"ZONE_MANSION_BACKYARD"; break;
			case "zone_maze": self.st_zone_hud.label = &"ZONE_MAZE"; break;
			case "zone_maze_staircase": self.st_zone_hud.label = &"ZONE_MAZE_STAIRCASE"; break;
		}
	if(name != "^3")
		return name;
	if(isdierise())
	switch (zone)
		{
			case "zone_green_start": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_3B"; break;
			case "zone_green_escape_pod": self.st_zone_hud.label = &"ZONE_ESCAPE_POD"; break;
			case "zone_green_escape_pod_ground": self.st_zone_hud.label = &"ZONE_ESCAPE_POD_SHAFT"; break;
			case "zone_green_level1": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_3A"; break;
			case "zone_green_level2a": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_2A"; break;
			case "zone_green_level2b": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_2B"; break;
			case "zone_green_level3a": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_RESTAURANT"; break;
			case "zone_green_level3b": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_1A"; break;
			case "zone_green_level3c": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_LEVEL_1B"; break;
			case "zone_green_level3d": self.st_zone_hud.label = &"ZONE_GREEN_HIGHRISE_BEHIND_RESTAURANT"; break;
			case "zone_orange_level1": self.st_zone_hud.label = &"ZONE_UPPER_ORANGE_HIGHRISE_LEVEL_2"; break;
			case "zone_orange_level2": self.st_zone_hud.label = &"ZONE_UPPER_ORANGE_HIGHRISE_LEVEL_1"; break;
			case "zone_orange_elevator_shaft_top": self.st_zone_hud.label = &"ZONE_ELEVATOR_SHAFT_LEVEL_3"; break;
			case "zone_orange_elevator_shaft_middle_1": self.st_zone_hud.label = &"ZONE_ELEVATOR_SHAFT_LEVEL_2"; break;
			case "zone_orange_elevator_shaft_middle_2": self.st_zone_hud.label = &"ZONE_ELEVATOR_SHAFT_LEVEL_1"; break;
			case "zone_orange_elevator_shaft_bottom": self.st_zone_hud.label = &"ZONE_ELEVATOR_SHAFT_BOTTOM"; break;
			case "zone_orange_level3a": self.st_zone_hud.label = &"ZONE_LOWER_ORANGE_HIGHRISE_LEVEL_1A"; break;
			case "zone_orange_level3b": self.st_zone_hud.label = &"ZONE_LOWER_ORANGE_HIGHRISE_LEVEL_1B"; break;
			case "zone_blue_level5": self.st_zone_hud.label = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_1"; break;
			case "zone_blue_level4a": self.st_zone_hud.label = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2A"; break;
			case "zone_blue_level4b": self.st_zone_hud.label = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2B"; break;
			case "zone_blue_level4c": self.st_zone_hud.label = &"ZONE_LOWER_BLUE_HIGHRISE_LEVEL_2C"; break;
			case "zone_blue_level2a": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1A"; break;
			case "zone_blue_level2b": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1B"; break;
			case "zone_blue_level2c": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1C"; break;
			case "zone_blue_level2d": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_1D"; break;
			case "zone_blue_level1a": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2A"; break;
			case "zone_blue_level1b": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2B"; break;
			case "zone_blue_level1c": self.st_zone_hud.label = &"ZONE_UPPER_BLUE_HIGHRISE_LEVEL_2C"; break;
		}
	if(name != "^3")
		return name;
	if(isnuketown())
	{
		switch (zone)
		{
			case "culdesac_yellow_zone": self.st_zone_hud.label = &"ZONE_YELLOW_HOUSE_MIDDLE"; break;
			case "culdesac_green_zone": self.st_zone_hud.label = &"ZONE_GREEN_HOUSE_MIDDLE"; break;
			case "truck_zone": self.st_zone_hud.label = &"ZONE_TRUCK"; break;
			case "openhouse1_f1_zone": self.st_zone_hud.label = &"ZONE_GREEN_HOUSE_DOWNSTAIRS"; break;
			case "openhouse1_f2_zone": self.st_zone_hud.label = &"ZONE_GREEN_HOUSE_UPSTAIRS"; break;
			case "openhouse1_backyard_zone": self.st_zone_hud.label = &"ZONE_GREEN_HOUSE_BACKYARD"; break;
			case "openhouse2_f1_zone": self.st_zone_hud.label = &"ZONE_YELLOW_HOUSE_DOWNSTAIRS"; break;
			case "openhouse2_f2_zone": self.st_zone_hud.label = &"ZONE_YELLOW_HOUSE_UPSTAIRS"; break;
			case "openhouse2_backyard_zone": self.st_zone_hud.label = &"ZONE_YELLOW_HOUSE_BACKYARD"; break;
			case "ammo_door_zone": self.st_zone_hud.label = &"ZONE_YELLOW_HOUSE_BACKYARD_DOOR"; break;
		}
	}
	if(name != "^3")
		return name;
	if(ismob())
		switch (zone)
		{
			case "zone_start": self.st_zone_hud.label = &"ZONE_DBLOCK"; break;
			case "zone_library": self.st_zone_hud.label = &"ZONE_LIBRARY"; break;
			case "zone_cellblock_west": self.st_zone_hud.label = &"ZONE_CELLBLOCK_2ND_FLOOR"; break;
			case "zone_cellblock_west_gondola": self.st_zone_hud.label = &"ZONE_CELLBLOCK_3RD_FLOOR"; break;
			case "zone_cellblock_west_gondola_dock": self.st_zone_hud.label = &"ZONE_CELLBLOCK_GONDOLA"; break;
			case "zone_cellblock_west_barber": self.st_zone_hud.label = &"ZONE_MICHIGAN_AVENUE"; break;
			case "zone_cellblock_east": self.st_zone_hud.label = &"ZONE_TIMES_SQUARE"; break;
			case "zone_cafeteria": self.st_zone_hud.label = &"ZONE_CAFETERIA"; break;
			case "zone_cafeteria_end": self.st_zone_hud.label = &"ZONE_CAFETERIA_END"; break;
			case "zone_infirmary": self.st_zone_hud.label = &"ZONE_INFIRMARY_1"; break;
			case "zone_infirmary_roof": self.st_zone_hud.label = &"ZONE_INFIRMARY_2"; break;
			case "zone_roof_infirmary": self.st_zone_hud.label = &"ZONE_ROOF_1"; break;
			case "zone_roof": self.st_zone_hud.label = &"ZONE_ROOF_2"; break;
			case "zone_cellblock_west_warden": self.st_zone_hud.label = &"ZONE_SALLY_PORT"; break;
			case "zone_warden_office": self.st_zone_hud.label = &"ZONE_WARDENS_OFFICE"; break;
			case "cellblock_shower": self.st_zone_hud.label = &"ZONE_SHOWERS"; break;
			case "zone_citadel_shower": self.st_zone_hud.label = &"ZONE_CITADEL_TO_SHOWERS"; break;
			case "zone_citadel": self.st_zone_hud.label = &"ZONE_CITADEL"; break;
			case "zone_citadel_warden": self.st_zone_hud.label = &"ZONE_CITADEL_TO_WARDENS_OFFICE"; break;
			case "zone_citadel_stairs": self.st_zone_hud.label = &"ZONE_CITADEL_TUNNELS"; break;
			case "zone_citadel_basement": self.st_zone_hud.label = &"ZONE_CITADEL_BASEMENT"; break;
			case "zone_citadel_basement_building": self.st_zone_hud.label = &"ZONE_CHINA_ALLEY"; break;
			case "zone_studio": self.st_zone_hud.label = &"ZONE_BUILDING_64"; break;
			case "zone_dock": self.st_zone_hud.label = &"ZONE_DOCKS"; break;
			case "zone_dock_puzzle": self.st_zone_hud.label = &"ZONE_DOCKS_GATES"; break;
			case "zone_dock_gondola": self.st_zone_hud.label = &"ZONE_UPPER_DOCKS"; break;
			case "zone_golden_gate_bridge": self.st_zone_hud.label = &"ZONE_GOLDEN_GATE_BRIDGE"; break;
			case "zone_gondola_ride": self.st_zone_hud.label = &"ZONE_GONDOLA"; break;
			default: self.st_zone_hud.label = &"ZONE_UNKNOWN_ZONE"; break;
		}
	if(name != "^3")
		return name;
	if(istranzit() || isdepot() || istown() || isfarm())
		switch (zone)
		{
			case "zone_pri": self.st_zone_hud.label = &"ZONE_BUS_DEPOT"; break;
			case "zone_pri2": self.st_zone_hud.label = &"ZONE_BUS_DEPOT_HALLWAY"; break;
			case "zone_station_ext": self.st_zone_hud.label = &"ZONE_OUTSIDE_BUS_DEPOT"; break;
			case "zone_trans_2b": self.st_zone_hud.label = &"ZONE_FOG_AFTER_BUS_DEPOT"; break;
			case "zone_trans_2": self.st_zone_hud.label = &"ZONE_TUNNEL_ENTRANCE"; break;
			case "zone_amb_tunnel": self.st_zone_hud.label = &"ZONE_TUNNEL"; break;
			case "zone_trans_3": self.st_zone_hud.label = &"ZONE_TUNNEL_EXIT"; break;
			case "zone_roadside_west": self.st_zone_hud.label = &"ZONE_OUTSIDE_DINER"; break;
			case "zone_gas": self.st_zone_hud.label = &"ZONE_GAS_STATION"; break;
			case "zone_roadside_east": self.st_zone_hud.label = &"ZONE_OUTSIDE_GARAGE"; break;
			case "zone_trans_diner": self.st_zone_hud.label = &"ZONE_FOG_OUTSIDE_DINER"; break;
			case "zone_trans_diner2": self.st_zone_hud.label = &"ZONE_FOG_OUTSIDE_GARAGE"; break;
			case "zone_gar": self.st_zone_hud.label = &"ZONE_GARAGE"; break;
			case "zone_din": self.st_zone_hud.label = &"ZONE_DINER"; break;
			case "zone_diner_roof": self.st_zone_hud.label = &"ZONE_DINER_ROOF"; break;
			case "zone_trans_4": self.st_zone_hud.label = &"ZONE_FOG_AFTER_DINER"; break;
			case "zone_amb_forest": self.st_zone_hud.label = &"ZONE_FOREST"; break;
			case "zone_trans_10": self.st_zone_hud.label = &"ZONE_OUTSIDE_CHURCH"; break;
			case "zone_town_church": self.st_zone_hud.label = &"ZONE_CHURCH"; break;
			case "zone_trans_5": self.st_zone_hud.label = &"ZONE_FOG_BEFORE_FARM"; break;
			case "zone_far": self.st_zone_hud.label = &"ZONE_OUTSIDE_FARM"; break;
			case "zone_far_ext": self.st_zone_hud.label = &"ZONE_FARM"; break;
			case "zone_brn": self.st_zone_hud.label = &"ZONE_BARN"; break;
			case "zone_farm_house": self.st_zone_hud.label = &"ZONE_FARMHOUSE"; break;
			case "zone_trans_6": self.st_zone_hud.label = &"ZONE_FOG_AFTER_FARM"; break;
			case "zone_amb_cornfield": self.st_zone_hud.label = &"ZONE_CORNFIELD"; break;
			case "zone_cornfield_prototype": self.st_zone_hud.label = &"ZONE_NACHT"; break;
			case "zone_trans_7": self.st_zone_hud.label = &"ZONE_UPPER_FOG_BEFORE_POWER"; break;
			case "zone_pow_ext1": self.st_zone_hud.label = &"ZONE_ZONE_POW_EXT1"; break;
			case "zone_trans_pow_ext1": self.st_zone_hud.label = &"ZONE_FOG_BEFORE_POWER"; break;
			case "zone_pow": self.st_zone_hud.label = &"ZONE_OUTSIDE_POWER_STATION"; break;
			case "zone_prr": self.st_zone_hud.label = &"ZONE_POWER_STATION"; break;
			case "zone_pcr": self.st_zone_hud.label = &"ZONE_POWER_CONTROL_ROOM"; break;
			case "zone_pow_warehouse": self.st_zone_hud.label = &"ZONE_WAREHOUSE"; break;
			case "zone_trans_8": self.st_zone_hud.label = &"ZONE_FOG_AFTER_POWER"; break;
			case "zone_amb_power2town": self.st_zone_hud.label = &"ZONE_CABIN"; break;
			case "zone_trans_9": self.st_zone_hud.label = &"ZONE_FOG_BEFORE_TOWN"; break;
			case "zone_town_north": self.st_zone_hud.label = &"ZONE_NORTH_TOWN"; break;
			case "zone_tow": self.st_zone_hud.label = &"ZONE_CENTER_TOWN"; break;
			case "zone_town_east": self.st_zone_hud.label = &"ZONE_EAST_TOWN"; break;
			case "zone_town_west": self.st_zone_hud.label = &"ZONE_WEST_TOWN"; break;
			case "zone_town_west2": self.st_zone_hud.label = &"ZONE_WEST_TOWN2"; break;
			case "zone_town_south": self.st_zone_hud.label = &"ZONE_SOUTH_TOWN"; break;
			case "zone_bar": self.st_zone_hud.label = &"ZONE_BAR"; break;
			case "zone_town_barber": self.st_zone_hud.label = &"ZONE_BOOKSTORE"; break;
			case "zone_ban": self.st_zone_hud.label = &"ZONE_BANK"; break;
			case "zone_ban_vault": self.st_zone_hud.label = &"ZONE_BANK_VAULT"; break;
			case "zone_tbu": self.st_zone_hud.label = &"ZONE_BELOW_BANK"; break;
			case "zone_trans_11": self.st_zone_hud.label = &"ZONE_FOG_AFTER_TOWN"; break;
			case "zone_amb_bridge": self.st_zone_hud.label = &"ZONE_BRIDGE"; break;
			case "zone_trans_1": self.st_zone_hud.label = &"ZONE_FOG_BEFORE_BUS_DEPOT"; break;
			case "zone_bunker_4c": self.st_zone_hud.label = &"ZONE_TANK_STATION"; break;
			case "zone_bunker_4d": self.st_zone_hud.label = &"ZONE_ABOVE_TANK_STATION"; break;
		}
    return name;
}