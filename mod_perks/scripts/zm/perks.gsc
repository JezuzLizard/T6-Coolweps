#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc( maps\mp\zombies\_zm_perks::perk_machine_spawn_init, ::perk_machine_spawn_init_hook );
	
	
	level.zombiemode_using_marathon_perk = 1;
	level.zombiemode_using_additionalprimaryweapon_perk = 1;
	
	
	level.zombiemode_using_divetonuke_perk = 1;
	maps\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
	
	replacefunc( maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke, ::noop );
	
	onfinalizeinitialization_callback( ::finalize_initialization );
}

finalize_initialization()
{
	disabledetouronce( maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke );
	maps\mp\zombies\_zm_perk_divetonuke::init_divetonuke();
}

noop()
{
}

perk_machine_spawn_init_hook()
{
	disabledetouronce( maps\mp\zombies\_zm_perks::perk_machine_spawn_init );
	maps\mp\zombies\_zm_perks::perk_machine_spawn_init();
	
	level.custom_vending_precaching = ::default_vending_precaching;
}

custom_vending_precaching_tomb()
{
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
	
	custom_vending_power_on = GetFunction( "maps/mp/zm_tomb_capture_zones", "custom_vending_power_on" );
	custom_vending_power_off = GetFunction( "maps/mp/zm_tomb_capture_zones", "custom_vending_power_off" );
	
	if ( isdefined( level.zombiemode_using_pack_a_punch ) && level.zombiemode_using_pack_a_punch )
	{
		precacheitem( "zombie_knuckle_crack" );
		precachemodel( "p6_anim_zm_buildable_pap" );
		precachemodel( "p6_anim_zm_buildable_pap_on" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH_ATT" );
		level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
	}
	
	if ( isdefined( level.zombiemode_using_additionalprimaryweapon_perk ) && level.zombiemode_using_additionalprimaryweapon_perk )
	{
		precacheitem( "zombie_perk_bottle_additionalprimaryweapon" );
		precacheshader( "specialty_additionalprimaryweapon_zombies" );
		precachemodel( "p6_zm_tm_vending_three_gun" );
		precachestring( &"ZOMBIE_PERK_ADDITIONALWEAPONPERK" );
		level._effect["additionalprimaryweapon_light"] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_tm_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_tm_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].power_on_callback = custom_vending_power_on;
		level.machine_assets["additionalprimaryweapon"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_deadshot_perk ) && level.zombiemode_using_deadshot_perk )
	{
		precacheitem( "zombie_perk_bottle_deadshot" );
		precacheshader( "specialty_ads_zombies" );
		precachemodel( "zombie_vending_ads" );
		precachemodel( "zombie_vending_ads_on" );
		precachestring( &"ZOMBIE_PERK_DEADSHOT" );
		level._effect["deadshot_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "zombie_vending_ads";
		level.machine_assets["deadshot"].on_model = "zombie_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = custom_vending_power_on;
		level.machine_assets["deadshot"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_divetonuke_perk ) && level.zombiemode_using_divetonuke_perk )
	{
		precacheitem( "zombie_perk_bottle_nuke" );
		precacheshader( "specialty_divetonuke_zombies" );
		precachemodel( "zombie_vending_nuke" );
		precachemodel( "zombie_vending_nuke_on" );
		precachestring( &"ZOMBIE_PERK_DIVETONUKE" );
		level._effect["divetonuke_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["divetonuke"] = spawnstruct();
		level.machine_assets["divetonuke"].weapon = "zombie_perk_bottle_nuke";
		level.machine_assets["divetonuke"].off_model = "zombie_vending_nuke";
		level.machine_assets["divetonuke"].on_model = "zombie_vending_nuke_on";
		level.machine_assets["divetonuke"].power_on_callback = custom_vending_power_on;
		level.machine_assets["divetonuke"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_doubletap_perk ) && level.zombiemode_using_doubletap_perk )
	{
		precacheitem( "zombie_perk_bottle_doubletap" );
		precacheshader( "specialty_doubletap_zombies" );
		precachemodel( "zombie_vending_doubletap2" );
		precachemodel( "zombie_vending_doubletap2_on" );
		precachestring( &"ZOMBIE_PERK_DOUBLETAP" );
		level._effect["doubletap_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "zombie_vending_doubletap2";
		level.machine_assets["doubletap"].on_model = "zombie_vending_doubletap2_on";
		level.machine_assets["doubletap"].power_on_callback = custom_vending_power_on;
		level.machine_assets["doubletap"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_juggernaut_perk ) && level.zombiemode_using_juggernaut_perk )
	{
		precacheitem( "zombie_perk_bottle_jugg" );
		precacheshader( "specialty_juggernaut_zombies" );
		precachemodel( "zombie_vending_jugg" );
		precachemodel( "zombie_vending_jugg_on" );
		precachestring( &"ZOMBIE_PERK_JUGGERNAUT" );
		level._effect["jugger_light"] = loadfx( "misc/fx_zombie_cola_jugg_on" );
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "zombie_vending_jugg";
		level.machine_assets["juggernog"].on_model = "zombie_vending_jugg_on";
		level.machine_assets["juggernog"].power_on_callback = custom_vending_power_on;
		level.machine_assets["juggernog"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_marathon_perk ) && level.zombiemode_using_marathon_perk )
	{
		precacheitem( "zombie_perk_bottle_marathon" );
		precacheshader( "specialty_marathon_zombies" );
		precachemodel( "zombie_vending_marathon" );
		precachemodel( "zombie_vending_marathon_on" );
		precachestring( &"ZOMBIE_PERK_MARATHON" );
		level._effect["marathon_light"] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
		level.machine_assets["marathon"].power_on_callback = custom_vending_power_on;
		level.machine_assets["marathon"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_revive_perk ) && level.zombiemode_using_revive_perk )
	{
		precacheitem( "zombie_perk_bottle_revive" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "p6_zm_tm_vending_revive" );
		precachemodel( "p6_zm_tm_vending_revive_on" );
		precachestring( &"ZOMBIE_PERK_QUICKREVIVE" );
		level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
		level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "p6_zm_tm_vending_revive";
		level.machine_assets["revive"].on_model = "p6_zm_tm_vending_revive_on";
		level.machine_assets["revive"].power_on_callback = custom_vending_power_on;
		level.machine_assets["revive"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_sleightofhand_perk ) && level.zombiemode_using_sleightofhand_perk )
	{
		precacheitem( "zombie_perk_bottle_sleight" );
		precacheshader( "specialty_fastreload_zombies" );
		precachemodel( "zombie_vending_sleight" );
		precachemodel( "zombie_vending_sleight_on" );
		precachestring( &"ZOMBIE_PERK_FASTRELOAD" );
		level._effect["sleight_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "zombie_vending_sleight";
		level.machine_assets["speedcola"].on_model = "zombie_vending_sleight_on";
		level.machine_assets["speedcola"].power_on_callback = custom_vending_power_on;
		level.machine_assets["speedcola"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_tombstone_perk ) && level.zombiemode_using_tombstone_perk )
	{
		precacheitem( "zombie_perk_bottle_tombstone" );
		precacheshader( "specialty_tombstone_zombies" );
		precachemodel( "zombie_vending_tombstone" );
		precachemodel( "zombie_vending_tombstone_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
		level.machine_assets["tombstone"].power_on_callback = custom_vending_power_on;
		level.machine_assets["tombstone"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_chugabud_perk ) && level.zombiemode_using_chugabud_perk )
	{
		precacheitem( "zombie_perk_bottle_whoswho" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "p6_zm_vending_chugabud" );
		precachemodel( "p6_zm_vending_chugabud_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
		level.machine_assets["whoswho"].off_model = "p6_zm_vending_chugabud";
		level.machine_assets["whoswho"].on_model = "p6_zm_vending_chugabud_on";
		level.machine_assets["whoswho"].power_on_callback = custom_vending_power_on;
		level.machine_assets["whoswho"].power_off_callback = custom_vending_power_off;
	}
}

custom_vending_precaching_prison()
{
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
	
	custom_vending_power_on = GetFunction( "maps/mp/zm_prison", "custom_vending_power_on" );
	custom_vending_power_off = GetFunction( "maps/mp/zm_prison", "custom_vending_power_off" );
	
	if ( isdefined( level.zombiemode_using_pack_a_punch ) && level.zombiemode_using_pack_a_punch )
	{
		precacheitem( "zombie_knuckle_crack" );
		precachemodel( "p6_anim_zm_buildable_pap" );
		precachemodel( "p6_anim_zm_buildable_pap_on" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH_ATT" );
		level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
		level.machine_assets["packapunch"].off_model = "p6_zm_al_vending_pap_on";
		level.machine_assets["packapunch"].on_model = "p6_zm_al_vending_pap_on";
		level.machine_assets["packapunch"].power_on_callback = custom_vending_power_on;
		level.machine_assets["packapunch"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_additionalprimaryweapon_perk ) && level.zombiemode_using_additionalprimaryweapon_perk )
	{
		precacheitem( "zombie_perk_bottle_additionalprimaryweapon" );
		precacheshader( "specialty_additionalprimaryweapon_zombies" );
		precachemodel( "p6_zm_al_vending_three_gun_on" );
		precachestring( &"ZOMBIE_PERK_ADDITIONALWEAPONPERK" );
		level._effect["additionalprimaryweapon_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_al_vending_three_gun_on";
		level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_al_vending_three_gun_on";
		level.machine_assets["additionalprimaryweapon"].power_on_callback = custom_vending_power_on;
		level.machine_assets["additionalprimaryweapon"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_deadshot_perk ) && level.zombiemode_using_deadshot_perk )
	{
		precacheitem( "zombie_perk_bottle_deadshot" );
		precacheshader( "specialty_ads_zombies" );
		precachemodel( "p6_zm_al_vending_ads_on" );
		precachestring( &"ZOMBIE_PERK_DEADSHOT" );
		level._effect["deadshot_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].on_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = custom_vending_power_on;
		level.machine_assets["deadshot"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_divetonuke_perk ) && level.zombiemode_using_divetonuke_perk )
	{
		precacheitem( "zombie_perk_bottle_nuke" );
		precacheshader( "specialty_divetonuke_zombies" );
		precachemodel( "p6_zm_al_vending_nuke_on" );
		precachestring( &"ZOMBIE_PERK_DIVETONUKE" );
		level._effect["divetonuke_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["divetonuke"] = spawnstruct();
		level.machine_assets["divetonuke"].weapon = "zombie_perk_bottle_nuke";
		level.machine_assets["divetonuke"].off_model = "p6_zm_al_vending_nuke_on";
		level.machine_assets["divetonuke"].on_model = "p6_zm_al_vending_nuke_on";
		level.machine_assets["divetonuke"].power_on_callback = custom_vending_power_on;
		level.machine_assets["divetonuke"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_doubletap_perk ) && level.zombiemode_using_doubletap_perk )
	{
		precacheitem( "zombie_perk_bottle_doubletap" );
		precacheshader( "specialty_doubletap_zombies" );
		precachemodel( "p6_zm_al_vending_doubletap2_on" );
		precachestring( &"ZOMBIE_PERK_DOUBLETAP" );
		level._effect["doubletap_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "p6_zm_al_vending_doubletap2_on";
		level.machine_assets["doubletap"].on_model = "p6_zm_al_vending_doubletap2_on";
		level.machine_assets["doubletap"].power_on_callback = custom_vending_power_on;
		level.machine_assets["doubletap"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_juggernaut_perk ) && level.zombiemode_using_juggernaut_perk )
	{
		precacheitem( "zombie_perk_bottle_jugg" );
		precacheshader( "specialty_juggernaut_zombies" );
		precachemodel( "p6_zm_al_vending_jugg_on" );
		precachestring( &"ZOMBIE_PERK_JUGGERNAUT" );
		level._effect["jugger_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "p6_zm_al_vending_jugg_on";
		level.machine_assets["juggernog"].on_model = "p6_zm_al_vending_jugg_on";
		level.machine_assets["juggernog"].power_on_callback = custom_vending_power_on;
		level.machine_assets["juggernog"].power_off_callback = custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_marathon_perk ) && level.zombiemode_using_marathon_perk )
	{
		precacheitem( "zombie_perk_bottle_marathon" );
		precacheshader( "specialty_marathon_zombies" );
		precachemodel( "zombie_vending_marathon" );
		precachemodel( "zombie_vending_marathon_on" );
		precachestring( &"ZOMBIE_PERK_MARATHON" );
		level._effect["marathon_light"] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
	}
	
	if ( isdefined( level.zombiemode_using_revive_perk ) && level.zombiemode_using_revive_perk )
	{
		precacheitem( "zombie_perk_bottle_revive" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "zombie_vending_revive" );
		precachemodel( "zombie_vending_revive_on" );
		precachestring( &"ZOMBIE_PERK_QUICKREVIVE" );
		level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
		level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "zombie_vending_revive";
		level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
	}
	
	if ( isdefined( level.zombiemode_using_sleightofhand_perk ) && level.zombiemode_using_sleightofhand_perk )
	{
		precacheitem( "zombie_perk_bottle_sleight" );
		precacheshader( "specialty_fastreload_zombies" );
		precachemodel( "p6_zm_al_vending_sleight_on" );
		precachestring( &"ZOMBIE_PERK_FASTRELOAD" );
		level._effect["sleight_light"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_perk_smk" );
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "p6_zm_al_vending_sleight_on";
		level.machine_assets["speedcola"].on_model = "p6_zm_al_vending_sleight_on";
		level.machine_assets["speedcola"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["speedcola"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}
	
	if ( isdefined( level.zombiemode_using_tombstone_perk ) && level.zombiemode_using_tombstone_perk )
	{
		precacheitem( "zombie_perk_bottle_tombstone" );
		precacheshader( "specialty_tombstone_zombies" );
		precachemodel( "zombie_vending_tombstone" );
		precachemodel( "zombie_vending_tombstone_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
	}
	
	if ( isdefined( level.zombiemode_using_chugabud_perk ) && level.zombiemode_using_chugabud_perk )
	{
		precacheitem( "zombie_perk_bottle_whoswho" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "p6_zm_vending_chugabud" );
		precachemodel( "p6_zm_vending_chugabud_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
		level.machine_assets["whoswho"].off_model = "p6_zm_vending_chugabud";
		level.machine_assets["whoswho"].on_model = "p6_zm_vending_chugabud_on";
	}
}

default_vending_precaching()
{
	if ( level.script == "zm_tomb" )
	{
		custom_vending_precaching_tomb();
		return;
	}
	
	if ( level.script == "zm_prison" )
	{
		custom_vending_precaching_prison();
		return;
	}
	
	if ( isdefined( level.zombiemode_using_divetonuke_perk ) && level.zombiemode_using_divetonuke_perk )
	{
		precacheitem( "zombie_perk_bottle_nuke" );
		precacheshader( "specialty_divetonuke_zombies" );
		precachemodel( "zombie_vending_nuke" );
		precachemodel( "zombie_vending_nuke_on" );
		precachestring( &"ZOMBIE_PERK_DIVETONUKE" );
		level._effect["divetonuke_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["divetonuke"] = spawnstruct();
		level.machine_assets["divetonuke"].weapon = "zombie_perk_bottle_nuke";
		level.machine_assets["divetonuke"].off_model = "zombie_vending_nuke";
		level.machine_assets["divetonuke"].on_model = "zombie_vending_nuke_on";
	}
	
	if ( isdefined( level.zombiemode_using_pack_a_punch ) && level.zombiemode_using_pack_a_punch )
	{
		precacheitem( "zombie_knuckle_crack" );
		precachemodel( "p6_anim_zm_buildable_pap" );
		precachemodel( "p6_anim_zm_buildable_pap_on" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH" );
		precachestring( &"ZOMBIE_PERK_PACKAPUNCH_ATT" );
		
		if ( level.script == "zm_highrise" )
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zmb_highrise_packapunch" );
		}
		else
		{
			level._effect["packapunch_fx"] = loadfx( "maps/zombie/fx_zombie_packapunch" );
		}
		
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
		level.machine_assets["packapunch"].off_model = "p6_anim_zm_buildable_pap";
		level.machine_assets["packapunch"].on_model = "p6_anim_zm_buildable_pap_on";
	}
	
	if ( isdefined( level.zombiemode_using_additionalprimaryweapon_perk ) && level.zombiemode_using_additionalprimaryweapon_perk )
	{
		precacheitem( "zombie_perk_bottle_additionalprimaryweapon" );
		precacheshader( "specialty_additionalprimaryweapon_zombies" );
		precachemodel( "zombie_vending_three_gun" );
		precachemodel( "zombie_vending_three_gun_on" );
		precachestring( &"ZOMBIE_PERK_ADDITIONALWEAPONPERK" );
		level._effect["additionalprimaryweapon_light"] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "zombie_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].on_model = "zombie_vending_three_gun_on";
	}
	
	if ( isdefined( level.zombiemode_using_deadshot_perk ) && level.zombiemode_using_deadshot_perk )
	{
		precacheitem( "zombie_perk_bottle_deadshot" );
		precacheshader( "specialty_ads_zombies" );
		precachemodel( "zombie_vending_ads" );
		precachemodel( "zombie_vending_ads_on" );
		precachestring( &"ZOMBIE_PERK_DEADSHOT" );
		level._effect["deadshot_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "zombie_vending_ads";
		level.machine_assets["deadshot"].on_model = "zombie_vending_ads_on";
	}
	
	if ( isdefined( level.zombiemode_using_doubletap_perk ) && level.zombiemode_using_doubletap_perk )
	{
		precacheitem( "zombie_perk_bottle_doubletap" );
		precacheshader( "specialty_doubletap_zombies" );
		precachemodel( "zombie_vending_doubletap2" );
		precachemodel( "zombie_vending_doubletap2_on" );
		precachestring( &"ZOMBIE_PERK_DOUBLETAP" );
		level._effect["doubletap_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "zombie_vending_doubletap2";
		level.machine_assets["doubletap"].on_model = "zombie_vending_doubletap2_on";
	}
	
	if ( isdefined( level.zombiemode_using_juggernaut_perk ) && level.zombiemode_using_juggernaut_perk )
	{
		precacheitem( "zombie_perk_bottle_jugg" );
		precacheshader( "specialty_juggernaut_zombies" );
		precachemodel( "zombie_vending_jugg" );
		precachemodel( "zombie_vending_jugg_on" );
		precachestring( &"ZOMBIE_PERK_JUGGERNAUT" );
		level._effect["jugger_light"] = loadfx( "misc/fx_zombie_cola_jugg_on" );
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "zombie_vending_jugg";
		level.machine_assets["juggernog"].on_model = "zombie_vending_jugg_on";
	}
	
	if ( isdefined( level.zombiemode_using_marathon_perk ) && level.zombiemode_using_marathon_perk )
	{
		precacheitem( "zombie_perk_bottle_marathon" );
		precacheshader( "specialty_marathon_zombies" );
		precachemodel( "zombie_vending_marathon" );
		precachemodel( "zombie_vending_marathon_on" );
		precachestring( &"ZOMBIE_PERK_MARATHON" );
		level._effect["marathon_light"] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
	}
	
	if ( isdefined( level.zombiemode_using_revive_perk ) && level.zombiemode_using_revive_perk )
	{
		precacheitem( "zombie_perk_bottle_revive" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "zombie_vending_revive" );
		precachemodel( "zombie_vending_revive_on" );
		precachestring( &"ZOMBIE_PERK_QUICKREVIVE" );
		level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
		level._effect["revive_light_flicker"] = loadfx( "maps/zombie/fx_zmb_cola_revive_flicker" );
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "zombie_vending_revive";
		level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
	}
	
	if ( isdefined( level.zombiemode_using_sleightofhand_perk ) && level.zombiemode_using_sleightofhand_perk )
	{
		precacheitem( "zombie_perk_bottle_sleight" );
		precacheshader( "specialty_fastreload_zombies" );
		precachemodel( "zombie_vending_sleight" );
		precachemodel( "zombie_vending_sleight_on" );
		precachestring( &"ZOMBIE_PERK_FASTRELOAD" );
		level._effect["sleight_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "zombie_vending_sleight";
		level.machine_assets["speedcola"].on_model = "zombie_vending_sleight_on";
	}
	
	if ( isdefined( level.zombiemode_using_tombstone_perk ) && level.zombiemode_using_tombstone_perk )
	{
		precacheitem( "zombie_perk_bottle_tombstone" );
		precacheshader( "specialty_tombstone_zombies" );
		precachemodel( "zombie_vending_tombstone" );
		precachemodel( "zombie_vending_tombstone_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
	}
	
	if ( isdefined( level.zombiemode_using_chugabud_perk ) && level.zombiemode_using_chugabud_perk )
	{
		precacheitem( "zombie_perk_bottle_whoswho" );
		precacheshader( "specialty_quickrevive_zombies" );
		precachemodel( "p6_zm_vending_chugabud" );
		precachemodel( "p6_zm_vending_chugabud_on" );
		precachemodel( "ch_tombstone1" );
		precachestring( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
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
}
