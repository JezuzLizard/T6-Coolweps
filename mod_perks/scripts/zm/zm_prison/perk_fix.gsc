#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	if ( is_gametype_active( "zclassic" ) )
	{
		replaceFunc( maps\mp\zm_prison_sq_bg::take_old_weapon_and_give_reward, ::take_old_weapon_and_give_reward );
	}
}

take_old_weapon_and_give_reward( current_weapon, reward_weapon, weapon_limit_override )
{
	if ( !isdefined( weapon_limit_override ) )
	{
		weapon_limit_override = 0;
	}
	
	if ( weapon_limit_override == 1 )
	{
		self takeweapon( current_weapon );
	}
	else
	{
		primaries = self getweaponslistprimaries();
		
		maxweapons = get_player_weapon_limit( self );
		
		if ( isdefined( primaries ) && primaries.size >= maxweapons )
		{
			self takeweapon( current_weapon );
		}
	}
	
	self giveweapon( reward_weapon );
	self switchtoweapon( reward_weapon );
	flag_set( "warden_blundergat_obtained" );
	self playsoundtoplayer( "vox_brutus_easter_egg_872_0", self );
}
