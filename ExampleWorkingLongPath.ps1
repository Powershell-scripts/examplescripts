# Собираем данные по работе и настраиваем переменные
$CAshFiles = Get-ChildItem -Path D:\DFS\ -Filter "*.harma" -Recurse | where {$_.Length -ge 100MB} 
$cred = Get-Credential -Credential ilccredits\kauser
$FileTXT = "C:\temp\harma.txt"

# удаляем старый файл 
Remove-Item -Path $FileTXT

# Формирование Файлов с путями и через литерал паф делаем перенос 
$CAshFiles.fullname | Out-File -FilePath C:\temp\harma.txt -Encoding utf8 -Append 
$LiteralPaths = Get-Content -Path $FileTXT  
New-PSDrive -Name w -PSProvider FileSystem -Root "\\192.168.1.139\ka_archive\CryptedFiles_Harma" -Description Crypted_files_harma -Credential $cred 
Move-Item -LiteralPath $CAshFiles.fullname -Destination "w:" -Verbose

