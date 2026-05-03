#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\strattester\settings;
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

perk_init()
{
    if ( !getDvarInt( "st_perks" ) )
        return;

    if ( self == gethostplayer() )
    {
        increase_perk_limit();
        availablePerks();
    }

    self.menu_perk_jugg     = getDvarInt( "st_perk_" + JUG_PERK );
    self.menu_perk_dtap     = getDvarInt( "st_perk_" + DT_PERK );
    self.menu_perk_speed    = getDvarInt( "st_perk_" + SPEED_PERK );
    self.menu_perk_staminup = getDvarInt( "st_perk_" + STAMIN_PERK );
    self.menu_perk_revive   = getDvarInt( "st_perk_" + QR_PERK );
    self.menu_perk_mule     = getDvarInt( "st_perk_" + MULE_PERK );
    self.menu_perk_whoswho  = getDvarInt( "st_perk_" + WHOISWHO_PERK );
    self.menu_perk_cherry   = getDvarInt( "st_perk_" + CHERRY_PERK );
    self.menu_perk_phd      = getDvarInt( "st_perk_" + PHD_PERK );
    self.menu_perk_deadshot = getDvarInt( "st_perk_" + DEADSHOT_PERK );
    self.menu_perk_vulture  = getDvarInt( "st_perk_" + VULTURE_PERK );


    self thread perk_apply_loop();
    self thread perk_menu_listener();
}

increase_perk_limit()
{
    level.perk_purchase_limit = 10;
}

availablePerks()
{
    if ( isdepot() )
        level.available_perks = QR_PERK;
    else if ( isfarm() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;
    else if ( istown() || istranzit() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + QR_PERK;
    else if ( isnuketown() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + QR_PERK;
    else if ( isdierise() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK + " " + WHOISWHO_PERK;
    else if ( ismob() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + SPEED_PERK + " " + CHERRY_PERK + " " + DEADSHOT_PERK;
    else if ( isburied() )
        level.available_perks = VULTURE_PERK + " " + JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK;
    else if ( isorigins() )
        level.available_perks = JUG_PERK + " " + DT_PERK + " " + STAMIN_PERK + " " + SPEED_PERK + " " + MULE_PERK + " " + QR_PERK + " " + CHERRY_PERK + " " + PHD_PERK + " " + DEADSHOT_PERK;
}

perk_apply_loop()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    level waittill( "initial_blackscreen_passed" );

    if ( ismob() )
        flag_wait( "afterlife_start_over" );

    wait 1;

    perk_array = strtok( level.available_perks, " " );

    self give_configured_perks( perk_array );

    while ( true )
    {
        self waittill_any( "spawned_player", "player_revived" );
        wait 0.5;
        self give_configured_perks( perk_array );
    }
}

give_configured_perks( perk_array )
{
    foreach ( perk in perk_array )
    {
        if ( self get_menu_perk( perk ) )
        {
            if ( !self hasperk( perk ) )
                self give_perk( perk );
        }
        wait 0.05;
    }
}

perk_menu_listener()
{
    self endon( "disconnect" );
    self notify( "perk_menu_listener" );
    self endon( "perk_menu_listener" );
    level endon( "game_ended" );

    while ( true )
    {
        self waittill( "menuresponse", menu, response );

        if ( !isdefined( menu ) || !isdefined( response ) )
            continue;

        if ( menu != "restartgamepopup" )
            continue;

        if ( !issubstr( response, "stperk+" ) )
            continue;

        self start_perk_menu_response( response );
    }
}

start_perk_menu_response( response )
{
    parts = strtok( response, "+" );

    if ( !isdefined( parts ) || parts.size < 2 )
        return;

    if ( parts[0] != "stperk" )
        return;

    if ( parts[1] == "sync" )
    {
        for ( i = 2; i < parts.size; i++ )
        {
            entry = strtok( parts[i], ":" );
            if ( !isdefined( entry ) || entry.size < 2 )
                continue;

            value = perk_response_value( entry[1] );
            self set_menu_perk( entry[0], value );
        }
        return;
    }

    if ( parts[1] == "set" && parts.size >= 4 )
    {
        value = perk_response_value( parts[3] );
        self set_menu_perk( parts[2], value );
        return;
    }
}

perk_response_value( value_string )
{
    if ( !isdefined( value_string ) ) return 0;
    if ( value_string == "1" ) return 1;
    return 0;
}

set_menu_perk( perk, value )
{
    if ( perk == JUG_PERK )           self.menu_perk_jugg     = value;
    else if ( perk == DT_PERK )       self.menu_perk_dtap     = value;
    else if ( perk == SPEED_PERK )    self.menu_perk_speed    = value;
    else if ( perk == STAMIN_PERK )   self.menu_perk_staminup = value;
    else if ( perk == QR_PERK )       self.menu_perk_revive   = value;
    else if ( perk == MULE_PERK )     self.menu_perk_mule     = value;
    else if ( perk == WHOISWHO_PERK ) self.menu_perk_whoswho  = value;
    else if ( perk == CHERRY_PERK )   self.menu_perk_cherry   = value;
    else if ( perk == PHD_PERK )      self.menu_perk_phd      = value;
    else if ( perk == DEADSHOT_PERK ) self.menu_perk_deadshot = value;
    else if ( perk == VULTURE_PERK )  self.menu_perk_vulture  = value;
}

get_menu_perk( perk )
{
    if ( perk == JUG_PERK )           return self.menu_perk_jugg;
    if ( perk == DT_PERK )            return self.menu_perk_dtap;
    if ( perk == SPEED_PERK )         return self.menu_perk_speed;
    if ( perk == STAMIN_PERK )        return self.menu_perk_staminup;
    if ( perk == QR_PERK )            return self.menu_perk_revive;
    if ( perk == MULE_PERK )          return self.menu_perk_mule;
    if ( perk == WHOISWHO_PERK )      return self.menu_perk_whoswho;
    if ( perk == CHERRY_PERK )        return self.menu_perk_cherry;
    if ( perk == PHD_PERK )           return self.menu_perk_phd;
    if ( perk == DEADSHOT_PERK )      return self.menu_perk_deadshot;
    if ( perk == VULTURE_PERK )       return self.menu_perk_vulture;
    return 0;
}