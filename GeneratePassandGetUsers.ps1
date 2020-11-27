
# Функция генерации пароля без спецсимволов
function GeneratePass
    ($long=10) { # $long = длинна пароля 

$PassNumber | ForEach-Object -process {
        $PassResult = -join (1..$long | % { [char[]]'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' | Get-Random })
        $PassResult
    }
    
    return $pass
    }

# забираем данные пользователей и фильтруем (не получилось с помощью (get-date).adddays)
$UsersAll = Get-ADUser -Filter 'Name -like "*"' -Properties *
$Userlogons = $UsersAll | Where-Object {$_.LastLogonDate -GT '10/30/2020 00:00' -and $_.samaccountname -notlike "00*"} 

# выбираем нужные поля (фио и логин)
$Users = $Userlogons | select Name,Samaccountname

# генерируем пароль и формируем вывод, выводим все в файл 
foreach ($User in $Users) {
    $Pass = GeneratePass -long 10 
    $UsersFormat =  $User.Name + "`r`n" + $User.Samaccountname + "`r`n"  + $Pass + "`r`n"
       $UsersFormat | Out-File -FilePath C:\TEMP\loginpass.txt -Append
       Remove-Variable -Name pass
    }
