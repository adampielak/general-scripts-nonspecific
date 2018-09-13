$wc = New-Object System.Net.WebClient
$wc.DownloadFile("http://gvit.com/img/WP/Wallpaper_3840x2160.jpg","C:\ProgramData\GoVanguardWallPaper.jpg")

Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "C:\ProgramData\GoVanguardWallPaper.jpg"
rundll32.exe user32.dll, UpdatePerUserSystemParameters ,1 ,True

kill -n explorer