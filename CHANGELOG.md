# Changelog

## 1.1
- Release

## 1.2
- Print a warning if `tf_mvm_jump_to_wave` is used whilst `sv_cheats` are disabled
- Utilise clean cash parameter for !restart, !wave and !keepmap
- Instead of disabling all features, only disable path picking if map is missing from the list
- Add example listenserver.cfg

## 1.3
- Fix !oneshot causing a server crash when player's sentry damages itself
- Fix wave jumping not giving cash bonus
- Fix !wave `with_clean_cash` having no effect
- Change the way !restart works to also reset upgrades in order to avoid negative cash>
- Switch !cash from setting cash to adding cash. Add `is_persistent` parameter