function  Get-ADUserData {
    param ($UserName = (read-host ""))
            
    $UserName -match '[а-я]{1,99}'
        
    if ($Matches[0] -eq $null) {
        $SearchParametr = "SamAccountName"
    }
        
    else {
        $SearchParametr = "Surname"
    }
        
    $UserData = Get-ADUser -Filter {$SearchParametr -eq "$UserName"} 
 
    return $UserData
}