#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
    level thread onPlayerConnect();
    
    // Denizens
    setDvar( "scr_screecher_ignore_player", 1 );
    
    // Portals
    level thread teleporters();

    // Doors
    level.power_local_doors_globally = true;
    
    // Jet Gun
    level.explode_overheated_jetgun = false;
    level.unbuild_overheated_jetgun = false;
    level.take_overheated_jetgun = true;
    set_zombie_var( "jetgun_grind_range", 1000 );
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
        
        // Message
        self iprintln("^1Bandit's TranZit Fix");
        
        // Players
        self setperk( "specialty_unlimitedsprint" );
        level.perk_purchase_limit = 9;
    }
}

teleporters()
{
    teleporters = GetStructArray( "screecher_escape", "targetname" );
    foreach(spot in teleporters)
    {
        spot thread setupTeleporters();
    }    
}

setupTeleporters()
{
    for(;;)
    {
        for(i=0;i<get_players().size;i++)
    	{
            if(Distance(get_players()[i].origin, self.origin) < 200)
            {
                self thread maps/mp/zm_transit_ai_screecher::create_portal();
                wait 1;
                self notify( "burrow_done" );
                while(is_true(self.burrow_active))
                {
                    wait 1;
                }
                break;
            }
        }
        wait 1;
    }
}
