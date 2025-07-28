#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_zm_gametype;

#include scripts\zm\_gametype_setup;

struct_init()
{
	if ( !is_true( level.ctsm_disable_custom_perk_locations ) )
	{
		register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 0, -132, 0 ), ( 10746, 7282, -557 ) );
		register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 0, 180, 0 ), ( 11402, 8159, -487 ) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, -35, 0 ), ( 10856, 7879, -576 ) );
		register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 0, 270, 0 ), ( 10946, 8308.77, -408 ) );
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 162, 0 ), ( 12625, 7434, -755 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, -4, 0 ), ( 11156, 8120, -575 ) );
		register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 0, -1, 0 ), ( 11568, 7723, -755 ) );
	}
	/*
	if ( !is_true( level.trash_spawns ) )
	{
		coordinates = array( ( 11288, 7988, -550 ), ( 11284, 7760, -549 ), ( 10784, 7623, -584 ), ( 10866, 7473, -580 ),
							( 10261, 8146, -580 ), ( 10595, 8055, -541 ), ( 10477, 7679, -567 ), ( 10165, 7879, -570 ) );
		angles = array( ( 0, -137, 0 ), ( 0, 177, 0 ), ( 0, -10, 0 ), ( 0, 21, 0 ), ( 0, -31, 0 ), ( 0, -43, 0 ), ( 0, -9, 0 ), ( 0, -15, 0 ) );
	}
	*/

	register_map_initial_spawnpoint( ( 11257, 8233, -487 ), ( 0, -137, 0 ) );
	register_map_initial_spawnpoint( ( 11403, 8245, -487 ), ( 0, 177, 0 ) );
	register_map_initial_spawnpoint( ( 11381, 8374, -487 ), ( 0, -10, 0 ) );
	register_map_initial_spawnpoint( ( 11269, 8360, -487 ), ( 0, 21, 0 ) );
	register_map_initial_spawnpoint( ( 10871, 8433, -407 ), ( 0, -31, 0 ) );
	register_map_initial_spawnpoint( ( 10852, 8230, -407 ), ( 0, -43, 0 ) );
	register_map_initial_spawnpoint( ( 10641, 8228, -407 ), ( 0, -9, 0 ) );
	register_map_initial_spawnpoint( ( 10655, 8431, -407 ), ( 0, -15, 0 ) );

	door_ents = getentarray( "zombie_door", "targetname" );
	foreach ( door in door_ents )
	{
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
		{
			door.script_noteworthy = "electric_buyable_door";
		}
	}

	level thread enable_zones();
	level thread maps\mp\zm_transit::falling_death_init();
	init_barriers();
}

precache()
{
	power_chest1_zbarrier = getEnt( "pow_chest2_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", power_chest1_zbarrier.origin );
	collision.angles = power_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", power_chest1_zbarrier.origin - ( 32, 0, 0 ) );
	collision.angles = power_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", power_chest1_zbarrier.origin + ( 32, 0, 0 ) );
	collision.angles = power_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	level.chests = [];
	level.chests[ 0 ] = getstruct( "pow_chest", "script_noteworthy" );
	level.chests[ 1 ] = getstruct( "pow_chest2", "script_noteworthy" );
}

enable_zones()
{
	// zones = []; 
	// zones[ 0 ] = "zone_pow";
	// zones[ 1 ] = "zone_pow_warehouse";
	flag_wait( "initial_blackscreen_passed" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_pow_warehouse" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_pow" );
}

power_main()
{
	setup_standard_objects( "power" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( "pow_chest" );
	scripts\zm\zm_transit\locs\location_common::common_init();
}

init_barriers()
{
	spawn_barrier( ( 9965, 8133, -556 ), "veh_t6_civ_60s_coupe_dead", ( 15, 5, 0 ) );
	spawn_barrier( ( 9955, 8105, -575 ), "collision_player_wall_256x256x10", ( 0, 0, 0 ) );
	spawn_barrier( ( 10056, 8350, -584 ), "veh_t6_civ_bus_zombie", ( 0, 340, 0 ), 1 );
	spawn_barrier( ( 10267, 8194, -556 ), "collision_player_wall_256x256x10", ( 0, 340, 0 ) );
	spawn_barrier( ( 10409, 8220, -181 ), "collision_player_wall_512x512x10", ( 0, 250, 0 ) );
	spawn_barrier( ( 10409, 8220, -556 ), "collision_player_wall_128x128x10", ( 0, 250, 0 ) );
	spawn_barrier( ( 10281, 7257, -575 ), "veh_t6_civ_microbus_dead", ( 0, 13, 0 ) );
	spawn_barrier( ( 10268, 7294, -569 ), "collision_player_wall_256x256x10", ( 0, 13, 0 ) );
	spawn_barrier( ( 10100, 7238, -575 ), "veh_t6_civ_60s_coupe_dead", ( 0, 52, 0 ) );
	spawn_barrier( ( 10170, 7292, -505 ), "collision_player_wall_128x128x10", ( 0, 140, 0 ) );
	spawn_barrier( ( 10030, 7216, -569 ), "collision_player_wall_256x256x10", ( 0, 49, 0 ) );
	spawn_barrier( ( 10563, 8630, -344 ), "collision_player_wall_256x256x10", ( 0, 270, 0 ) );
}