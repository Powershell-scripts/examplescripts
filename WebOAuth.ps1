# Пример авторизации на сайте с системой Rest API
# Набиваем переменные нужные для работы
$UrlAPILogin = "https://api.pyrus.com/v4/auth"
$URL = "http://pyrus.com/xlsx/tasklist?Mode=All&mi=15000&tz=180"
$FileName = "TaskList_" + (Get-Date -Format ddMMyyyy) + ".xlsx"
$path = "C:\temp"
$login = "?Somebody_email"
$API = "&security_key=Somebody_key"
$AccessUrl = $UrlAPILogin + $login + $API

# Тут есть как запрос задачи (легкий запрос) так и не рабочий запрос файла
# Сложность в том, что файл генерируется при запросе, а время сессии 5 сек. 
$TaskID = "/64706803"
$Task = "/tasks"
$URLTask = $UrlAPI + $Task + $TaskID

$Auth = Invoke-RestMethod -Uri "$AccessUrl" -ContentType "application/json" 
$AccessToken = $Auth.access_token

$URLDownload = $UrlAPI + $URLDownload + $URLIDFile

$Headers = @{ 
    "Authorization" = "Bearer $AccessToken"
}

$Logon = Invoke-RestMethod -Uri "$URLTask" -Headers $Headers -ContentType "application/json" -Method Get 
# Следующая проблема в кодировке и разборе как добится скачивания файла.





