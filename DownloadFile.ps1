# делаем выборку машин, которые должны получить файл
$CashPCs = Get-ADComputer -Filter 'name -like "*CASH1*"'

# проверяем наличие папки на пк и если ее нет - создаем
# а так же скачиваем сам файл. 
Invoke-Command -ComputerName $CashPCs.name -ScriptBlock {
    # назначаем переменные для работы.
    $path = "c:\ZK"
    $FileName = "DTO-10_8.exe"
    $InstallKey = "/S /WithEOU /WithWeb"

    



# Фактически - можно сделать и по другому. Можно скачать на машину файл и раздать ее.