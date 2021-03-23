# Назначаем переменные с CSV
$Path = "C:\temp\Библиотека знаний"
$FileCSV = "$path\Матрица_доступа_МА_UTF8WithBom.csv"
$DirDFS = "D:\DFS\библиотека знаний" 

# Создаем временные файлы для последующего разбора 
$NewFoulder = "LibraryTemp"
New-Item -Path $Path -name $NewFoulder -ItemType directory 
$TempFoulder = "$Path\$NewFoulder"
$TempFileDir = "Dirs"
$TempFileUser = "Users"
New-Item -Path $TempFoulder -name $TempFileDir -ItemType directory 
New-Item -Path $TempFoulder -name $TempFileUser -ItemType directory 
$PathTempFileDir = "$Path\$NewFoulder\$TempFileDir"
$PathTempFileUser = "$Path\$NewFoulder\$TempFileUser"

# Забираем и разбираем данные из CSV 
$AllData = Import-Csv -Delimiter "," -Path "$FileCSV" -Header Dir,PodDir,Users,Other,Groups
$Users = $AllData | select Users,Groups 
$Dirs = $AllData | select dir,poddir
$Poddirs = $AllData | where {$_.PodDir -like "*Приказы*"}
$Poddirs = $Poddirs | Select -ExpandProperty poddir 
$Poddirs2 = $AllData | where {$_.PodDir -like "*Лайн*"}
$Poddirs2 = $Poddirs2 | Select -ExpandProperty poddir 

# Создаем группы безопасности
$Groups = $Users.Groups 
foreach ($Group in $Groups) {
    New-ADGroup -DisplayName $Group -GroupCategory Security -GroupScope Global -Name $Group -Path "OU=Библиотека знаний,OU=ILC-GROUPS,DC=ilccredits,DC=com"
    }

# Создаем директории 
$RemotePath = "\\ILC-FILESERV\D`$\DFS\библиотека знаний"
foreach ($Poddir in $Poddirs) {
    New-Item -Path $RemotePath\приказы -ItemType directory -name $Poddir 
    }

foreach ($Poddir2 in $Poddirs2) {
    New-Item -Path "$RemotePath\Договора с партнерами" -ItemType directory -name $Poddir2
    }


# Добавляем пользователей в группы бесопасности. 
# Первая часть - выгружаем пользователей в файлы с названием группы.
foreach ($User in $Users) {
    $FileName = $User.groups
    $Users | select * | Where-Object {$_.Groups -like $User.groups} | ConvertTo-Csv -Delimiter ',' | Out-File $PathTempFileUser\$FileName.csv  -Encoding utf8 
    }

# Получаем данные по файлам, забираем от туда все имена и убираем расширение csv
$AllGroupFiles = Get-ChildItem -Path $PathTempFileUser
$GroupFiles = $AllGroupFiles.Name
$replaceCSV = $GroupFiles -replace '.csv',''

# Первым этапом в цикле берем файл с пользователями и разбиваем его по пробелам
# Вторым этапом берем пользователя и ищем его по surname в АД. Если находим - добавляем к группе безопасности по логину
foreach ($CSV in $replaceCSV) {
    $CSV
    $Users = Import-Csv -Delimiter ',' -Path $PathTempFileUser\$CSV.csv 
    $ADUsers = $Users.users -split ' '
    foreach ($ADUser in $ADUsers) {
        $User = $ADUser
        $GetUser = Get-ADUser -Filter "surname -like '*$User*'"
        $GetGroup = Get-ADGroup -Identity $CSV 
        Add-ADGroupMember -Identity $GetGroup.Name -Members $GetUser.SamAccountName
        }
    }
