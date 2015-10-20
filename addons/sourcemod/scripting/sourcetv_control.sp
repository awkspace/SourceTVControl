/**
 * Copyright © 2015 awk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

 #pragma semicolon 1

 #define PLUGIN_VERSION "1.0.0"

 #include <sourcemod>
 #include <sdktools>

public Plugin:myinfo = {

  name        = "SourceTV Control",
  author      = "awk",
  description = "Records per-round STV demos when server has players.",
  version     = PLUGIN_VERSION,
  url         = "https://github.com/cjlesiw/SourceTVControl"

}

// Plugin ConVars.
new Handle:cvar_tvc_filename = INVALID_HANDLE;

// Client tracking
new bool:client_connected[MAXPLAYERS + 1] = { false, ... };

public OnPluginStart() {

  // Hook round start.
  HookEvent("teamplay_round_start", OnRoundStart, EventHookMode_PostNoCopy);

  // Adjust SourceTV variables to keep recordings usable.
  SetConVarInt(FindConVar("tv_delay"), 0);
  SetConVarInt(FindConVar("tv_transmitall"), 1);

  // Initialize configuration variables.
  cvar_tvc_filename = CreateConVar("sm_tvc_filename", "demos/%F %H-%M-%S {mapname}", "Demo save location.");

  // Count the number of clients currently connected to the server.
  for (new client = 1; client <= MaxClients; client++) {
    if (IsClientConnected(client) && !IsFakeClient(client) && IsClientInGame(client)) client_connected[client] = true;
  }

}

public OnPluginEnd() {

  SourceTV_StopRecording();

}

public OnClientPutInServer(client) {

  if (!IsFakeClient(client)) client_connected[client] = true;

}

public OnClientDisconnect_Post(client) {

  client_connected[client] = false;

  if (CountConnectedClients() < 1) {
    SourceTV_StopRecording();
  }

}

stock CountConnectedClients() {

  new result;
  for (new client = 1; client <= MaxClients; client++) (client_connected[client] && result++);
  return result;

}

public OnRoundStart(Handle:event, const String:name[], bool:hide_broadcast) {

  SourceTV_StopRecording();
  if (CountConnectedClients() > 0) SourceTV_StartRecording();

}

stock SourceTV_StartRecording() {

  decl String:format[512];
  GetConVarString(cvar_tvc_filename, format, sizeof(format));

  decl String:filename[PLATFORM_MAX_PATH];
  FormatTime(filename, sizeof(filename), format);

  decl String:mapname[64];
  GetCurrentMap(mapname, sizeof(mapname));

  decl String:timestamp[16];
  IntToString(GetTime(), timestamp, sizeof(timestamp));

  ReplaceString(filename, sizeof(filename), "{timestamp}", timestamp, false);
  ReplaceString(filename, sizeof(filename), "{mapname}", mapname, false);

  ServerCommand("tv_record \"%s\"", filename);

}

stock SourceTV_StopRecording() {

  ServerCommand("tv_stoprecord");

}
