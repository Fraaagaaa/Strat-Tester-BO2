#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;
#include scripts\zm\strattester\hud;

#define HIDE_TIMER 0
#define TOP_RIGHT_TIMER 1
#define TOP_LEFT_TIMER 2
#define MID_LEFT_TIMER 3
#define AMMO_TIMER 4

timer()
{
	self endon("disconnect");

	self thread roundtimer();
	self.timer = newclienthudelem(self);
	self.timer.hidewheninmenu = 1;
	self.timer.fontscale = 1.7;
	self thread timerlocation();
	flag_wait("initial_blackscreen_passed");
	while(true)
	{
		self.timer settimer( int(gettime() / 1000) - level.start_time);
		wait 0.05;
	}
}

roundtimer()
{
	level endon("end_game");
    self endon("disconnect");

	self.roundtimer = newclienthudelem(self);
	self.roundtimer.alpha = 1;
	self.roundtimer.fontscale = 1.7;
	self.roundtimer.color = (0.8, 0.8, 0.8);
	self.roundtimer.hidewheninmenu = true;
	self.roundtimer.x = self.timer.x;
	self.roundtimer.y = self.timer.y + 15;
	flag_wait("initial_blackscreen_passed");
	if(ismob()) flag_wait("afterlife_start_over");
	while(true)
	{
		self.roundtimer settimerup(0);
        start_time = int(gettime() / 1000);
        level waittill("end_of_round");
        end_time = int(gettime() / 1000);
        self.roundtimer thread display_round_time(end_time - start_time);
		level waittill("start_of_round");
	}
}

display_round_time(time)
{
    level endon("end_game");
    level endon("start_of_round");

    while (true)
    {
        self settimer(time - 0.1);
        wait 0.05;
    }
}

despawnersTimer()
{
    level endon("end_game");
    self endon("disconnect");

    if ( !isdefined( level.zombie_tracking_wait ) )
    {
        c = 0;
        waittillframeend;

        while ( !isdefined( level.zombie_tracking_wait ) )
        {
            c++;
            if ( c >= 100 )
                return;
            wait 0.05;
            waittillframeend;
        }
    }

    self.despawnersTimer = newclienthudelem(self);
    self.despawnersTimer.font = "objective";
    self.despawnersTimer.fontscale = 1.4;
    self.despawnersTimer.hidewheninmenu = 1;
    self.despawnersTimer.color = (0.7, 0.7, 0.7);

    while(true)
    {
        self.despawnersTimer settimer( level.zombie_tracking_wait );
        wait level.zombie_tracking_wait;
    }
}
    

traptimer()
{
	self endon( "disconnect" );

	self.traptimer = newclienthudelem( self );
	self.traptimer.alignx = "left";
	self.traptimer.aligny = "top";
	self.traptimer.horzalign = "user_left";
	self.traptimer.vertalign = "user_top";
	self.traptimer.x = 2;
	self.traptimer.y = 40;
	self.traptimer.fontscale = 1.4;
	self.traptimer.hidewheninmenu = 1;
	self.traptimer.hidden = 0;
	self.traptimer.label = &"";

	while(true)
    {
        level waittill( "trap_activated" );
        wait 0.1;
        self.traptimer.color = ( 0, 1, 0 );
        self.traptimer.alpha = 1;
        self.traptimer settimer( 25 );
        wait 25;
        self.traptimer settimer( 25 );
        self.traptimer.color = ( 1, 0, 0 );
        wait 25;
        self.traptimer.alpha = 0;
    }
}

icestafftimer()
{
	self endon( "disconnect" );

	self.icestafftimer = newclienthudelem( self );
	self.icestafftimer.fontscale = 1.4;
	self.icestafftimer.hidewheninmenu = 1;
	self.icestafftimer.color = (0, 0.8, 0.8);
    self.icestafftimer.alpha = 0;
	
	while(true)
	{
		level waittill("blizzard_shot", time);
        if(self get_menu_hud("st_stafftimer") == 0)
            continue;
        self.icestafftimer thread setnotifytimer("ice", time + 1);
	}
}

windstafftimer()
{
	self endon( "disconnect" );

	self.windstafftimer = newclienthudelem( self );
	self.windstafftimer.fontscale = 1.4;
	self.windstafftimer.hidewheninmenu = 1;
	self.windstafftimer.color = (0.9, 0.9, 0.25);
    self.windstafftimer.alpha = 0;
	
	while(true)
	{
        level waittill("whirlwind_active", time);
        if(self get_menu_hud("st_stafftimer") == 0)
            continue;
        self.windstafftimer setnotifytimer("wind", time);
	}
}

setnotifytimer(end, time)
{
    self notify("end_timer_" + end);
    self endon("end_timer_" + end);

    self.alpha = 1;
	self settimer(time);
    wait time + 0.5;
    self.alpha = 0;
}

bustimer()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self.bustimer = newclienthudelem(self);
    self.bustimer.alpha = 0;
    self.bustimer.color = (0.505, 0.478, 0.721);
    self.bustimer.hidewheninmenu = true;
    self.bustimer.fontscale = 1.7;
    self.bustimer.alignx = "right";
    self.bustimer.aligny = "top";
    self.bustimer.horzalign = "user_right";
    self.bustimer.vertalign = "user_top";
    self.bustimer.x = 0;
    while(true)
    {
        wait 0.1;
        zone = level.the_bus get_current_zone();
        if(!isdefined(zone))
            continue;

        if( zone == "zone_station_ext")
            self.bustimer settimerup(0);
    }
}

sliquifiretimer()
{
    self endon( "disconnect" );

    self.sliquifiretimer = newclienthudelem( self );
    self.sliquifiretimer.fontscale = 1.4;
    self.sliquifiretimer.hidewheninmenu = 1;
    self.sliquifiretimer.color = (0.9, 0.1, 0.9);
    self.sliquifiretimer.alpha = 0;
    
    while(true)
    {
        level waittill("sliq_fired", time);
        if(self get_menu_hud("st_sliquifiretimer") == 0)
            continue;
        self.sliquifiretimer thread setnotifytimer("sliq", time);
    }
}

timerlocation()
{
	level endon("end_game");
	self endon("disconnect");

    offset = 15;
	while(true)
	{
		switch(getDvarInt("st_timer"))
		{
			case HIDE_TIMER:
				self.timer.alpha = 0;
				self.roundtimer.alpha = 0;
				break;
			case TOP_RIGHT_TIMER:
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -1;
				self.timer.y = 13;
				self.timer.alpha = 1;
				self.roundtimer.alpha = 1;
				if(getDvar("cg_drawFPS") != "Off") self.timer.y += 6;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese") self.timer.y += 10;
				if(isdierise()) self.timer.y = 30;
				break;
			case TOP_LEFT_TIMER:
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 0;
				self.timer.alpha = 1;
				self.roundtimer.alpha = 1;
				if(isorigins()) self.timer.y = 45;
				if(issurvivalmap()) self.timer.y = 40;
				if(isdierise() && level.springpad_hud.alpha != 0) self.timer.y = 10;
				if(isburied() && level.springpad_hud.alpha != 0) self.timer.y = 35;
				break;
			case MID_LEFT_TIMER:
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 250;
				self.timer.alpha = 1;
				self.roundtimer.alpha = 1;
				break;
			case AMMO_TIMER:
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -170;
                if(isorigins())
				    self.timer.y = 400;
                else
				    self.timer.y = 415;
				self.timer.alpha = 1;
				self.roundtimer.alpha = 1;
				break;
			default: break;
		}

		self.roundtimer.alignx = self.timer.alignx;
		self.roundtimer.aligny = self.timer.aligny;
		self.roundtimer.horzalign = self.timer.horzalign;
		self.roundtimer.vertalign = self.timer.vertalign;
		self.roundtimer.x = self.timer.x;
		self.roundtimer.y = self.timer.y + offset;

        current_y = self.roundtimer.y;

        if(isdefined(self.despawnersTimer))
        {
            self.despawnersTimer.alpha = self get_menu_hud("st_despawners");
            current_y = self.despawnersTimer setLocation(self.timer, current_y, offset);
        }

        if(isdefined(self.sliquifireTimer))
        {
            self.sliquifiretimer .alpha = self get_menu_hud("st_sliquifiretimer");
            current_y = self.sliquifiretimer setLocation(self.timer, current_y, offset);
        }

        if(isdefined(self.traptimer))
            current_y = self.traptimer setLocation(self.timer, current_y, offset);

        if(isdefined(self.icestafftimer))
            current_y = self.icestafftimer setLocation(self.timer, current_y, offset);

        if(isdefined(self.windstafftimer))
            current_y = self.windstafftimer setLocation(self.timer, current_y, offset);

        if(isdefined(self.bustimer))
        {
            self.bustimer .alpha = self get_menu_hud("st_bustimer");
            current_y = self.bustimer setLocation(self.timer, current_y, offset);
        }

        if(isdefined(self.sliquifiretimer))
            current_y = self.sliquifiretimer setLocation(self.timer, current_y, offset);

        if(GetDvar("language") == "japanese")
            self.timer.fontscale = 1.5;
        else
            self.timer.fontscale = 1.7;

        self.roundtimer.fontscale = self.timer.fontscale;
        self.despawnersTimer.fontscale = self.timer.fontscale;
        if(isdefined(self.traptimer)) self.traptimer.fontscale = self.timer.fontscale;
        if(isdefined(self.icestafftimer)) self.icestafftimer.fontscale = self.timer.fontscale;
        if(isdefined(self.windstafftimer)) self.windstafftimer.fontscale = self.timer.fontscale;

        wait 0.1;
    }
}

setLocation(ref, current_y, offset)
{
    if(!isdefined(offset))
        offset = 15;

    self.alignx = ref.alignx;
    self.aligny = ref.aligny;
    self.horzalign = ref.horzalign;
    self.vertalign = ref.vertalign;
    self.x = ref.x;

    if (self.alpha > 0)
        current_y += offset;

    self.y = current_y;

    return current_y; 
}
