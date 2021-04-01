# Удаление ПО  "Агент администрирования Kaspersky*" и "*aspersky Endpoint Security*" со всех машин в домене

# Запрашиваем все машины и делегируем имена в отдельную переменную 
$ComputerAll = Get-ADComputer -Filter 'name -like "*"'
$PCs = $ComputerAll.name

# Запускаем цикл с подключениями к машинам и получением имен установленного ПО, фильтруем данные и записываем в отдельную переменную
foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock { 
        $GetAllProgramm = Get-WmiObject -Class Win32_Product | Select-Object -Property Name
        $GetFilterProgramm = $GetAllProgramm | where {$_.name -like "Агент администрирования Kaspersky*" -or $_.Name -like "*aspersky Endpoint Security*"}
        $AppNames = $GetFilterProgramm.name 

        # Проводим первую проверку на наличие фильтрованного ПО. Если его нет, тогда выдаем сообщение
        if ($null -eq $GetFilterProgramm) {
            $DelAppMessage = "На машине " + $env:COMPUTERNAME + " ПО " + $AppNames +  " удалено или не обнаружено"
            }

        # Если не пусто в переменной ПО - тогда запускаем удаление объектов в цикле 
        else {
            $DelAppMessage = "Произвожу удаление " + $AppNames + " на машине " + $env:COMPUTERNAME  
            foreach ($AppName in $AppNames) {
                (Get-WmiObject Win32_Product -Filter "Name = '$AppName'").uninstall()
                }

            # Проводим вторую проверку на наличие ПО. Если оно есть - выдаем "присутствует касперски - удалить его не вышло", если его нет - значит удален успешно. 
            $GetAllProgramm = Get-WmiObject -Class Win32_Product | Select-Object -Property Name
            $GetFilterProgramm = $GetAllProgramm | where {$_.name -like "Агент администрирования Kaspersky*" -or $_.Name -like "*aspersky Endpoint Security*"}
            if ($null -eq $GetFilterProgramm) {
                $DelAppMessage = "На машине " + $env:COMPUTERNAME + " удалены " + $AppNames
                }

            else {
                $DelAppMessage = "На машине " + $env:COMPUTERNAME + " присутствует " + $AppNames + " - удалить их не вышло"
                }
            }
            $arrayMessage = @(ComputerName = "$env:COMPUTERNAME"; Message = "$DelAppMessage")
            $arrayMessage 
        }

    }