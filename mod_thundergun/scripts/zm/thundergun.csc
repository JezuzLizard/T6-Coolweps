#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weapons;

init()
{
	include_weapon( "thundergun_zm" );
	include_weapon( "thundergun_upgraded_zm", 0 );
	clientscripts\mp\zombies\_zm_weap_thundergun::init();
}
