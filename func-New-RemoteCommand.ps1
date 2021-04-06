function New-RemoteCommand {
    <#
   .SYNOPSIS
   Фильтруем компы и выполняем введенную команду. 

   .DESCRIPTION
   Функция получает список компов в домене и выполняет внутри них введенные команды

   .PARAMETER -FilterCompName
   Принимает string - наименование или часть наименования компа

   .PARAMETER -Command
   Принимает string - комманда для выполнения (Если есть кириллица или проблелы - команду с производными втыкай в кавычки) 
        
   .EXAMPLE
   New-RemoteCommand -FilterCompName sdv5 -Command "Get-ChildItem c:\"
   Возвращает каталоги диска C:\ на машине SDV5 

   .NOTES
    Author: @Chentsov_VS
   #>
    param (
        $FilterCompName,
        $Command
        )

    # Формируем перечень компов для последующей работы 
    $Computers = Get-ADComputer -Filter "name -like '*$FilterCompName*'"
    $ComputerNames = $Computers.name 

    # Формируем скриптблок - иначе команду передать не выйдет 
    $ScriptBlock = [ScriptBlock]::Create("$Command")

    # Проверяем, если машин в списке больше 1 - тогда будем делать через цикл 
    if ($ComputerNames.count -gt 1) {
        $Data = foreach ($ComputerName in $ComputerNames) {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
        }
    }

    # Если 1 комп, тогда просто выполняем команду 
    else {
        $Data = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    } 
    
    return $Data   
}