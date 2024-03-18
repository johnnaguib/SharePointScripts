Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue
$date = get-date -format d 
# replace \ by - 
$time = get-date -format t 
$month = get-date  
$month1 = $month.month 
$year1 = $month.year 
 
$date = $date.ToString().Replace(“/”, “-”) 
 
$time = $time.ToString().Replace(":", "-") 
$time = $time.ToString().Replace(" ", "") 
 
$log1 = ".\Processed\Logs" + "\" + "skipcsv_" + $date + "_.log" 
#$log2 = ".\Processed\Logs" + "\" + "Modified_" + $month1 +"_" + $year1 +"_.log" 
#$output1 = ".\" + "G_DistributionList_" + $date + "_" + $time + "_.csv"  
 
$logs = ".\Processed\Logs" + "\" + "Powershell" + $date + "_" + $time + "_.txt" 
 
  
 
# *************************************************************************** 
# Variable initializing to send mail 
$TXTFile = ".\ContentDBReport.html" 
$SMTPServer = "mailhost.x.com"  
$emailFrom = "ServersPing@x.com"  

$emailTo = ""  
$subject = "Sharepoint Custom databases Report"  
$emailBody = "Weekly report on Sharepoint Farm databases" 
 
#**************************************************************************** 
# HTML code to format output 
$b = "<!--mce:0-->" 
 
#******************************************************************************** 
# Creating PSSession and Loading Snapin(make sure your account has rights to sharepoint) 
 


 
Function ContentReport (){ 
 

 
$f1 = Get-SPDatabase
$result  = $f1 | Select-Object DisplayName,WebApplication,CurrentSiteCount,disksizerequired,WarningSiteCount,MaximumSiteCount
if($result -ne $null)
{
    $Outputreport = "<HTML><TITLE>SharePoint Database size</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2>DB size Report </H2></font><Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>DBName</B></TD><TD><B>WebApplication</B></TD><TD><B>CurrentSiteCount</B></TD><TD><B>Size in GB</B></TD></TR><TR></TR>"
    Foreach($Entry in $Result)
    {
        if($Entry.disksizerequired -gt 100Gb)
        {
            $Outputreport += "<TR bgcolor=red>"
        }
        else
        {
            $Outputreport += "<TR>"
        }
        $Outputreport += "<TD>$($Entry.DisplayName)</TD><TD align=center>$($Entry.WebApplication)</TD><TD align=center>$($Entry.CurrentSiteCount)</TD><TD align=center>$($Entry.disksizerequired/1073741824)</TD><TD align=center>$($Entry.timetaken)</TD></TR>"
    }
    $Outputreport += "</Table></BODY></HTML>"
return $Outputreport
}
 

} 
###############call function for diffrent farms################################################### 
 
$Outputreport= ContentReport

 
##############################Convert to HTML #################################################### 
 
$Outputreport | out-file E:\DBSize\DBSize-$date.htm
 # Code to Send Mail  
Send-MailMessage -SmtpServer $SMTPServer -From $emailFrom -To $emailTo -Subject $subject -Body $emailBody -Attachment E:\DBSize\DBSize-$date.htm 
 

  
