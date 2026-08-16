#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\utility;

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
    while(true)
    {
        level waittill("dvar_st_busstatus_changed");

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
