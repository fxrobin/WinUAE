@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86

echo === Starting WinUAE build ===
echo.
"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" "C:\Scripts\WinUAE\od-win32\winuae_msvc15\winuae_msvc.sln" /p:Configuration=Release /p:Platform=Win32 /m /v:minimal
echo.
echo === Build exit code: %ERRORLEVEL% ===
