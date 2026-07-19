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