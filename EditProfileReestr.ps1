# Подключаемся к ПК 
Enter-PSSession -ComputerName ILC-PVL-GHR1

# Получаем список пользователей из реестра и получаем bak
$Reestr = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" 
$BakFile = $Reestr | select name | where {$_.name -like "*.bak" }

# Редактируем пути для использования 
<# где DelBakName - выявляем просто файл реестра 
RenameProfile - меняем обычный файл на .old 
EditPath - меняем префикс пути текущего пользователя
EditPathOld - меняем префикс пути текущего пользователя на .old
EditBak - меняем префикс пути бэкапного пользователя
#>
$BakFileEdit = $BakFile.Name
$DelBakName = $BakFileEdit -replace '.bak',''
$RenameProfile = $BakFileEdit -replace '.bak','.old'
$EditPath = $DelBakName -replace 'HKEY_LOCAL_MACHINE','HKLM:'
$EditPathOld = $RenameProfile -replace 'HKEY_LOCAL_MACHINE','HKLM:'
$EditBak = $BakFileEdit -replace 'HKEY_LOCAL_MACHINE','HKLM:'

# Меняем файлы (old,bak)
Move-Item -Path $ProfileName -Destination $OldName
Move-Item -Path $EditBak -Destination $EditPath

# Проверяем значения и меняем их 
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\"
$ItemProperty =  Get-ItemProperty -Path $EditPath
Set-ItemProperty -Path $EditPath -Name State -Value 0

# Перезагружаем ПК 
Shutdown -r -f -t 0 