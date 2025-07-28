main()
{
	add_map_gamemode( "zclassic", undefined, undefined );
	add_map_gamemode( "zgrief", undefined, undefined );
	add_map_gamemode( "zstandard", undefined, undefined );
	add_map_location_gamemode( "zstandard", "diner", ::precache, ::_main );
	add_map_location_gamemode( "zstandard", "tunnel", ::precache, ::_main );
	add_map_location_gamemode( "zstandard", "power", ::precache, ::_main );
	add_map_location_gamemode( "zstandard", "cornfield", ::precache, ::_main );
	add_map_location_gamemode( "zgrief", "diner", ::precache, ::_main );
	add_map_location_gamemode( "zgrief", "tunnel", ::precache, ::_main );
	add_map_location_gamemode( "zgrief", "power", ::precache, ::_main );
	add_map_location_gamemode( "zgrief", "cornfield", ::precache, ::_main );
}

precache()
{

}

/*
rawfile,vision/zm_transit_base_on.vision
rawfile,vision/zm_transit_base_off.vision
rawfile,vision/zm_transit_cornfield_on.vision
rawfile,vision/zm_transit_cornfield_off.vision
rawfile,vision/zm_transit_depot_ext_on.vision
rawfile,vision/zm_transit_depot_ext_off.vision
rawfile,vision/zm_transit_depot_int_on.vision
rawfile,vision/zm_transit_depot_int_off.vision
rawfile,vision/zm_transit_diner_ext_on.vision
rawfile,vision/zm_transit_diner_ext_off.vision
rawfile,vision/zm_transit_diner_int_on.vision
rawfile,vision/zm_transit_diner_int_off.vision
rawfile,vision/zm_transit_farm_ext_on.vision
rawfile,vision/zm_transit_farm_ext_off.vision
rawfile,vision/zm_transit_farm_int_on.vision
rawfile,vision/zm_transit_farm_int_off.vision
rawfile,vision/zm_transit_power_ext_on.vision
rawfile,vision/zm_transit_power_ext_off.vision
rawfile,vision/zm_transit_power_int_fluctuate.vision
rawfile,vision/zm_transit_power_int_on.vision
rawfile,vision/zm_transit_power_int_off.vision
rawfile,vision/zm_transit_town_ext_on.vision
rawfile,vision/zm_transit_town_ext_off.vision
rawfile,vision/zm_transit_town_int_on.vision
rawfile,vision/zm_transit_town_int_off.vision
rawfile,vision/zm_transit_tunnel_on.vision
rawfile,vision/zm_transit_tunnel_off.vision
*/
_main()
{
	location = getdvar( #"ui_zm_mapstartlocation" );
	gametype = getdvar( #"ui_gametype" );
	level thread clientscripts\mp\zombies\_zm::init_perk_machines_fx();

	vision = "";
	switch ( location )
	{
		case "diner":
			vision = "zm_transit_diner_ext";
			break;
		case "tunnel":
			vision = "zm_transit_tunnel";
			break;
		case "power":
			vision = "zm_transit_power_ext";
			break;
		case "cornfield":
			vision = "zm_transit_cornfield";
			break;
	}
	
	if ( gametype == "zstandard" )
	{
		clientscripts\mp\zombies\_zm_game_mode_objects::gamemode_common_setup( "standard", location, vision, 1 );
		level thread dog_start_monitor();
		level thread dog_stop_monitor();
	}
	else if ( gametype == "zgrief" )
	{
		clientscripts\mp\zombies\_zm_game_mode_objects::gamemode_common_setup( "grief", location, vision, 1 );
	}
}

dog_start_monitor()
{
	while ( true )
	{
		level waittill( "dog_start" );
		players = getlocalplayers();

		for ( i = 0; i < players.size; i++ )
			setworldfogactivebank( i, 2 );
	}
}

dog_stop_monitor()
{
	while ( true )
	{
		level waittill( "dog_stop" );

		if ( !isdefined( level.current_fog ) )
			level.current_fog = 8;

		players = getlocalplayers();

		for ( i = 0; i < players.size; i++ )
			setworldfogactivebank( i, level.current_fog );
	}
}