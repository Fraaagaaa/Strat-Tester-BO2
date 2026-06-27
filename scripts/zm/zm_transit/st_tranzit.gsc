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

    level thread waitSpawn();
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

waitSpawn()
{
    while(true)
    {
        level waittill("connecting", player);
        player thread fridge();
    }
}

fridge()
{
	if(istranzit())
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m16_gl_upgraded_zm");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 270);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 30);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", 1);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", 8);
	}
}
