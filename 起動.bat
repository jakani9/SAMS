@echo off
chcp 65001 >nul
title 学習塾 入退室管理

cd /d "%~dp0"
set PORT=8765

echo ========================================
echo   学習塾 入退室管理アプリを起動します
echo ========================================
echo.

REM Python コマンドを検出
set PYTHON=
where python >nul 2>&1
if %ERRORLEVEL%==0 set PYTHON=python

if not defined PYTHON (
    where py >nul 2>&1
    if %ERRORLEVEL%==0 set PYTHON=py
)

if not defined PYTHON (
    echo Python が見つかりません。HTML を直接開きます。
    echo カメラが使えない場合は Python をインストールして再度お試しください。
    start "" "%~dp0index.html"
    goto :end
)

REM サーバー起動後にブラウザを開く（バックグラウンドで待機）
start /B powershell -NoProfile -WindowStyle Hidden -Command ^
  "$port=%PORT%; for($i=0; $i -lt 30; $i++) { try { Invoke-WebRequest -Uri \"http://localhost:$port/\" -UseBasicParsing -TimeoutSec 1 | Out-Null; Start-Process \"http://localhost:$port/\"; exit 0 } catch { Start-Sleep -Seconds 1 } }; exit 1"

echo サーバーを起動しています...
echo ブラウザが自動で開きます（http://localhost:%PORT%）
echo.
echo 終了するにはこのウィンドウを閉じてください。
echo.

%PYTHON% -m http.server %PORT%

:end
