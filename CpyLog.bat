set ANMDate=2024-06-01

for /f "skip=1 delims=" %%x in ('wmic os get localdatetime') do if not defined X set X=%%x
set yyyymmdd=%X:~0,8%

set name=_LogFile
set output=C:\%name%\%name%%yyyymmdd%
set evtx=%output%\Evtx
set vigor=%output%\Log\vigor
set svad=%output%\Log\svad

del %output% /q /s
del %output%.zip /q /s

md %evtx%
wevtutil.exe epl application %evtx%\app.evtx /ow:True /q:"*[System[TimeCreated[@SystemTime >= '%ANMDate%T00:00:00']]]"
wevtutil.exe epl system %evtx%\sys.evtx /ow:True /q:"*[System[TimeCreated[@SystemTime >= '%ANMDate%T00:00:00']]]"

md %vigor%
md %svad%
xcopy "%userprofile%\VIGOR\DEBUG" %vigor% /s /i
xcopy "%userprofile%\SVAD\DEBUG" %svad% /s /i

powershell Compress-Archive -LiteralPath %output% %output%.zip
pause
