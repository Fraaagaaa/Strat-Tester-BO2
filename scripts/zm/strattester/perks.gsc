#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\strattester\settings;
#include scripts\zm\strattester\utility;

#define JUG_PERK "specialty_armorvest"
#define SPEED_PERK "specialty_fastreload"
#define DT_PERK "specialty_rof"
#define QR_PERK "specialty_quickrevive"
#define STAMIN_PERK "specialty_longersprint"
#define CHERRY_PERK "specialty_grenadepulldeath"
#define MULE_PERK "specialty_additionalprimaryweapon"
#define PHD_PERK "specialty_flakjacket"
#define DEADSHOT_PERK "specialty_deadshot"
#define WHOISWHO_PERK "specialty_finalstand"
#define VULTURE_PERK "specialty_nomotionsensor"

perk_init()
{
	if(self == gethostplayer())
	{
		increase_perk_limit();
		availablePerks();
	}
	self thread give_perks_on_spawn();
	self thread give_perks_on_revive();
	self thread setPerkDvars();
}

increase_perk_limit()
{
	level.perk_purchase_limit = 10;
}

availablePerks()
{
	// all perks:
	//	level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK +  " " + SPEED_PERK + " " + MULE_PERK + " "  + QR_PERK + " " + CHERRY_PERK + " " + PHD_PERK + " " + DEADSHOT_PERK;

	if(isdepot())
		level.available_perks = QR_PERK;

	if(isfarm())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;

	if(istown())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + QR_PERK;

	if(istranzit())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + QR_PERK;

	if(isnuketown())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;

	if(isdierise())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + MULE_PERK +  " " + QR_PERK + " " + WHOISWHO_PERK;

	if(ismob())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + CHERRY_PERK + " " + DEADSHOT_PERK;

	if(isburied())
		level.available_perks = VULTURE_PERK + " " + JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK;

	if(isorigins())
		level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK +  " " + SPEED_PERK + " " + MULE_PERK + " "  + QR_PERK + " " + CHERRY_PERK + " " + PHD_PERK + " " + DEADSHOT_PERK;
}

st_give_perks()
{
	if(!isdefined(level.available_perks))
		println("level.available_perks NOT DEFINED");

	while(!isdefined(level.available_perks))
		wait 0.1;

	perk_array = strtok(level.available_perks, " ");
	foreach( perk in perk_array )
	{
		if(ignorePerk(self.name, perk))
			continue;
		self give_perk(perk, 0 );
		wait 0.05;
	}
}

ignorePerk(who, perk)
{
	return(getDvarInt("st_give_perk_" + perk + "_" + who) == 0);
}

give_perks_on_revive()
{
    if(!getDvarInt("st_perks"))
        return;

	level endon("end_game");
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
        self st_give_perks();
		wait 2;
	}
}

give_perks_on_spawn()
{
	if(!getDvarInt("st_perks"))
		return;


    level waittill("initial_blackscreen_passed");
	if(ismob()) flag_wait("afterlife_start_over");
    wait 0.5;
    self st_give_perks();
}