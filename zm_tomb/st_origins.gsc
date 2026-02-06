#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\zm_tomb_capture_zones;
#include maps\mp\zm_tomb_capture_zones;

#include scripts\zm\strattester\origins;
#include scripts\zm\strattester\buildables;


init()
{
    replacefunctions();
	level thread pack_a_punch_enable();
	level thread enable_all_teleporters();
	level thread takeAllParts();
	level thread call_tank();
	level thread readchat_origins();
    level thread wait_for_players();
    
	flag_wait("initial_blackscreen_passed");
    
    give_max_ammo_reward();

	if(getDvarInt("shield"))
	{
		spawn_buildable_trigger_shield((110, -3000, 60), "tomb_shield_zm", "^3Press &&1 for ^5Shield");
	    spawn_buildable_trigger_shield((2308, 689, -23), "tomb_shield_zm", "^3Press &&1 for ^5Shield");
	}

    turn_gens_on();
	takecraftableparts("");
    placeStaffsInChargers();
}

wait_for_players()
{
    while(true)
    {
        level waittill( "connected" , player);
        player thread connected_st();
    }
}

connected_st()
{
    self endon( "disconnect" );

    while(true)
    {
        self waittill( "spawned_player" );

		self thread stomptracker();
		self thread tanktracker();
		self thread tumbletracker();

		if(self == level.players[0])
			self tomb_give_equipment();
        
        wait 0.05;
    }
}