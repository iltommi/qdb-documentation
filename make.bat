
@ECHO OFF

setlocal enabledelayedexpansion

set TARGET=%1
set BUILDDIR=build

if "%TARGET%" == "" goto help

if "%TARGET%" == "help" (
	:help
	echo.Please use `make ^<target^>` where ^<target^> is one of
	echo.  html       to make standalone HTML files
	echo.  dirhtml    to make HTML files named index.html in directories
	echo.  singlehtml to make a single large HTML file
	echo.  pickle     to make pickle files
	echo.  json       to make JSON files
	echo.  htmlhelp   to make HTML files and a HTML help project
	echo.  qthelp     to make HTML files and a qthelp project
	echo.  devhelp    to make HTML files and a Devhelp project
	echo.  epub       to make an epub
	echo.  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter
	echo.  text       to make text files
	echo.  man        to make manual pages
	echo.  changes    to make an overview over all changed/added/deprecated items
	echo.  linkcheck  to check all external links for integrity
	echo.  doctest    to run all doctests embedded in the documentation if enabled
	goto end
)

REM - Targets where we need to version-switch.
if "%TARGET%" == "html" (goto build_htmllike)
if "%TARGET%" == "dirhtml" (goto build_htmllike)
if "%TARGET%" == "singlehtml" (goto build_htmllike)

REM - Targets where we do not need to version-switch.
if "%TARGET%" == "pickle" (goto build_booklike)
if "%TARGET%" == "json" (goto build_booklike)
if "%TARGET%" == "htmlhelp" (goto build_booklike)
if "%TARGET%" == "qthelp" (goto build_booklike)
if "%TARGET%" == "devhelp" (goto build_booklike)
if "%TARGET%" == "epub" (goto build_booklike)
if "%TARGET%" == "latex" (goto build_booklike)
if "%TARGET%" == "text" (goto build_booklike)
if "%TARGET%" == "man" (goto build_booklike)
if "%TARGET%" == "changes" (goto build_booklike)
if "%TARGET%" == "linkcheck" (goto build_booklike)
if "%TARGET%" == "doctest" (goto build_booklike)


if "%TARGET%" == "clean" (
	:clean
	for /d %%i in (%BUILDDIR%\*) do rmdir /q /s %%i
	del /q /s %BUILDDIR%\*

	REM Clean each directory conforming to source\N.N*, where N is a number.
	for /f "tokens=*" %%V in ('dir source\* /b /ad ^| findstr /i "^[0-9]\.[0-9]*"') do (
		pushd "source\%%V"
		make.bat clean
		if errorlevel 1 exit /b 1
		popd
	)

	goto end
)


:build_htmllike
REM - A target where we need to inject version switching on the fly.

mkdir %BUILDDIR%\%TARGET%

set GIT_FOUND=0
where /q git
if ERRORLEVEL 0 ( set GIT_FOUND=1 )

REM Build each directory conforming to source\N.N*, where N is a number.
for /f "tokens=*" %%V in ('dir source\* /b /ad ^| findstr /i "^[0-9]\.[0-9]*"') do (
	echo ##teamcity[blockOpened name='Build %%V']

	wscript find_and_replace_in_file.js "source\%%V\source\conf.py" "html_static_path = .*" "html_static_path = ['../../shared/_static']"
	wscript find_and_replace_in_file.js "source\%%V\source\conf.py" "templates_path = .*" "templates_path = ['../../shared/_templates']"

	pushd "source\%%V"
	call make.bat %TARGET% || exit /b 1
	popd

	mkdir "%BUILDDIR%\%TARGET%\%%V"
	xcopy /Y /E source\%%V\build\%TARGET%\* %BUILDDIR%\%TARGET%\%%V

	if "%GIT_FOUND%" == "1" ( git -C "source\%%V" checkout -- source\conf.py )

	set last_built_ver=%%V

	echo ##teamcity[blockClosed name='Build %%V']
)

copy source\index.html %BUILDDIR%\%TARGET%\index.html

REM Find / Replace the url in the redirect file with the latest built number.
wscript find_and_replace_in_file.js "%BUILDDIR%\%TARGET%\index.html" "https://doc.quasardb.net/1.1.0/" "https://doc.quasardb.net/%last_built_ver%/"

echo.
echo.Build finished. The HTML pages are in %BUILDDIR%/%TARGET%/VERSION.
goto end


:build_booklike
REM - A target without version switching.

mkdir %BUILDDIR%\%TARGET%

REM Build each directory conforming to source\N.N*, where N is a number.
for /f "tokens=*" %%V in ('dir source\* /b /ad ^| findstr /i "^[0-9]\.[0-9]*"') do (
	echo ##teamcity[blockOpened name='Build %%V']

	pushd "source\%%V"
	make.bat %TARGET% || exit /b 1
	popd

	mkdir "%BUILDDIR%\%TARGET%\%%V"
	xcopy /Y /E source\%%V\build\%TARGET%\* %BUILDDIR%\%TARGET%\%%V

	echo ##teamcity[blockClosed name='Build %%V']
)

echo.
echo.Build finished. The HTML pages are in %BUILDDIR%/%TARGET%/VERSION.
goto end


:end
endlocal
