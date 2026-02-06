#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility; 

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\ismap;
#include scripts\zm\strattester\tranzit;

main()
{
    if(!istranzit())
        level thread raygun_counter();

    if(istranzit())
    while(true)
    {
        level waittill("connecting", player);
        if(!isdefined(player.bustimer))
            player thread busloc();
    }
}