# Пример добавления прав доступа до папок в DFS 
Get-DfsnFolder -Path "\\ilccredits\библиотека знаний\*"

$Path = "\\ilccredits\библиотека знаний\*"
$Dirs = Get-ChildItem -Path $Path 
$Fullnames = $Dirs.fullname

# Получаем наименование папок + берем данные о группах безопасности
$DirsName = $Dirs.Name 
$Group = Foreach ($DirName in $DirsName) {
    Get-ADGroup -Filter "name -like '*$DirName*'"
    }

# Дополнительно берем данные других групп и путь к DFS 
$DomainAdmin = Get-ADGroup -Filter 'name -like "*Администраторы домена*"'
$GroupsName = $Group.name
$Path = "\\ilccredits\библиотека знаний"

# Прогоняем цикл - если совпадает директория + группа - тогда добавляем права на папку
foreach ($DirName in $DirsName) {
    foreach ($GroupName in $GroupsName) {
        if ($GroupName -like "*$DirName*") {
            Grant-DfsnAccess -Path "$Path\$DirName" -AccountName $GroupName,$DomainAdmin.name
            "Добавил $GroupName в директорию $DirName"
            }
        else { 
            "Совпадений не найдено"
            }
        }
    }

# Перепроверяем измененные данные. 
foreach ($Fullname in $Fullnames) {
    Get-DfsnAccess -Path $Fullname -Verbose
    }

