#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	level.script = getdvar( "mapname" );
	
	if ( level.script == "zm_tomb" || level.script == "zm_buried" || level.script == "zm_highrise" )
	{
		return;
	}
	
	include_powerup( "perk_slot_bottle" );
	
	if ( !isdefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}
	
	maps\mp\zombies\_zm_powerups::add_zombie_powerup( "perk_slot_bottle", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_MAX_AMMO", ::should_drop, true, false, false );
}

init()
{
	if ( level.script == "zm_tomb" || level.script == "zm_buried" || level.script == "zm_highrise" )
	{
		return;
	}
	
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 0.05;
	
	level._zombiemode_powerup_grab_old_perk_drop = level._zombiemode_powerup_grab;
	level._zombiemode_powerup_grab = ::on_grab;
	
	level.get_player_perk_purchase_limit_old_perk_drop = level.get_player_perk_purchase_limit;
	level.get_player_perk_purchase_limit = ::player_perk_purchase_limit;
	
	level._powerup_grab_check_old_perk_drop = level._powerup_grab_check;
	level._powerup_grab_check = ::powerup_grab_check;
}

powerup_grab_check( player )
{
	if ( !self [[ level._powerup_grab_check_old_perk_drop ]]( player ) )
	{
		return false;
	}
	
	if ( self.powerup_name == "perk_slot_bottle" && isDefined( player.bonus_perk_slots ) && player.bonus_perk_slots >= 4 )
	{
		// already at max perk slots
		return false;
	}
	
	return true;
}


player_perk_purchase_limit()
{
	// origins only, but whatever, we are good citizins
	if ( isdefined( level.get_player_perk_purchase_limit_old_perk_drop ) )
	{
		return self [[ level.get_player_perk_purchase_limit_old_perk_drop ]]();
	}
	
	if ( !isdefined( self.bonus_perk_slots ) )
	{
		return level.perk_purchase_limit;
	}
	
	return level.perk_purchase_limit + self.bonus_perk_slots;
}

on_grab( s_powerup, e_player )
{
	// same deal, but could also be used to handle other custom powerups
	if ( isdefined( level._zombiemode_powerup_grab_old_perk_drop ) )
	{
		level thread [[ level._zombiemode_powerup_grab_old_perk_drop ]]( s_powerup, e_player );
	}
	
	if ( s_powerup.powerup_name != "perk_slot_bottle" )
	{
		return;
	}
	
	if ( !isdefined( e_player.bonus_perk_slots ) )
	{
		e_player.bonus_perk_slots = 0;
	}
	
	if ( e_player.bonus_perk_slots < 4 )
	{
		e_player.bonus_perk_slots++;
	}
}

should_drop()
{
	// drop once every x amount of rounds
	if ( level.round_number < 15 )
	{
		return false;
	}
	
	if ( isdefined( level.next_perk_drop_round ) && level.round_number < level.next_perk_drop_round )
	{
		return false;
	}
	
	should = false;
	
	foreach ( player in level.players )
	{
		if ( !isDefined( player.bonus_perk_slots ) || player.bonus_perk_slots < 4 )
		{
			should = true;
			break;
		}
	}
	
	if ( !should )
	{
		return false;
	}
	
	level.next_perk_drop_round = level.round_number + 6 - clamp( level.players.size, 1, 4 ) + randomInt( 2 );
/#
	iprintln( "Next perk drop round: " + level.next_perk_drop_round + ", current round: " + level.round_number + ", players: " + level.players.size );
#/
	return true;
}
