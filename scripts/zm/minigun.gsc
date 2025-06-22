#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	include_weapon( "minigun_zm" );
	include_powerup( "minigun" );
}

init()
{
	array_thread( level.zombie_spawners, ::add_spawn_function, ::minigun_bonus_damage );
	
	if ( isdefined( level.dog_spawners ) )
	{
		array_thread( level.dog_spawners, ::add_spawn_function, ::minigun_bonus_damage );
	}
	
	if ( level.script == "zm_tomb" )
	{
		getent( "chamber_capture_zombie_spawner", "targetname" ) add_spawn_function( ::minigun_bonus_damage );
		array_thread( level.dig_spawners, ::add_spawn_function, ::minigun_bonus_damage );
		getent( "capture_zombie_spawner", "targetname" ) add_spawn_function( ::minigun_bonus_damage );
	}
	
	onplayerconnect_callback( ::minigun_allow_swap );
	
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 0.05;
	
	if ( level.script == "zm_prison" || level.script == "zm_tomb" )
	{
		game["zmbdialog"]["minigun"] = "sam_powerup_death_machine";
	}
	
	if ( level.script == "zm_prison" )
	{
		level.zombie_powerups[ "minigun" ].func_should_drop_with_regular_powerups = ::func_should_drop_minigun_prison;
		level._powerup_grab_check_old_minigun = level._powerup_grab_check;
		level._powerup_grab_check = ::minigun_powerup_grab_check;
	}
	
	if ( level.script == "zm_tomb" )
	{
		level.zombie_powerups[ "minigun" ].func_should_drop_with_regular_powerups = ::func_should_drop_minigun_tomb;
	}
	
	if ( level.script == "zm_buried" )
	{
		replacefunc( ::is_temporary_zombie_weapon, ::is_temporary_zombie_weapon_minigun );
	}
}

is_temporary_zombie_weapon_minigun( weap )
{
	if ( weap == "minigun_zm" )
	{
		return true;
	}
	
	disabledetouronce( ::is_temporary_zombie_weapon );
	return is_temporary_zombie_weapon( weap );
}

func_should_drop_minigun_tomb()
{
	if ( level.total_capture_zones == 6 )
	{
		level._tomb_minigun_drop = true;
	}
	
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].zombie_vars["zombie_powerup_minigun_on"] == 1 )
		{
			return false;
		}
	}
	
	if ( is_true( level._tomb_minigun_drop ) )
	{
		return true;
	}
	
	return false;
}

func_should_drop_minigun_prison()
{
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].zombie_vars["zombie_powerup_minigun_on"] == 1 )
		{
			return false;
		}
	}
	
	if ( level.n_quest_iteration_count == 0 )
	{
		return false;
	}
	
	return true;
}

minigun_powerup_grab_check( player )
{
	if ( !self [[ level._powerup_grab_check_old_minigun ]]( player ) )
	{
		return false;
	}
	
	if ( self.powerup_name == "minigun" && is_true( player.afterlife ) )
	{
		return false;
	}
	
	return true;
}

minigun_allow_swap()
{
	self endon( "disconnect" );
	
	for ( ;; )
	{
		self waittill( "replace_weapon_powerup" );
		self thread minigun_weapon_change_watch();
		self thread prone_watcher();
		self thread force_stand();
		waittillframeend;
		self EnableWeaponCycling();
	}
}

set_no_allow_prone()
{
	self endon( "player_downed" );
	self endon( "minigun_time_over" );
	self allowprone( false );
	self waittill( "replace_weapon_powerup" );
}

force_stand()
{
	self endon( "disconnect" );
	self set_no_allow_prone();
	self allowprone( true );
}

prone_watcher()
{
	self endon( "disconnect" );
	self endon( "player_downed" );
	self endon( "minigun_time_over" );
	self endon( "replace_weapon_powerup" );
	
	while ( self getstance() == "prone" )
	{
		wait 0.05;
	}
	
	self switchtoweapon( "minigun_zm" );
}

minigun_weapon_change_watch()
{
	self endon( "disconnect" );
	self endon( "player_downed" );
	self endon( "minigun_time_over" );
	self endon( "replace_weapon_powerup" );
	
	while ( 1 )
	{
		self waittill( "weapon_change", newWeapon, oldWeapon );
		
		if ( newWeapon != "none" && newWeapon != "minigun_zm" )
		{
			break;
		}
	}
	
	level thread maps\mp\zombies\_zm_powerups::minigun_weapon_powerup_remove( self, "minigun_time_over" );
}

minigun_bonus_damage()
{
	if ( !isdefined( self.actor_damage_func ) )
	{
		self.actor_damage_func = ::minigun_bonus_damage_func;
	}
}

minigun_bonus_damage_func( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if ( weapon == "minigun_zm" )
	{
		damage += self.health * randomfloatrange( 0.34, 0.75 );
	}
	
	return damage;
}
