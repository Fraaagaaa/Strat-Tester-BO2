#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_nuked_perks;
#include maps\mp\zm_nuked;

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\hud;
#include scripts\zm\strattester\utility;

init()
{
    level.total_chest_accessed = 0;
    level thread checkpaplocation();
}

checkpaplocation()
{
	wait 0.1;
	pap = getent( "specialty_weapupgrade", "script_noteworthy" );
	jug = getent( "vending_jugg", "targetname" );
	if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
		cmdexec("fast_restart");
}