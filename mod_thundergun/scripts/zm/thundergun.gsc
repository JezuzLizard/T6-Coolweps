#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init()
{
	include_weapon( "thundergun_zm" );
	include_weapon( "thundergun_upgraded_zm", 0 );

	maps\mp\zombies\_zm_weapons::add_limited_weapon( "thundergun_zm", 1 );
	add_zombie_weapon( "thundergun_zm", "thundergun_upgraded_zm", &"WEAPON_THUNDERGUN", 50, "", "", undefined );
	maps\mp\zombies\_zm_weap_thundergun::init();

	maps\mp\zombies\_zm_spawner::register_zombie_death_animscript_callback( maps\mp\zombies\_zm_weap_thundergun::enemy_killed_by_thundergun );
}
