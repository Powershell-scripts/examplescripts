function  Get-ADUserData {
 <#
    .SYNOPSIS
    Возвращает данные пользователя 

    .DESCRIPTION
    Производит разбор текста, если текст состоит из кириллицы 
    То возвращает surname параметр (фамилию) и ищет в AD по нему.
    Если латиница - тогда ищет по samaccauntname (логин AD)

    .PARAMETER -FilterAddress
    Параметр принимает следующие значения: 
    UserName = часть или полное наименование пользователя 
    Принимает как логин отдельно, так и просто фамилию или имя
        
    .EXAMPLE
    Get-ADUserData -UserName Иванов 
    Получает все данные на пользователя с фамилией Иванов 

    .EXAMPLE
    Get-ADUserData -UserName admin  
    Получает все данные на пользователя с логином admin
    
    .EXAMPLE
    $User = Get-ADUserData -UserName admin  
    $User.email 
    Что бы получить данные по пользователю сделай вывод в переменную
    Как в примере выше и работай со свойствами объекта 
    (пример $User.email # вернет почту пользователя) 
    по имеющимся свойствам выполни:
    
    Get-ADUser -Filter 'name -like "*"' -Properties * | gm -MemberType Properties 

    .EXAMPLE
    Get-ADUserData -UserName adm*
    Вернет всех пользователей, которые начинаются с adm

    .NOTES
     Author: @Chentsov_VS
#>
    param ($UserName = (Read-Host ''))

    
    # фильтруем данные на наличие кириллицы
    $RusLang = $UserName -match '[а-я]{1,99}'
        
    if ($RusLang -eq $true) {
        $SearchParametr = "Surname"
    }
        
    else {
        $SearchParametr = "SamAccountName"
    }
    
    # Запрашиваем данные из AD 
    $UserData = Get-ADUser -Filter 'name -like "*"' -property * `
    | Where-Object { $_.$SearchParametr -eq "$UserName" } 

    return $UserData
}
