#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weapons;

main()
{
	level.script = getdvar( "mapname" );
	level.createfx_enabled = getdvar( #"createfx" ) != "";
	
	if ( level.script == "zm_tomb" || level.script == "zm_buried" || level.script == "zm_highrise" )
	{
		return;
	}

	include_powerup( "perk_slot_bottle" );
	clientscripts\mp\zombies\_zm_powerups::add_zombie_powerup( "perk_slot_bottle" );
}
