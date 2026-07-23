// Default values can be changed

/**
 * Whether to preserve picked path after new wave / wave fails
 * Only works after picking the path, otherwise does nothing
 * @type {bool}
 */
local KeepPath = true;

/**
 * Whether real players can one shot everything they hit, this
 * includes bots, tanks and buildings. This is not team dependent
 * and solely relies on whether you're a real player or not
 * Penetrates uber and other kinds of invulnerabilities
 * @type {bool}
 */
local OneShot = false;

/**
 * Whether real players get health and ammo regeneration
 * This also restores buff meters and other miscellaneous bars
 * This prevents real players from dying as their health will
 * be kept at their max health threshold
 * @type {bool}
 */
local Regen = false;

/**
 * Whether to keep the map after completing the mission.
 * After finishing the mission starts at wave 1
 * @type {bool}
 */
local KeepMap = true;


// Internals
const HUD_PRINTTALK = 3;
const ID_BEGGARS_BAZOOKA = 730;
const GR_STATE_PREROUND = 3;

/** @const */
local MAX_CLIENTS = MaxClients().tointeger();

/** @const */
local OBJECTIVE_RESOURCE = Entities.FindByClassname(null, "tf_objective_resource");

local Maps = {};

Maps.mvm_coaltown <- {
    paths = {
        left = ["bombpath_left_relay"],
        high_left = ["bombpath_high_left_relay"],
        right = ["bombpath_right_relay"],
        high_right = ["bombpath_high_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_holograms_clear_relay"]
};
// Same relay layout as mvm_coaltown
Maps.mvm_ghost_town <- Maps.mvm_coaltown;
// Same relay layout as mvm_coaltown
Maps.mvm_bigrock <- Maps.mvm_coaltown;

Maps.mvm_decoy <- {
    paths = {
        left = ["bombpath_left_relay"],
        high_left = ["bombpath_high_left_relay"],
        right = ["bombpath_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_rottenburg <- {
    paths = {
        left = ["bombpath_left"],
        right = ["bombpath_right"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_mannworks <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_relay"],
    }
    path_clear = ["bombpath_navavoid*,Enable", "bombpath_arrows_clear_relay"]
}

// Mannhattan has no Reset/Random entities in the source config.
Maps.mvm_mannhattan <- {
    paths = {
        "3ways": ["holograms_3way_relay"],
        centerpath = ["holograms_centerpath_relay"],
    }
    // path_clear intentionally omitted (none defined)
}

// CUSTOM MAPS

// Note: source VDF has Left/Right swapped relative to relay names
Maps.mvm_barren <- {
    paths = {
        left = ["bombpath_right_relay"],
        right = ["bombpath_left_relay"],
        hatch_center = ["bombpath_center_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// Doppler: unusually complex, spawn-set based rather than simple left/right.
// Reset targets doors + wildcard path disable; each "path" fires several relays.
Maps.mvm_doppler <- {
    paths = {
        first_a_spawn_set = ["spawnbot_g2s*,Enable", "spawnbot_g2s0a,Disable", "spawnbot_g2s1b,Disable"],
        first_b_spawn_set = ["spawnbot_g2s*,Enable", "spawnbot_g2s1a,Disable", "spawnbot_g2s0b,Disable"],
        second_a_spawn_set = ["spawnbot_g1s*,Enable", "spawnbot_g1s0a,Disable", "spawnbot_g1s1b,Disable"],
        second_b_spawn_set = ["spawnbot_g1s*,Enable", "spawnbot_g1s1a,Disable", "spawnbot_g1s0b,Disable"],
        third_cave_topside_a_set = ["spawnbot_g0s1b,Enable", "spawnbot_g0s2a,Enable", "spawnbot_g0s1_alt,Enable", "spawnbot_g0s2_alt,Enable", "gate0s0_entrance_door,Close", "path_g0_s1,Enable", "path_g0_s2,Enable"],
        third_cave_topside_b_set = ["spawnbot_g0s1a,Enable", "spawnbot_g0s2b,Enable", "spawnbot_g0s1_alt,Enable", "spawnbot_g0s2_alt,Enable", "gate0s0_entrance_door,Close", "path_g0_s1,Enable", "path_g0_s2,Enable"],
        third_cave_top_a_set = ["spawnbot_g0s2a,Enable", "spawnbot_g0s0b,Enable", "spawnbot_g0s0_alt,Enable", "spawnbot_g0s2_alt,Enable", "gate0s1_entrance_door,Close", "path_g0_s0,Enable", "path_g0_s2,Enable"],
        third_cave_top_b_set = ["spawnbot_g0s2b,Enable", "spawnbot_g0s0a,Enable", "spawnbot_g0s0_alt,Enable", "spawnbot_g0s2_alt,Enable", "gate0s1_entrance_door,Close", "path_g0_s0,Enable", "path_g0_s2,Enable"],
        third_tops_a_set = ["spawnbot_g0s0b,Enable", "spawnbot_g0s1a,Enable", "spawnbot_g0s0_alt,Enable", "spawnbot_g0s1_alt,Enable", "gate0s2_entrance_door,Close", "path_g0_s0,Enable", "path_g0_s1,Enable"],
        third_tops_b_set = ["spawnbot_g0s0a,Enable", "spawnbot_g0s1b,Enable", "spawnbot_g0s0_alt,Enable", "spawnbot_g0s1_alt,Enable", "gate0s2_entrance_door,Close", "path_g0_s0,Enable", "path_g0_s1,Enable"],
    }
    path_clear = ["gate0s0_entrance_door,Open", "gate0s1_entrance_door,Open", "gate0s2_entrance_door,Open", "path_g0_*,Disable"]
}

// Note: source VDF has Left/Right swapped relative to relay names
Maps.mvm_downpour <- {
    paths = {
        left = ["bombpath_choose_right_relay", "bombpath_arrows_right_relay"],
        right = ["bombpath_choose_left_relay", "bombpath_arrows_left_relay"],
    }
    path_clear = ["bombpath_arrows_clear_relay", "bombpath_clear_relay"]
}
// Same relay layout as mvm_downpour
Maps.mvm_deathpour <- Maps.mvm_downpour;

// Note: source VDF has Left/Right swapped relative to relay names
Maps.mvm_powerplant <- {
    paths = {
        left_right = ["bombpath_right_left"],
        right_left = ["bombpath_left_right"],
        right_centre = ["bombpath_left_middle"],
        right_right = ["bombpath_left_left"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// Note: source VDF has Left/Right swapped relative to relay names
Maps.mvm_shiverpeak <- {
    paths = {
        left_straight = ["bombpath_right_straight_relay"],
        right_straight = ["bombpath_left_straight_relay"],
        left_zigzag = ["bombpath_right_zz_relay"],
        right_zigzag = ["bombpath_left_zz_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_hologram_clear_relay"]
}

// Note: source VDF has Mid-left/Mid-right swapped relative to relay names
Maps.mvm_snowpine <- {
    paths = {
        mid_left = ["bombpath_right_relay"],
        mid_right = ["bombpath_left_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_waterfront <- {
    paths = {
        left = ["bombpath_left"],
        right = ["bombpath_right"],
    }
    path_clear = ["bombpath_arrows_clear_relay", "bombpath_clearall_relay"]
}

Maps.mvm_teien <- {
    paths = {
        hatch_left = ["bombpath_right_relay"],
        hatch_right = ["bombpath_left_relay"],
        hatch_center = ["bombpath_center_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_whitecliff <- {
    paths = {
        left = ["bombpath_a"],
        right = ["bombpath_b"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_waterlogged <- {
    paths = {
        mid_left = ["bombpath_right2_relay"],
        mid_center = ["bombpath_right_relay"],
        mid_right = ["bombpath_left_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_cyberia <- {
    paths = {
        hatch_left = ["bombpath_right_upper_relay"],
        hatch_right = ["bombpath_left_upper_relay"],
        hatch_center = ["bombpath_center_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_dockyard <- {
    paths = {
        hatch_left = ["bombpath_path2_relay"],
        hatch_right = ["bombpath_path1_relay"],
    }
    path_clear = ["bombpath_clearmarkers_relay", "bombpath_clear_blockers_relay"]
}

Maps.mvm_hideout <- {
    paths = {
        left = ["bombpath_flank_relay"],
        right = ["bombpath_main_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_isolation <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_upper_relay"],
        center = ["bombpath_center_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// "Up-left" means "Up then left"
Maps.mvm_quetzal <- {
    paths = {
        up_left = ["bombpath_upper_hatch_right_relay"],
        up_right = ["bombpath_upper_hatch_left_relay"],
        left_right = ["bombpath_right_hatch_left_relay"],
        left_left = ["bombpath_right_hatch_right_relay"],
        center_right = ["bombpath_center_hatch_left_relay"],
        center_left = ["bombpath_center_hatch_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_spacepost <- {
    paths = {
        left_up = ["bombpath_upper_left_relay"],
        left_low = ["bombpath_lower_left_relay"],
        right_up = ["bombpath_upper_right_relay"],
        right_low = ["bombpath_lower_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_steep <- {
    paths = {
        cave = ["bombpath_cave_relay"],
        hill = ["bombpath_hill_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// No relay resets bomb arrows on this map
Maps.mvm_swirl <- {
    paths = {
        low = ["wave_prepare_relay_lower"],
        up = ["wave_prepare_relay_upper"],
    }
    path_clear = ["wave_init_relay"]
}

Maps.mvm_tensai <- {
    paths = {
        left = ["bombpath_plaza_relay"],
        right = ["bombpath_street_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_underground <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_holograms_clear_relay"]
}
// Same relay layout as mvm_underground
Maps.mvm_underworld <- Maps.mvm_underground;

Maps.mvm_butcher <- {
    paths = {
        left = ["bombpath_left_upper_relay"],
        right = ["bombpath_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_calico <- {
    paths = {
        left_low = ["bombpath_left_low_relay"],
        left_up = ["bombpath_left_up_relay"],
        right_low = ["bombpath_right_low_relay"],
        right_up = ["bombpath_right_up_relay"],
    }
    path_clear = ["bombpath_clear_relay"]
}

Maps.mvm_casino_city <- {
    paths = {
        left_low = ["bombpath_left_lower_relay"],
        left_up = ["bombpath_left_upper_relay"],
        right_low = ["bombpath_right_lower_relay"],
        right_up = ["bombpath_right_upper_relay"],
    }
    path_clear = ["relay_bombpath_arrows_clear", "relay_bombpath_nav_clearall"]
}

Maps.mvm_cliffside <- {
    paths = {
        left = ["bombpath_left"],
        right = ["bombpath_right"],
    }
    path_clear = ["bombpath_clear"]
}
// Same relay layout as mvm_cliffside
Maps.mvm_creepside <- Maps.mvm_cliffside;

Maps.mvm_coastrock <- {
    paths = {
        left = ["bombpath_left"],
        right = ["bombpath_right"],
    }
    path_clear = ["bombpath_arrows_clear_relay", "bombpath_clearall_relay"]
}
// Same relay layout as mvm_coastrock
Maps.mvm_meltdown <- Maps.mvm_coastrock;
// Same relay layout as mvm_coastrock
Maps.mvm_metro <- Maps.mvm_coastrock;

// Note: source VDF has Left/Right and Far-left/Far-right swapped relative to relay names
Maps.mvm_downtown <- {
    paths = {
        left = ["right_relay"],
        right = ["left_relay"],
        far_left = ["farright_relay"],
        far_right = ["farleft_relay"],
    }
    path_clear = ["bombpath_purge", "farleft_hologram,Disable", "left_hologram,Disable", "right_hologram,Disable", "farright_hologram,Disable"]
}

// Hanami: three gates (front/mid/back), each path fires one relay per gate.
// Only the 8 combos listed in the source are included; more are possible.
Maps.mvm_hanami <- {
    paths = {
        right_right_right = ["bombpath_frontright_relay", "bombpath_midright_relay", "bombpath_backright_relay"],
        right_left_right = ["bombpath_frontright_relay", "bombpath_midleft_relay", "bombpath_backright_relay"],
        right_right_left = ["bombpath_frontright_relay", "bombpath_midright_relay", "bombpath_backleft_relay"],
        right_left_left = ["bombpath_frontright_relay", "bombpath_midleft_relay", "bombpath_backleft_relay"],
        left_left_left = ["bombpath_frontleft_relay", "bombpath_midleft_relay", "bombpath_backleft_relay"],
        left_right_left = ["bombpath_frontleft_relay", "bombpath_midright_relay", "bombpath_backleft_relay"],
        left_left_right = ["bombpath_frontleft_relay", "bombpath_midleft_relay", "bombpath_backright_relay"],
        left_right_right = ["bombpath_frontleft_relay", "bombpath_midright_relay", "bombpath_backright_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_havana <- {
    paths = {
        path_1 = ["bombpath_1_relay"],
        path_2 = ["bombpath_2_relay"],
        path_1_up = ["bombpath_1_upper_relay"],
        path_2_up = ["bombpath_2_upper_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_nox <- {
    paths = {
        left = ["bombpath_left"],
        right = ["bombpath_right"],
    }
    path_clear = ["bombpath_hologram_clear"]
}

Maps.mvm_outlands <- {
    paths = {
        left_left = ["path_leftleft_relay"],
        left_right = ["path_leftright_relay"],
        right_right = ["path_rightright_relay"],
        right_left = ["path_rightleft_relay"],
    }
    path_clear = ["path_clearall_relay"]
}

Maps.mvm_oxidize <- {
    paths = {
        path_1 = ["activate_route_1"],
        path_2 = ["activate_route_2"],
    }
    // path_clear intentionally omitted (none defined)
}

Maps.mvm_production <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_relay"],
        left_mid = ["bombpath_mid_left_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// Shared left/right layout: Akure, Autumnull, Brugge, Boogge, Bloodlust,
// Dusk, Maple Hill, Null, Oilrig, Sharp, Shank
Maps.mvm_akure <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}
Maps.mvm_autumnull <- Maps.mvm_akure;
Maps.mvm_brugge <- Maps.mvm_akure;
Maps.mvm_boogge <- Maps.mvm_akure;
Maps.mvm_bloodlust <- Maps.mvm_akure;
Maps.mvm_dusk <- Maps.mvm_akure;
Maps.mvm_maplehill <- Maps.mvm_akure;
Maps.mvm_null <- Maps.mvm_akure;
Maps.mvm_oilrig <- Maps.mvm_akure;
Maps.mvm_sharp <- Maps.mvm_akure;
Maps.mvm_shank <- Maps.mvm_akure;

Maps.mvm_derelict <- {
    paths = {
        left_center = ["bombpath_centerleft_relay"],
        left_up = ["bombpath_upperleft_relay"],
        right_center = ["bombpath_centerright_relay"],
        right_up = ["bombpath_upperright_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_hologram_clear"]
}
// Same relay layout as mvm_derelict
Maps.mvm_terrorlict <- Maps.mvm_derelict;

Maps.mvm_heatrock <- {
    paths = {
        left = ["bombpath_left_relay"],
        right = ["bombpath_right_relay"],
        high_left = ["bombpath_high_left_relay"],
        high_right = ["bombpath_high_right_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_holograms_clear_relay"]
}

Maps.mvm_kelly <- {
    paths = {
        left = ["bombpath_left_relay"],
        left_up = ["bombpath_left_upper_relay"],
        right = ["bombpath_right_relay"],
        right_up = ["bombpath_right_upper_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

// Legerdemain: two zones (forest/town), each path fires one relay per zone.
Maps.mvm_legerdemain <- {
    paths = {
        left = ["bombpath_activate_forest_left", "bombpath_activate_town_left"],
        right = ["bombpath_activate_town_right", "bombpath_activate_forest_right"],
        left_mid = ["bombpath_activate_town_middle", "bombpath_activate_forest_left"],
        right_mid = ["bombpath_activate_town_middle", "bombpath_activate_forest_right"],
        left_right = ["bombpath_activate_forest_left", "bombpath_activate_town_right"],
        right_left = ["bombpath_activate_town_left", "bombpath_activate_forest_right"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_arrows_clear_relay"]
}

Maps.mvm_redstone_ridge <- {
    paths = {
        path_1 = ["bombpath_1_relay"],
        path_2 = ["bombpath_2_relay"],
        path_4 = ["bombpath_4_relay"],
        path_6 = ["bombpath_6_relay"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_holograms_clear_relay"]
}

Maps.mvm_skullcove <- {
    paths = {
        left = ["bombpath_relay_left"],
        right = ["bombpath_relay_right"],
        left_flank = ["bombpath_relay_left_flank"],
        right_flank = ["bombpath_relay_right_flank"],
    }
    path_clear = ["bombpath_clearall_relay", "bombpath_holograms_clear_relay"]
}

Maps.mvm_thematic <- {
    paths = {
        left = ["bombpath_choose_left"],
        left_high = ["bombpath_choose_high_left"],
        right = ["bombpath_choose_right"],
    }
    // path_clear intentionally omitted (none defined)
}
// Same relay layout as mvm_thematic
Maps.mvm_traumatic <- Maps.mvm_thematic;

Maps.mvm_wizardry <- {
    paths = {
        right = ["set_path_side_right"],
        left = ["set_path_side_left"],
        center_right = ["set_path_center_right"],
        center_left = ["set_path_center_left"],
    }
    // path_clear intentionally omitted (none defined)
}

Maps.mvm_yucatan <- {
    paths = {
        left_1 = ["relay_block_left_1"],
        left_2 = ["relay_pyr_left"],
        right_1 = ["relay_block_right_1"],
        right_2 = ["relay_pyr_right"],
    }
    path_clear = ["bombpath_clearall"]
}


local function dummy_ent() {
	local dummy = Entities.CreateByClassname("logic_relay");
	NetProps.SetPropBool(dummy, "m_bForcePurgeFixedupStrings", true);
	dummy.ValidateScriptScope();
    return dummy;
}

local function RunWithDelay(func, delay = 0.0) {
    local relay = dummy_ent();
	relay.GetScriptScope()["Run"] <- function[this]() {
		relay.Kill();
		func();
	}

	EntFireByHandle(relay, "CallScriptFunction", "Run", delay, null, null);
	return relay;
}

local function Print(text) {
    ClientPrint(null,HUD_PRINTTALK,"\x04[MvM Utilities] \x01" + text);
}

local map_name = function() {
    local raw_name = GetMapName();

    if (!startswith(raw_name, "workshop/")) {
        return raw_name;
    }

    for (local i = raw_name.len() - 1; i > 9; i--) {
        if (raw_name[i] == '.') {
           // workshop/ 9 chars
           return raw_name.slice(9, i);
        }
    }

    throw "Unreachable";
}();

if (!startswith(map_name, "mvm")) {
    Print("Current map is not MvM");
    return;
}

/** @type {table} */
local MapData = function() {
    if (map_name in Maps) {
        print("Exact match");
        return Maps[map_name];
    }

    foreach (name, data in Maps) {
        if (startswith(map_name, name)) {
            print("Prefix match");
            return data;
        }
    }

    Print("Current map is not available");
    // To find stuff for new maps
    printl(map_name);
    for (local ent; ent = Entities.FindByClassname(ent, "logic_relay"); ) {
        printl(ent);
    }

    return null;
}();

if (!MapData) {
    return;
}

/** @type {string|null} */
local LastPath = null;
local RegenEnt = null;

local function SetPath() {
    local function TriggerLoop(arr, delay) {
        foreach (component in arr) {
            local parts = split(component, ",", false);
            local target = parts[0];
            local action = parts.len() == 1 ? "Trigger" : parts[1];
            EntFire(target, action, "", delay);
        }
    }

    if ("path_clear" in MapData) {
        TriggerLoop(MapData.path_clear, 0.0);
        TriggerLoop(MapData.paths[LastPath], 0.2);
    } else {
        TriggerLoop(MapData.paths[LastPath], 0.0);
    }
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandlePathCommand(arguments) {
    if (!("paths" in MapData)) {
        Print("Current map does not support path picking");
        return;
    }

    if (arguments.len() == 0) {
        local available_paths = MapData.paths.keys().reduce(@(pre, current) pre + "\n" + current, "");
        Print("Usage: !path <path_literal: string>\nAvailable paths: " + available_paths);
        return;
    }

    if (!(arguments[0] in MapData.paths)) {
        local available_paths = MapData.paths.keys().reduce(@(pre, current) pre + "\n" + current, "");
        Print(format("Unknown path: '%s'\nAvailable paths: %s", arguments[0], available_paths));
        return;
    }

    LastPath = arguments[0];
    SetPath();
    Print(format("Path '%s' has been activated", LastPath));
}


/**
 * @type {function}
 * @param {[string]} _arguments
 */
local function HandleStartCommand(_arguments) {
    if (!IsQuickBuildTime()) {
        Print("The wave has already started");
        return;
    }

    SendToConsole("mp_restartgame_immediate 1");
}

/**
 * @type {function}
 * @param {[string]} _arguments
 */
local function HandleRestartCommand(_arguments) {
    local current_wave = NetProps.GetPropInt(OBJECTIVE_RESOURCE, "m_nMannVsMachineWaveCount");
    SendToConsole("tf_mvm_jump_to_wave " + current_wave);
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleWaveCommand(arguments) {
    if (arguments.len() == 0) {
        Print("Usage: !wave <wave_number: integer>")
        return;
    }

    local wave;
    try {
        wave = arguments[0].tointeger();
    } catch (e) {
        Print("Received a non-integer argument");
        return;
    }

    local max_wave = NetProps.GetPropInt(OBJECTIVE_RESOURCE, "m_nMannVsMachineMaxWaveCount");
    if (wave > max_wave) {
        Print(format("Wave '%d' exceed the possible number of waves ('%d')", wave, max_wave));
        return;
    }

    SendToConsole("tf_mvm_jump_to_wave " + wave);
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleCashCommand(arguments) {
    if (arguments.len() == 0) {
        Print("Usage: !cash <cash_amount: integer>")
        return;
    }

    local cash;
    try {
        cash = arguments[0].tointeger();
    } catch (e) {
        Print("Received a non-integer argument");
        return;
    }

    for (local i = 1; i < MAX_CLIENTS; i++) {
        local player = PlayerInstanceFromIndex(i);
        if (!player || player instanceof CTFBot) {
            continue;
        }

        NetProps.SetPropInt(player, "m_nCurrency", cash);
    }
}

local function toggle_switch(argument) {
    switch (argument) {
    case "1":
    case "true":
        return true
    case "0":
    case "false":
        return false;
    default:
        Print("Unknown toggle argument, valid options are: 0|1|false|true")
        return null;
    }
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleKeepMapCommand(arguments) {
    if (arguments.len() == 0) {
        KeepMap = !KeepMap;
        Print("KeepMap toggled to: " + KeepMap);
        return;
    }

    local new = toggle_switch(arguments[0]);
    if (new == null) {
        return;
    }

    KeepMap = new;
    Print("KeepMap set to: " + KeepMap);
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleKeepPathCommand(arguments) {
    if (!("paths" in MapData)) {
        Print("Current map does not support path picking");
        return;
    }

    if (arguments.len() == 0) {
        KeepPath = !KeepPath;
        Print("KeepPath toggled to: " + KeepPath);
    } else {
        local new = toggle_switch(arguments[0]);
        if (new == null) {
            return;
        }

        KeepPath = new;
        Print("KeepPath set to: " + KeepPath);
    }

    if (KeepPath) {
        if (LastPath) {
            SetPath();
        } else {
            Print("Note: the path was not selected")
        }
    }
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleOneShotCommand(arguments) {
    if (arguments.len() == 0) {
        OneShot = !OneShot;
        Print("OneShot toggled to: " + OneShot);
        return;
    }

    local new = toggle_switch(arguments[0]);
    if (new == null) {
        return;
    }

    OneShot = new;
    Print("OneShot set to: " + OneShot);
}

/**
 * @type {function}
 * @param {[string]} arguments
 */
local function HandleRegenCommand(arguments) {
    if (arguments.len() == 0) {
        Regen = !Regen;
        Print("Regen toggled to: " + Regen);
    } else {
        local new = toggle_switch(arguments[0]);
        if (new == null) {
            return;
        }

        Regen = new;
        Print("Regen set to: " + Regen);
    }

    if (!Regen) {
        if (RegenEnt && RegenEnt.IsValid()) {
            RegenEnt.Kill();
        }
        return;
    }

    for (local i = 1; i < MAX_CLIENTS; i++) {
        local player = PlayerInstanceFromIndex(i);
        if (!player || player instanceof CTFBot) {
            continue;
        }

        player.Regenerate(true);
    }

    RegenEnt = dummy_ent();
    // To prevent deletion on round restart
    NetProps.SetPropString(RegenEnt, "m_iClassname", "worldspawn");
    RegenEnt.GetScriptScope().Think <- function() {
        for (local i = 1; i < MAX_CLIENTS; i++) {
            local player = PlayerInstanceFromIndex(i);
            if (!player || player instanceof CTFBot) {
                continue;
            }

            local weapon = player.GetActiveWeapon();
            if (!weapon) {
                continue;
            }

            if (NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") != ID_BEGGARS_BAZOOKA) {
                weapon.SetClip1(99);
            }

            for (local i = 0; i < 9; i++) {
                NetProps.SetPropInt(player, "m_iAmmo.00" + i, 999)
            }

            NetProps.SetPropFloat(weapon, "m_flEnergy", 100.0);
            player.SetRageMeter(100.0);
            player.SetSpyCloakMeter(100.0);
            player.SetScoutHypeMeter(100.0);
        }

        return -1;
    }

    AddThinkToEnt(RegenEnt, "Think");
}

// if (KeepPath) {
//     HandleKeepPathCommand(["true"]);
// }

// if (OneShot) {
//     HandleOneShotCommand(["true"]);
// }

// if (Regen) {
//     HandleRegenCommand(["true"]);
// }

// if (KeepMap) {
//     HandleKeepMapCommand(["true"]);
// }

local commands_map = {
    "path": HandlePathCommand,
    "start": HandleStartCommand,
    "restart": HandleRestartCommand,
    "wave": HandleWaveCommand,
    "cash": HandleCashCommand,
    "keepmap": HandleKeepMapCommand,
    "keep_map": HandleKeepMapCommand,
    "keeppath": HandleKeepPathCommand,
    "keep_path": HandleKeepPathCommand,
    "oneshot": HandleOneShotCommand,
    "one_shot": HandleOneShotCommand,
    "regen": HandleRegenCommand,
};

__CollectGameEventCallbacks(::MvMUtilitiesEvents <- {
    function OnGameEvent_player_say(params) {
        /** @type {string} */
        local text = params.text;
        if (!startswith(text, "!")) {
            return;
        }

        local parts = split(text.slice(1).tolower(), " ", true);
        if (parts.len() == 0) {
            return;
        }

        local command = parts[0];
        if (command in commands_map) {
            /** @type {@(arguments: [string])} */
            local callback = commands_map[command];
            local arguments = parts.slice(1);
            callback(arguments);
        }
    }

    function OnGameEvent_recalculate_holidays(_params) {
        if (GetRoundState() != GR_STATE_PREROUND) {
            return;
        }

        if (KeepPath && LastPath != null) {
            RunWithDelay(SetPath, 1.0);
        }
    }

    function OnGameEvent_mvm_wave_complete(_params) {
        if (KeepPath && LastPath != null) {
            RunWithDelay(SetPath, 6.0);
        }
    }

    function OnScriptHook_OnTakeDamage(params) {
        if (!OneShot) {
            return;
        }

        if (params.const_entity == params.attacker || params.attacker == null) {
            return;
        }

        if (params.attacker instanceof CTFPlayer && !(params.attacker instanceof CTFBot)) {
            params.const_entity.SetHealth(0);
            // Needed for buildings (perhaps for something else too)
            params.const_entity.AcceptInput("SetHealth", "0", null, null);
        }
    }

    function OnGameEvent_player_hurt(params) {
        if (!Regen) {
            return;
        }

        local player = GetPlayerFromUserID(params.userid);

        if (player instanceof CTFBot) {
            return;
        }

        local health = player.GetHealth();
        local max_health = player.GetMaxHealth();

        if (health < max_health) {
            player.SetHealth(max_health);
        }
    }

    function OnGameEvent_mvm_mission_complete(_params) {
        if (!KeepMap) {
            return;
        }

        RunWithDelay(@() SendToConsole("tf_mvm_jump_to_wave 1"), 15);
    }
});
