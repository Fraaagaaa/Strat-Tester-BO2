#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;

#include scripts\zm\strattester\ismap;

#define MULE_PERK "specialty_additionalprimaryweapon"

give_weapons_on_spawn()
{
	if(!getDvarInt("st_weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

    if(isburied())
	{
		self takeweapon("m1911_zm");
		self weapon_give( "m32_zm" );
		self weapon_give( "m1911_upgraded_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "claymore_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
		{
			self weapon_give( "slowgun_upgraded_zm" );
			self switchToWeapon( "slowgun_upgraded_zm" );
		}
	}
	if(isdierise())
	{
		self takeweapon("m1911_zm");
		if(self == level.players[0])
			self weapon_give( "slipgun_zm" );
		else
			self weapon_give( "m1911_upgraded_zm" );
		self weapon_give( "an94_upgraded_zm+mms" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		self weapon_give( "claymore_zm", undefined, undefined, 0 );
		self giveweapon_nzv( "equip_springpad_zm" );
		self switchToWeapon( "slipgun_zm" );
	}
	if(isnuketown())
	{
		self takeweapon("m1911_zm");
		if(self == level.players[0])
			self weapon_give( "raygun_mark2_upgraded_zm" );
		else
			self weapon_give( "ray_gun_zm" );
		self weapon_give( "m1911_upgraded_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
	}
	if(ismob())
	{
		flag_wait( "afterlife_start_over" );
		self takeweapon("m1911_zm");
		if(self == level.players[0])
		{
			self weapon_give( "blundersplat_upgraded_zm" );
			self weapon_give( "raygun_mark2_upgraded_zm" );
		}
		else if(self == level.players[1])
		{
			self weapon_give( "blundersplat_upgraded_zm" );
			self weapon_give( "m1911_upgraded_zm" );
		}
		else if(self == level.players[2])
		{
			self weapon_give( "m1911_upgraded_zm" );
			self weapon_give( "uzi_zm" );
		}
		else if(self == level.players[3])
		{
			self weapon_give( "m1911_upgraded_zm" );
			self weapon_give( "uzi_zm" );
		}
		if(getDvarInt("st_shield"))
			self giveweapon_nzv( "alcatraz_shield_zm" );
		self giveweapon_nzv( "claymore_zm" );
		self giveweapon_nzv( "upgraded_tomahawk_zm" );
		self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
	}
	if(isorigins())
	{
		self takeweapon("c96_zm");
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		if(getDvarInt("st_shield"))
			self giveweapon_nzv( "tomb_shield_zm" );
		if(level.players.size == 1)
		{
			if(getDvarInt("st_wm_origins"))
				self weapon_give( "m32_upgraded_zm" );
			else
				self weapon_give( "mp40_upgraded_zm" );
			self weapon_give( "raygun_mark2_upgraded_zm" );
			self equipment_take( "claymore_zm" );
			self weapon_give( "claymore_zm", undefined, undefined, 0 );
			self switchToWeapon( "mp40_upgraded_zm" );

			self setactionslot( 3, "weapon", "staff_revive_zm" );
			self giveweapon( "staff_revive_zm" );
			self givemaxammo( "staff_revive_zm" );
			switch(getDvarInt("st_staff"))
			{
				case 0:
				self weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_water_upgraded_zm" );
				break;

				case 1:
				self weapon_give( "staff_air_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_air_upgraded_zm" );
				break;

				case 2:
				self weapon_give( "staff_fire_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_fire_upgraded_zm" );
				break;
				
				case 3:
				self weapon_give( "staff_lightning_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_lightning_upgraded_zm" );
				break;

				default:
				self weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_water_upgraded_zm" );
				break;
			}
		}
		else
		{
			if(self != level.players[0])
			self giveweapon( "mp40_upgraded_zm" );

			if(self == level.players[0])
			{	
				if(getDvarInt("st_wm_origins"))
					self giveweapon( "m32_upgraded_zm" );
				else
					self giveweapon( "mp40_upgraded_zm" );

				self giveweapon( "raygun_mark2_upgraded_zm" );
			}
			else 
				self giveweapon( "c96_upgraded_zm" );

			self equipment_take( "claymore_zm" );
			self weapon_give( "claymore_zm", undefined, undefined, 0 );

			self setactionslot( 3, "weapon", "staff_revive_zm" );
			self giveweapon( "staff_revive_zm" );
			self givemaxammo( "staff_revive_zm" );
			level.players[0] weapon_give( "staff_air_upgraded_zm", undefined, undefined, 0 );
			level.players[1] weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
			level.players[2] weapon_give( "staff_fire_upgraded_zm", undefined, undefined, 0 );
			level.players[3] weapon_give( "staff_lightning_upgraded_zm", undefined, undefined, 0 );
			level.players[0] switchToWeapon( "staff_air_upgraded_zm" );
			level.players[1] switchToWeapon( "staff_water_upgraded_zm" );
			level.players[2] switchToWeapon( "staff_fire_upgraded_zm" );
			level.players[3] switchToWeapon( "staff_lightning_upgraded_zm" );
		}
	}
	if(istranzit())
	{
		self takeweapon("m1911_zm");
		self equipment_take( "claymore_zm" );
		self weapon_give( "claymore_zm", undefined, undefined, 0 );
		self giveweapon_nzv( "m16_gl_upgraded_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "jetgun_zm" );
		self giveweapon_nzv( "emp_grenade_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self != level.players[0])
			giveweapon_nzv( "m1911_upgraded_zm" );
		
	}
	if(istown())
	{
		self takeweapon("m1911_zm");
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
		else
			self giveweapon_nzv( "ray_gun_upgraded_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
	}
	if(isfarm() || isdepot())
	{
		self takeweapon("m1911_zm");
		self giveweapon_nzv( "cymbal_monkey_zm" );
		if(isfarm())
			self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "raygun_mark2_zm" );
		else
			self giveweapon_nzv( "ray_gun_zm" );
		self giveweapon_nzv( "qcw05_zm" );
	}
}

giveweapon_nzv( weapon )
{
	if( issubstr( weapon, "tomahawk_zm" ) && level.script == "zm_prison" )
	{
		self play_sound_on_ent( "purchase" );
		self notify( "tomahawk_picked_up" );
		level notify( "bouncing_tomahawk_zm_aquired" );
		self notify( "player_obtained_tomahawk" );
		if( weapon == "bouncing_tomahawk_zm" )
		{
			self.tomahawk_upgrade_kills = 0;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 0;
		}
		else
		{
			self.tomahawk_upgrade_kills = 99;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 1;
			self notify( "tomahawk_upgraded_swap" );
		}
		old_tactical = self get_player_tactical_grenade();
		if( old_tactical != "none" && IsDefined( old_tactical ) )
		{
			self takeweapon( old_tactical );
		}
		self set_player_tactical_grenade( weapon );
		self.current_tomahawk_weapon = weapon;
		gun = self getcurrentweapon();
		self disable_player_move_states( 1 );
		self giveweapon( "zombie_tomahawk_flourish" );
		self switchtoweapon( "zombie_tomahawk_flourish" );
		self waittill_any( "player_downed", "weapon_change_complete" );
		self switchtoweapon( gun );
		self enable_player_move_states();
		self takeweapon( "zombie_tomahawk_flourish" );
		self giveweapon( weapon );
		self givemaxammo( weapon );
		if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
		{
			self switchtoweapon( gun );
			self waittill( "weapon_change_complete" );
		}
		else
		{
			primaryweapons = self getweaponslistprimaries();
			if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
			{
				self switchtoweapon( primaryweapons[ 0] );
				self waittill( "weapon_change_complete" );
			}
		}
		self play_weapon_vo( weapon );
	}
	else
	{
		if( issubstr( weapon, "staff_" ) && isorigins() )
		{
			if( issubstr( weapon, "_upgraded_zm" ) )
			{
				if( !(self hasweapon( "staff_revive_zm" )) )
				{
					self setactionslot( 3, "weapon", "staff_revive_zm" );
					self giveweapon( "staff_revive_zm" );
				}
				self givemaxammo( "staff_revive_zm" );
			}
			else
			{
				if( self hasweapon( "staff_revive_zm" ) )
				{
					self takeweapon( "staff_revive_zm" );
					self setactionslot( 3, "altmode" );
				}
			}
			self weapon_give( weapon, undefined, undefined, 0 );
		}
		else
		{
			if( self is_melee_weapon( weapon ) )
			{
				if( weapon == "bowie_knife_zm" || weapon == "tazer_knuckles_zm" )
				{
					// self give_melee_weapon_by_name( weapon );
					self give_melee_weapon_instant( weapon );
				}
				else
				{
					self play_sound_on_ent( "purchase" );
					gun = self getcurrentweapon();
					gun = self change_melee_weapon( weapon, gun );
					self giveweapon( weapon );
					if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
					{
						self switchtoweapon( gun );
						self waittill( "weapon_change_complete" );
					}
					else
					{
						primaryweapons = self getweaponslistprimaries();
						if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
						{
							self switchtoweapon( primaryweapons[ 0] );
							self waittill( "weapon_change_complete" );
						}
					}
					self play_weapon_vo( weapon );
				}
			}
			else
			{
				if( self is_equipment( weapon ) )
				{
					self play_sound_on_ent( "purchase" );
					if( level.destructible_equipment.size > 0 && IsDefined( level.destructible_equipment ) )
					{
						i = 0;
						while( i < level.destructible_equipment.size )
						{
							equip = level.destructible_equipment[ i];
							if( equip.name == weapon && IsDefined( equip.name ) && equip.owner == self && IsDefined( equip.owner ) )
							{
								equip item_damage( 9999 );
								break;
							}
							else
							{
								if( equip.name == weapon && IsDefined( equip.name ) && weapon == "jetgun_zm" )
								{
									equip item_damage( 9999 );
									break;
								}
								else
								{
									i++;
								}
							}
							i++;
						}
					}
					self equipment_take( weapon );
					self equipment_buy( weapon );
					self play_weapon_vo( weapon );
				}
				else
				{
					if( self is_weapon_upgraded( weapon ) )
					{
						self weapon_give( weapon, 1, undefined, 0 );
					}
					else
					{
						self weapon_give( weapon, undefined, undefined, 0 );
					}
				}
			}
		}
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
		    self thread giveplayerdata();
	}
}