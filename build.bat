@echo off
REM This script builds the mod for Black Ops 2 Zombies.

pushd "%~dp0"
set GAME_FOLDER=%CODBO2_PATH%
set OAT_BASE=%cd%
set MOD_BASE=%cd%
set MOD_NAME=zm_perks

"%OAT_BASE%\linker.exe" ^
-v ^
--load "%GAME_FOLDER%\zone\all\zm_tomb.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_transit.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_buried.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_highrise.ff" ^
--load "%GAME_FOLDER%\zone\all\so_zencounter_zm_prison.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_prison.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_tomb_patch.ff" ^
--load "%GAME_FOLDER%\zone\all\zm_buried_patch.ff" ^
--load "%GAME_FOLDER%\zone\all\so_zsurvival_zm_transit.ff" ^
--base-folder "%OAT_BASE%" ^
--asset-search-path "%MOD_BASE%" ^
--add-asset-search-path "%MOD_BASE%\mod_thundergun" ^
--add-asset-search-path "%MOD_BASE%\mod_minigun_powerup" ^
--add-asset-search-path "%MOD_BASE%\mod_perk_slot_powerup" ^
--add-asset-search-path "%MOD_BASE%\mod_perks" ^
--source-search-path "%MOD_BASE%\zone_source" ^
--add-source-search-path "%MOD_BASE%\mod_thundergun\zone_source" ^
--add-source-search-path "%MOD_BASE%\mod_minigun_powerup\zone_source" ^
--add-source-search-path "%MOD_BASE%\mod_perk_slot_powerup\zone_source" ^
--add-source-search-path "%MOD_BASE%\mod_perks\zone_source" ^
--output-folder "%MOD_BASE%" mod

if %ERRORLEVEL% NEQ 0 (
    COLOR C
    echo FAIL!
)

popd
pause
