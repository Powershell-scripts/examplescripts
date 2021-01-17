# Настраиваем переменные (пути, папки, файлы и т.д.)
$Path = "C:\temp"
$NewFoulder = "KKM"
New-Item -Path $Path -name $NewFoulder -ItemType directory 
$KKMFoulder = "$Path\kkm"
$FileCSV = "$Path\LogPass.csv"
$RemoteFile = "KKMPass.txt"
$PCFilter = "cash*" 

# Получаем список компов в АД, на которые потребуется раздать данные
$Objects = Get-ADcomputer -filter {name -like "*$PCFilter"} | select -ExpandProperty name 

# Получаем данные из CSV - сначала samaccountname для раздачи по компам 
# С фильтрацией - по наличию samaccountname в компе (значит пользователь там работал)
$Users = Import-Csv -Path $FileCSV  -Header Name,Pass -Encoding UTF8 -Delimiter ";" | select -ExpandProperty Name
$All = Import-Csv -Path $FileCSV  -Header Name,Pass -Delimiter ";" -Encoding UTF8 
foreach ($user in $Users) {
$All | select * | Where-Object {$_.Name -like "$User"} | Out-File $KKMFoulder\$User.txt -Encoding utf8}

# Для начала выгружаем в файлы с паролями в отдельные файлы а потом эти файлы отправляем в компы пользователей
$result = foreach ($User in $Users) {
    foreach ($Object in $Objects) {
    Copy-Item "$KKMFoulder\$User.txt" -Destination  "\\$Object\C$\Users\$User\Desktop\$RemoteFile" }
    }