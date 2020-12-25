
$Help = Get-ADUser -Filter 'name -like "*help*"' -Properties * # меняй "*help*" на нужное тебе по формату *Фамилия*
$user = Get-ADUser -Filter 'name -like "*Сангад*"' -Properties * # меняй "*Сангад*" на нужное по формату *Фамилия*
$TextSubject = "Test Forwarding"
$TextBody = ""test forwarding mail"
$Date = (get-Date) # или в формате MM/dd/yyyy

# получаем прошлые настройки перенаправления (на всякий) и устанавливаем новые
 Get-Mailbox $help.mail | fl ForwardingAddress,DeliverToMailboxandForward
 Set-Mailbox $help.mail -ForwardingAddress "$user.mail" -DeliverToMailboxAndForward $true

# Осуществляем проверку данных 
Send-MailMessage -From $user.mail -To $help.mail -Subject "$TextSubject" -Body "$TextBody" -SmtpServer ex0
$Log = Get-MessageTrackingLog -Start $Date -End (Get-Date) -Server ex0 -Recipients $help.mail | Where-Object {$_.MessageSubject -like "$TextSubject"} 

$Log


