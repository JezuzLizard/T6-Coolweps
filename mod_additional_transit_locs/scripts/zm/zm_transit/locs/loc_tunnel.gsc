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
		register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 0, -180, 0 ), ( -11541, -2630, 194 ) );
		register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 0, -10, 0 ), ( -11170, -590, 196 ) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, -19, 0 ), ( -11681, -734, 228 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, -98, 0 ), ( -10664, -757, 196 ) );
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 115, 0 ), ( -11301, -2096, 184 ) );
		register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 0, 270, 0 ), ( -10780, -2565, 224 ) );
		register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 0, -89, 0 ), ( -11373, -1674, 192 ) );
	}

	register_map_initial_spawnpoint( ( -11196, -837, 192 ), ( 0, -94, 0 ) );
	register_map_initial_spawnpoint( ( -11386, -863, 192 ), ( 0, -44, 0 ) );
	register_map_initial_spawnpoint( ( -11405, -1000, 192 ), ( 0, -32, 0 ) );
	register_map_initial_spawnpoint( ( -11498, -1151, 192 ), ( 0, 4, 0 ) );
	register_map_initial_spawnpoint( ( -11398, -1326, 191 ), ( 0, 50, 0 ) );
	register_map_initial_spawnpoint( ( -11222, -1345, 192 ), ( 0, 157, 0 ) );
	register_map_initial_spawnpoint( ( -10934, -1380, 192 ), ( 0, -144, 0 ) );
	register_map_initial_spawnpoint( ( -10999, -1072, 192 ), ( 0, -15, 0 ) );

	level thread enable_zones();
	init_barriers();
}

precache()
{
	tunnel_chest1_zbarrier = getent( "tunnel_chest1_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", tunnel_chest1_zbarrier.origin );
	collision.angles = tunnel_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", tunnel_chest1_zbarrier.origin - ( 4, 30, 0 ) );
	collision.angles = tunnel_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", tunnel_chest1_zbarrier.origin + ( 4, 30, 0 ) );
	collision.angles = tunnel_chest1_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	tunnel_chest2_zbarrier = getent( "tunnel_chest2_zbarrier", "script_noteworthy" );
	collision = spawn( "script_model", tunnel_chest2_zbarrier.origin );
	collision.angles = tunnel_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", tunnel_chest2_zbarrier.origin - ( 36, 0, 0 ) );
	collision.angles = tunnel_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision = spawn( "script_model", tunnel_chest2_zbarrier.origin + ( 36, 0, 0 ) );
	collision.angles = tunnel_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );

	level.chests = [];
	level.chests[ 0 ] = getstruct( "tunnel_chest1", "script_noteworthy" );
	level.chests[ 1 ] = getstruct( "tunnel_chest2", "script_noteworthy" );
}

enable_zones()
{
	flag_wait( "initial_blackscreen_passed" );
	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_amb_tunnel" );
}

tunnel_main()
{
	setup_standard_objects( "tunnel" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( random( array( "tunnel_chest1", "tunnel_chest2" ) ) );
	scripts\zm\zm_transit\locs\location_common::common_init();
}

init_barriers()
{
	spawn_barrier( ( -11250, -520, 255 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 172, 0 ) );
	spawn_barrier( ( -11250, -580, 255 ), "collision_player_wall_256x256x10", ( 0, 180, 0 ) );
	spawn_barrier( ( -11506, -580, 255 ), "collision_player_wall_256x256x10", ( 0, 180, 0 ) );
	spawn_barrier( ( -10770, -3240, 255 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 214, 0 ) );
	spawn_barrier( ( -10840, -3190, 255 ), "collision_player_wall_256x256x10", ( 0, 214, 0 ) );
	level thread delete_barriers_on_end_game();
}

// intermission camera paths through the barriers
delete_barriers_on_end_game()
{
	level waittill( "intermission" );
	foreach ( barrier in level.survival_barriers )
	{
		barrier delete();
	}
}