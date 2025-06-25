#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_weapons;

main()
{
	level.zombiemode_using_marathon_perk = 1;
	level.zombiemode_using_additionalprimaryweapon_perk = 1;
	level.zombiemode_using_deadshot_perk = 1;
	
	level.zombiemode_using_divetonuke_perk = 1;
	clientscripts\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
}

is_specialty_in_use( perk )
{
	switch (perk)
	{
		case "specialty_additionalprimaryweapon":
			return is_true( level.zombiemode_using_additionalprimaryweapon_perk );
		case "specialty_flakjacket":
			if ( level.script == "zm_buried" )
			{
				return isdefined( level._custom_perks[ perk ] );
			}

			return is_true( level.zombiemode_using_divetonuke_perk );
		case "specialty_deadshot":
			return is_true( level.zombiemode_using_deadshot_perk );
		case "specialty_longersprint":
			return is_true( level.zombiemode_using_marathon_perk );
		case "specialty_rof":
			return is_true( level.zombiemode_using_doubletap_perk );
		case "specialty_armorvest":
			return is_true( level.zombiemode_using_juggernaut_perk );
		case "specialty_quickrevive":
			return is_true( level.zombiemode_using_revive_perk );
		case "specialty_fastreload":
			return is_true( level.zombiemode_using_sleightofhand_perk );
		case "specialty_scavenger":
			return is_true( level.zombiemode_using_tombstone_perk );
		case "specialty_weapupgrade":
			return is_true( level.zombiemode_using_pack_a_punch );
		case "specialty_finalstand":
			return is_true( level.zombiemode_using_chugabud_perk );
		case "specialty_stalker":
			return is_true( level.zombiemode_using_random_perk );
		default:
			return isdefined( level._custom_perks[ perk ] );
	}
}
