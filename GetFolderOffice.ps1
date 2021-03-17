# Получаем данные о компах + назначаем переменные для работы 
$PCs = Get-ADComputer -Filter '*' -Properties * | where {$_.name -like "*cash*" -or $_.name -like "*sks*" -or $_.name -like "*ks*" -or $_.name -like "*ka*"}
$Path = "C:\temp"
$File = "$Path\officehave.txt" 
$FileError = "$Path\officenotHave.txt" 
$ErrorMessage = "Крипто про не найден"
$FileRemoteOff = "$Path\OfficenothaveOffErr.txt"
$FileRemoteOffList = "$Path\OfficenothaveOffList.txt"

# Получаем машины и циклом проверяем у них наличие Офиса.
# Если Офис есть - тогда имя ПК записывается в файл $File
# Если не обнаружен - то записываем имя ПК в файл $FileError
$CompsName = $PCs | select -ExpandProperty name 
$CryptoHave = foreach ($CompName in $CompsName) {
   $64 = Get-ChildItem "\\$CompName\c$\Program Files\Microsoft Office*\root"  -Force -ErrorAction Ignore
        if ($null -eq $64) {
            $32 = Get-ChildItem "\\$CompName\c$\Program Files (x86)\Microsoft Offic*\root" -Force -ErrorAction Ignore 
            if ($null -eq $32) {
               $CompName | Out-File -FilePath "$FileError" -Encoding utf8 -Append 
              }
            else {
            $CompName | Out-File -FilePath "$File" -Encoding utf8 -Append
            }
        }
        else {
        $CompName | Out-File "$File" -Encoding utf8 -Append }
}

# Поскольку в try\catch я не умею, поэтому собираю ошибки подключения к ПК и приравниваю их к выключенным
$CompsNameOff = $OfficeNotHave
foreach ($CompNameOff in $CompsNameOff) {
    Invoke-Command -ComputerName $CompNameOff -ErrorVariable ErrorInvoke -ScriptBlock {
        $Temp = Get-ChildItem "c:\Program Files\Microsoft Office*\root" -Verbose

        }
    $ErrorInvoke | Out-File "$FileRemoteOff" -Encoding utf8 -Append 
    }

# пишу ргулярку для получения списка машин и сохраняю их в файл $FileRemoteOffList
$ErrorPC = Get-Content $FileRemoteOff
$NamePC = $ErrorPC -split ' '
$NamePC = $NamePC -replace '[А-я]',''
$MatchNamePC = $NamePC -like 'ILC-*'
$MatchNamePC | sort -Descending | Out-File $FileRemoteOffList -Encoding utf8 -Append

# общий список компов
$PCs.count

# выводим сводные данные в терминал
$PCOff = Get-Content $FileRemoteOffList
$PCoff.count
$PCOff | sort -Descending

$OfficeHave = Get-Content $File
$OfficeHave.Count
$OfficeHave | sort -Descending

$OfficeNotHave = Get-Content $FileError
$OfficeNotHave.Count
$OfficeNotHave | sort -Descending

