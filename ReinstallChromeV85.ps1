$KZN = Get-ADComputer -Filter 'name -like "*KZN*"'

Invoke-Command -ComputerName $KZN.name -ScriptBlock {
    $DirName = "distrib"
    $path = "c:\$DirName"
    $FileName = "$path\Chrome_85.exe"
    $BatName = "$path\SilentInstallChrome.bat"
    $DownloadURL = 
    $HavePath = Get-ChildItem -Path $path 
    if ($HavePath -eq $null) {
        New-Item -Path "C:\" -Name $DirName -ItemType Directory 
        }

    $CreateBat = "@Echo Off" + "`r`n" `
    + "SetLocal EnableExtensions DisableDelayedExpansion" + "`r`n" `
    + "cd c:\ditsrib\" + "`r`n" `
    + "start /wait Chrome_85.exe -ms" + "`r`n" `
    + "taskkill.exe /F /IM chrome.exe" + "`r`n"  `
    + ")" 

    $CreateBat | Out-File -FilePath $path\$BatName -Encoding utf8 

    


}