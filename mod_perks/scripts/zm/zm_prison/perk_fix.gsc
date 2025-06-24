#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	// wait for perks to be initialized
	flag_wait( "initial_blackscreen_passed" );
	
	// prevent map script from deleting the clip of the marathon perk machine
	perk_machines = getentarray( "zombie_vending", "targetname" );
	old_stam_clip = undefined;
	stam_machine = undefined;
	old_phd_clip = undefined;
	phd_machine = undefined;
	
	foreach ( perk_machine in perk_machines )
	{
		if ( perk_machine.script_noteworthy == "specialty_longersprint" )
		{
			old_stam_clip = perk_machine.clip;
			perk_machine.clip = undefined;
			stam_machine = perk_machine;
		}
		else if ( perk_machine.script_noteworthy == "specialty_flakjacket" )
		{
			old_phd_clip = perk_machine.clip;
			perk_machine.clip = undefined;
			phd_machine = perk_machine;
		}
	}
	
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;
	
	// restore the clip of the marathon perk machine
	if ( isDefined( old_stam_clip ) && isDefined( stam_machine ) )
	{
		stam_machine.clip = old_stam_clip;
	}
	
	if ( isDefined( old_phd_clip ) && isDefined( phd_machine ) )
	{
		phd_machine.clip = old_phd_clip;
	}
}

init()
{
	waittillframeend;
	level.afterlife_save_loadout_old_perks = level.afterlife_save_loadout;
	level.afterlife_save_loadout = ::afterlife_save_loadout_hook;
}

afterlife_save_loadout_hook()
{
	if ( self hasperk( "specialty_additionalprimaryweapon" ) && !is_true( self.keep_perks ) )
	{
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = self maps\mp\zombies\_zm::take_additionalprimaryweapon();
	}
	
	self [[ level.afterlife_save_loadout_old_perks ]]();
}
