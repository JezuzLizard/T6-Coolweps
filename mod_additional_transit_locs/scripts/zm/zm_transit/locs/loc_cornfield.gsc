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
		register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 0, 179, 0 ), ( 13936, -649, -189 ) );
		register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 0, -137, 0 ), ( 12052, -1943, -160 ) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, -35, 0 ), ( 9944, -725, -211 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, 133, 0 ), ( 13551, -1384, -188 ) );
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 123, 0), ( 9960, -1288, -217 ) );
		register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 0, -90, 0 ), ( 7831, -464, -203 ) );
		register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 0, -4, 0 ), ( 13255, 74, -195 ) );
	}

	register_map_initial_spawnpoint( ( 7521, -545, -198 ), ( 0, 40, 0 ) );
	register_map_initial_spawnpoint( ( 7751, -522, -202 ), ( 0, 145, 0 ) );
	register_map_initial_spawnpoint( ( 7691, -395, -201 ), ( 0, -131, 0 ) );
	register_map_initial_spawnpoint( ( 7536, -432, -199 ), ( 0, -24, 0 ) );
	register_map_initial_spawnpoint( ( 13745, -336, -188 ), ( 0, -178, 0 ) );
	register_map_initial_spawnpoint( ( 13758, -681, -188 ), ( 0, -179, 0 ) );
	register_map_initial_spawnpoint( ( 13816, -1088, -189 ), ( 0, -177, 0 ) );
	register_map_initial_spawnpoint( ( 13752, -1444, -182 ), ( 0, -177, 0 ) );

	structs = getstructarray( "game_mode_object", "targetname" );
	foreach ( struct in structs )
	{
		if ( struct.script_noteworthy == "cornfield" )
		{
			struct.script_string = "zstandard zgrief";
		}
	}

	init_barriers();
}

precache()
{
	cornfield1_zbarrier = getent( "cornfield_chest1_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", cornfield1_zbarrier.origin );
	collision.angles = cornfield1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield1_zbarrier.origin - ( 0, 32, 0 ) );
	collision.angles = cornfield1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield1_zbarrier.origin + ( 0, 32, 0 ) );
	collision.angles = cornfield1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	cornfield2_zbarrier = getent( "cornfield_chest2_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", cornfield2_zbarrier.origin );
	collision.angles = cornfield2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield2_zbarrier.origin - ( 0, 32, 0 ) );
	collision.angles = cornfield2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield2_zbarrier.origin + ( 0, 32, 0 ) );
	collision.angles = cornfield2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	cornfield3_zbarrier = getent( "cornfield_chest3_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", cornfield3_zbarrier.origin );
	collision.angles = cornfield3_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield3_zbarrier.origin - ( 32, 0, 0 ) );
	collision.angles = cornfield3_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", cornfield3_zbarrier.origin + ( 32, 0, 0 ) );
	collision.angles = cornfield3_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	level.chests = [];
	level.chests[ 0 ] = getstruct( "cornfield_chest1", "script_noteworthy" );
	level.chests[ 1 ] = getstruct( "cornfield_chest2", "script_noteworthy" );
	level.chests[ 2 ] = getstruct( "cornfield_chest3", "script_noteworthy" );
}

cornfield_main()
{
	setup_standard_objects( "cornfield" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( random( array( "cornfield_chest1", "cornfield_chest2", "cornfield_chest3" ) ) );
	scripts\zm\zm_transit\locs\location_common::common_init();
}

// zombie_speed_up_distance_check()
// {
// 	if ( distance( self.origin, self.closestPlayer.origin ) > 1000 )
// 	{
// 		return 1;
// 	}
// 	return 0;
// }

// increase_cornfield_zombie_speed()
// {
// 	level endon( "end_game" );
// 	level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
// 	level.speed_change_round = undefined;
// 	while ( 1 )
// 	{
// 		zombies = get_round_enemy_array();
// 		for ( i = 0; i < zombies.size; i++ )
// 		{
// 			zombies[ i ].closestPlayer = get_closest_valid_player( zombies[ i ].origin );
// 		}
// 		zombies = get_round_enemy_array();
// 		for ( i = 0; i < zombies.size; i++ )
// 		{
// 			if ( zombies[ i ] zombie_speed_up_distance_check() )
// 			{
// 				zombies[ i ] set_zombie_run_cycle( "chase_bus" );
// 			}
// 			else if ( zombies[ i ].zombie_move_speed != "sprint" )
// 			{
// 				zombies[ i ] set_zombie_run_cycle( "sprint" );
// 			}
// 		}
// 		wait 1;
// 	}
// }

init_barriers()
{
	// scripts\zm\_gametype_setup::barrier( ( 10190, 135, -159 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 172, 0 ) );
	// scripts\zm\_gametype_setup::barrier( ( 10100, 100, -159 ), "collision_player_wall_512x512x10", ( 0, 172, 0 ) );
	// scripts\zm\_gametype_setup::barrier( ( 10100, -1800, -217 ), "veh_t6_civ_bus_zombie", ( 0, 126, 0 ), 1 );
	// scripts\zm\_gametype_setup::barrier( ( 10045, -1607, -181 ), "collision_player_wall_512x512x10", ( 0, 126, 0 ) );
	precachemodel( "zm_collision_transit_cornfield_survival" );
	collision = spawn( "script_model", ( 10500, -850, 0 ), 1 );
	collision setmodel( "zm_collision_transit_cornfield_survival" );
}