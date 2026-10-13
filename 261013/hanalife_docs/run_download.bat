@echo off
chcp 65001 > nul
cd /d "%~dp0"
echo [1/3] Python 패키지 설치
python -m pip install -r requirements.txt
echo [2/3] 크롬(Playwright) 브라우저 설치
python -m playwright install chromium
echo [3/3] 하나생명 기초서류 다운로드 시작
python hanalife_download.py %*
pause
