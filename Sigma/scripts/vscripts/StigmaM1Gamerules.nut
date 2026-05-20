/*
// This is all obsolete code that isn't used anymore due to having custom models with custom names that can be assigned in hammer.
//
// Code for custom alien models asigned during gameplay
// using Update() it looks for alien entities without a name and gives them one based on an incrementing counter
// (this is bad because there is a entity limit, though they are removed when they are killed.)
// (But it can still be laggy with many aliens)
//
// Once an alien is named they are given the i/o to be killed (deleted) when they die. This is because the models were pretty glitchy and not removing the corpses.
// The other half of this code is just looking for alien entity classnames and changing their models. A process which happens during gameplay.

NewAlienModels_t <- {};

// key - alien entity classname
// value - array of data:
// 0 - model name 
// 1 - default skin number
// 2 - custom skin number (-1 if doesnt have)
// 3 - chance for the custom skin (0.0 to 1.0)
NewAlienModels_t[ "asw_drone" ] <- [ "models/swarm/drone/drone.mdl", 0, 1, 0.15 ];
NewAlienModels_t[ "asw_drone_uber" ] <- [ "models/swarm/drone/uberdrone.mdl", 0, 1, 0.15 ];
NewAlienModels_t[ "asw_drone_jumper" ] <- [ "models/swarm/drone/drone.mdl", 2, 3, 0.15 ];
NewAlienModels_t[ "asw_mortarbug" ] <- [ "models/swarm/mortarbug/mortarbug.mdl", 0, -1, 0.0 ];
NewAlienModels_t[ "asw_buzzer" ] <- [ "models/swarm/buzzer/buzzer.mdl", 0, -1, 0.0 ];
NewAlienModels_t[ "asw_harvester" ] <- [ "models/swarm/harvester/harvester.mdl", 0, -1, 0.0 ];
NewAlienModels_t[ "asw_parasite" ] <- [ "models/swarm/parasite/parasite.mdl", 1, -1, 0.0 ];
NewAlienModels_t[ "asw_parasite_defanged" ] <- [ "models/swarm/parasite/parasite.mdl", 0, -1, 0.0 ];
NewAlienModels_t[ "asw_shieldbug" ] <- [ "models/swarm/shieldbug/shieldbug.mdl", 0, -1, 0.0 ];

foreach( k, v in NewAlienModels_t )
	PrecacheModel( v[0] );

// check asw_spawner entity in swarm.fgd for order
SpawnerAlienIndexes_t <-
[
	"asw_drone",
	"asw_buzzer",
	"asw_parasite",
	"asw_shieldbug",
	"asw_grub",
	"asw_drone_jumper",
	"asw_harvester",
	"asw_parasite_defanged",
	"asw_queen",
	"asw_boomer",
	"asw_ranger",
	"asw_mortarbug",
	"asw_shaman",
	"asw_drone_uber"
];

// Add a counter table to track named aliens
g_alienCounter <- { count = 0 };

// Queue to store alien names that need outputs added
g_alienOutputQueue <- [];

function OnMissionStart()
{
	local hSpawner = null;
	while ( hSpawner = Entities.FindByClassname( hSpawner, "asw_spawner" ) )
	{
		local nAlienClass = hSpawner.GetKeyValue( "AlienClass" ).tointeger();
		if ( nAlienClass > SpawnerAlienIndexes_t.len() - 1 )
			continue;
		
		local strClass = SpawnerAlienIndexes_t[ nAlienClass ];
		if ( !( strClass in NewAlienModels_t ) )
			continue;
			
		hSpawner.__KeyValueFromString( "AlienModelOverride", NewAlienModels_t[ strClass ][0] );
	}
}

function AddAlienOutputs()
{
	// Process all aliens in the queue
	foreach( alienName in g_alienOutputQueue )
	{
		local hAlien = Entities.FindByName( null, alienName );
		if ( hAlien != null )
		{
			EntityOutputs.AddOutput( hAlien, "OnDeath", "!self", "Kill", "", 2.0, 1 );
			//ClientPrint( null, 2, "[OUTPUT] Death output added to: " + alienName );
		}
	}
	
	// Clear the queue after processing
	g_alienOutputQueue.clear();
}

function Update()
{
	foreach( k, v in NewAlienModels_t )
	{
		local hAlien = null;
		while ( hAlien = Entities.FindByClassname( hAlien, k ) )
		{
			// Check if this alien needs naming
			if ( hAlien.GetName() == "" )
			{
				g_alienCounter.count += 1;
				local alienName = "alien_" + g_alienCounter.count.tostring();
				hAlien.SetName( alienName );
				
				//ClientPrint( null, 2, "[UPDATE] Alien named: " + alienName );
				
				// Add to queue for output processing
				g_alienOutputQueue.append( alienName );
			}
			
			// Apply model changes
			local strNewModel = v[0];
			if ( hAlien.GetModelName() == strNewModel )
				continue;
				
			hAlien.SetModel( strNewModel );
			if ( v[2] != -1 && RandomFloat( 0.0, 1.0 ) <= v[3] )
			{
				EntFireByHandle( hAlien, "Skin", v[2].tostring(), 0.0, null, null );
				continue;
			}
			
			EntFireByHandle( hAlien, "Skin", v[1].tostring(), 0.0, null, null );
		}
	}
	
	// Call the output addition function if there are aliens in the queue
	if ( g_alienOutputQueue.len() > 0 )
	{
		AddAlienOutputs();
	}
	
	return 0.0;
}

*/

function OnGameEvent_player_say(params)
{
    local msg = params.text.tolower();

    if (msg == "/cam 2k4")
    {
        cam2k4();
    }

    else if (msg == "/cam asrd")
    {
        camDefault();
    }
       
    else if (msg == "/cam topdown")
    {
        topDown();
    }
        
    else if (msg == "/cam first")
    {
        firstPerson();
    }
        
    else if (msg == "/cam third")
    {
        thirdPerson();
    }

}

function showCommands()
{
	ClientPrint(null, 3, "Switch between 2k4 or ASRD, first, third, and top down camera!");
	ClientPrint(null, 3, "/cam 2k4");
	ClientPrint(null, 3, "/cam asrd");
	ClientPrint(null, 3, "/cam topdown");
	ClientPrint(null, 3, "/cam first");
	ClientPrint(null, 3, "/cam third");

}


function cam2k4()
{
        ClientPrint(null, 3, "2k4 Cam enabled");
	
        // Enable 2k4-style topdown
        Convars.SetValue("fog_enable", 1);
        Convars.SetValue("asw_cam_marine_dist", 400);
        Convars.SetValue("asw_cam_marine_dist_death", 400);
        Convars.SetValue("asw_cam_marine_pitch", 90);
	
}

function camDefault()
{
        ClientPrint(null, 3, "Default Cam enabled");
		// Restore default cam
        Convars.SetValue("fog_enable", 1);
        Convars.SetValue("asw_cam_marine_dist", 412);
        Convars.SetValue("asw_cam_marine_dist_death", 200);
        Convars.SetValue("asw_cam_marine_pitch", 60);
}

function firstPerson()
{
        ClientPrint(null, 3, "First person Cam enabled");
        Convars.SetValue("asw_controls", 0);
        Convars.SetValue("asw_marine_rolls", 0);
}

function thirdPerson()
{
        ClientPrint(null, 3, "Third person Cam enabled");
        Convars.SetValue("asw_controls", 2);
        Convars.SetValue("asw_marine_rolls", 1);
}

function topDown()
{
        ClientPrint(null, 3, "Topdown Cam enabled");
        Convars.SetValue("asw_controls", 1);
        Convars.SetValue("asw_marine_rolls", 1);
}