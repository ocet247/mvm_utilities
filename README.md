# MvM Utilities
Provides a set of chat commands that help with testing or just completing the mission on local servers.

## Usage instructions
Put this file in `tf/scripts/vscripts/`. After creating a server use `script_execute mvm_utilities`
or paste this command in `tf/cfg/listenserver.cfg` to run it automatically on server creation.

## Command list

### !path
**Usage:** `!path <path_literal: string>` or `!path` to get list of pathes.
Forces the bomb path during the next wave.

### !keeppath or !keep_path
**Usage:** `!keeppath <toggle: 0|1|true|false>` or `!keeppath` to toggle (switch from false to true and viceversa).
Keeps the forced paths through wave completions/losses, has no effect unless `!path` is used.

### !start
**Usage:** `!start`
Starts the next wave without the countdown.

### !restart
**Usage:** `!restart`
Restarts the game (can work either in setup time or during the wave).

### !wave
**Usage:** `!wave <wave_number: integer>`
Jumps to the given wave
> [!WARNING]
> Does not figure out the cash that comes with the corresponding wave and therefore it must be given manually if needed.

### !cash
**Usage:** `!cash <amount: integer>`
Sets the cash for all players to a given amount.

### !keepmap or !keep_map
**Usage:** `!keepmap <toggle: 0|1|true|false>` or `!keepmap` to toggle.
After completing the mission sets the wave to 1 to prevent the game from cycling to another map.

### !oneshot or !one_shot
**Usage:** `!oneshot <toggle: 0|1|true|false>` or `!oneshot` to toggle.
Whether real players can one shot everything they hit, this includes bots, tanks and buildings.
This is not team dependent and solely relies on whether you're a real player or not.
Penetrates through über and other kinds of invulnerabilities.

### !regen
**Usage:** `!regen <toggle: 0|1|true|false>` or `!regen` to toggle.
Whether real players get health and ammo regeneration.
This also restores buff meters and other miscellaneous bars (not all of them though).
This prevents real players from dying as their health will be kept at their max health threshold.
