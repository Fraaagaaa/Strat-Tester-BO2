#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\utility;

replacefunctions()
{
    replaceFunc(maps\mp\zm_alcatraz_distance_tracking::delete_zombie_noone_looking, ::delete_zombie_noone_looking);
}

power_on_shit()
{
    wait 2;
    level notify( "gondola_powered_on_docks" );
    waittillframeend;
    a_afterlife_interact = getentarray( "afterlife_interact", "targetname" );

    foreach(interact in  a_afterlife_interact)
        if ( isdefined( interact.script_string ) )
            interact notify( "damage", 1, level );

    m_master_key_pulley = getent( "master_key_pulley_" + ( level.is_master_key_west ? "west" : "east" ), "targetname" );
    m_master_key_pulley notify( "damage", 1, level );

    for ( n_panel_index = 1; n_panel_index < 4; n_panel_index++ )
    {
        m_generator_panel = getent( "generator_panel_" + n_panel_index, "targetname" );
        m_generator_panel notify( "damage", 1, level );
    }

    m_docks_shockbox = getent( "docks_panel", "targetname" );
    m_docks_shockbox notify( "damage", 1, level );
}
speeddoor()
{
    if(getDvarInt("st_doors") == 0)
        return;
    if(getDvarInt("st_power") == 0)
        return;

    thread power_on_shit();

    flag_wait( "initial_blackscreen_passed" );

    a_t_doors = getentarray( "zombie_door", "targetname" );
    while(true)
    {
        foreach ( player in level.players )
        {
            if ( player getcurrentweapon() == "lightning_hands_zm" )
            {
                prev_dist = level.afterlife_interact_dist;
                level.afterlife_interact_dist = 2147483647;

                foreach (aft_door in a_t_doors)
                {
                    if( isdefined( aft_door.script_noteworthy ) && aft_door.script_noteworthy == "afterlife_door" && Distance( aft_door.origin, (2138, 9210, 1375) ) > 10 )
                    {
                        s_struct = getstruct( aft_door.target, "targetname" );
                        m_shockbox = getent( s_struct.target, "targetname" );
                        m_shockbox notify( "damage", 1, player );
                    }
                }

                waittillframeend;
                level.afterlife_interact_dist = prev_dist;
                return;
            }
        }

        wait 1;
    }
}

infinite_afterlifes()
{
	self endon( "disconnect" );
	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		if(getDvarInt("lives"))
			self.lives++;
	}
}