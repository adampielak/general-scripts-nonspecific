$wc = New-Object System.Net.WebClient
$wc.DownloadFile("http://gvit.com/img/WP/Wallpaper_3840x2160.jpg","C:\Windows\Web\4K\Wallpaper\GoVanguard\WallPaper.jpg")

Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value "C:\Windows\Web\4K\Wallpaper\GoVanguard\WallPaper.jpg"
rundll32.exe user32.dll, UpdatePerUserSystemParameters

kill -n explorer