#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_ai_sloth;
#include maps\mp\zombies\zm_buried_distance_tracking;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_equip_subwoofer;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\buildables;

init()
{
    replaceFunc(getfunction("maps/mp/zombies/_zm_equip_subwoofer","subwooferthink"), ::subwooferthink);
	flag_wait("initial_blackscreen_passed");
	level thread displaysubwooferkills();
	setDvar("magic_chest_movable", 0); // Make sure this is set to 1 if the player changes maps
    deleteBarricades();
    buildables_buried(getDvarInt("st_setupBuried"), getDvarInt("st_power"));
}

deleteBarricades()
{
	if(!getDvarInt("st_keepBarricades"))
		deleteSlothbarricades();
}

subwooferthink( weapon, armed )
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "equip_subwoofer_zm_taken" );
    weapon notify( "subwooferthink" );
    weapon endon( "subwooferthink" );
    weapon endon( "death" );
    direction_forward = anglestoforward( flat_angle( weapon.angles ) + vectorscale( ( -1, 0, 0 ), 30.0 ) );
    direction_vector = vectorscale( direction_forward, 512 );
    direction_origin = weapon.origin + direction_vector;
    original_angles = weapon.angles;
    original_origin = weapon.origin;
    tag_spin_origin = weapon gettagorigin( "tag_spin" );
    wait 0.05;

    while ( true )
    {
        if ( !( isdefined( weapon.power_on ) && weapon.power_on ) )
        {
            wait 1;
            continue;
        }

        wait 2.0;

        if ( !( isdefined( weapon.power_on ) && weapon.power_on ) )
            continue;

        if ( !isdefined( level._subwoofer_choke ) )
            level thread subwoofer_choke();

        while ( level._subwoofer_choke )
            wait 0.05;

        level._subwoofer_choke++;
        weapon.subwoofer_network_choke_count = 0;
        weapon thread maps\mp\zombies\_zm_equipment::signal_equipment_activated( 1 );
        vibrateamplitude = 4;

        if ( self.subwoofer_power_level == 3 )
            vibrateamplitude = 8;
        else if ( self.subwoofer_power_level == 2 )
            vibrateamplitude = 13;

        if ( self.subwoofer_power_level == 1 )
            vibrateamplitude = 17;

        weapon vibrate( vectorscale( ( 0, -1, 0 ), 100.0 ), vibrateamplitude, 0.2, 0.3 );
        zombies = get_array_of_closest( weapon.origin, get_round_enemy_array(), undefined, undefined, 1200 );
        players = get_array_of_closest( weapon.origin, get_players(), undefined, undefined, 1200 );
        props = get_array_of_closest( weapon.origin, getentarray( "subwoofer_target", "script_noteworthy" ), undefined, undefined, 1200 );
        entities = arraycombine( zombies, players, 0, 0 );
        entities = arraycombine( entities, props, 0, 0 );
        level.subwooferkills_count = 0;
        diff = 0;
        foreach ( ent in entities )
        {
            if ( !isdefined( ent ) || ( isplayer( ent ) || isai( ent ) ) && !isalive( ent ) )
                continue;

            if ( isdefined( ent.ignore_subwoofer ) && ent.ignore_subwoofer )
                continue;

            distanceentityandsubwoofer = distance2dsquared( original_origin, ent.origin );
            onlydamage = 0;
            action = undefined;

            if ( distanceentityandsubwoofer <= 32400 )
                action = "burst";
            else if ( distanceentityandsubwoofer <= 230400 )
                action = "fling";
            else if ( distanceentityandsubwoofer <= 1440000 )
                action = "stumble";
            else
                continue;

            if ( !within_fov( original_origin, original_angles, ent.origin, cos( 45 ) ) )
            {
                if ( isplayer( ent ) )
                    ent hit_player( action, 0 );

                continue;
            }

            weapon subwoofer_network_choke();
            ent_trace_origin = ent.origin;

            if ( isai( ent ) || isplayer( ent ) )
                ent_trace_origin = ent geteye();

            if ( isdefined( ent.script_noteworthy ) && ent.script_noteworthy == "subwoofer_target" )
                ent_trace_origin = ent_trace_origin + vectorscale( ( 0, 0, 1 ), 48.0 );

            if ( !sighttracepassed( tag_spin_origin, ent_trace_origin, 1, weapon ) )
                continue;

            if ( isdefined( ent.script_noteworthy ) && ent.script_noteworthy == "subwoofer_target" )
            {
                ent notify( "damaged_by_subwoofer" );
                continue;
            }

            if ( isdefined( ent.in_the_ground ) && ent.in_the_ground || isdefined( ent.in_the_ceiling ) && ent.in_the_ceiling || isdefined( ent.ai_state ) && ent.ai_state == "zombie_goto_entrance" || !( isdefined( ent.completed_emerging_into_playable_area ) && ent.completed_emerging_into_playable_area ) )
                onlydamage = 1;

            if ( isplayer( ent ) )
            {
                ent notify( "player_" + action );
                ent hit_player( action, 1 );
                continue;
            }

            if ( isdefined( ent ) )
            {
                ent notify( "zombie_" + action );
                shouldgib = distanceentityandsubwoofer <= 810000;

                if ( action == "fling" )
                {
                    ent thread fling_zombie( weapon, direction_vector / 4, self, onlydamage );
                    weapon.subwoofer_kills++;
                    diff++;
                    self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "subwoofer" );
                    continue;
                }

                if ( action == "burst" )
                {
                    ent thread burst_zombie( weapon, self );
                    weapon.subwoofer_kills++;
                    diff++;
                    self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "subwoofer" );
                    continue;
                }

                if ( action == "stumble" )
                    ent thread knockdown_zombie( weapon, shouldgib, onlydamage );
            }
        }

        level.subwooferkills_count += diff;

        if ( weapon.subwoofer_kills >= 45 )
            self thread subwoofer_expired( weapon );
    }
}

displaysubwooferkills()
{
	level thread displayWatcher();
	level.subwooferkills.hidewheninmenu = true;
    level.subwooferkills = createserverfontstring( "objective", 1.3 );
    level.subwooferkills.y = 0;
    level.subwooferkills.x = 0;
    level.subwooferkills.fontscale = 1.4;
    level.subwooferkills.alignx = "center";
    level.subwooferkills.horzalign = "user_center";
    level.subwooferkills.vertalign = "user_top";
    level.subwooferkills.aligny = "top";
    level.subwooferkills.label = &"ST_SUBWOOFER_KILLS_HUD";
    level.subwooferkills.alignx = "left";
    level.subwooferkills.horzalign = "user_left";
    level.subwooferkills.alpha = 0;
    level.subwooferkills setvalue(0);

    while(true)
    {
    	level.subwooferkills setvalue(level.subwooferkills_count);
        wait 0.1;
    }
}

displayWatcher()
{
    while(true)
    {
        wait 0.1;
        level.subwooferkills.alpha = getDvarInt("st_subwooferkills");
        level.subwooferkills.y = 15 * getDvarInt("st_despawners");
    }
}


deleteSlothbarricades()
{

    deleteSlothBarricade( "juggernaut_alley" );
    deleteSlothBarricade( "candystore_alley" );
    deleteSlothBarricade( "jail" );
    deleteSlothBarricade( "mansion" );
    level notify( "jail_barricade_down" );
    level notify( "cell_open" );
}