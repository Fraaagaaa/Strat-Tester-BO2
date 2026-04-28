#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;

#include scripts\zm\strattester\utility;

#define MULE_PERK "specialty_additionalprimaryweapon"

#define AN_U "an94_upgraded_zm+mms"
#define BOOMHILDA "c96_upgraded_zm"
#define CHICOM "qcw05_zm"
#define CLAYMORE "claymore_zm"
#define ELECTRIC "staff_lightning_upgraded_zm"
#define FIRE "staff_fire_upgraded_zm"
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
#define SPRINGPAD "equip_springpad_zm"
#define STAFF_ALT "staff_revive_zm"
#define TOMAHAWK "upgraded_tomahawk_zm"
#define UZI "uzi_zm"
#define WAR_MACHINE "m32_zm"
#define WAR_MACHINE_U "m32_upgraded_zm"
#define WIND "staff_air_upgraded_zm"
#define EMPS "emp_grenade_zm"
#define KNIFE "knife_zm"

map_has_mulekick()
{
	return (isdierise() || isburied() || isorigins());
}

player_wants_mulekick(player)
{
	if(!getDvarInt("st_weapons"))
		return false;
	return getDvarInt("st_give_perk_" + MULE_PERK);
	// return getDvarInt("st_give_perk_" + MULE_PERK + "_" + player);
}

loadouts_init()
{
	if(!getDvarInt("st_weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

	if(ismob())
		flag_wait( "afterlife_start_over" );

	self thread remove_starting_pistol();
	self thread main_loadouts();
	self thread giveloadout();
}

waitformulekick()
{
	while(true)
	{
		wait 0.1;
		if(self hasperk(MULE_PERK))
			return;
	}
}
giveloadout()
{
    level.player_too_many_players_check = 0;
	while(!self.st_loadout_completed)
		wait 0.1;

	foreach(equipment in self.st_loadout_equipment)
		self equipment_buy(equipment);

	foreach(weapon in self.st_loadout_weapons)
		self weapon_give( weapon, undefined, undefined, 0 );

	if(map_has_mulekick() && player_wants_mulekick(self.name) && isdefined(self.st_loadout_mule))
	{
		self waitformulekick();
		self weapon_give( self.st_loadout_mule, undefined, undefined, 0 );
	}

	if(istranzit())
		self give_melee_weapon_instant(self.st_loadout_melee);

	self switchToWeapon(self.st_loadout_main);
}

remove_starting_pistol()
{
	if(isorigins())
		self takeweapon(MAUSER);
	else 
		self takeweapon(M1911);
}

main_loadouts()
{
	self.st_loadout_completed = false;
	self.st_loadout_weapons = array();
	self.st_loadout_equipment = array();
	self.st_loadout_main = undefined;
	self.st_loadout_mule = undefined;
	self.st_loadout_melee = KNIFE;

	if(istranzit())
	{
		self.st_loadout_weapons = array(M16, SALLYS, EMPS);
		self.st_loadout_melee = GALVA;
		self.st_loadout_main = M16;
		if(iswhite(self))
			self.st_loadout_weapons[self.st_loadout_weapons.size] = JETGUN;
	}
	if(istown())
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
	if(isfarm() || isdepot())
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
		if(isfarm())
			self.st_loadout_melee = GALVA;
	}
	if(isnuketown())
	{
		if(iswhite(self))
			self.st_loadout_weapons = array(MK2_U, SALLYS, MONKS);
		else
			self.st_loadout_weapons = array(RAY_U, SALLYS, MONKS);
		self.st_loadout_main = SALLYS;
	}
	if(isdierise())
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
	if(ismob())
	{
		if(getDvarInt("st_shield"))
			self.st_loadout_equipment = array(SHIELD_MOB);

		if(iswhite(self))
		{
			self.st_loadout_weapons = array(GAT, MK2_U, CLAYMORE);
			self.st_loadout_main = GAT;
		}
		else if(isblue(self))
		{
			self.st_loadout_weapons = array(GAT, SALLYS, CLAYMORE);
			self.st_loadout_main = GAT;
		}
		else if(isyellow(self) || isgreen(self))
		{
			self.st_loadout_weapons = array(UZI, SALLYS, CLAYMORE);
			self.st_loadout_main = SALLYS;
		}
		self thread givetomahawk();
		self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
	}
	if(isburied())
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
	if(isorigins())
	{
		if(getDvarInt("st_shield"))
			self.st_loadout_equipment = array(SHIELD_ORIGINS);

		if(iswhite(self) && level.players.size == 1)
		{
			if(getDvarInt("st_wm_origins"))
				self.st_loadout_weapons = array(MK2_U, MP40_U, MONKS, SEMTEX, CLAYMORE);
			else
				self.st_loadout_weapons = array(MK2_U, MP40_U, MONKS, SEMTEX, CLAYMORE);

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

				self.st_loadout_weapons = array(MK2_U, MONKS, SEMTEX);
			}
			else
			{
				self.st_loadout_weapons = array(BOOMHILDA, MONKS, SEMTEX);
				self.st_loadout_mule = MP40_U;
			}

			if(iswhite(self))	{self.st_loadout_weapons[self.st_loadout_weapons.size] = ICE; self.st_loadout_main = ICE;}
			if(isblue(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = WIND; self.st_loadout_main = WIND;}
			if(isyellow(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = FIRE; self.st_loadout_main = FIRE;}
			if(isgreen(self)) 	{self.st_loadout_weapons[self.st_loadout_weapons.size] = ELECTRIC; self.st_loadout_main = ELECTRIC;}
		}
	}
	self.st_loadout_completed = true;
}

/////////////////////////////////////////////////////////
// GIVE WEAPONS BACK AFTER DEATH
/////////////////////////////////////////////////////////

giveplayerdata()
{
	self maps\mp\zombies\_zm_weapons::weapondata_give( self.a_saved_primaries_weapons[2] );
}

scanweapons()
{
	while(true)
	{
		wait 5;
		while(true)
		{
			wait 0.1;
			if(isdefined(self.revivetrigger))
			{
				while(isdefined(self.revivetrigger))
					wait 0.1;
				break;
			}
			if(self.origin[2] < 0 && isdierise())	//die rise
			{
				while(self.origin[2] < 0)
					wait 0.1;
				break;
			}
			self.a_saved_primaries = self getweaponslistprimaries();
			self.a_saved_primaries_weapons = [];
			index = 0;

			foreach ( weapon in self.a_saved_primaries )
			{
				self.a_saved_primaries_weapons[index] = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weapon );
				index++;
			}
			wait 0.1;
		}
	}
}

give_mule_weapon_on_revive()
{
	level endon("end_game");
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
        if(self hasperk(MULE_PERK))
		{
		    self thread giveplayerdata();
			self iprintln("MULE PERK");
		}
		self iprintln("NO MULE PERK");
	}
}

give_melee_weapon_instant( weapon_name )
{
	self giveweapon( weapon_name );
	gun = change_melee_weapon( weapon_name, "knife_zm" );
	if ( self hasweapon( "knife_zm" ) )
		self takeweapon( "knife_zm" );

    gun = self getcurrentweapon();
	if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
		self switchtoweapon( gun );
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