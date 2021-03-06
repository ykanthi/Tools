$namepc = (gc env:computername)
$a = get-date
$a = (get-date).AddDays(-1)
$allpath= Split-Path -Parent $MyInvocation.MyCommand.Path;
$logfolders = $env:WINDIR +"\system32\Logfiles\W3SVC*"
foreach($logfolder in  Get-ChildItem $logfolders)
{
$logfiles= $logfolder.FullName
Write-Host "parsing"  $logfiles
$log =  $a.ToString("yyMMdd") + ".log"
$process = [Diagnostics.Process]::Start($allpath + "\iis.bat" , $log + " "+ $allpath + " "+ $log + ".html" + " TIME" +$log + ".html" + " " + $logfiles)
$process.WaitForExit()
$content = "<h1>IIS REPORT " + $namepc  + "</H1>"
$content += (get-content ($allpath  + "\" + $log + ".html"))
$content += (get-content ($allpath  + "\TIME" + $log + ".html"))

$SmtpClient = new-object system.net.mail.smtpClient
$SmtpServer = "emailserver"
$SmtpClient.host = $SmtpServer 

$mm = new-Object System.Net.Mail.MailMessage("from@yourcompany.com","to@yourcompany.com")
$mm.Subject = "Report IIS " + $namepc 
$mm.Body = $content
$mm.Body=$mm.Body.Replace("<cmp>",$namepc  )
$mm.IsBodyHtml = 1
$SmtpClient.Send($mm)  
}