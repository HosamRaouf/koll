@echo off
setlocal EnableDelayedExpansion

REM Deploy Flutter Web to GitHub Pages with VAPID key from GitHub Secrets
REM Usage: deploy.bat

echo.
echo ================================
echo Retrieving VAPID key...
echo ================================
echo.

REM Try to get VAPID key from GitHub secrets using gh CLI
set "VAPID_KEY="
gh secret get VAPID_KEY --repo HosamRaouf/koll >vapid_temp.txt 2>nul
if %errorlevel% equ 0 (
    set /p VAPID_KEY=<vapid_temp.txt
    del vapid_temp.txt
    echo ✅ Retrieved VAPID key from GitHub secrets
) else (
    del vapid_temp.txt 2>nul
    echo ❌ Could not retrieve VAPID from GitHub secrets
    echo.
    set /p "VAPID_KEY=Please enter VAPID key manually: "
    if "!VAPID_KEY!"=="" (
        echo Error: VAPID key is required
        exit /b 1
    )
)

echo.
echo ================================
echo Building Flutter Web...
echo ================================
echo.

REM Build with VAPID key as compile-time constant
flutter build web --base-href "/koll/" --no-tree-shake-icons --dart-define=FCM_VAPID_KEY=!VAPID_KEY!

if errorlevel 1 (
    echo.
    echo ================================
    echo Build failed!
    echo ================================
    exit /b 1
)

echo.
echo ================================
echo Deploying to GitHub Pages...
echo ================================
echo.

REM Clean up old git repo in build/web
if exist build\web\.git rmdir /s /q build\web\.git

REM Navigate to build directory
cd build\web

REM Create .nojekyll file to prevent Jekyll processing
echo. > .nojekyll

REM Initialize a temporary git repo
git init
git config user.name "GitHub Actions"
git config user.email "actions@github.com"
git remote add origin https://github.com/HosamRaouf/koll.git
git add .
git commit -m "Deploy to GitHub Pages with .nojekyll"

REM Force push to the gh-pages branch
echo.
echo Pushing to GitHub...
git push -f origin HEAD:gh-pages

if errorlevel 1 (
    echo.
    echo ================================
    echo Push failed!
    echo ================================
    cd ..\..
    exit /b 1
)

cd ..\..

echo.
echo ================================
echo Successfully deployed!
echo ================================
echo Your app will be live at: https://HosamRaouf.github.io/koll/
echo Service worker at: https://hosamraouf.github.io/firebase-messaging-sw.js
echo.
echo Note: GitHub Pages may take 5-10 minutes to update
echo.
