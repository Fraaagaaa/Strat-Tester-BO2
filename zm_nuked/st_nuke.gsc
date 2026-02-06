#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\nuketown;

init()
{
    replacefunctions();
    level.total_chest_accessed = 0;
    level thread checkpaplocation();
    level thread boxhits();
	level thread raygun_counter();
}