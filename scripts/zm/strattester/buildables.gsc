#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;

#include scripts\zm\strattester\utility;

#define BUILDABLE_BURIED_JUG_ORIGIN (-340, 747.4, 188)
#define BUILDABLE_BURIED_COURT_ORIGIN (-107.4, 951.4, 76)
#define BUILDABLE_BURIED_SALOON_ORIGIN (675.67, -1145.29, 116.78)
#define BUILDABLE_BURIED_CHURCH_ORIGIN (1262.05, 1488.44, 60.15)

#define BUILDABLE_BURIED_JUG_ANGLES (0, 180, 0)
#define BUILDABLE_BURIED_COURT_ANGLES (0, -180, 0)
#define BUILDABLE_BURIED_SALOON_ANGLES (61.5365, 270.343, 0.216167)
#define BUILDABLE_BURIED_CHURCH_ANGLES (0, 340, 0)

#define BUILDABLE_DIERISE_SPRINGPAD_ORIGIN (1890, 1350.11, 3105)
#define BUILDABLE_DIERISE_SPRINGPAD_ANGLES (75, 0, 0)

#define BUILDABLE_DIERISE_SLIQUIFIRE_ORIGIN (2399.31, -327.68, 1181.41)
#define BUILDABLE_DIERISE_SLIQUIFIRE_ANGLES (0, 150.4, 0)

#define BUILDABLE_MOB_CAFETERIA_ORIGIN (3380, 9406, 1407)
#define BUILDABLE_MOB_CAFETERIA_ANGLES (0, 180, 0)

#define BUILDABLE_ORIGINS_WIND_ORIGIN (2308, 700, 50)
#define BUILDABLE_ORIGINS_WIND_ANGLES (0, 90, 0)

#define BUILDABLE_ORIGINS_CHURCH_ORIGIN (130, -2990, 120) 
#define BUILDABLE_ORIGINS_CHURCH_ANGLES (0, 15, 0) 


#define SPRINGPAD "equip_springpad_zm"
#define SUBWOOFER "equip_subwoofer_zm"
#define TURBINE "equip_turbine_zm"
#define HEADCHOPPER "equip_headchopper_zm"
#define SHIELD_MOB "alcatraz_shield_zm"
#define SHIELD_ORIGINS "tomb_shield_zm"

#define SUBWOOFER_ID 1
#define TURBINE_ID 2
#define SPRINGPAD_ID 3
#define HEADCHOPPER_ID 4
#define SHIELD_MOB_ID 5
#define SHIELD_ORIGINS_ID 6

#define SUBWOOFER_MODEL "t6_wpn_zmb_subwoofer"
#define TURBINE_MODEL "p6_anim_zm_buildable_turbine"
#define SPRINGPAD_MODEL "p6_anim_zm_buildable_tramplesteam"
#define HEADCHOPPER_MODEL "t6_wpn_zmb_chopper"
#define SHIELD_MOB_MODEL "t6_wpn_zmb_shield_dlc2_dmg0_world"
#define SHIELD_ORIGINS_MODEL "t6_wpn_zmb_shield_dlc4_dmg0_world"

#define SUBWOOFER_STRING &"ZM_BURIED_EQ_SW_PHS"
#define TURBINE_STRING &"ZOMBIE_EQUIP_TURBINE_PICKUP_HINT_STRING"
#define SPRINGPAD_STRING_BURIED &"ZM_BURIED_EQ_SP_PHS"
#define SPRINGPAD_STRING_DIERISE &"ZM_HIGHRISE_GRAB_SPRINGPAD"
#define HEADCHOPPER_STRING &"ZM_BURIED_EQ_HC_PHS"
#define SHIELD_STRING &"ZOMBIE_GRAB_RIOTSHIELD"

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
		if (craftable.equipname == "open_table")
			craftable thread setcraftableoption( index );
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
		wait 0.05;

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
			trig sethintstring( self.hint_string );
	}
}


takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
    {
        foreach (piece in stub.a_piecestubs)
        {
            piecespawn = piece.piecespawn;
            if ( isDefined( piecespawn ) && buildable == "gramaphone" )
                player player_take_piece_gramophone( piecespawn );
            else
                player player_take_piece(piecespawn);
        }
    }
			return;
}

get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
		if ( uts_craftable.craftablestub.name == str_craftable )
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
				if ( piecespawn.piecename == str_piece )
					return piecespawn;
	return undefined;
}

player_take_piece_gramophone( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared  && isDefined( piecestub.client_field_id ))
        level setclientfield( piecestub.client_field_id, 1 );

	else if ( isDefined( piecestub.client_field_state ) )
		self setclientfieldtoplayer( "craftable", piecestub.client_field_state );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
		self.model delete();

	self.model = undefined;

	if ( isDefined( self.unitrigger ) )
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );

	self.unitrigger = undefined;
}

takeAllParts() 
{
	if(ismob() && !getDvarInt("st_power"))
		return;
    p = getPlayers()[0];
    foreach ( craftable in level.a_uts_craftables ) 
	{
        foreach ( piece in craftable.craftablespawn.a_piecespawns )
		{
            p player_take_piece(piece);
            wait 0.1;
        }
    }

    p player_drop_piece();

    level notify("allPartsTaken");
}

equipment_buy( equipment )
{
    if ( isdefined( self.current_equipment ) && equipment != self.current_equipment )
        self equipment_drop( self.current_equipment );

    if ( ( equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" || equipment == "tomb_shield_zm" ) && isdefined( self.player_shield_reset_health ) )
        self [[ self.player_shield_reset_health ]]();
    else
        self player_set_equipment_damage( equipment, 0 );

    self equipment_give( equipment );
}

createBuildable(buildable, origin, angles, hintstring, dvar)
{
    b = spawnStruct();

    b.build = buildable;
    b.origin = origin;
    b.angles = angles;
    b.hintstring = hintstring;

    b.model = spawn("script_model", (b.origin));
    b.model.angles = (b.angles + vectorScale((0, 0, 0), 90));

    b.trigger = spawn("trigger_radius", b.origin, 40, 70, 140);
    b.trigger.targetname = "shield_trigger";
    b.trigger SetCursorHint("HINT_NOICON");
    b.trigger SetHintString(b.hintstring);

    if(isdefined(dvar))
    {
        b.dvar = dvar;
        b thread buildableWatchDvarChange();
    }
    else
    {
        if(buildable == SPRINGPAD)
            b setBuildableData(SPRINGPAD_ID);
        else if(buildable == TURBINE)
            b setBuildableData(TURBINE_ID);
        else if(buildable == SUBWOOFER)
            b setBuildableData(SUBWOOFER_ID);
        else if(buildable == HEADCHOPPER)
            b setBuildableData(HEADCHOPPER_ID);
        else if(buildable == SHIELD_MOB)
            b setBuildableData(SHIELD_MOB_ID);
        else if(buildable == SHIELD_ORIGINS)
            b setBuildableData(SHIELD_ORIGINS_ID);
    }

    while(true)
    {
        b.trigger waittill("trigger", player);

        if(player UseButtonPressed())
        {
            if(!player hasWeapon(b.build))
                player equipment_buy(b.build);
        }

        wait 0.1;
    }
}

buildableWatchDvarChange()
{
    if(!isdefined(self.dvar))
        return;

    oldBuildable = undefined;

    newBuildable = getDvarInt(self.dvar);

    while(true)
    {
        self setBuildableData(newBuildable);
        self.trigger SetHintString(self.hintstring);

        level waittill("dvar_" + self.dvar + "_changed", newBuildable);
        newBuildable = int(newBuildable);
    }
}

setBuildableData(id)
{
    if(id == SUBWOOFER_ID)
    {
        self.build = SUBWOOFER;
        self.hintstring = SUBWOOFER_STRING;
        self.model setmodel(SUBWOOFER_MODEL);
    }
    else if(id == TURBINE_ID)
    {
        self.build = TURBINE;
        self.hintstring = TURBINE_STRING;
        self.model setmodel(TURBINE_MODEL);
    }
    else if(id == SPRINGPAD_ID && isburied())
    {
        self.build = SPRINGPAD;
        self.hintstring = SPRINGPAD_STRING_BURIED;
        self.model setmodel(SPRINGPAD_MODEL);
    }
    else if(id == SPRINGPAD_ID && isdierise())
    {
        self.build = SPRINGPAD;
        self.hintstring = SPRINGPAD_STRING_DIERISE;
        self.model setmodel(SPRINGPAD_MODEL);
    }
    else if(id == HEADCHOPPER_ID)
    {
        self.build = HEADCHOPPER;
        self.hintstring = HEADCHOPPER_STRING;
        self.model setmodel(HEADCHOPPER_MODEL);
    }
    else if(id == SHIELD_MOB_ID)
    {
        self.build = SHIELD_MOB;
        self.hintstring = SHIELD_STRING;
        self.model setmodel(SHIELD_MOB_MODEL);
    }
    else if(id == SHIELD_ORIGINS_ID)
    {
        self.build = SHIELD_ORIGINS;
        self.hintstring = SHIELD_STRING;
        self.model setmodel(SHIELD_ORIGINS_MODEL);
    }
}

init_buildables()
{
	flag_wait( "initial_blackscreen_passed" );
	if(isburied())
	{
		level thread createBuildable(SUBWOOFER, BUILDABLE_BURIED_JUG_ORIGIN, BUILDABLE_BURIED_JUG_ANGLES, SUBWOOFER_STRING, "st_buried_jug_buildable");
		level thread createBuildable(TURBINE, BUILDABLE_BURIED_COURT_ORIGIN, BUILDABLE_BURIED_COURT_ANGLES, TURBINE_STRING, "st_buried_court_buildable");
		level thread createBuildable(SPRINGPAD, BUILDABLE_BURIED_SALOON_ORIGIN, BUILDABLE_BURIED_SALOON_ANGLES, SPRINGPAD_STRING_BURIED, "st_buried_saloon_buildable");
		level thread createBuildable(HEADCHOPPER, BUILDABLE_BURIED_CHURCH_ORIGIN, BUILDABLE_BURIED_CHURCH_ANGLES, HEADCHOPPER_STRING, "st_buried_church_buildable");
	}
	else if(isorigins())
	{
		level thread createBuildable(SHIELD_ORIGINS, BUILDABLE_ORIGINS_CHURCH_ORIGIN, BUILDABLE_ORIGINS_CHURCH_ANGLES, SHIELD_STRING);
		level thread createBuildable(SHIELD_ORIGINS, BUILDABLE_ORIGINS_WIND_ORIGIN, BUILDABLE_ORIGINS_WIND_ANGLES, SHIELD_STRING);
	}
	else if(ismob())
	{
		level thread createBuildable(SHIELD_MOB, BUILDABLE_MOB_CAFETERIA_ORIGIN, BUILDABLE_MOB_CAFETERIA_ANGLES, SHIELD_STRING);
	}
	else if(isdierise())
	{
		level thread createBuildable(SPRINGPAD, BUILDABLE_DIERISE_SPRINGPAD_ORIGIN, BUILDABLE_DIERISE_SPRINGPAD_ANGLES, SPRINGPAD_STRING_DIERISE);
	}
}