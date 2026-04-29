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
        level thread busstatus();
        level thread denizens();
        level thread busloc();
        bhb = maps\mp\zombies\_zm_buildables::vehicle_buildable_trigger_think( level.the_bus, "bus_hatch_bottom_trigger", "bushatch", "bushatch", "", 0, 0 );
        bhb.origin = (0,0,0);
        // level thread screecher_test();
        while(true)
        {
            level waittill("connecting", player);
            // player thread busloc();
        }
    }
}