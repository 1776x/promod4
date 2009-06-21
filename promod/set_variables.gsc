/*
  Copyright (c) 2009-2017 Andreas Göransson <andreas.goransson@gmail.com>
  Copyright (c) 2009-2017 Indrek Ardel <indrek@ardel.eu>

  This file is part of Call of Duty 4 Promod.

  Call of Duty 4 Promod is licensed under Promod Modder Ethical Public License.
  Terms of license can be found in LICENSE.md document bundled with the project.
*/

main()
{
	// Promod
	setDvar( "bg_bobMax", "0" );
	setDvar( "player_sustainAmmo", "0" );
	setDvar( "player_throwBackInnerRadius", "0" );
	setDvar( "player_throwBackOuterRadius", "0" );
	setDvar( "clientsideeffects", "0" );
	setDvar( "sv_pure", "1" );
	setDvar( "sv_fps", "20" );
	setDvar( "__promod_mode", toLower( getDvar( "promod_mode" ) ) );
	setDvar( "__promod_version", game["PROMOD_VERSION"] );

	// Class counts
	game["allies_assault_count"] = 0;
	game["allies_specops_count"] = 0;
	game["allies_demolitions_count"] = 0;
	game["allies_sniper_count"] = 0;

	game["axis_assault_count"] = 0;
	game["axis_specops_count"] = 0;
	game["axis_demolitions_count"] = 0;
	game["axis_sniper_count"] = 0;

	// Timeout
	game["promod_timeout_called"] = 0;
	game["promod_in_timeout"] = 0;
	game["allies_timeout_called"] = 0;
	game["axis_timeout_called"] = 0;

	// Ready-Up/Strat-Bypass
	game["promod_first_readyup_done"] = 0;
	game["promod_allies_bypassed_by"] = 0;
	game["promod_axis_bypassed_by"] = 0;
}