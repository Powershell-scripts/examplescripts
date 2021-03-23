# Устанавливаем путь к папке с гит репозиториями и переносим объекты в переменную GitFullname
$Path = Get-ChildItem C:\coding\ -Exclude "*.*"
$GitFullname = $Path.fullname

<# 
    Запускаем цикл, который будет заходить в каждую папку
    Брать данные удаленных репозиториев
    Менять данные (сначала берем наименование удаленного репозитория (origin)
    Удалить пробелы и значения после наименования - записать в переменную Origin
    Еще раз взять данные об удаленке, изменить данные http://188.246.230.114:54580 на https://gitlab.vercloud.ru
    Удаляем лишние пробелы [\s]{1,99}
    Изменяем репы 
#>
foreach ($Fullname in $GitFullname) {
    cd "$Fullname"  
    $GitRemote = git remote -v 
    $Origin = (($GitRemote -replace 'http://188.246.230.114:54580[\D]{1,99}','') -replace '[\s]{1}')[0]
    $URL = (($GitRemote -replace 'origin','') -split ' ')[0]
    $URL = $URL -replace 'http://188.246.230.114:54580','https://gitlab.vercloud.ru'
    $URL = $URL -replace '[\s]{1,99}',''
    git remote set-url $Origin $URL
    }


<#     Тест \ debag 

cd C:\Coding\contractstatus
  $GitRemote = git remote -v 
  $Origin = (($GitRemote -replace 'http://188.246.230.114:54580[\D]{1,99}','') -replace '[\s]{1}')[0]
  $Origin.Length
  $URL = (($GitRemote -replace 'origin','') -split ' ' )[0]
  $URL = $URL -replace 'http://188.246.230.114:54580','https://gitlab.vercloud.ru'
  $URL = $URL -replace '[\s]{1,99}',''
  git remote set-url $Origin $URL
#>  