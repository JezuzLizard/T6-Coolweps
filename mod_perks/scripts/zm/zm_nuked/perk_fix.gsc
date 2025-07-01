main()
{
	if ( isDedicated() )
	{
		replacefunc( maps\mp\zm_nuked_perks::init_nuked_perks, maps\mp\zm_nuked_perks::init_nuked_perks );
		replacefunc( maps\mp\zm_nuked_perks::perks_from_the_sky, maps\mp\zm_nuked_perks::perks_from_the_sky );
	}
}
