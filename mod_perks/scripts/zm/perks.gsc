#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( maps\mp\zombies\_zm_perks::perk_machine_spawn_init, ::perk_machine_spawn_init_hook );
	
	
	level.zombiemode_using_marathon_perk = 1;
	level.zombiemode_using_additionalprimaryweapon_perk = 1;
	level.zombiemode_using_deadshot_perk = 1;
	
	level.zombiemode_using_divetonuke_perk = 1;
	maps\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
	replacefunc( maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke, ::noop );
	
	precachemodel( "p6_zm_vending_electric_cherry" );
	level.zombiemode_using_electric_cherry_perk = 1;
	maps\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level();
	replacefunc( maps\mp\zombies\_zm_perk_electric_cherry::init_electric_cherry, ::noop );
	
	level._effect["bottle_glow"] = loadfx( "maps/zombie_tomb/fx_tomb_dieselmagic_portal" );
	level.zombiemode_using_random_perk = 1;
	
	onfinalizeinitialization_callback( ::finalize_initialization );
	
	flag_wait( "initial_blackscreen_passed" );
	
	if ( level.script != "zm_nuked" && level.script != "zm_tomb" )
	{
		gamemode_random_perk();
		level thread maps\mp\zombies\_zm_perk_random::start_random_machine();
	}
	
	if ( level.script == "zm_prison" )
	{
		level thread listen_for_afterlife_box_power_random_perk( "0" );
		level thread listen_for_afterlife_box_power_random_perk( "1" );
		level thread listen_for_afterlife_box_power_random_perk( "2" );
		
		// fix exploit spot
		spawn_blocker_collision( ( -585, 6128, -41 ), ( 0, 0, 0 ) );
	}
	else if ( level.script != "zm_tomb" )
	{
		level thread turn_random_perk_on_with_power();
	}
}

init()
{
	if ( level.script != "zm_tomb" )
	{
		// for the unitriggers
		maps\mp\zombies\_zm_perk_random::init();
		
		fizz_perks = array( "specialty_armorvest", "specialty_quickrevive", "specialty_fastreload", "specialty_rof", "specialty_longersprint", "specialty_deadshot", "specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_grenadepulldeath" );
		
		foreach ( perk in fizz_perks )
		{
			if ( is_specialty_in_use( perk ) )
			{
				maps\mp\zombies\_zm_perk_random::include_perk_in_random_rotation( perk );
			}
		}
	}
}

fix_flakjacket_jingle( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_phdflopper_jingle";
	use_trigger.script_string = "divetonuke_perk";
	use_trigger.script_label = "mus_perks_phdflopper_sting";
	use_trigger.target = "vending_divetonuke";
	perk_machine.script_string = "divetonuke_perk";
	perk_machine.targetname = "vending_divetonuke";
	
	if ( isdefined( bump_trigger ) )
	{
		bump_trigger.script_string = "divetonuke_perk";
	}
}

is_specialty_in_use( perk )
{
	switch ( perk )
	{
		case "specialty_additionalprimaryweapon":
			return is_true( level.zombiemode_using_additionalprimaryweapon_perk );
			
		case "specialty_flakjacket":
			if ( level.script == "zm_buried" )
			{
				return isdefined( level._custom_perks[ perk ] );
			}
			
			return is_true( level.zombiemode_using_divetonuke_perk ); // buried doesnt set this...
			
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
			
		case "specialty_stalker": // custom specialty for the fizz
			return is_true( level.zombiemode_using_random_perk );
			
		case "specialty_grenadepulldeath":
			return is_true( level.zombiemode_using_electric_cherry_perk ); // csc doesnt use this...
			
		default:
			return isdefined( level._custom_perks[ perk ] ); // vulture aid doesnt have a bool at all!
	}
}

delay_init()
{
	wait 0.05;
	
	if ( level.script != "zm_tomb" )
	{
		level thread maps\mp\zombies\_zm_perk_random::init_animtree();
	}
}

finalize_initialization()
{
	disabledetouronce( maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke );
	maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke();
	
	disabledetouronce( maps\mp\zombies\_zm_perk_electric_cherry::init_electric_cherry );
	maps\mp\zombies\_zm_perk_electric_cherry::init_electric_cherry();
	
	thread delay_init();
}

noop()
{
}

spawn_blocker_collision( origin, angles )
{
	blocker = spawn( "script_model", origin, 1 );
	blocker.angles = angles;
	blocker setmodel( "zm_collision_perks1" );
	blocker.script_noteworthy = "clip";
	blocker disconnectpaths();
	return blocker;
}

listen_for_afterlife_box_power_random_perk( num )
{
	machines = getentarray( "random_perk_machine", "targetname" );
	machine = undefined;
	
	foreach ( machine_ in machines )
	{
		if ( machine_.target == "random_perk_machine" + num )
		{
			machine = machine_;
			break;
		}
	}
	
	machine.is_locked = 1;
	machine.clip = spawn_blocker_collision( machine.origin, machine.angles );
	
	level waittill( "random_perk_machine" + num + "_on" );
	
	machine.is_locked = 0;
}

turn_random_perk_on_with_power()
{
	machines = getentarray( "random_perk_machine", "targetname" );
	
	foreach ( machine in machines )
	{
		machine.is_locked = 1;
		machine.clip = spawn_blocker_collision( machine.origin, machine.angles );
	}
	
	flag_wait( "power_on" );
	
	foreach ( machine in machines )
	{
		machine.is_locked = 0;
	}
}

perk_machine_spawn_init_hook()
{
	// fix jingle for phd
	if ( level.script != "zm_prison" && is_specialty_in_use( "specialty_flakjacket" ) )
	{
		level._custom_perks[ "specialty_flakjacket" ].perk_machine_set_kvps = ::fix_flakjacket_jingle;
	}
	
	disabledetouronce( maps\mp\zombies\_zm_perks::perk_machine_spawn_init );
	maps\mp\zombies\_zm_perks::perk_machine_spawn_init();
	
	level.custom_vending_precaching = ::mod_vending_precache;
}

mod_vending_precache()
{
	custom_vending_power_on = undefined;
	custom_vending_power_off = undefined;
	
	if ( level.script == "zm_tomb" )
	{
		custom_vending_power_on = GetFunction( "maps/mp/zm_tomb_capture_zones", "custom_vending_power_on" );
		custom_vending_power_off = GetFunction( "maps/mp/zm_tomb_capture_zones", "custom_vending_power_off" );
	}
	else if ( level.script == "zm_prison" )
	{
		custom_vending_power_on = GetFunction( "maps/mp/zm_prison", "custom_vending_power_on" );
		custom_vending_power_off = GetFunction( "maps/mp/zm_prison", "custom_vending_power_off" );
	}
	
	if ( is_true( level.zombiemode_using_divetonuke_perk ) )
	{
		level._custom_perks[ "specialty_flakjacket" ].precache_func = undefined; // nuke broken default logic for dive to nuke precaching as custom perk
		
		precacheshader( "specialty_divetonuke_zombies" );
		precachestring( &"ZOMBIE_PERK_DIVETONUKE" );
		
		level.machine_assets["divetonuke"] = spawnstruct();
		level.machine_assets["divetonuke"].weapon = "zombie_perk_bottle_nuke";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["divetonuke_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		}
		else
		{
			level._effect["divetonuke_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		}
		
		level.machine_assets["divetonuke"].off_model = "p6_zm_al_vending_nuke";
		level.machine_assets["divetonuke"].on_model = "p6_zm_al_vending_nuke_on";
	}
	
	if ( is_true( level.zombiemode_using_pack_a_punch ) )
	{
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH_ATT" );
		
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
		
		if ( level.script == "zm_highrise" )
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zmb_highrise_packapunch" );
			level.machine_assets["packapunch"].off_model = "p6_anim_zm_buildable_pap";
			level.machine_assets["packapunch"].on_model = "p6_anim_zm_buildable_pap_on";
		}
		else if ( level.script == "zm_prison" )
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
			level.machine_assets["packapunch"].off_model = "p6_zm_al_vending_pap_on";
			level.machine_assets["packapunch"].on_model = "p6_zm_al_vending_pap_on";
		}
		else if ( level.script == "zm_tomb" )
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
			level.machine_assets["packapunch"].no_power_on_callback = true;
		}
		else
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
			level.machine_assets["packapunch"].off_model = "p6_anim_zm_buildable_pap";
			level.machine_assets["packapunch"].on_model = "p6_anim_zm_buildable_pap_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_additionalprimaryweapon_perk ) )
	{
		precacheshader( "specialty_additionalprimaryweapon_zombies" );
		precachestring( &"ZOMBIE_PERK_ADDITIONALWEAPONPERK" );
		
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		
		if ( level.script == "zm_tomb" )
		{
			level._effect["additionalprimaryweapon_light"] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
			level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_tm_vending_three_gun";
			level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_tm_vending_three_gun";
		}
		else if ( level.script == "zm_prison" )
		{
			level._effect["additionalprimaryweapon_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_al_vending_three_gun_on";
			level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_al_vending_three_gun_on";
		}
		else
		{
			level._effect["additionalprimaryweapon_light"] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
			level.machine_assets["additionalprimaryweapon"].off_model = "zombie_vending_three_gun";
			level.machine_assets["additionalprimaryweapon"].on_model = "zombie_vending_three_gun_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_deadshot_perk ) )
	{
		precacheshader( "specialty_ads_zombies" );
		precachestring( &"ZOMBIE_PERK_DEADSHOT" );
		
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["deadshot_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads_on";
		}
		else
		{
			level._effect["deadshot_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
			level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads";
		}
		
		level.machine_assets["deadshot"].on_model = "p6_zm_al_vending_ads_on";
	}
	
	if ( is_true( level.zombiemode_using_doubletap_perk ) )
	{
		precacheshader( "specialty_doubletap_zombies" );
		precachestring( &"ZOMBIE_PERK_DOUBLETAP" );
		
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["doubletap_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level.machine_assets["doubletap"].off_model = "p6_zm_al_vending_doubletap2_on";
			level.machine_assets["doubletap"].on_model = "p6_zm_al_vending_doubletap2_on";
		}
		else
		{
			level._effect["doubletap_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
			level.machine_assets["doubletap"].off_model = "zombie_vending_doubletap2";
			level.machine_assets["doubletap"].on_model = "zombie_vending_doubletap2_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_juggernaut_perk ) )
	{
		precacheshader( "specialty_juggernaut_zombies" );
		precachestring( &"ZOMBIE_PERK_JUGGERNAUT" );
		
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["jugger_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level.machine_assets["juggernog"].off_model = "p6_zm_al_vending_jugg_on";
			level.machine_assets["juggernog"].on_model = "p6_zm_al_vending_jugg_on";
		}
		else
		{
			level._effect["jugger_light"] = loadfx( "misc/fx_zombie_cola_jugg_on" );
			level.machine_assets["juggernog"].off_model = "zombie_vending_jugg";
			level.machine_assets["juggernog"].on_model = "zombie_vending_jugg_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_marathon_perk ) )
	{
		precacheshader( "specialty_marathon_zombies" );
		precachestring( &"ZOMBIE_PERK_MARATHON" );
		
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["marathon_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		}
		else
		{
			level._effect["marathon_light"] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
		}
		
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
	}
	
	if ( is_true( level.zombiemode_using_revive_perk ) )
	{
		precacheshader( "specialty_quickrevive_zombies" );
		precachestring( &"ZOMBIE_PERK_QUICKREVIVE" );
		
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		
		if ( level.script == "zm_tomb" )
		{
			level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
			level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
			level.machine_assets["revive"].off_model = "p6_zm_tm_vending_revive";
			level.machine_assets["revive"].on_model = "p6_zm_tm_vending_revive_on";
		}
		else if ( level.script == "zm_prison" )
		{
			level._effect["revive_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
			level.machine_assets["revive"].off_model = "zombie_vending_revive";
			level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
		}
		else
		{
			level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
			level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
			level.machine_assets["revive"].off_model = "zombie_vending_revive";
			level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_sleightofhand_perk ) )
	{
		precacheshader( "specialty_fastreload_zombies" );
		precachestring( &"ZOMBIE_PERK_FASTRELOAD" );
		
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["sleight_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
			level.machine_assets["speedcola"].off_model = "p6_zm_al_vending_sleight_on";
			level.machine_assets["speedcola"].on_model = "p6_zm_al_vending_sleight_on";
		}
		else
		{
			level._effect["sleight_light"] = loadfx( "misc/fx_zombie_cola_on" );
			level.machine_assets["speedcola"].off_model = "zombie_vending_sleight";
			level.machine_assets["speedcola"].on_model = "zombie_vending_sleight_on";
		}
	}
	
	if ( is_true( level.zombiemode_using_tombstone_perk ) )
	{
		precacheshader( "specialty_tombstone_zombies" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["tombstone_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		}
		else
		{
			level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		}
		
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
	}
	
	if ( is_true( level.zombiemode_using_chugabud_perk ) )
	{
		precachestring( &"ZOMBIE_PERK_CHUGABUD" );
		
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
		
		if ( level.script == "zm_prison" )
		{
			level._effect["tombstone_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		}
		else
		{
			level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		}
		
		level.machine_assets["whoswho"].off_model = "p6_zm_vending_chugabud";
		level.machine_assets["whoswho"].on_model = "p6_zm_vending_chugabud_on";
	}
	
	if ( level._custom_perks.size > 0 )
	{
		a_keys = getarraykeys( level._custom_perks );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( isdefined( level._custom_perks[a_keys[i]].precache_func ) )
			{
				level [[ level._custom_perks[a_keys[i]].precache_func ]]();
			}
		}
	}
	
	keys = getarraykeys( level.machine_assets );
	
	for ( i = 0; i < keys.size; i++ )
	{
		if ( !is_true( level.machine_assets[ keys[ i ] ].no_power_on_callback ) )
		{
			if ( isdefined( custom_vending_power_on ) )
			{
				level.machine_assets[ keys[ i ] ].power_on_callback = custom_vending_power_on;
			}
			
			if ( isdefined( custom_vending_power_off ) )
			{
				level.machine_assets[ keys[ i ] ].power_off_callback = custom_vending_power_off;
			}
		}
		
		if ( isdefined( level.machine_assets[ keys[ i ] ].off_model ) )
		{
			precachemodel( level.machine_assets[ keys[ i ] ].off_model );
		}
		
		if ( isdefined( level.machine_assets[ keys[ i ] ].on_model ) )
		{
			precachemodel( level.machine_assets[ keys[ i ] ].on_model );
		}
		
		if ( isdefined( level.machine_assets[ keys[ i ] ].weapon ) )
		{
			precacheitem( level.machine_assets[ keys[ i ] ].weapon );
		}
	}
}

gamemode_random_perk()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	
	if ( ( location == "default" || location == "" ) && isdefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}
	
	match_string = level.scr_zm_ui_gametype + "_perks_" + location;
	machines = getentarray( "random_perk_machine", "targetname" );
	
	foreach ( machine in machines )
	{
		tokens = strtok( machine.script_string, " " );
		found = false;
		
		foreach ( token in tokens )
		{
			if ( token == match_string )
			{
				found = true;
				break;
			}
		}
		
		if ( !found )
		{
			machine delete ();
		}
	}
}
