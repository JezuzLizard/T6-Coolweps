#include maps\mp\zombies\_load;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;

#include codescripts\struct;

_DEFAULT( value, default_value )
{
	if ( !isdefined( value ) )
	{
		return default_value;
	}

	return value;
}

main()
{
	onplayerconnect_callback( ::no_out_of_playable_area );
}

no_out_of_playable_area()
{
	level.player_out_of_playable_area_monitor = false;
}

register_perk_struct( specialty_perk, model, angles, origin )
{
	perk_struct = createstruct();
	perk_struct.script_noteworthy = specialty_perk;
	perk_struct.model = model;
	perk_struct.angles = angles;
	perk_struct.origin = origin;
	perk_struct.targetname = "zm_perk_machine";
	perk_struct.script_string = getdvar( "g_gametype" ) + "_perks_" + getdvar( "ui_zm_mapstartlocation" );

	if ( specialty_perk == "specialty_weapupgrade" )
	{
		perk_struct.target = "pack_flag_pos_" + randomint( 10000 );

		flag_pos = createstruct();
		flag_pos.targetname = perk_struct.target;
		flag_pos.origin = origin + ( anglestoforward( angles ) * 29 ) + ( anglestoright( angles ) * -13.5 ) + ( anglestoup( angles ) * 49.5 );
		flag_pos.angles = angles + ( 0, 180, 180 );
		flag_pos.model = "zombie_sign_please_wait";
	}

	return perk_struct;
}

register_map_initial_spawnpoint( origin, angles, radius, script_noteworthy, script_int, locked )
{
	angles = _DEFAULT( angles, ( 0, 0, 0 ) );
	radius = _DEFAULT( radius, 32 );
	script_noteworthy = _DEFAULT( script_noteworthy, "initial_spawn" );
	script_int = _DEFAULT( script_int, 2048 );
	locked = _DEFAULT( locked, false );

	spawnpoint_struct = createstruct();
	spawnpoint_struct.origin = origin;
	spawnpoint_struct.angles = angles;
	spawnpoint_struct.radius = radius;
	spawnpoint_struct.script_noteworthy = script_noteworthy;
	spawnpoint_struct.script_int = script_int;
	spawnpoint_struct.script_string = getdvar( "g_gametype" ) + "_" + getdvar( "ui_zm_mapstartlocation" );
	spawnpoint_struct.locked = locked;

	return spawnpoint_struct;
}

register_zombie_weapon_upgrade( weapon_type, origin, angles, targetname, target, model, model_angles, model_origin )
{
	wallbuy = createstruct();
	wallbuy.zombie_weapon_upgrade = weapon_type;
	wallbuy.origin = origin;
	wallbuy.angles = angles;
	wallbuy.targetname = targetname;
	wallbuy.target = target;

	wallbuy_model = createstruct();
	wallbuy_model.model = model;
	wallbuy_model.angles = model_angles;
	wallbuy_model.origin = model_origin;
	wallbuy_model.targetname = wallbuy.target;

	strucs = [];
	strucs[ strucs.size ] = wallbuy;
	strucs[ strucs.size ] = wallbuy_model;
	return strucs;
}

spawn_barrier( origin, model, angles, not_solid )
{
	if ( !isDefined( level.survival_barriers ) )
	{
		level.survival_barriers = [];
		level.survival_barriers_index = 0;
	}

	level.survival_barriers[ level.survival_barriers_index ] = spawn( "script_model", origin );
	level.survival_barriers[ level.survival_barriers_index ] setmodel( model );
	level.survival_barriers[ level.survival_barriers_index ] rotateto( angles, 0.1 );
	if ( is_true( not_solid ) )
	{
		level.survival_barriers[ level.survival_barriers_index ] notsolid();
	}
	level.survival_barriers_index++;
}

add_struct_location_gamemode_func( gametype, location, func )
{
	if ( !isDefined( level.add_struct_gamemode_location_funcs ) )
	{
		level.add_struct_gamemode_location_funcs = [];
	}
	if ( !isDefined( level.add_struct_gamemode_location_funcs[ gametype ] ) )
	{
		level.add_struct_gamemode_location_funcs[ gametype ] = [];
	}
	level.add_struct_gamemode_location_funcs[ gametype ][ location ] = func;
}

add_zone_location_func( location, func )
{
	if ( !isDefined( level.location_zones ) )
	{
		level.location_zones = [];
	}
	if ( !isDefined( level.location_zones[ location ] ) )
	{
		level.location_zones[ location ] = [];
	}
	level.location_zones[ location ] = [[ func ]]();
}