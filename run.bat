@ECHO OFF
CD "%~dp0"
FOR /F "delims=" %%i IN ('TYPE "src\info.json" ^| "jq.exe" .version') DO SET ver=%%i
FOR /F "delims=" %%G IN ("%ver%") DO SET ver=%%~G
IF NOT EXIST "bin\Surfaces_%ver%.zip" (
	ECHO "Error: Project must be built, build files could not be found for this version."
) ELSE (
	CD "bin"
	COPY /V /Y "Surfaces_%ver%.zip" "%appdata%\Factorio\mods\Surfaces_%ver%.zip"
	ECHO "Launching Factorio..."
	START "" "steam://rungameid/427520"
)