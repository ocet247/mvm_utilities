# MvM Utilities
Provides a set of chat commands that help with testing or just completing the mission on local servers.

## Usage instructions
Put `mvm_utilities.nut` in `tf/scripts/vscripts/`. After creating a server enable `sv_cheats` and then use `script_execute mvm_utilities`.
Another way would be to copy `listenserver.cfg` in `tf/cfg/` directory to run the script automatically upon server creation.

## Command list

### !path
**Usage:** `!path <path_literal: string>` or `!path` to get list of pathes.

Forces the bomb path during the next wave.

### !keeppath or !keep_path
**Usage:** `!keeppath <toggle: 0|1|true|false>` or `!keeppath` to toggle (switch from false to true and viceversa).

Keeps the forced paths through wave completions/losses, has no effect unless `!path` is used.

### !start
**Usage:** `!start`.

Starts the next wave without the countdown.

### !restart
**Usage:** `!restart`.

Restarts the current wave (can work either in setup time or during the wave).

### !wave
**Usage:** `!wave <wave_number: integer> <with_clean_cash?: 0|1|false|true = true>`.

Jumps to the given wave.
`with_clean_cash` determines whether all upgrades are reset and cash is set to the maximum achievable one for this wave.

### !cash
**Usage:** `!cash <amount: integer> <is_persistent?: bool = true>`.

Adds the cash for all players to a given amount.
`is_persistent` determines whether cash should persist between wave restarts.

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

## Path picking
Path picking data (e.g. relays) has mainly been copied from the Source Mod plugin [Bomb Path Picker](https://forums.alliedmods.net/showthread.php?p=2788098). It doesn't include all maps that are out right now and it might be incorrect as I didn't check each map manually. This might be improved in the future.
