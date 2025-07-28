#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\gametypes_zm\_zm_gametype;

#include scripts\zm\_gametype_setup;

struct_init()
{
	if ( !is_true( level.ctsm_disable_custom_perk_locations ) )
	{
		register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 0, 176, 0 ), ( -3634, -7464, -58 ) );
		register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 0, 270, 0 ), (-4591.74 + 12.5, -7755.04, -40.5759) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, 4, 0 ), ( -4576, -6704, -61 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, 90, 0 ), ( -6496, -7691, 0 ) );
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 175, 0 ), ( -6351, -7778, 227 ) );
		register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 0, 270, 0 ), ( -4170 - 12.5, -7610, -61 ) );
		register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 0, 270, 0 ), ( -5470, -7859.5, 0 ) );
	}

	// Players spawn in the garage
	register_map_initial_spawnpoint( ( -4290.99, -7583.55, -62.699 ), ( 0, -177.244, 0 ) );
	register_map_initial_spawnpoint( ( -4290.95, -7679.21, -60.8681 ), ( 0, 179.015, 0 ) );
	register_map_initial_spawnpoint( ( -4292.12, -7782.84, -62.726 ), ( 0, 176.477, 0 ) );
	register_map_initial_spawnpoint( ( -4292.43, -7872.34, -62.875 ), ( 0, 176.477, 0 ) );
	register_map_initial_spawnpoint( ( -4685.57, -7904.69, -62.875 ), ( 0, 1.68447, 0 ) );
	register_map_initial_spawnpoint( ( -4694.29, -7786.72, -55.6662 ), ( 0, 1.68447, 0 ) );
	register_map_initial_spawnpoint( ( -4707.08, -7671.75, -57.9624 ), ( 0, 1.68447, 0 ) );
	register_map_initial_spawnpoint( ( -4691.18, -7588.58, -57.875 ), ( 0, 1.68447, 0 ) );
	/*
	//OLd spawnpoints
	coordinates = array( ( -3991, -7317, -63 ), ( -4231, -7395, -60 ), ( -4127, -6757, -54 ), ( -4465, -7346, -58 ),
						 ( -5770, -6600, -55 ), ( -6135, -6671, -56 ), ( -6182, -7120, -60 ), ( -5882, -7174, -61 ) );
	angles = array( ( 0, 161, 0 ), ( 0, 120, 0 ), ( 0, 217, 0 ), ( 0, 173, 0 ), ( 0, -106, 0 ), ( 0, -46, 0 ), ( 0, 51, 0 ), ( 0, 99, 0 ) );
	*/
	
	gameObjects = getentarray( "script_model", "classname" );
	foreach ( object in gameObjects )
	{
		if ( isDefined( object.script_gameobjectname ) && object.script_gameobjectname == "zcleansed zturned" )
		{
			object.script_gameobjectname = "zstandard zgrief zcleansed zturned";
		}
	}
	
	diner_hatch = getent( "diner_hatch", "targetname" );
	diner_hatch.script_gameobjectname = "zclassic zstandard zgrief";
	diner_hatch_mantle = getent( "diner_hatch_mantle", "targetname" );
	diner_hatch_mantle.script_gameobjectname = "zclassic zstandard zgrief";
	gameObjects = getentarray( "script_model", "classname" );
	foreach ( object in gameObjects )
	{
		if ( isDefined( object.script_gameobjectname ) && object.script_gameobjectname == "zcleansed zturned" )
		{
			object.script_gameobjectname = "zstandard zgrief zcleansed zturned";
		}
	} 

	door_ents = getentarray( "zombie_door", "targetname" );
	foreach ( door in door_ents )
	{
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
		{
			door.script_noteworthy = "electric_buyable_door";
			door.zombie_cost = 1000;
		}
	}

	/*
	start_node = spawnpathnode( "node_negotiation_begin", (-6279.89, -7947.26, 146.691), (0, 177.35, 0), "animscript", "zm_jump_down_48", "target", "diner_roof_zm_jump_down" );
	end_node = spawnpathnode( "node_negotiation_end", (-6301.12, -7947.22, 40.125), (0, 176.801, 0), "targetname", "diner_roof_zm_jump_down" );

	a_nodes1 = getnodesinradiussorted( start_node.origin, 64, 16, 100, "pathnodes" );
	linkNodes( a_nodes1[ 0 ], start_node );
	a_nodes2 = getnodesinradiussorted( end_node.origin, 64, 16, 100, "pathnodes" );
	linkNodes( a_nodes2[ 0 ], end_node );
	linkNodes( start_node, end_node );
	*/

	level thread enable_zones();
	diner_hatch_access();
	init_barriers();
}

enable_zones()
{
	// zones = []; 
	// zones[ 0 ] = "zone_gar";
	// zones[ 1 ] = "zone_din";
	// zones[ 2 ] = "zone_diner_roof";
	flag_wait( "initial_blackscreen_passed" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_gar" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_din" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_diner_roof" );
}

diner_adjacent_zones()
{
	maps\mp\zombies\_zm_zonemgr::add_adjacent_zone( "zone_din", "zone_diner_roof", "always_on" );
}

precache()
{
	diner_roof_chest1_zbarrier = getEnt( "diner_roof_chest1_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", diner_roof_chest1_zbarrier.origin );
	collision.angles = diner_roof_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", diner_roof_chest1_zbarrier.origin - ( 32, 0, 0 ) );
	collision.angles = diner_roof_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", diner_roof_chest1_zbarrier.origin + ( 32, 0, 0 ) );
	collision.angles = diner_roof_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	
	level.chests = [];
	level.chests[ 0 ] = getstruct( "start_chest", "script_noteworthy" );
	level.chests[ 1 ] = getstruct( "diner_roof_chest1", "script_noteworthy" );
}

diner_main()
{
	setup_standard_objects( "diner" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( random( array( "start_chest", "diner_roof_chest1" ) ) );
	scripts\zm\zm_transit\locs\location_common::common_init();
}

diner_hatch_access()
{
	diner_hatch = getent( "diner_hatch", "targetname" );
	diner_hatch_col = getent( "diner_hatch_collision", "targetname" );
	diner_hatch_mantle = getent( "diner_hatch_mantle", "targetname" );
	if ( !isDefined( diner_hatch ) || !isDefined( diner_hatch_col ) )
	{
		return;
	}
	diner_hatch hide();
	diner_hatch_mantle.start_origin = diner_hatch_mantle.origin;
	diner_hatch_mantle.origin += vectorScale( ( 0, 0, 0 ), 500 );
	diner_hatch show();
	diner_hatch_col delete();
	diner_hatch_mantle.origin = diner_hatch_mantle.start_origin;
}

init_barriers()
{
	precachemodel( "zm_collision_transit_diner_survival" );
	collision = spawn( "script_model", ( -5000, -6700, 0 ), 1 );
	collision setmodel( "zm_collision_transit_diner_survival" );
}

