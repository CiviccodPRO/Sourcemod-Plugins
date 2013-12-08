/*
***	Seasonal Weather		***
===========================================================================
* Seasonal Weather!
===========================================================================
*	Author: Civiccod PRO
*
*	Description: Getting close to winter? Whats winter without snow! Seasonal Weather modifies the
*	particles to form a seasonal weather effect, without the hassle of downloading a seperate map!
*	Also, programmed with an easy menu to use ^_^
*
*	Credits:
*	CrimsonGT				Environmental Tools Plugin
*
*	Version: 1.0
*	URL: www.sourcemod.net
*	URL 2: http://steamcommunity.com/id/CiviccodPRO/
*
*	Notes:
*	More weather effects will come in future updates!
============================================================================
***	Seasonal Weather		***
*/
// PREPROCESSOR
#pragma semicolon 1

// INCLUDES
#include <sourcemod>
#include <sdktools>
#include <morecolors>

// CONSTANTS
#define PLUGIN_NAME	"Seasonal Weather"
#define PLUGIN_AUTHOR	"Civiccod PRO"
#define PLUGIN_DESC	"Seasonal Weather effects on any map!"
#define PLUGIN_VERSION	"1.0"
#define PLUGIN_URL	"www.sourcemod.net"


// VARIABLES
/* CONVARRS */
new Handle:sm_weather_enabled;

// PLUGIN
public Plugin:myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESC,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};


/* OnPluginStart()
**
** When the plugin is loaded.
** -------------------------------------------------------------------------- */
public OnPluginStart()
{
	// Only runs on TF2
	decl String:strModName[32]; GetGameFolderName(strModName, sizeof(strModName));
	if (!StrEqual(strModName, "tf")) SetFailState("This plugin is only for TF2!");
	
	// Convar(s)
	CreateConVar("sm_weather_version", PLUGIN_VERSION, "Weather Plugin Version", FCVAR_PLUGIN|FCVAR_REPLICATED|FCVAR_NOTIFY); 
	
	sm_weather_enabled = CreateConVar("sm_weather_enabled", "1", "Enables Weather | WHO WOULD WANT TO DISABLE THIS?", FCVAR_PLUGIN);
	
	RegAdminCmd("sm_weather", Weather_Cmd, ADMFLAG_CONVARS, "");
	
}

//Launches Weather Menu
public Action:Weather_Cmd(client, args)
{
	if(GetConVarBool(sm_weather_enabled))
	WMenu(client);
	return Plugin_Handled;
}

//Weather Menu
public WMenu(client)
{
	//Creates a handle for our menu
	new Handle:wmenu = CreateMenu(WMenuCallback);
	
	//Sets Menu Title
	SetMenuTitle(wmenu, "Seasonal Weather!");
	
	//Add items to the menu
	AddMenuItem(wmenu, "1", "Weather Effects");
	
	//Sets an exit button
	SetMenuExitButton(wmenu, true);
	
	//Displays menu until client hits exit button
	DisplayMenu(wmenu, client, MENU_TIME_FOREVER);
}

//Weather Menu Functions
public WMenuCallback(Handle:wmenu, MenuAction:action, client, param2)
{
	//Selects a menu item
	if (action == MenuAction_Select)
	{
		//Get client's choice of menu item
		new String:sInfo[4];
		GetMenuItem(wmenu, param2, sInfo, sizeof(sInfo));
		new MenuWChoice:choice = MenuWChoice:StringToInt(sInfo);
		
		switch (choice)
		{
			//Options for menu items
			case 1:
			{
				//Creates a new menu
				new Handle:WFMenu = CreateMenu(WFMenuCallback);
				
				//Sets Menu Title
				SetMenuTitle(WFMenu, "Weather");
				
				//Add items to the menu
				AddMenuItem(WFMenu, "1", "Snow");
				AddMenuItem(WFMenu, "2", "Rain");
				
				//Sets an exit back button
				SetMenuExitBackButton(WFMenu, true);
				
				//Display the menu 
				DisplayMenu(WFMenu, client, MENU_TIME_FOREVER);
			}
		}
	}
	//Close Menu
	else if (action == MenuAction_End)
	{
		CloseHandle(wmenu);
	}
}

//Weather Menu Effects
public WFMenuCallback(Handle:WFMenu, MenuAction:action, client, param2)
{
	//Get Menu Selection
	if (action == MenuAction_Select)
	{
		new String:sInfo[4];
		GetMenuItem(WFMenu, param2, sInfo, sizeof(sInfo));
		new WFMenuChoice:choice = WFMenuChoice:StringToInt(sInfo);
	
		switch (choice)
		{
			//Set Effect for snow
			case 1:
			{
				AttachSnowParticle(client);
				CPrintToChat(client, "{cyan} It's now snowing!");
			}
			//Set Effect for rain
			case 2:
			{
				AttachRainParticle(client);
				CPrintToChat(client, "{fullblue} It's now raining!");
			}
		}
	}
}

//Attach the snow weather effect particles
stock AttachSnowParticle(client)
{
	//Create Entity
	new ent = CreateEntityByName("func_precipitation");
	
	//Set settings for entity
	DispatchKeyValue(ent, "preciptype", "3");
	DispatchKeyValue(ent, "renderamt", "5");
	DispatchKeyValue(ent, "rendercolor", "200 200 200");
	
	DispatchSpawn(ent);
	ActivateEntity(ent);
	
	AcceptEntityInput(ent, "start");
	
	
	//Targeting Map
	new Float:minbounds[3];
	GetEntPropVector(0, Prop_Data, "m_WorldMins", minbounds); 
	new Float:maxbounds[3];
	GetEntPropVector(0, Prop_Data, "m_WorldMaxs", maxbounds); 	
	
	SetEntPropVector(ent, Prop_Send, "m_vecMins", minbounds);
	SetEntPropVector(ent, Prop_Send, "m_vecMaxs", maxbounds);    
	new Float:m_vecOrigin[3];
	m_vecOrigin[0] = (minbounds[0] + maxbounds[0])/2;
	m_vecOrigin[1] = (minbounds[1] + maxbounds[1])/2;
	m_vecOrigin[2] = (minbounds[2] + maxbounds[2])/2;
	
	//Teleport entity
	TeleportEntity(ent, m_vecOrigin, NULL_VECTOR, NULL_VECTOR);
}

//Attach the rain weather effect particles
stock AttachRainParticle(client)
{
	//Create Entity
	new ent = CreateEntityByName("func_precipitation");
	
	//Set settings for entity
	DispatchKeyValue(ent, "preciptype", "0");
	DispatchKeyValue(ent, "renderamt", "2");
	DispatchKeyValue(ent, "rendercolor", "200 200 200");
	
	DispatchSpawn(ent);
	ActivateEntity(ent);
	
	AcceptEntityInput(ent, "start");
	
	new Float:clientPos[3];
	
	//Loop through all clients
	for (new i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			GetClientAbsOrigin(i, clientPos);
		}
	}
	
	TeleportEntity(ent, clientPos, NULL_VECTOR, NULL_VECTOR);
}

//Delete Weather Effects Particle
stock KillEffect()
{
	new ent = -1;
	
	//Find the classname used
	while ((ent = FindEntityByClassname(ent, "func_precipitation")) != -1)
	{
		//If is right entity
		if (IsValidEntity(ent))
		{
			//Delete Particle
			RemoveEdict(ent);
		}
	}
}
