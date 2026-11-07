#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_power;

#include scripts\zm\strattester\utility;

#define DEBRIS_ORIGIN_BURIED_TUNELCOUCH (-435, 498, 478)
#define DEBRIS_ORIGIN_BURIED_STORECOUCH (-190, 141, 193)

#define DOOR_ORIGIN_TRANZIT_JUG (625, -1222, 166)
#define DOOR_ORIGIN_TRANZIT_BANK1 (1045, -28, 28)
#define DOOR_ORIGIN_TRANZIT_BANK2 (1113, 469, 8)

#define DOOR_ORIGIN_MOB_SALLYPORT (-149, 8679, 1166)
#define DOOR_ORIGIN_MOB_INFIRMARY (2281, 9484, 1564)
#define DOOR_ORIGIN_MOB_MICHIGANAVENUE (1601, 9223, 1482)
#define DOOR_ORIGIN_MOB_SHOWERS (2138, 9210, 1375)

#define DOOR_ORIGIN_BURIED_SALOON (453, -1188, 100)
#define DOOR_ORIGIN_BURIED_OUTSIDEGENERALSTORE (-384, -628, 52)
#define DOOR_ORIGIN_BURIED_CANDYSHOP (525, 61, 53)
#define DOOR_ORIGIN_BURIED_FRONTGENERALSTORE (0, 92, 52)
#define DOOR_ORIGIN_BURIED_TOYSTORE (508, -672, 52)
#define DOOR_ORIGIN_BURIED_GENERALSTOREROOF (-188, -440, 188)

init_start()
{
	level thread resetSPH();
    level thread turnOnPower();
	level thread openAllDoors();
    level thread zombieSpawnDelay();
    level thread removeBoardsFromWindows();
    level thread changeRound(getDvarInt("st_round"), false);

	setDvar("magic_chest_movable", !isburied());
}

resetSPH()
{
	level endon("end_game");
	while (true) 
	{
		level waittill("start_of_round");
		self.sph.time_start = gettime() / 1000;
    	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	}
}

openAllDoors()
{
	if(!getDvarInt("st_doors"))
		return;
	flag_wait("initial_blackscreen_passed");

    setdvar( "zombie_unlock_all", 1 );
    players = get_players();

    foreach(door in getentarray("zombie_door", "targetname"))
    {
		wait 0.1;
		if(istown() && !getDvarInt("st_jug_setup") && door.origin == DOOR_ORIGIN_TRANZIT_JUG)
			continue;
		if(istown() && getDvarInt("st_jug_setup") && door.origin == DOOR_ORIGIN_TRANZIT_BANK1)
			continue;
		if(istown() && getDvarInt("st_jug_setup") && door.origin == DOOR_ORIGIN_TRANZIT_BANK2)
			continue;
		if(istranzit() && door.origin[0] > 7000 && door.origin[0] < 8400) // Farm area
			continue;
		if(ismob())
		{
			if(door.origin == DOOR_ORIGIN_MOB_SALLYPORT)
				continue;
			if(door.origin == DOOR_ORIGIN_MOB_INFIRMARY)
				continue;
			if(door.origin == DOOR_ORIGIN_MOB_MICHIGANAVENUE)
				continue;
			if(door.origin == DOOR_ORIGIN_MOB_SHOWERS)
				continue;
		}
		if(isburied())
		{
			if(door.origin == DOOR_ORIGIN_BURIED_SALOON)
 				continue;
			if(door.origin == DOOR_ORIGIN_BURIED_OUTSIDEGENERALSTORE)
 				continue;
			if(door.origin == DOOR_ORIGIN_BURIED_CANDYSHOP)
 				continue;
			if(door.origin == DOOR_ORIGIN_BURIED_FRONTGENERALSTORE)
 				continue;
			if(door.origin == DOOR_ORIGIN_BURIED_TOYSTORE)
 				continue;
			if(door.origin == DOOR_ORIGIN_BURIED_GENERALSTOREROOF)
 				continue;
		}

        if (is_true(door.power_door_ignore_flag_wait))
            door notify("power_on");
			
        door notify("trigger", players[0]);
        wait 0.05;
    }

	foreach(debri in getentarray("zombie_debris", "targetname"))
	{
		if(isburied())
		{
			if(debri.origin == DEBRIS_ORIGIN_BURIED_TUNELCOUCH)
 				continue;
			if(debri.origin == DEBRIS_ORIGIN_BURIED_STORECOUCH)
 				continue;
		}
        debri notify("trigger", players[0]);
        wait 0.05;
	}
}

disableAISpawn(time)
{
	setDvar("ai_disableSpawn", 1);

	wait time;

	setDvar("ai_disableSpawn", 0);
}

zombieSpawnDelay()
{   
	flag_wait("initial_blackscreen_passed");

	if(ismob())
		flag_wait("afterlife_start_over");
	
	time = getDvarInt("st_delay");

	if(time <= 0)
		return;

	level.startDelayCountdown = create_simple_hud();
	level.startDelayCountdown.fontscale = 24;
	level.startDelayCountdown setshader( "hud_chalk_1", 64, 64 );
	level.startDelayCountdown FadeOverTime( 2.0 );
	level.startDelayCountdown SetValue(getDvarInt("st_delay"));
	level.startDelayCountdown.color = ( 0.21, 0, 0 );
	level.startDelayCountdown.alpha = 1;
	level.startDelayCountdown.hidewheninmenu = 1;
	level.startDelayCountdown.alignx = "center";
	level.startDelayCountdown.aligny = "center";
	level.startDelayCountdown.horzalign = "user_center";
	level.startDelayCountdown.vertalign = "user_center";

	level thread disableAISpawn(time);

	for(; time > 0; time--)
	{
		wait 1;
		level.startDelayCountdown SetValue(time);
	}
	level notify("start_of_round");

	level.startDelayCountdown FadeOverTime( 1.0 );
	level.startDelayCountdown.color = (1,1,1);
	level.startDelayCountdown.alpha = 0;
	wait( 1.0 );
	
	foreach(player in level.players)
	{
		player.roundtimer settimerup(0);
		player.timer settimerup(0);
	}
	level.startDelayCountdown destroy_hud();
}

removeBoardsFromWindows()
{
	if(getDvarInt("st_boards"))
		return;

	flag_wait( "initial_blackscreen_passed" );

	maps\mp\zombies\_zm_blockers::open_all_zbarriers();
}

turnOnPower()
{
	if(!getDvarInt("st_power"))
		return;

	flag_wait("initial_blackscreen_passed");
	wait 5;

	trig = getEnt("use_elec_switch", "targetname");
	powerSwitch = getEnt("elec_switch", "targetname");

	powerSwitch notSolid();

	trig setHintString(&"ZOMBIE_ELECTRIC_SWITCH");
	trig setVisibleToAll();
	trig notify("trigger", self);
	trig setInvisibleToAll();

	powerSwitch rotateRoll(-90, 0, 3);

	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();

	powerSwitch waittill("rotatedone");

	flag_set("power_on");
	level setClientField("zombie_power_on", 1); 

	if(istranzit()) [[getfunction("maps/mp/zm_transit_power", "raisereactordoors")]]();
}