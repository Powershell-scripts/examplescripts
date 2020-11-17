# Пример авторизации на сайте с системой Basic Authorisation 
# Набиваем переменные нужные для работы

$UrlLogin = "https://pyrus.com/ru/signup-or-login"
$Login = "You_Login"
$Pass = "you_Pass"

# Заполняем данные защищенные данные и конвертируем. 
$SecurePassword = $Pass `
    | ConvertTo-SecureString -AsPlainText -Force

$Credential = New-Object System.Management.Automation.PSCredential `
    -ArgumentList $Login,$SecurePassword 

# Используем RestMethod для работы POST 
$AccessToken = Invoke-RestMethod -Uri "$UrlLogin" -ContentType "application/json" -Credential $Credential