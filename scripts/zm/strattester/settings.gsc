#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;

#define ON 1
#define OFF 0
#define START_DELAY 30
#define START_ROUND 100
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

settings_init()
{
    self thread createDvars();
	self thread createClientDvars();
}

// createClientDvar(dvar, set)
// {
// 	if(self getClientDvar(dvar) == "")
// 		self createDvar(dvar, set);
// }

createClientDvars()
{
	createDvar("st_zone", 1);
    createDvar("st_despawnersCounter", 0);
	createDvar("st_healthbar", 0);
	createDvar("st_sph", 1);
	createDvar("st_timer", 1);
	createDvar("st_remaining", 1);

	if(ismob())
	{
		createDvar("st_traptimer", 1);
	}
	if(istranzit())
	{
		createDvar("st_busloc", 0);
		createDvar("st_bustimer", 0);
	}
	if(isburied())
	{
    	createDvar("subwooferkills", 0);
	}
	if(isorigins())
	{
		createDvar("st_stomp", 0);
		createDvar("st_tumble", 0);
		createDvar("st_tank", 0);
	}

	perk_array = strtok(level.available_perks, " ");

	foreach(perk in perk_array)
	{
		if(istranzit())
		{
			if(perk == DT_PERK)
			{
				self createDvar("st_give_perk_" + perk, 0);
				continue;
			}
		}
		if(istown())
		{
			if(perk == JUG_PERK)
			{
				self createDvar("st_give_perk_" + perk, getDvarInt("st_jug_setup"));
				continue;
			}
			if(perk == SPEED_PERK)
			{
				self createDvar("st_give_perk_" + perk, !getDvarInt("st_jug_setup"));
				continue;
			}
		}
		if(isdierise())
		{
			if(perk == WHOISWHO_PERK)
			{
				self createDvar("st_give_perk_" + perk, 0);
				continue;
			}
		}
		if(ismob())
		{
			if(perk == DEADSHOT_PERK)
			{
				self createDvar("st_give_perk_" + perk, 0);
				continue;
			}
		}
		if(isburied())
		{
			if(perk == VULTURE_PERK)
			{
				self createDvar("st_give_perk_" + perk, 0);
				continue;
			}
		}
		if(isorigins())
		{
			if(perk == DEADSHOT_PERK)
			{
				self createDvar("st_give_perk_" + perk, 0);
				continue;
			}
			if(perk == CHERRY_PERK)
			{
				self createDvar("st_give_perk_" + perk, getDvarInt("st_cherry_origins"));
				continue;
			}
		}
		self createDvar("st_give_perk_" + perk, 1);
	}
}


createDvars()
{
    setdvar("player_strafeSpeedScale", 1 );
    setdvar("player_backSpeedScale", 1 );
    setdvar("r_dof_enable", 0 );

    createDvar("st_perkrng", ON);
	createDvar("st_weapons", ON);
	createDvar("st_doors", ON);
	createDvar("st_perks", ON);
	createDvar("st_power", ON);
	createDvar("st_boards", OFF);
	createDvar("st_delay", START_DELAY);
	createDvar("st_round", START_ROUND);
	createDvar("st_remove_drops", OFF);
	createDvar("st_boxhits", ON);
    createDvar("st_changeround", level.round_number);
    createDvar("chat", "xxxxxxxxxxxx");

	if(isorigins() || ismob())
		createDvar("st_shield", OFF);
	if(isorigins())
	{
		createDvar("st_staff", 0); 
		createDvar("st_cherry_origins", OFF);
		createDvar("st_wm", OFF);
	}
	if(istown())
		createDvar("st_jug_setup", OFF); 

	if(issurvivalmap())
		createDvar("st_avg", ON);
	if(isburied())
	{
		createDvar("st_setupBuried", OFF); 
	}
	if(istranzit())
	{
		createDvar("st_busstatus", ON);
		createDvar("st_busloc", OFF);
		createDvar("st_bustimer", OFF);
		createDvar("st_depart", 40);
		createDvar("st_denizens", ON);
	}
	if(ismob())
	{
		createDvar("st_lives", ON);
	}

	flag_wait("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000);
}