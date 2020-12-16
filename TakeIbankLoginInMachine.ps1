$CashPCs = Get-ADComputer -Filter 'name -like "*CASH1*"'

Invoke-Command -ComputerName $CashPCs.name -ScriptBlock {
    # Введение нужных переменных. Заменить только DomainLogin на имя УЗ в домене
    # И заменить Pass и Login на нужный логин и пароль
    $UserName = "DomainLogin"
    $UserAuthPaysLogin = "Login"
    $UserAuthPaysPassword = "Pass"    
    
    $UserAuthIbank = $UserAuthPaysLogin + "`r`n" + $UserAuthPaysPassword
    $UserFoulder = "c:\Users\$UserName\Desktop"
    $AuthFile = "card.txt"
    $LinkFile = "payst.url"
    $LinkPayst = "https://corp-mck.payst.ru"
 
    $UserAuthIbank | out-file $UserFoulder\$AuthFile -Encoding utf8
        
    New-Item -Path $UserFoulder -Name "$LinkFile" -ItemType SymbolicLink -Target "$LinkPayst" 

        $link = New-Object -ComObject ("wscript.shell") 
        $url = $link.createshortcut("$UserFoulder\$LinkFile")
        $url.targetpath = "$LinkPayst"
            $url.save()
            }