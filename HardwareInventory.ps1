$ComputerAll = Get-ADComputer -Filter 'name -like "*"' -Properties *
$PCs = $ComputerAll.name

# Получаем данные о дисках и конвертируешь размер на ГБ
$Disks = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-Disk | select FriendlyName,SerialNumber,PSComputerName,@{Label="Size"; expression={$_.Size / 1GB}}
        }
    }

# Фильтры для дальнейшей работы по поиску дисков
$Group = $Disks | group PSComputerName   
$HPs = ($Group | where {$_.group.FriendlyName -like "*WD*"}).Group
$FilterDisk = $Group | where {$_.group.size -le 8000 -and $_.Group.size -gt 2000} 
$Kingston256 = $Group.group | where {$_.size -le 300 -and $_.size -gt 200 -and $_.friendlyname -like "*king*"} 
$Kingston1TB = $Group.group | where {$_.size -le 2000 -and $_.size -gt 900 -and $_.friendlyname -notlike "WDC*" -and $_.friendlyname -notlike "st*"} 
$128GB = $Group.group | where {$_.size -le 1000 -and $_.size -gt 900 -and $_.friendlyname -like "*Kingston*"}
$ST = $Group.group | where {$_.size -le 4000 -and $_.size -gt 800 -and $_.friendlyname -like "*ST*"} 
$ST.PSComputerName
$Kingston256
$Kingston1TB
($128GB | group PSComputerName).Name
$SSD = ($Group | where {$_.group.size -LE '150'})

# Получаем RAM и конвертируешь размер на ГБ
$CompInfos = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-WmiObject Win32_physicalMemory | select Name,Model,MemoryType,Manufacturer,Description,DeviceLocator,speed,configuredclockspeed,@{Label="Capacity"; expression={$_.Capacity / 1GB}}
        }
    }
$GroupRAM = $CompInfos | group PSComputerName
$21 = ($GroupRAM | where {$_.group.Manufacturer -like "*King*" -and $_.group.speed -eq 1600 -and $_.group.Capacity -eq 4 -and $_.Group.PSComputerName -like "*CO*"})
$21.group | Out-File c:\temp\RAM.txt -Append -Encoding utf8

# Получаем список материнских плат. 
$CompMotherboards = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-WmiObject -Class "Win32_BaseBoard"    
        }
    }

$GroupMotherboard = $CompMotherboards | group PSComputerName
$CompMotherboards | where {$_.pscomputername -like "*ILC-1C-HARD*"}


# Получаем список процессоров 
$CompProcessor = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-WmiObject -Class "Win32_Processor"    
        }
    }

($CompProcessor | where {$_.Name -like "*i5-4460*" -and $_.PSComputerName -like "ILC-CO-PR1"})
$CompProcessor | where {$_.name -like "*i9-7900X*"}
# Получаем список подключенных по usb принтеров.
$Printers = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-Printer -Name * | where {$_.PortName -like "USB*"}
        }
    }

   $GroupPrinters = $Printers | Group-Object PSComputername 
   $Printers | where {$_.name -like "*1102*"}

   $Printers | where {$_.Name -like "*Canon*"}

# Получаем список подключенных мониторов 
$Monitors = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-WmiObject WmiMonitorID -Namespace root\wmi 
        }
    }

<#
    Короткая справка по мониторам 

    (Philips)
    PHLC0CD = 19
    PHLC0D1 = 24
    PHLC0CF = 22

    (LG)
    LGD052D = 13
    GSM4BEA = 19
    GSM0001 = 43
    GSM4C0B = 19
    GSM4C24 = 19
    GSM4C22 = 19
    GSM5ACB = ? 

    (Samsung)
    SAM09AC = ?
    SAM0B43 = ?
    SAM0B34 = ?

    (Benq)
    BNQ8016 = 24
    BNQ7843 = ?
    BNQ8023 = ?
#> 

($Monitors | where {$_.InstanceName -like "*BNQ8016*"} | group PSComputername ).Name | sort PSComputername
$Monitors.InstanceName
$Monitors | select InstanceName,PSComputername | where {$_.InstanceName -like "*PHLC0D1*"} | sort PSComputername

$ModelsPC = foreach ($PC in $PCs) {
    Invoke-Command -ComputerName $PC -ScriptBlock {
        Get-CimInstance -ClassName Win32_ComputerSystem
        }
    }

$ModelsPC | where {$_.manufacturer -like "*HP*"}
$modelspc | where {$_.pscomputername -like "*ILC-1C-HARD*"}
