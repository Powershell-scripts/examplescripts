    # формируем URL ресурсов 
    $URLLogin = "https://jira.t1-group.ru/login"
    $urlReload = "https://jira.t1-group.ru/browse/IT2019-2346"

    # добавляем статичную информацию о работе 
    $DateLog = (Get-Date -Format dd:MM:yyyy hh:mm:ss)
    $FormatLog = "[$DateLog]"
    $StatusOKReload = "$FormatLog Отправили запрос в МП АК $urlReload на перезагрузку (контракт №$ID) "
    $StatusErrorReload = "$FormatLog Не удалось перезагрузить контракт $urlReload (Контракт не найден) Удостоверьтесь что контракт №$ID существует в МП АК"

    # формируем хедеры и тело для отправки данных контракта в перезапуск 
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/x-www-form-urlencoded")
    $headers.Add("Cookie", "MOCKSESSID=c59aee23ad76280186fc1709d0f7a004c5a16d79018c7f454b24de8009d1bad5")
    $body = "os_username=name&os_password=pass&os_destination=&user_role=&atl_token=&login=Log+In"

    # Включаем TLS 1.2 протокол для выполнения сценариев 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # Логинимся на сайте с помощью базовой аутентификации
    $response = Invoke-RestMethod "$URLLogin" -Method 'POST' -Headers $headers -Body $body -SessionVariable Session
    $response | ConvertTo-Json

    $response2 = Invoke-RestMethod $urlReload -Method Get -WebSession $Session