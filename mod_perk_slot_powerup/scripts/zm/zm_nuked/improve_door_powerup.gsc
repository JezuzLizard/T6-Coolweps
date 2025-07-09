#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replacefunc( maps\mp\zm_nuked::perks_behind_door, ::perks_behind_door_override );
}

perks_debug_print( msg )
{
	if ( getdvarint( "zm_nuked_test" ) )
	{
		print( msg + "\n" );
		iprintln( msg );
	}
}

door_powerup_drop( powerup_name, drop_spot, powerup_team, powerup_location )
{
	if ( is_true( level.door_powerup_spawning ) )
	{
		perks_debug_print( "door_powerup_drop: already spawning a powerup, aborting." );
		return;
	}
	
	level.door_powerup_spawning = true;
	
	if ( isdefined( level.door_powerup ) )
	{
		level.door_powerup powerup_delete();
		level.door_powerup = undefined;
	}
	
	powerup = maps\mp\zombies\_zm_net::network_safe_spawn( "powerup", 1, "script_model", drop_spot + vectorscale( ( 0, 0, 1 ), 40.0 ) );
	level notify( "powerup_dropped", powerup );
	
	if ( isdefined( powerup ) )
	{
		powerup.grabbed_level_notify = "magic_door_power_up_grabbed";
		playfx( level._effect["lightning_dog_spawn"], powerup.origin );
		playsoundatposition( "pre_spawn", powerup.origin );
		
		wait 1.5;
		
		playsoundatposition( "zmb_bolt", powerup.origin );
		earthquake( 0.5, 0.75, powerup.origin, 1000 );
		playrumbleonposition( "explosion_generic", powerup.origin );
		playsoundatposition( "spawn", powerup.origin );
		powerup maps\mp\zombies\_zm_powerups::powerup_setup( powerup_name, powerup_team, powerup_location );
		powerup thread maps\mp\zombies\_zm_powerups::powerup_wobble();
		powerup thread maps\mp\zombies\_zm_powerups::powerup_grab( powerup_team );
		powerup thread maps\mp\zombies\_zm_powerups::powerup_move();
		level.door_powerup = powerup;
	}
	
	level.door_powerup_spawning = undefined;
}

reset_door_powerup_list()
{
	level.door_powerup_index = 0;
	level.door_powerup_drop_list = getarraykeys( level.zombie_include_powerups );
	level.door_powerup_drop_list = array_randomize( level.door_powerup_drop_list );
}

_reset_powerup_requirement()
{
	level.door_powerup_clock_chimes_required = 1;
	level.door_powerup_clock_chimes_for_reward = 0;
}

on_round_over()
{
	for ( ;; )
	{
		level waittill( "between_round_over" );
		_reset_powerup_requirement();
	}
}

perks_behind_door_override()
{
	if ( !is_true( level.enable_magic ) )
	{
		return;
	}
	
	flag_wait( "initial_blackscreen_passed" );
	reset_door_powerup_list();
	ammodrop = getstruct( "zm_nuked_ammo_drop", "script_noteworthy" );
	
	door_powerup_drop( level.door_powerup_drop_list[ 0 ], ammodrop.origin );
	
	_reset_powerup_requirement();
	level thread on_round_over();
	min_hand_model = getent( "clock_min_hand", "targetname" );
	
	while ( true )
	{
		level waittill( "nuke_clock_moved" );
		
		// every 4 ticks is a chime, just a tick
		if ( min_hand_model.position != 3 )
		{
			// if they didn't pick it up, cycle it
			if ( isdefined( level.door_powerup ) )
			{
				_powerup_drop( ammodrop );
			}

			continue;
		}
		
		level.door_powerup_clock_chimes_for_reward++;
		
		if ( level.door_powerup_clock_chimes_for_reward < level.door_powerup_clock_chimes_required )
		{
			continue;
		}
		
		level.door_powerup_clock_chimes_required++;
		level.door_powerup_clock_chimes_for_reward = 0;
		
		_powerup_drop( ammodrop );
	}
}

_powerup_drop( ammodrop )
{
	if ( level.door_powerup_index >= level.door_powerup_drop_list.size )
	{
		reset_door_powerup_list();
	}
	
	powerup_type = level.door_powerup_drop_list[ level.door_powerup_index ];
	level.door_powerup_index++;
	level thread door_powerup_drop( powerup_type, ammodrop.origin );
}
