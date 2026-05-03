#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility; 

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\tranzit;
#include scripts\zm\strattester\schreecher;
#include scripts\zm\strattester\hud;

main()
{
    replacefunctions();

	flag_wait("initial_blackscreen_passed");

    if(!istranzit())
        level thread raygun_counter();

    if(istranzit())
    {
        level thread buildtranzitstuff();
        level thread busstatus();
        level thread denizens();
        level thread busloc();
        level thread showDenizenLocation();
    }
}
