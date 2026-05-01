#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\fixes;
#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\start;
#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\despawners;
#include scripts\zm\strattester\settings;
#include scripts\zm\strattester\perks;
#include scripts\zm\strattester\weapons;

#define VERSION "2.2.0"
main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::base_game_network_frame);
}

init()
{
	level.strat_tester = true;
	level thread enable_cheats();
	level thread settings_init();
	level thread despawners_init();
    level thread start_init();
	level thread readChat();
	level thread readconsole();
    level thread wait_for_players();
    
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
	flag_wait("initial_blackscreen_passed");
	level thread openAllDoors();
    level thread round_pause_st();
}

wait_for_players()
{
    while(true)
    {
        level waittill("connected" , player);
        player thread connected_st();
    }
}


connected_st()
{
    self endon( "disconnect" );
	self waittill("spawned_player");

    while(true)
    {
		if(!isdefined(self.has_hud))
		{
			self iprintln("^6Strat Tester " + VERSION + " by BoneCrusher");
			self strattesterprint("Source: github.com/Fraaagaaa/Strat-Tester-BO2", "Fuente: github.com/Fraaagaaa/Strat-Tester-BO2");
			self thread health_bar_hud();
			self thread zone_hud();
			self thread zombies_remaining();
			self thread denizens_alive();
			self thread st_sph();
            if(istranzit())
                self thread busloc();
			if(!isdefined(self.has_hud))
				self.has_hud = true;
		}
		self.score = 1000000;
        self thread perk_init();
		self thread loadouts_init();
	    self thread timer();
	    self thread timerlocation();
	    self thread trap_timer();
        self thread specialcommands();
    	self thread bus_debug_pos_hud_think();
        wait 0.05;
		self waittill("spawned_player");
    }
}

enable_cheats()
{
    setDvar("sv_cheats", 1 );
	setdvar("cg_ufo_scaler", 6);

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
		self notify( "stop_player_out_of_playable_area_monitor" );
	level.player_out_of_playable_area_monitor = 0;
    level.player_too_many_players_check = 0;
}

tpcase(player, location)
{
	if(istranzit())
		switch(location)
		{
			case "farm": pos = (6908, -5750, -62); ang = (0, 173, 0); break;
			case "town": pos = (1152, -717, -55); ang = (0, 45, 0); break;
			case "depot": pos = (-7384, 4693, -63); ang = (0, 18, 0); break;
			case "tunel": pos = (-11814, -1903, 228); ang = (0, -60, 0); break;
			case "diner": pos = (-5012, -6694, -60); ang = (0, -127, 0); break;
			case "nacht": pos = (13840, -261, -188); ang = (0, -108, 0); break;
			case "power": pos = (12195, 8266, -751); ang = (0, -90, 0); break;
			case "ak": pos = (11200, 7745, -564); ang = (0, -108, 0); break;
			case "ware": pos = (10600, 8272, -400); ang = (0, -108, 0); break;
			case "bus": pos = level.the_bus.origin; ang = level.the_bus.angles; break;
			default: return;
		}
	if(ismob())
		switch(location)
		{
			case "cafe": pos = (3309, 9329, 1336); ang = (0, 131, 0); break;
			case "cage": pos = (-1771, 5401, -71); ang = (0, 0, 0); break;
			case "fans": pos = (-1042, 9489, 1350); ang = (0, -43, 0); break;
			case "dt":   pos = (25, 8762, 1128); ang = (0, 0, 0); break;
			default: return;
		}
	if(isdierise())
		switch(location)
		{
			case "shaft": pos = (3805, 1920, 2197); ang = (0, -161, 0); break;
			case "tramp": pos = (2159, 1161, 3070); ang = (0, 135, 0); break;
			case "trample": pos = (2159, 1161, 3070); ang = (0, 135, 0); break;
			default: return;
		}
	if(isburied())
		switch(location)
		{
			case "saloon": pos = (553, -1214, 56); ang = (0, -50, 0); break;
			case "jug": pos = (-660, 1030, 8); ang = (0, -90, 0); break;
			case "tunel": pos = (-483, 293, 423); ang = (0, -40, 0); break;
			default: return;
		}
	if(isorigins())
		switch(location)
		{
			case "church": pos = (1878, -1358, 150); ang = (0, 140, 0); break;
			case "tcp": pos = (10335, -7902, -411); ang = (0, 140, 0); break;
			case "gen1": pos = (2340, 4978, -303); ang = (0, -132, 0); break;
			case "gen2": pos = (469, 4788, -285); ang = (0, -134, 0); break;
			case "gen3": pos = (740, 2123, -125); ang = (0, 135, 0); break;
			case "gen4": pos = (2337, -170, 140); ang = (0, 90, 0); break;
			case "gen5": pos = (-2830, -21, 238); ang = (0, 40, 0); break;
			case "gen6": pos = (732, -3923, 300); ang = (0, 50, 0); break;
			case "tank": pos = level.vh_tank.origin + (0, 0, 50); ang = level.vh_tank.angles; break;
			default: return;
		}

	strattesterprint("Teleporting " + player.name + " to " + location, "Teletransportando " + player.name + " a " + location);
    player setOrigin(pos);
    player setPlayerAngles(ang);
}

bus_debug_pos_hud_think()
{
    // self endon( "disconnect" );
    // level endon( "end_game" );

    // lx = 10;
    // vx = 20;

    // hud_xl = newclienthudelem( self );
    // hud_xl.horzalign = "left"; hud_xl.vertalign = "bottom";
    // hud_xl.alignx = "left";   hud_xl.aligny = "bottom";
    // hud_xl.x = lx; hud_xl.y = -135;
    // hud_xl.font = "small"; hud_xl.fontscale = 1.1;
    // hud_xl.color = ( 0.6, 1, 0.6 ); hud_xl.alpha = 1;
    // hud_xl.hidewheninmenu = true;
    // hud_xl.label =&"X:\t";

    // hud_yl = newclienthudelem( self );
    // hud_yl.horzalign = "left"; hud_yl.vertalign = "bottom";
    // hud_yl.alignx = "left";   hud_yl.aligny = "bottom";
    // hud_yl.x = lx; hud_yl.y = -120;
    // hud_yl.font = "small"; hud_yl.fontscale = 1.1;
    // hud_yl.color = ( 0.6, 1, 0.6 ); hud_yl.alpha = 1;
    // hud_yl.hidewheninmenu = true;
    // hud_yl.label =&"Y:\t";

    // hud_zl = newclienthudelem( self );
    // hud_zl.horzalign = "left"; hud_zl.vertalign = "bottom";
    // hud_zl.alignx = "left";   hud_zl.aligny = "bottom";
    // hud_zl.x = lx; hud_zl.y = -105;
    // hud_zl.font = "small"; hud_zl.fontscale = 1.1;
    // hud_zl.color = ( 0.6, 1, 0.6 ); hud_zl.alpha = 1;
    // hud_zl.hidewheninmenu = true;
    // hud_zl.label =&"Z:\t";

    // hud_yawl = newclienthudelem( self );
    // hud_yawl.horzalign = "left"; hud_yawl.vertalign = "bottom";
    // hud_yawl.alignx = "left";   hud_yawl.aligny = "bottom";
    // hud_yawl.x = lx; hud_yawl.y = -90;
    // hud_yawl.font = "small"; hud_yawl.fontscale = 1.1;
    // hud_yawl.color = ( 0.6, 1, 0.6 ); hud_yawl.alpha = 1;
    // hud_yawl.hidewheninmenu = true;
    // hud_yawl.label =&"Yaw:\t";

    // while ( isdefined( self ) )
    // {
    //     wait 0.1;

    //     pos    = self.origin;
    //     angles = self getplayerangles();
    //     hud_xl   setvalue( int( pos[0] ) );
    //     hud_yl   setvalue( int( pos[1] ) );
    //     hud_zl   setvalue( int( pos[2] ) );
    //     hud_yawl setvalue( int( angles[1] ) );
    // }
}