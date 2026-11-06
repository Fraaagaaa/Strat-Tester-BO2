#include maps\mp\gametypes_zm\_hud_util;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\nopower;

#define FILE_TRANZIT 	"loadouts/tranzit.loadout"
#define FILE_DEPOT 		"loadouts/depot.loadout"
#define FILE_FARM 		"loadouts/farm.loadout"
#define FILE_TOWN	 	"loadouts/town.loadout"
#define FILE_NUKETOWN 	"loadouts/nuketown.loadout"
#define FILE_DIERISE 	"loadouts/dierise.loadout"
#define FILE_MOB 		"loadouts/mob.loadout"
#define FILE_BURIED 	"loadouts/buried.loadout"
#define FILE_ORIGINS 	"loadouts/origins.loadout"

#define MULE_PERK "specialty_additionalprimaryweapon"

#define AN_U "an94_upgraded_zm+mms"
#define AIR_STRIKE "beacon_zm"
#define BOOMHILDA "c96_upgraded_zm"
#define BOWIE "bowie_knife_zm"
#define CHICOM "qcw05_zm"
#define CLAYMORE "claymore_zm"
#define ELECTRIC "staff_lightning_upgraded_zm"
#define FIRE "staff_fire_upgraded_zm"
#define FISTS "zombie_fists_zm"
#define GALVA "tazer_knuckles_zm"
#define GAT "blundersplat_upgraded_zm"
#define ICE "staff_water_upgraded_zm"
#define JETGUN "jetgun_zm"
#define M16 "m16_gl_upgraded_zm"
#define M1911 "m1911_zm"
#define MAUSER "c96_zm"
#define MK2 "raygun_mark2_zm"
#define MK2_U "raygun_mark2_upgraded_zm"
#define MONKS "cymbal_monkey_zm"
#define MP40_U "mp40_upgraded_zm"
#define PARA_U "slowgun_upgraded_zm"
#define RAY "ray_gun_zm"
#define RAY_U "ray_gun_upgraded_zm"
#define SALLYS "m1911_upgraded_zm"
#define SEMTEX "sticky_grenade_zm"
#define SHIELD_MOB "alcatraz_shield_zm"
#define SHIELD_ORIGINS "tomb_shield_zm"
#define SLIQ "slipgun_zm"
#define SPORK "spork_zm_alcatraz"
#define SPRINGPAD "equip_springpad_zm"
#define STAFF_ALT "staff_revive_zm"
#define TOMAHAWK "upgraded_tomahawk_zm"
#define UZI "uzi_zm"
#define WAR_MACHINE "m32_zm"
#define WAR_MACHINE_U "m32_upgraded_zm"
#define WIND "staff_air_upgraded_zm"
#define EMPS "emp_grenade_zm"
#define KNIFE "knife_zm"

init_loadouts()
{
	if(!getDvarInt("st_weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

	if(ismob())
		flag_wait( "afterlife_start_over" );

 	self initializeLoadout();

	if(!checkCustomLoadouts())
	{
		if(!getDvarInt("st_power"))
			self nopowerLoadout();

		self getMapLoadout();
	}

	self removeStartingPistol();
	self giveLoadout();

	if(mapHasMulekick())
		self giveMuleWeaponOnRevive();
}

giveLoadout()
{
    level.player_too_many_players_check = 0;

	foreach(equipment in self.st_loadout_equipment)
		self equipment_buy(equipment);

	foreach(weapon in self.st_loadout_weapons)
    {
		self weapon_give( weapon, undefined, undefined, 0 );
        if (isorigins() && issubstr(weapon, "staff"))
        {
            self thread [[getfunction("maps/mp/zm_tomb_main_quest", "watch_staff_ammo_reload")]]();
            [[getfunction("maps/mp/zm_tomb_craftables", "set_player_staff")]]( weapon, self );
        }
    }

	if(mapHasMulekick() && isdefined(self.st_loadout_mule) && self.st_loadout_mule != "undefined")
		self mulekickWepaon();

	self giveMelee(self.st_loadout_melee);
	self switchToWeapon(self.st_loadout_main);
}

removeStartingPistol()
{
	if(isorigins())
		self takeweapon(MAUSER);
	else 
		self takeweapon(M1911);
}

initializeLoadout()
{
	self.st_loadout_weapons = array();
	self.st_loadout_equipment = array();
	self.st_loadout_main = undefined;
	self.st_loadout_mule = undefined;
	self.st_loadout_melee = KNIFE;
}

getMapLoadout()
{
	if(istranzit()) 		self tranzitLoadout();
	else if(istown()) 		self townLoadout();
	else if(isfarm()) 		self farmLoadout();
	else if(isdepot()) 		self depotLoadout();
	else if(isnuketown()) 	self nuketownLoadout();
	else if(isdierise()) 	self dieriseLoadout();
	else if(ismob()) 		self mobLoadout();
	else if(isburied()) 	self buriedLoadout();
	else if(isorigins()) 	self originsLoadout();
}

tranzitLoadout()
{
	self.st_loadout_weapons = array(M16, SALLYS, EMPS);
	self.st_loadout_melee = GALVA;
	self.st_loadout_main = M16;
	if(iswhite(self))
		self.st_loadout_weapons[self.st_loadout_weapons.size] = JETGUN;
}

townLoadout()
{
	if(iswhite(self))
	{
		self.st_loadout_weapons = array(MK2_U, SALLYS, MONKS, SEMTEX);
		self.st_loadout_main = MK2_U;
	}
	else
	{
		self.st_loadout_weapons = array(RAY_U, SALLYS, MONKS, SEMTEX);
		self.st_loadout_main = RAY_U;
	}
	self.st_loadout_melee = GALVA;
}

farmLoadout()
{

	if(iswhite(self))
	{
		self.st_loadout_weapons = array(MK2, CHICOM , MONKS);
		self.st_loadout_main = MK2;
	}
	else
	{
		self.st_loadout_weapons = array(RAY, CHICOM, MONKS);
		self.st_loadout_main = RAY;
	}
	self.st_loadout_melee = GALVA;
}

depotLoadout()
{

	if(iswhite(self))
	{
		self.st_loadout_weapons = array(MK2, CHICOM , MONKS);
		self.st_loadout_main = MK2;
	}
	else
	{
		self.st_loadout_weapons = array(RAY, CHICOM, MONKS);
		self.st_loadout_main = RAY;
	}
}

nuketownLoadout()
{
	if(iswhite(self))
		self.st_loadout_weapons = array(MK2_U, SALLYS, MONKS, CLAYMORE);
	else
		self.st_loadout_weapons = array(RAY_U, SALLYS, MONKS, CLAYMORE);
	self.st_loadout_main = SALLYS;
	self.st_loadout_melee = GALVA;
}

dieriseLoadout()
{
	if(iswhite(self))
	{
		self.st_loadout_weapons = array(SLIQ, MK2_U, MONKS, SEMTEX, CLAYMORE);
		self.st_loadout_mule = AN_U;
		self.st_loadout_equipment = array(SPRINGPAD);
		self.st_loadout_main = SLIQ;
	}
	else
	{
		self.st_loadout_weapons = array(SALLYS, MK2_U, MONKS, SEMTEX, CLAYMORE);
		self.st_loadout_melee = GALVA;
		self.st_loadout_mule = AN_U;
		self.st_loadout_equipment = array(SPRINGPAD);
		self.st_loadout_main = AN_U;
	}
}

mobLoadout()
{
	if(getDvarInt("st_shield"))
		self.st_loadout_equipment = array(SHIELD_MOB);

	if(iswhite(self))
	{
		self.st_loadout_weapons = array(GAT, MK2_U, CLAYMORE);
		self.st_loadout_main = GAT;
	}
	if(isblue(self))
	{
		self.st_loadout_weapons = array(GAT, SALLYS, CLAYMORE);
		self.st_loadout_main = GAT;
	}
	if(isyellow(self) || isgreen(self))
	{
		self.st_loadout_weapons = array(UZI, SALLYS, CLAYMORE);
		self.st_loadout_main = SALLYS;
	}
	self givetomahawk();
	self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
}

buriedLoadout()
{
	if(iswhite(self))
	{
		self.st_loadout_weapons = array(WAR_MACHINE, PARA_U, MONKS, CLAYMORE);
		self.st_loadout_melee = GALVA;
		self.st_loadout_main = PARA_U;
		self.st_loadout_mule = SALLYS;
	}
	else
	{
		self.st_loadout_weapons = array(WAR_MACHINE, MK2_U, MONKS, CLAYMORE);
		self.st_loadout_melee = GALVA;
		self.st_loadout_mule = SALLYS;
		self.st_loadout_main = WAR_MACHINE;
	}
}

originsLoadout()
{

	if(getDvarInt("st_shield"))
		self.st_loadout_equipment = array(SHIELD_ORIGINS);

	if(iswhite(self) && level.players.size == 1)
	{
		if(getDvarInt("st_wm_origins"))
			self.st_loadout_weapons = array(MK2_U, MP40_U, AIR_STRIKE, SEMTEX, CLAYMORE);
		else
			self.st_loadout_weapons = array(MK2_U, MP40_U, AIR_STRIKE, SEMTEX, CLAYMORE);

		switch(getDvarInt("st_staff"))
		{
			case 0: self.st_loadout_mule = ICE; self.st_loadout_main = ICE; break;
			case 1: self.st_loadout_mule = WIND; self.st_loadout_main = WIND; break;
			case 2: self.st_loadout_mule = FIRE; self.st_loadout_main = FIRE; break;
			case 3: self.st_loadout_mule = ELECTRIC; self.st_loadout_main = ELECTRIC; break;
			default: self.st_loadout_mule = ICE; self.st_loadout_main = ICE; break;
		}
	}
	else
	{
		if(iswhite(self))
		{
			if(getDvarInt("st_wm_origins"))
				self.st_loadout_mule = WAR_MACHINE_U;
			else
				self.st_loadout_mule = MP40_U;

			self.st_loadout_weapons = array(MK2_U, SEMTEX, AIR_STRIKE);
		}
		else
		{
			self.st_loadout_weapons = array(BOOMHILDA, SEMTEX, AIR_STRIKE);
			self.st_loadout_mule = MP40_U;
		}
		if(iswhite(self))	{self.st_loadout_weapons[self.st_loadout_weapons.size] = ICE; self.st_loadout_main = ICE;}
		if(isblue(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = WIND; self.st_loadout_main = WIND;}
		if(isyellow(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = FIRE; self.st_loadout_main = FIRE;}
		if(isgreen(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = ELECTRIC; self.st_loadout_main = ELECTRIC;}
	}
}

giveMelee(weapon_name )
{
	if(!isdefined(weapon_name))
		return;

	if (self hasweapon("knife_zm"))
		self takeweapon("knife_zm");

	self weapon_give(weapon_name, undefined, undefined, 0);

    gun = self getcurrentweapon();
	if (gun != "none" && !is_placeable_mine(gun) && !is_equipment(gun))
		self switchtoweapon(gun);
}

givetomahawk()
{
    flag_wait("afterlife_start_over");

	self notify( "tomahawk_picked_up" );
	level notify( "bouncing_tomahawk_zm_aquired" );
	self notify( "player_obtained_tomahawk" );
	self.tomahawk_upgrade_kills = 99;
	self.killed_with_only_tomahawk = 1;
	self.killed_something_thq = 1;
	self notify( "tomahawk_upgraded_swap" );
	self set_player_tactical_grenade("upgraded_tomahawk_zm");
	self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
	self disable_player_move_states( 1 );
	self giveweapon( "zombie_tomahawk_flourish" );
	self switchtoweapon( "zombie_tomahawk_flourish" );
	self waittill_any( "player_downed", "weapon_change_complete" );
	self enable_player_move_states();
	self takeweapon( "zombie_tomahawk_flourish" );
	self giveweapon("upgraded_tomahawk_zm");
	self givemaxammo("upgraded_tomahawk_zm");
	self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
}

checkCustomLoadouts()
{
    loadout = validateLoadoutFile(getLoadoutFilePath());

    if(!isdefined(loadout))
        return false;

    self.st_loadout_melee = loadout[3];
    self.st_loadout_mule = loadout[1];

    weapons = strtok(loadout[0], " ");
    equipment = strtok(loadout[2], " ");

    self.st_loadout_weapons = array();
    self.st_loadout_equipment = array();

    for(i = 0; i < weapons.size; i++)
        self.st_loadout_weapons[i] = weapons[i];

    for(i = 0; i < equipment.size; i++)
        self.st_loadout_equipment[i] = equipment[i];

    if(self.st_loadout_weapons.size > 0)
        self.st_loadout_main = self.st_loadout_weapons[0];

    return true;
}

getLoadoutFilePath()
{
	if(istranzit()) return FILE_TRANZIT;
	else if(isdepot()) return FILE_DEPOT;
	else if(isfarm()) return FILE_FARM;
	else if(istown()) return FILE_TOWN;
	else if(isnuketown()) return FILE_NUKETOWN;
	else if(isdierise()) return FILE_DIERISE;
	else if(ismob()) return FILE_MOB;
	else if(isburied()) return FILE_BURIED;
	else if(isorigins()) return FILE_ORIGINS;
}

validateLoadoutFile(path)
{
    f = fs_fopen(path, "read");

    if(f == -1)
        return undefined;

    loadout = array();

    for(i = 0; i < 4; i++)
    {
        line = fs_readline(f);

        if(!isdefined(line))
        {
            fs_fclose(f);
            return undefined;
        }

        loadout[i] = line;
    }

    fs_fclose(f);
    return loadout;
}

fridge()
{
	if(istranzit())
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m16_gl_upgraded_zm");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 270);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 30);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", 1);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", 8);
	}
}

// MULEKICK STUFF
mulekickWepaon()
{
	self endon("disconnect");
	level endon("end_game");

	if(self waitForMulekick() == false)
		return;

    gun = self getCurrentWeapon();
	self weapon_give(self.st_loadout_mule, undefined, undefined, 0);

    if (isorigins() && issubstr(self.st_loadout_mule, "staff"))
    {
        self thread [[getfunction("maps/mp/zm_tomb_main_quest", "watch_staff_ammo_reload")]]();
        [[getfunction("maps/mp/zm_tomb_craftables", "set_player_staff")]](self.st_loadout_mule, self);
		return;
    }

	self switchtoweapon(gun);
}

waitForMulekick()
{
	self endon("disconnect");
	level endon("end_game");

	for(i = 0; i < 50; i++)
	{
		if(self hasperk(MULE_PERK))
			return true;
		wait 0.1;
	}
	return false;
}

giveMuleWeaponOnRevive()
{
	level endon("end_game");
	self endon( "disconnect" );
	self thread scanweapons();

	while(true)
	{
		self waittill( "player_revived", reviver );
        if(isdefined(self.saved_mule_weapon))
		{
			if(self waitForMulekick())
				self maps\mp\zombies\_zm_weapons::weapondata_give(self.saved_mule_weapon);
		}
	}
}

scanweapons()
{
	prev = undefined;
	while(true)
	{
		wait 5;
		while(true)
		{
			prev = self.saved_mule_weapon;
			wait 0.1;
			if(isdefined(self.revivetrigger))
			{
				while(isdefined(self.revivetrigger))
					wait 0.1;
				break;
			}
			if(self.origin[2] < 0 && isdierise())
			{
				while(self.origin[2] < 0)
					wait 0.1;
				break;
			}
			weap = self getweaponslistprimaries();
			self.saved_mule_weapon = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weap[2]);
			wait 0.1;
		}
	}
}