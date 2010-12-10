/*
  Copyright (c) 2009-2017 Andreas Göransson <andreas.goransson@gmail.com>
  Copyright (c) 2009-2017 Indrek Ardel <indrek@ardel.eu>

  This file is part of Call of Duty 4 Promod.

  Call of Duty 4 Promod is licensed under Promod Modder Ethical Public License.
  Terms of license can be found in LICENSE.md document bundled with the project.
*/

main()
{
	for(;;)
	{
		if ( getDvarInt( "sv_cheats" ) )
			break;

		forceDvar( "sv_disableClientConsole", "0");
		forceDvar( "sv_fps", "20" );
		forceDvar( "sv_pure", "1" );
		forceDvar( "sv_maxrate", "25000");
		forceDvar( "g_gravity", "800" );
		forceDvar( "g_knockback", "1000" );
		forceDvar( "authServerName", "cod4master.activision.com" );

		if ( !getDvarInt( "sv_punkbuster" ) && !game["LAN_MODE"] && !game["PROMOD_PB_OFF"] )
			iPrintLNBold("^1Server Violation^7: Punkbuster Disabled");

		if ( getDvarInt( "scr_player_maxhealth" ) != 100 && game["HARDCORE_MODE"] != 1 && game["CUSTOM_MODE"] != 1 || getDvarInt( "scr_player_maxhealth" ) != 30 && game["HARDCORE_MODE"] == 1 && game["CUSTOM_MODE"] != 1 )
			iPrintLNBold("^1Server Violation^7: Modified Player Health");

		if ( getDvarInt( "g_speed" ) != 0 && getDvarInt( "g_speed" ) != 190 )
			iPrintLNBold("^1Server Violation^7: Modified Player Speed");

		antilag = getDvarInt( "g_antilag" );
		dedicated = getDvar( "dedicated" );
		if ( (antilag && dedicated == "dedicated LAN server") || (!antilag && dedicated == "dedicated internet server" && !game["PROMOD_PB_OFF"]))
			iPrintLNBold("^1Server Violation^7: Modified Connection");

		if( isDefined( game["PROMOD_MATCH_MODE"] ) && game["PROMOD_MATCH_MODE"] == "match" || toLower( getDvar( "fs_game" ) ) == "mods/promodlive210" )
		{
			if( toLower(getDvar("fs_game")) != "mods/promodlive210" )
				iPrintLNBold("^1Server Violation^7: Invalid fs_game value");

			iwdnames = strToK( getDvar( "sv_iwdnames" ), " " );
			iwdsums = strToK( getDvar( "sv_iwds" ), " " );
			iwd_loaded = false;
			for(i=0;i<iwdnames.size;i++)
			{
				switch(iwdnames[i])
				{
					case "iw_00":
					case "iw_01":
					case "iw_02":
					case "iw_03":
					case "iw_04":
					case "iw_05":
					case "iw_06":
					case "iw_07":
					case "iw_08":
					case "iw_09":
					case "iw_10":
					case "iw_11":
					case "iw_12":
					case "iw_13":
						break;

					case "z_custom_ruleset":
						if ( isDefined( game["PROMOD_MATCH_MODE"] ) && game["PROMOD_MATCH_MODE"] == "match" && iwdsums[i] != "-350238000" )
							iPrintLNBold("^1Server Violation^7: Modified Custom IWD File While In Match Mode");
						break;

					case "promodlive210":
						if( iwdsums[i] != "60316905" )
							iPrintLNBold("^1Server Violation^7: Bad Promod IWD Checksum");
						iwd_loaded = true;
						break;

					default:
						if( !isCustomMap() || !isSubStr(iwdnames[i], level.script ) )
							iPrintLNBold("^1Server Violation^7: Extra IWD Files Detected");
						break;
				}
			}
			if(!iwd_loaded)
				iPrintLNBold("^1Server Violation^7: Promod IWD Not Loaded");
		}

		wait 3;
	}
}

isCustomMap()
{
	switch(level.script)
	{
		case "mp_backlot":
		case "mp_bloc":
		case "mp_bog":
		case "mp_broadcast":
		case "mp_carentan":
		case "mp_cargoship":
		case "mp_citystreets":
		case "mp_convoy":
		case "mp_countdown":
		case "mp_crash":
		case "mp_crash_snow":
		case "mp_creek":
		case "mp_crossfire":
		case "mp_farm":
		case "mp_killhouse":
		case "mp_overgrown":
		case "mp_pipeline":
		case "mp_shipment":
		case "mp_showdown":
		case "mp_strike":
		case "mp_vacant":
			return false;
	}
	return true;
}

forceDvar(dvar, value)
{
	if( getDvar( dvar ) != value)
		setDvar( dvar, value );
}