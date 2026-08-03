#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\utility;

timer()
{
	self endon("disconnect");

	self thread roundtimer();
	self thread timerlocation();
	self.timer = newclienthudelem(self);
	self.timer.hidewheninmenu = 1;
	self.timer.fontscale = 1.7;
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
        // -0.1 avoids flickering
        self settimer(time - 0.1);
        wait 0.05;
    }
}

#define HIDE_TIMER 0
#define TOP_RIGHT_TIMER 1
#define TOP_LEFT_TIMER 2
#define MID_LEFT_TIMER 3
#define AMMO_TIMER 4

timerlocation()
{
	level endon("end_game");
	self endon("disconnect");

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
				if(getDvar("cg_drawFPS") != "Off")
					self.timer.y += 6;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese")
					self.timer.y += 10;
				if(isdierise())
					self.timer.y = 30;
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
		self.roundtimer.y = self.timer.y + 15;
        if(isdefined(self.traptimer))
        {
            self.traptimer.alignx = self.timer.alignx;
            self.traptimer.aligny = self.timer.aligny;
            self.traptimer.horzalign = self.timer.horzalign;
            self.traptimer.vertalign = self.timer.vertalign;
            self.traptimer.x = self.timer.x;
            self.traptimer.y = self.timer.y + 30;
        }
		
		if(GetDvar("language") == "japanese")
		{
			self.timer.fontscale = 1.5;
			self.roundtimer.fontscale = self.timer.fontscale;
		}

        wait 0.1;
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
		if(getDvarInt("st_traptimer"))
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
		wait 0.1;
	}
}
