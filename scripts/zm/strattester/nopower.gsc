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

#define JUG_PERK      "specialty_armorvest"
#define SPEED_PERK    "specialty_fastreload"
#define DT_PERK       "specialty_rof"
#define QR_PERK       "specialty_quickrevive"
#define STAMIN_PERK   "specialty_longersprint"
#define CHERRY_PERK   "specialty_grenadepulldeath"
#define MULE_PERK     "specialty_additionalprimaryweapon"
#define PHD_PERK      "specialty_flakjacket"
#define DEADSHOT_PERK "specialty_deadshot"
#define WHOISWHO_PERK "specialty_finalstand"
#define VULTURE_PERK  "specialty_nomotionsensor"

#define AIR_STRIKE "beacon_zm"
#define AN_U "an94_upgraded_zm+mms"
#define AN "an94_zm"
#define BOOMHILDA "c96_upgraded_zm"
#define CHICOM "qcw05_zm"
#define CLAYMORE "claymore_zm"
#define ELECTRIC "staff_lightning_upgraded_zm"
#define FIRE "staff_fire_upgraded_zm"
#define GALVA "tazer_knuckles_zm"
#define GAT "blundersplat_upgraded_zm"
#define ICE "staff_water_upgraded_zm"
#define JETGUN "jetgun_zm"
#define MP5 "mp5k_zm"
#define M16_U "m16_gl_upgraded_zm"
#define M1911 "m1911_zm"
#define MAUSER "c96_zm"
#define MK2 "raygun_mark2_zm"
#define MK2_U "raygun_mark2_upgraded_zm"
#define MONKS "cymbal_monkey_zm"
#define MP40 "mp40_zm"
#define MP40_U "mp40_upgraded_zm"
#define PARA "slowgun_zm"
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
#define STG "mp44_zm"
#define STG_U "mp44_upgraded_zm"
#define TOMAHAWK_U "upgraded_tomahawk_zm"
#define UZI "uzi_zm"
#define WAR_MACHINE "m32_zm"
#define WAR_MACHINE_U "m32_upgraded_zm"
#define WIND "staff_air_upgraded_zm"
#define EMPS "emp_grenade_zm"
#define KNIFE "knife_zm"
#define TOMAHAWK "bouncing_tomahawk_zm"

nopower_loadout()
{
	self.st_loadout_completed = false;
	self.st_loadout_weapons = array();
	self.st_loadout_equipment = array();
	self.st_loadout_main = undefined;
	self.st_loadout_mule = undefined;
	self.st_loadout_melee = KNIFE;

	if(istranzit())
	{
        if(iswhite(self))
		    self.st_loadout_weapons = array(M16_U, MK2, MONKS);
        else
		    self.st_loadout_weapons = array(M16_U, RAY, MONKS);
		self.st_loadout_main = M16_U;
	}
	if(isdierise())
	{
		if(iswhite(self))
		{
			self.st_loadout_weapons = array(SLIQ, AN_U, MONKS);
			self.st_loadout_mule = MK2;
			self.st_loadout_equipment = array(SPRINGPAD);
			self.st_loadout_main = SLIQ;
		}
		else if (isblue(self))
		{
			self.st_loadout_weapons = array(WAR_MACHINE_U, AN, MONKS);
			self.st_loadout_equipment = array(SPRINGPAD);
			self.st_loadout_main = WAR_MACHINE_U;
		}
		else if (isyellow(self))
		{
			self.st_loadout_weapons = array(AN_U, RAY, MONKS);
			self.st_loadout_equipment = array(SPRINGPAD);
			self.st_loadout_main = AN_U;
		}
		else if (isgreen(self))
		{
			self.st_loadout_weapons = array(WAR_MACHINE_U, AN, MONKS);
			self.st_loadout_equipment = array(SPRINGPAD);
			self.st_loadout_main = AN_U;
		}
	}
	if(ismob())
	{
		if(getDvarInt("st_shield"))
			self.st_loadout_equipment = array(SHIELD_MOB);

		if(iswhite(self))
			self.st_loadout_weapons = array(MK2, MP5);
		else
			self.st_loadout_weapons = array(RAY, MP5);

		self.st_loadout_main = MP5;
		self thread givetomahawk_unupgraded();
	}
	if(isburied())
	{
		if(iswhite(self))
		{
			self.st_loadout_weapons = array(MK2, PARA, MONKS, CLAYMORE);
			self.st_loadout_main = PARA;
		}
		else if(isblue(self))
		{
			self.st_loadout_weapons = array(RAY, MONKS, CLAYMORE);
			self.st_loadout_main = RAY;
		}
		else if(isyellow(self))
		{
			self.st_loadout_weapons = array(RAY, MONKS, CLAYMORE);
			self.st_loadout_main = RAY;
		}
		else if(isgreen(self))
		{
			self.st_loadout_weapons = array(MK2, MONKS, CLAYMORE);
			self.st_loadout_main = MK2;
		}
	}
	if(isorigins())
	{
		if(getDvarInt("st_shield"))
			self.st_loadout_equipment = array(SHIELD_ORIGINS);

		if(iswhite(self))
        {
            self.st_loadout_weapons = array(STG_U, ICE, AIR_STRIKE, CLAYMORE);
            self.st_loadout_main = ICE;
        }
        else if(isblue(self))
        {
            self.st_loadout_weapons = array(MP40, WIND, AIR_STRIKE, CLAYMORE);
            self.st_loadout_main = WIND;
        }
        else if(isyellow(self))
        {
            self.st_loadout_weapons = array(MP40, FIRE, AIR_STRIKE, CLAYMORE);
            self.st_loadout_main = FIRE;
        }
        else if(isgreen(self))
        {
            self.st_loadout_weapons = array(MP40, ELECTRIC, AIR_STRIKE, CLAYMORE);
            self.st_loadout_main = ELECTRIC;
        }
	}

	self.st_loadout_completed = true;
}

givetomahawk_unupgraded()
{
    flag_wait("afterlife_start_over");

	self notify( "tomahawk_picked_up" );
	level notify( "bouncing_tomahawk_zm_aquired" );
	self notify( "player_obtained_tomahawk" );

	self set_player_tactical_grenade(TOMAHAWK);
	self disable_player_move_states( 1 );
	self giveweapon( "zombie_tomahawk_flourish" );
	self switchtoweapon( "zombie_tomahawk_flourish" );
	self waittill_any( "player_downed", "weapon_change_complete" );
	self enable_player_move_states();
	self takeweapon( "zombie_tomahawk_flourish" );
	self giveweapon(TOMAHAWK);
	self givemaxammo(TOMAHAWK);
}

availablePerks_nopower()
{

    if ( isdepot() )
        level.available_perks = QR_PERK;
    else if ( isfarm() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;
    else if ( istown() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + QR_PERK;
    else if ( isnuketown() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;

    else if ( istranzit() && level.players.size == 1)
        level.available_perks =  QR_PERK;
    else if ( isdierise() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK + " " + WHOISWHO_PERK;
    else if ( isburied() )
        level.available_perks = VULTURE_PERK + " " + JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK;
    else if ( isorigins() )
        level.available_perks = DT_PERK;
	else 
        level.available_perks =  "";
}