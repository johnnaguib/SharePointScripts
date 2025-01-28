# Warm up script 

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue



function Get-WebPage([string]$url)
{
    $wc = new-object net.webclient;
    $wc.credentials = [System.Net.CredentialCache]::DefaultCredentials;
    $pageContents = $wc.DownloadString($url);
    $wc.Dispose();
    return $pageContents;
}


# Enumerate the web app along with the site collections within it, and send a request to each one of them
foreach ($site in Get-SPSite -Limit All)
{
write-host $site.Url;
$html=get-webpage -url $site.Url -cred $cred;
}
