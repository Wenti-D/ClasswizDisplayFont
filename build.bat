@echo off
cd /d %~dp0

set VENV_DIR=%~dp0fontmake_venv
set PYTHON=python

%PYTHON% -c "" >output.log 2>error.log
if %ERRORLEVEL% == 0 goto :check_pip
echo Couldn't launch python.
goto :show_output_error

:check_pip
%PYTHON% -m pip --help >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :create_venv
echo Couldn't find pip.
goto :show_output_error

:create_venv
dir "%VENV_DIR%\Scripts\Python.exe" >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :activate_venv

for /f "delims=" %%i in ('CALL python -c "import sys; print(sys.executable)"') do set PYTHON_FULLPATH="%%i"
echo Creating venv in %VENV_DIR% using python at %PYTHON_FULLPATH%.
%PYTHON% -m venv "%VENV_DIR%" >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :activate_venv
echo Cannot create venv in "%VENV_DIR%".
goto :show_output_error

:activate_venv
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
echo venv %VENV_DIR%.

:detect_fontmake
fontmake -h >>output.log 2>>error.log
if %ERRORLEVEL% == 0 (
    echo Detected fontmake.
    goto :clean_output_folder
) else (
    echo No fontmake installed.
)

:install_fontmake
echo Configuring fontmake...
%PYTHON% -m pip install --upgrade pip >>output.log 2>>error.log
%PYTHON% -m pip install -r requirements.txt >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :clean_output_folder
echo An error occured when installing requirements.
goto :show_output_error

:clean_output_folder
set OUTPUT_DIR=output
rd /s /q %OUTPUT_DIR% >>output.log 2>>error.log
if %ERRORLEVEL% neq 0 (
    if %ERRORLEVEL% neq 2 (
        goto :show_output_error
    )
)

:build_font_x
set FONT_NAME=ClassWizXDisplay-Regular
echo Building font X Display into "%OUTPUT_DIR%" folder...
fontmake -u %FONT_NAME%.ufo --output-dir %OUTPUT_DIR% >>output.log 2>>error.log
if %ERRORLEVEL% neq 0 goto :show_output_error
%PYTHON% -c "from fontTools.ttLib.woff2 import compress; compress('%OUTPUT_DIR%/%FONT_NAME%.otf', '%OUTPUT_DIR%/%FONT_NAME%.woff2')" >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :build_font_cw

:build_font_cw
set FONT_NAME=ClassWizCWDisplay-Regular
echo Building font CW Display into "%OUTPUT_DIR%" folder...
fontmake -u %FONT_NAME%.ufo --output-dir %OUTPUT_DIR% >>output.log 2>>error.log
if %ERRORLEVEL% neq 0 goto :show_output_error
%PYTHON% -c "from fontTools.ttLib.woff2 import compress; compress('%OUTPUT_DIR%/%FONT_NAME%.otf', '%OUTPUT_DIR%/%FONT_NAME%.woff2')" >>output.log 2>>error.log
if %ERRORLEVEL% == 0 goto :end_success

:show_output_error
set prev_err_lvl=%ERRORLEVEL%
for /f %%f in ("output.log") do set size=%%~zf
if %size% equ 0 goto :show_error
echo.
echo ########################################
echo # output.log:
echo ########################################
echo.
type output.log
echo.

:show_error
for /f %%f in ("error.log") do set size=%%~zf
if %size% equ 0 goto :end_failed
echo.
echo ########################################
echo # error.log:
echo ########################################
echo.
type error.log
echo.

echo !!!
echo Failed due to an error, please refer to error.log above or file.
echo Exit code: %prev_err_lvl%.
goto :end

:end_failed_no_error
echo !!!
echo Failed due to an error.
echo Exit code: %prev_err_lvl%.
goto :end

:end_success
echo.
echo Done.

:end
pause
exit /b %ERRORLEVEL%
