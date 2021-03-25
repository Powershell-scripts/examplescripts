# Назначаем переменные с CSV
$Path = "C:\temp\Библиотека знаний"
$FileCSV = "$path\Матрица_доступа_МА_UTF8WithBom.csv"
$DirDFS = "D:\DFS\библиотека знаний" 
$DirShare = "D:\DFS\" 
$NameLibrary = "библиотека знаний"
$FindLibrary = Get-ChildItem -Path $DirDFS
if ($null -eq $FindLibrary) {
    New-Item -Path $DirShare -ItemType directory -name $NameLibrary
    }


# Забираем и разбираем данные из CSV 
$AllData = Import-Csv -Delimiter "," -Path "$FileCSV" -Header Dir,PodDir,Users,Other,Groups
$Users = $AllData | select Users,Groups 
$Dirs = $AllData | select -ExpandProperty dir
$Poddirs = $AllData | where {$_.PodDir -like "*Приказы*"}
$Poddirs = $Poddirs | Select -ExpandProperty poddir 
$Poddirs2 = $AllData | where {$_.PodDir -like "*Лайн*"}
$Poddirs2 = $Poddirs2 | Select -ExpandProperty poddir 

# Создание директорий и поддерикторий, удаляем ненужные
$RemotePath = "\\ILC-FILESERV\D`$\DFS\библиотека знаний"
foreach ($dir in $dirs) {
    New-Item -Path $RemotePath\ -ItemType directory -name $dir 
    Remove-Item -Path "$RemotePath\Договора с партнерами" 
    Remove-Item -Path "$RemotePath\Приказы" 
    }

# Создаем поддиректории первой папки
foreach ($Poddir in $Poddirs) {
    New-Item -Path $RemotePath\ -ItemType directory -name $poddir 
    }

# Создаем поддиректории второй папки ,
foreach ($Poddir2 in $Poddirs2) {
    New-Item -Path "$RemotePath\Договора с партнерами $Poddir2" -ItemType directory -name $Poddir2
    }