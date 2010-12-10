/*
  Copyright (c) 2009-2017 Andreas Göransson <andreas.goransson@gmail.com>
  Copyright (c) 2009-2017 Indrek Ardel <indrek@ardel.eu>

  This file is part of Call of Duty 4 Promod.

  Call of Duty 4 Promod is licensed under Promod Modder Ethical Public License.
  Terms of license can be found in LICENSE.md document bundled with the project.
*/

init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_team_flipped"] = "team_marinesopfor_flipped";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines_mw";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor_mw";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass_mw";
	game["menu_changeclass_offline"] = "changeclass_offline";
	game["menu_shoutcast"] = "shoutcast";
	game["menu_shoutcast_map"] = "shoutcast_map";
	game["menu_shoutcast_setup"] = "shoutcast_setup";
	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_team_flipped"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_changeclass_offline"]);
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	precacheMenu(game["menu_shoutcast"]);
	precacheMenu(game["menu_shoutcast_map"]);
	precacheMenu(game["menu_shoutcast_setup"]);
	precacheMenu("echo");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	level endon("restarting");
	self endon("disconnect");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if ( response == "back" )
		{
			if (self.team == "none")
				continue;

			self closeMenu();
			self closeInGameMenu();

			if ( menu == "changeclass_mw" && isDefined( self.pers["class"] ) )
			{
				self maps\mp\gametypes\_promod::setClassChoice( self.pers["class"] );
				self maps\mp\gametypes\_promod::menuAcceptClass( "go" );
			}

			if ( menu == "changeclass_mw" && self.pers["team"] == "allies" )
				self openMenu( game["menu_changeclass_allies"] );
			else if ( menu == "changeclass_mw" && self.pers["team"] == "axis" )
				self openMenu( game["menu_changeclass_axis"] );

			continue;
		}

		if( getSubStr( response, 0, 7 ) == "loadout" )
		{
			self maps\mp\gametypes\_promod::processLoadoutResponse( response );
			continue;
		}

		if( menu == "echo" )
		{
			k = strtok(response, "_");
			buf = "";
			for(i=0;i<k.size;i++)
			{
				buf += k[i];
				if(i!=k.size-1) buf += " ";
			}
			self iprintln(buf);
			continue;
		}

		if( response == "classavailability" )
		{
			self maps\mp\gametypes\_promod::updateClassAvailability( self.pers["team"] );
			continue;
		}

		if( response == "changeteam" )
		{
			self closeMenu();
			self closeInGameMenu();

			self openMenu(game["menu_team"]);
		}

		if( response == "shoutcast_setup" )
		{
			if ( self.pers["team"] != "spectator" )
				continue;

			self closeMenu();
			self closeInGameMenu();

			self openMenu(game["menu_shoutcast_setup"]);
		}

		if( response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if( response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if( menu == game["menu_team"] || menu == game["menu_team_flipped"] )
		{
			switch(response)
			{
				case "allies":
					self [[level.allies]]();
					break;

				case "axis":
					self [[level.axis]]();
					break;

				case "autoassign":
					self [[level.autoassign]]();
					break;

				case "shoutcast":
					self [[level.spectator]]();
					break;
			}
		}
		else if( menu == game["menu_changeclass_allies"] || menu == game["menu_changeclass_axis"] )
		{
			if ( response == "killspec" )
			{
				self [[level.killspec]]();
				continue;
			}

			if ( (response != "assault" && response != "specops" && response != "demolitions" && response != "sniper") || !self maps\mp\gametypes\_promod::verifyClassChoice( self.pers["team"], response ) )
				continue;

			self maps\mp\gametypes\_promod::setClassChoice( response );
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass"] );
			continue;
		}
		else if( menu == game["menu_changeclass"] )
			self maps\mp\gametypes\_promod::menuAcceptClass( response );
		else if( menu == game["menu_shoutcast_setup"] )
			self maps\mp\gametypes\_quickmessages::setFollow( response );

		if( menu == game["menu_quickcommands"] )
			maps\mp\gametypes\_quickmessages::quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			maps\mp\gametypes\_quickmessages::quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			maps\mp\gametypes\_quickmessages::quickresponses(response);
		else if(menu == game["menu_quickpromod"])
			thread maps\mp\gametypes\_quickmessages::quickpromod(response);
		else if(menu == game["menu_quickpromodgfx"])
			maps\mp\gametypes\_quickmessages::quickpromodgfx(response);
	}
}