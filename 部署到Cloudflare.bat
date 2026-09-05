@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo 未找到 Node.js。请先安装：https://nodejs.org/
  pause
  exit /b 1
)
echo [1/5] 安装部署工具...
call npm install
if errorlevel 1 goto :failed
echo [2/5] 登录 Cloudflare...
call npx wrangler login
if errorlevel 1 goto :failed
echo [3/5] 创建云端数据库...
call npx wrangler d1 create rixu-db > d1_result.txt
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "$m=[regex]::Match((Get-Content 'd1_result.txt' -Raw),'database_id[^0-9a-fA-F]+([0-9a-fA-F-]{36})'); if($m.Success){$m.Groups[1].Value}"`) do set "DBID=%%A"
if not defined DBID (
  echo 无法自动读取数据库编号。请打开 d1_result.txt 检查。
  goto :failed
)
powershell -NoProfile -Command "(Get-Content 'wrangler.jsonc' -Raw).Replace('在部署时自动填写','%DBID%') | Set-Content 'wrangler.jsonc' -Encoding utf8"
echo [4/5] 建立数据表并设置密码...
call npx wrangler d1 execute rixu-db --remote --file=schema.sql
if errorlevel 1 goto :failed
echo 请输入日序访问密码，然后按 Enter：
call npx wrangler secret put APP_PASSWORD
if errorlevel 1 goto :failed
echo [5/5] 发布网站...
call npx wrangler deploy
if errorlevel 1 goto :failed
echo.
echo 发布完成。上方 https:// 开头的网址就是手机网址。
pause
exit /b 0
:failed
echo.
echo 部署失败，请把这个窗口的错误截图发给我。
pause
exit /b 1
