/*
*** Hashtags! ***
====================================================
* Hashtags! 
====================================================
* Author: Civiccod PRO
*
* Description: Twitter, Facebook, Instagram, and Vine, what do they all
* have in common? They all use hashtags! Im bringing hashtags to TF2!
*
* Version: 1.0
* URL: www.sourcemod.net
* URL 2: http://steamcommunity.com/id/CiviccodPRO/
*
* Notes:
* Requires Morecolors.inc
* Must use /# <text>	
=====================================================
*** Hashtags! ***
*/
#pragma semicolon 1

#include <sourcemod>
#include <morecolors>

#define PLUGIN_NAME	"Hashtags!"
#define PLUGIN_AUTHOR	"Civiccod PRO"
#define PLUGIN_DESC	"The use of hashtags in game :O!"
#define PLUGIN_VERSION	"1.0"
#define PLUGIN_URL	"www.sourcemod.net"

new Handle:sm_hashtag_enabled;

public Plugin:myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESC,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

public OnPluginStart()
{
	CreateConVar("sm_hashtag_version", PLUGIN_VERSION, "Hashtag Plugin Version", FCVAR_PLUGIN|FCVAR_REPLICATED|FCVAR_NOTIFY); 

	sm_hashtag_enabled = CreateConVar("sm_hashtag_enabled", "1", "Enables hashtag", FCVAR_PLUGIN);
	
	RegAdminCmd("sm_#", Hashtag_Cmd, ADMFLAG_RESERVATION, "c:");
}

public Action:Hashtag_Cmd(client, args)
{
	if(GetConVarBool(sm_hashtag_enabled))
	{
	
		if (args < 1)
		{
			ReplyToCommand(client, "[SM] Usage: sm_# <text>");
			return Plugin_Handled;
		}
		
		new String:tag[256];
	
		GetCmdArgString(tag, sizeof(tag));
		
		CPrintToChatAll("{aqua}#%s", tag);
	
	}
	
	return Plugin_Handled;
}
