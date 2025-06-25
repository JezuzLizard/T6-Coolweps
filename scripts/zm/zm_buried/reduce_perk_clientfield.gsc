#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replacefunc( maps\mp\zombies\_zm_perks::perks_register_clientfield, ::perks_register_clientfield );
}

perks_register_clientfield()
{
	if ( isdefined( level.zombiemode_using_additionalprimaryweapon_perk ) && level.zombiemode_using_additionalprimaryweapon_perk )
	{
		registerclientfield( "toplayer", "perk_additional_primary_weapon", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_deadshot_perk ) && level.zombiemode_using_deadshot_perk )
	{
		registerclientfield( "toplayer", "perk_dead_shot", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_doubletap_perk ) && level.zombiemode_using_doubletap_perk )
	{
		registerclientfield( "toplayer", "perk_double_tap", 1, 1, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_juggernaut_perk ) && level.zombiemode_using_juggernaut_perk )
	{
		registerclientfield( "toplayer", "perk_juggernaut", 1, 1, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_marathon_perk ) && level.zombiemode_using_marathon_perk )
	{
		registerclientfield( "toplayer", "perk_marathon", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_revive_perk ) && level.zombiemode_using_revive_perk )
	{
		registerclientfield( "toplayer", "perk_quick_revive", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_sleightofhand_perk ) && level.zombiemode_using_sleightofhand_perk )
	{
		registerclientfield( "toplayer", "perk_sleight_of_hand", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_tombstone_perk ) && level.zombiemode_using_tombstone_perk )
	{
		registerclientfield( "toplayer", "perk_tombstone", 1, 2, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_perk_intro_fx ) && level.zombiemode_using_perk_intro_fx )
	{
		registerclientfield( "scriptmover", "clientfield_perk_intro_fx", 1000, 1, "int" );
	}
	
	if ( isdefined( level.zombiemode_using_chugabud_perk ) && level.zombiemode_using_chugabud_perk )
	{
		registerclientfield( "toplayer", "perk_chugabud", 1000, 1, "int" );
	}
	
	if ( isdefined( level._custom_perks ) )
	{
		a_keys = getarraykeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( isdefined( level._custom_perks[a_keys[i]].clientfield_register ) )
			{
				level [[ level._custom_perks[a_keys[i]].clientfield_register ]]();
			}
		}
	}
}
