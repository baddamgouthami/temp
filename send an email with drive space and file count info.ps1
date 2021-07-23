
$logfile="C:\send an email with used space and count of files\logs"

$CountOfFiles=(Get-ChildItem -Directory | Measure-Object).Count

$drivename = "C", "E";

$usedSpace=(Get-PSDrive $drivename)

Function Logwrite
{
  param([string]$logstring)
  add-content $logfile -value $logstring
}


Function sendEmailNotification()
 
 try
 {

 $eBody="<h2>please find the below details</h2><br><br>"
 $eBody+=$CountOfFiles
 
 Send-MailMessage -To “<eEmailTo>” -From “<eEmailFrom>”  -Subject “used Drive space and File count inside Drive” -Body “$eBody” -SmtpServer “<$esmtp>” -Port <$esmtpPort>
 
 Logwrite((Get-Date).Tostring()+"_"+"Email Notification sent")

 }

 catch
 {

 Logwrite((Get-Date).Tostring()+"_"+ $_.Exception.message)
 Exit

 }

 
 $path= Split-Path $MyInvocation.MyCommand.Path -Parent  #Get script path

$XMLfile= Join-Path $path "Config.xml"
  
 [XML]$configuration = Get-Content $XMLfile


 foreach ($config in $configuration.configuration)
 {

 try
 {
 $FilePath=$config.filepath

 $eSmtpServer=$config.smtpServer
 $eEmailFrom=$config.EmailFrom
 $esmtpPort=$config.smtpPort
 
    [string[]] $eEmailTo =$config.EmailTo.Split(',')
 }

 catch

 {
 Logwrite((Get-Date).ToString()+"_"+$_.Exception.Message)
 Exit

 }

 }