
$Help = Get-ADUser -Filter 'name -like "*help*"' -Properties * # меняй "*help*" на нужное тебе по формату *Фамилия*
$support = Get-ADUser -Filter 'name -like "*support*"' -Properties *
$NewContactName = "Verci Tech Support"
$NewContactMail = "support@verci.ru"
$TextSubject = "Test Forwarding"
$TextBody = ""test forwarding mail"
$Date = (get-Date) # или в формате MM/dd/yyyy


# получаем прошлые настройки перенаправления (на всякий) и устанавливаем новые 
# а так же создаем новый контакт в AD
Get-Mailbox $help.mail | fl ForwardingAddress,DeliverToMailboxandForward
$user = new-MailContact -Name $NewContactName -ExternalEmailAddress $NewContactMail
Set-Mailbox $help.mail -ForwardingAddress $user.$Verci.ExternalEmailAddress -DeliverToMailboxAndForward $true

# Осуществляем проверку данных 
Send-MailMessage -From $user.mail -To $help.mail -Subject "$TextSubject" -Body "$TextBody" -SmtpServer ex0
$Log = Get-MessageTrackingLog -Start $Date -End (Get-Date) -Server ex0 -Recipients $help.mail | Where-Object {$_.MessageSubject -like "$TextSubject"} 
$Log


