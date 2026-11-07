#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\buildables;

init()
{
	flag_wait("initial_blackscreen_passed");

	level thread activateAfterlifeSwitches();
	level thread fixBrutusRounds();
	level thread takeAllParts();

	foreach(player in getPLayers())
		player thread infiniteAfterlifes();
}

activateAfterlifeSwitches()
{
    if(getDvarInt("st_doors") == 0)
        return;
    if(getDvarInt("st_power") == 0)
        return;

    flag_wait("afterlife_start_over");

    thread openOfficeDoor();


    foreach(interact in  getentarray("afterlife_interact", "targetname"))
        if (isdefined(interact.script_string))
            interact notify("damage", 1, level);

    m_master_key_pulley = getent("master_key_pulley_" + (level.is_master_key_west ? "west" : "east"), "targetname");
    m_master_key_pulley notify("damage", 1, level);

    for (n_panel_index = 1; n_panel_index < 4; n_panel_index++)
    {
        m_generator_panel = getent("generator_panel_" + n_panel_index, "targetname");
        m_generator_panel notify("damage", 1, level);
    }

    m_docks_shockbox = getent("docks_panel", "targetname");
    m_docks_shockbox notify("damage", 1, level);

    level notify("gondola_powered_on_docks");
}

openOfficeDoor()
{
    while(true)
    {
        foreach (player in level.players)
        {
            if (player getcurrentweapon() == "lightning_hands_zm")
            {
                baseDistance = level.afterlife_interact_dist;
                level.afterlife_interact_dist = 2147483647;

                foreach (door in getentarray("zombie_door", "targetname"))
                {
                    if(isdefined(door.script_noteworthy) && door.script_noteworthy == "afterlife_door" && distance(door.origin, (2138, 9210, 1375)) > 10)
                    {
                        s_struct = getstruct(door.target, "targetname");
                        m_shockbox = getent(s_struct.target, "targetname");
                        m_shockbox notify("damage", 1, player);
                    }
                }

                waittillframeend;
                level.afterlife_interact_dist = baseDistance;
                return;
            }
        }

        wait 1;
    }
}

infiniteAfterlifes()
{
    level endon("end_game");
	self endon("disconnect");
	while(true)
	{
		self waittill("player_revived", reviver);
		wait 2;
		if(getDvarInt("st_lives"))
        {
            if(level.players.size == 1)
			    self.lives = 4;
            else
			    self.lives = 2;
        }
	}
}

fixBrutusRounds()
{
    level endon("end_game");
    while(true)
    {
        level waittill("start_of_round");
        if(level.next_brutus_round < level.round_number)
            level.next_brutus_round = level.round_number + randomintrange( level.brutus_min_round_fq, level.brutus_max_round_fq );

        if(level.next_brutus_round > (level.round_number + level.brutus_max_round_fq))
            level.next_brutus_round = level.round_number + randomintrange( level.brutus_min_round_fq, level.brutus_max_round_fq );
    }
}