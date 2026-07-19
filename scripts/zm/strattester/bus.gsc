#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\utility;

busloc()
{
	level.busloc.hidewheninmenu = true;
    level.busloc = createserverfontstring( "objective", 1.3 );
    level.busloc.y = 20;
    level.busloc.x = 0;
    level.busloc.fontscale = 1;
    level.busloc.alignx = "center";
    level.busloc.horzalign = "user_center";
    level.busloc.vertalign = "user_top";
    level.busloc.aligny = "top";
    level.busloc.alpha = 1;
    level.busloc.label = " ";
    
	self.bustimer = newclienthudelem(self);
	self.bustimer.alpha = 1;
	self.bustimer.color = (0.505, 0.478, 0.721);
	self.bustimer.hidewheninmenu = 1;
	self.bustimer.fontscale = 1.7;
	self.bustimer settimerup(0);
    self.bustimer.alignx = "right";
    self.bustimer.aligny = "top";
    self.bustimer.horzalign = "user_right";
    self.bustimer.vertalign = "user_top";
    self.bustimer.x = -1;
    while(!isdefined(self.timer))
        wait 0.1;
    self.bustimer.y = self.timer + 30;
	
    while(true)
    {
        wait 0.1;
        self.bustimer.x = self.timer.x;
        self.bustimer.y = self.timer.y + 30;
		self.bustimer.alignx = self.timer.alignx;
		self.bustimer.aligny = self.timer.aligny;
		self.bustimer.horzalign = self.timer.horzalign;
		self.bustimer.vertalign = self.timer.vertalign;
        self.bustimer.alpha = getDvarInt("st_bustimer");
        level.busloc.alpha = getDvarInt("st_busloc");
        zone = level.the_bus get_current_zone();
        if(!isdefined(zone))
            continue;
        switch (zone)
		{
			case "zone_pri": name = &"ZONE_BUS_DEPOT"; break;
			case "zone_pri2": name = &"ZONE_BUS_DEPOT_HALLWAY"; break;
			case "zone_station_ext": name = &"ZONE_OUTSIDE_BUS_DEPOT"; break;
			case "zone_trans_2b": name = &"ZONE_FOG_AFTER_BUS_DEPOT"; break;
			case "zone_trans_2": name = &"ZONE_TUNNEL_ENTRANCE"; break;
			case "zone_amb_tunnel": name = &"ZONE_TUNNEL"; break;
			case "zone_trans_3": name = &"ZONE_TUNNEL_EXIT"; break;
			case "zone_roadside_west": name = &"ZONE_OUTSIDE_DINER"; break;
			case "zone_gas": name = &"ZONE_GAS_STATION"; break;
			case "zone_roadside_east": name = &"ZONE_OUTSIDE_GARAGE"; break;
			case "zone_trans_diner": name = &"ZONE_FOG_OUTSIDE_DINER"; break;
			case "zone_trans_diner2": name = &"ZONE_FOG_OUTSIDE_GARAGE"; break;
			case "zone_gar": name = &"ZONE_GARAGE"; break;
			case "zone_din": name = &"ZONE_DINER"; break;
			case "zone_diner_roof": name = &"ZONE_DINER_ROOF"; break;
			case "zone_trans_4": name = &"ZONE_FOG_AFTER_DINER"; break;
			case "zone_amb_forest": name = &"ZONE_FOREST"; break;
			case "zone_trans_10": name = &"ZONE_OUTSIDE_CHURCH"; break;
			case "zone_town_church": name = &"ZONE_CHURCH"; break;
			case "zone_trans_5": name = &"ZONE_FOG_BEFORE_FARM"; break;
			case "zone_far": name = &"ZONE_OUTSIDE_FARM"; break;
			case "zone_far_ext": name = &"ZONE_FARM"; break;
			case "zone_brn": name = &"ZONE_BARN"; break;
			case "zone_farm_house": name = &"ZONE_FARMHOUSE"; break;
			case "zone_trans_6": name = &"ZONE_FOG_AFTER_FARM"; break;
			case "zone_amb_cornfield": name = &"ZONE_CORNFIELD"; break;
			case "zone_cornfield_prototype": name = &"ZONE_NACHT"; break;
			case "zone_trans_7": name = &"ZONE_UPPER_FOG_BEFORE_POWER"; break;
			case "zone_pow_ext1": name = &"ZONE_ZONE_POW_EXT1"; break;
			case "zone_trans_pow_ext1": name = &"ZONE_FOG_BEFORE_POWER"; break;
			case "zone_pow": name = &"ZONE_OUTSIDE_POWER_STATION"; break;
			case "zone_prr": name = &"ZONE_POWER_STATION"; break;
			case "zone_pcr": name = &"ZONE_POWER_CONTROL_ROOM"; break;
			case "zone_pow_warehouse": name = &"ZONE_WAREHOUSE"; break;
			case "zone_trans_8": name = &"ZONE_FOG_AFTER_POWER"; break;
			case "zone_amb_power2town": name = &"ZONE_CABIN"; break;
			case "zone_trans_9": name = &"ZONE_FOG_BEFORE_TOWN"; break;
			case "zone_town_north": name = &"ZONE_NORTH_TOWN"; break;
			case "zone_tow": name = &"ZONE_CENTER_TOWN"; break;
			case "zone_town_east": name = &"ZONE_EAST_TOWN"; break;
			case "zone_town_west": name = &"ZONE_WEST_TOWN"; break;
			case "zone_town_west2": name = &"ZONE_WEST_TOWN2"; break;
			case "zone_town_south": name = &"ZONE_SOUTH_TOWN"; break;
			case "zone_bar": name = &"ZONE_BAR"; break;
			case "zone_town_barber": name = &"ZONE_BOOKSTORE"; break;
			case "zone_ban": name = &"ZONE_BANK"; break;
			case "zone_ban_vault": name = &"ZONE_BANK_VAULT"; break;
			case "zone_tbu": name = &"ZONE_BELOW_BANK"; break;
			case "zone_trans_11": name = &"ZONE_FOG_AFTER_TOWN"; break;
			case "zone_amb_bridge": name = &"ZONE_BRIDGE"; break;
			case "zone_trans_1": name = &"ZONE_FOG_BEFORE_BUS_DEPOT"; break;
			case "zone_bunker_4c": name = &"ZONE_TANK_STATION"; break;
			case "zone_bunker_4d": name = &"ZONE_ABOVE_TANK_STATION"; break;
		}
        if(isdefined(name))
        level.busloc settext(name);
    }
}

busschedulecreate()
{
    schedule = spawnstruct();
    schedule.destinations = [];
    return schedule;
}

busscheduleadd( stopname, isambush, maxwaittimebeforeleaving, busspeedleaving, gasusage )
{
    assert( isdefined( stopname ) );
    assert( isdefined( isambush ) );
    assert( isdefined( maxwaittimebeforeleaving ) );
    assert( isdefined( busspeedleaving ) );
    destinationindex = self.destinations.size;
    self.destinations[destinationindex] = spawnstruct();
    self.destinations[destinationindex].name = stopname;
    self.destinations[destinationindex].isambush = isambush;
    self.destinations[destinationindex].maxwaittimebeforeleaving = maxwaittimebeforeleaving;
    self.destinations[destinationindex].busspeedleaving = busspeedleaving;
    self.destinations[destinationindex].gasusage = gasusage;
}

busstatus()
{
    dvar = getDvarInt("st_busstatus");
    while(true)
    {
        wait 0.1;
        if(dvar == getDvarInt("st_busstatus"))
            continue;
        dvar = getDvarInt("st_busstatus");

	    if(!isdefined(level.the_bus.off))
		    level.the_bus.off = false;

        if(level.the_bus.targetspeed > 0)
	    {
		    strattesterprint("Stopping bus", "Parando el autobús");
		    level.the_bus.targetspeed = 0;
	    }
	    else
	    {
		    strattesterprint("Starting bus", "Encendiendo el autobús");
		    level.the_bus.targetspeed = 10;
	    }
    }
}