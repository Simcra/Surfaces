@ECHO OFF
CD "%~dp0"
FOR /F "delims=" %%i IN ('TYPE "src\info.json" ^| "jq.exe" .version') DO SET ver=%%i
FOR /F "delims=" %%G IN ("%ver%") DO SET ver=%%~G
IF NOT EXIST "bin\Surfaces_%ver%" (
	MKDIR "bin\Surfaces_%ver%"
) ELSE (
	CD "bin\Surfaces_%ver%"
	DEL /Q *.*
	CD "..\.."
)
CD "src"
XCOPY /S /V /Q /Y *.* "..\bin\Surfaces_%ver%"
CD "..\bin"
"%~dp0zip.exe" -r -q "Surfaces_%ver%.zip" "Surfaces_%ver%"