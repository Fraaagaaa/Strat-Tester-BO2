#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility; 

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\tranzit;
#include scripts\zm\strattester\schreecher;

main()
{
    replacefunctions();

	flag_wait("initial_blackscreen_passed");

    if(!istranzit())
        level thread raygun_counter();

    if(istranzit())
    {
        buildables = array("dinerhatch", "bushatch", "busladder", "cattlecatcher", "jetgun_zm", "electric_trap", "turret", "turbine", "pap", "powerswitch", "riotshield_zm");
        foreach(buildable in buildables)
            build_buildable( buildable );
        level thread busstatus();
        level thread denizens();
        level thread busloc();
        // level thread screecher_test();
        while(true)
        {
            level waittill("connecting", player);
            // player thread busloc();
        }
    }
}

build_buildable( buildable )
{
    player = get_players()[0];

    for ( i = 0; i < level.buildable_stubs.size; i++ )
    {
        if ( !isdefined( buildable ) || level.buildable_stubs[i].equipname == buildable )
        {
            if ( !isdefined( buildable ) && is_true( level.buildable_stubs[i].ignore_open_sesame ) )
                continue;

            if ( isdefined( buildable ) || level.buildable_stubs[i].persistent != 3 )
                level.buildable_stubs[i] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
        }
    }
}