# делаем выборку машин, которые должны получить файл
$CashPCs = Get-ADComputer -Filter 'name -like "*CASH1*"'

# проверяем наличие папки на пк и если ее нет - создаем
# а так же скачиваем сам файл. 
Invoke-Command -ComputerName $CashPCs.name -ScriptBlock {
    $path = "c:\ZK"
    $FileName = "DTO-10_8.exe"
    $HavePath = Get-ChildItem -Path $path
    if ($HavePath -eq $null) {
        New-Item -Path "C:\" -Name "ZK" -ItemType Directory 
        }
    $URL = "http://fs.atol.ru/_layouts/15/atol.templates/Handlers/FileHandler.ashx?guid=ae707e39-b0dc-467e-a1e5-846c8a140ff2&webUrl="

    Invoke-RestMethod -Uri $URL -Method Get -OutFile "$path\$FileName"



# Фактически - можно сделать и по другому. Можно скачать на машину файл и раздать ее.