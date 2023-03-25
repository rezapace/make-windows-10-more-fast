### PowerShell template profile 
### Version 1.03 - Tim Sneath <tim@sneath.org>
### From https://gist.github.com/timsneath/19867b12eee7fd5af2ba
###
### This file should be stored in $PROFILE.CurrentUserAllHosts
### If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
###    PS> New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
### This will create the file and the containing subdirectory if it doesn't already 
###
### As a reminder, to enable unsigned script execution of local scripts on client Windows, 
### you need to run this line (or similar) from an elevated PowerShell prompt:
###   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
### This is the default policy on Windows Server 2012 R2 and above for server Windows. For 
### more information about execution policies, run Get-Help about_Execution_Policies.

# Import Terminal Icons
Import-Module -Name Terminal-Icons

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n { notepad $args }

# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

# Creates drive shortcut for Work Folders, if current user account is using it
if (Test-Path "$env:USERPROFILE\Work Folders") {
    New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
    function Work: { Set-Location Work: }
}

# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt { 
    if ($isAdmin) {
        "[" + (Get-Location) + "] # " 
    } else {
        "[" + (Get-Location) + "] $ "
    }
}

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin) {
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
        $argList = "& '" + $args + "'"
        Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    } else {
        Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin


# Make it easy to edit this profile once it's installed
function Edit-Profile {
    if ($host.Name -match "ise") {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    } else {
        notepad $profile.CurrentUserAllHosts
    }
}

# We don't need these any more; they were just temporary variables to get to $isAdmin. 
# Delete them to prevent cluttering up the user profile. 
Remove-Variable identity
Remove-Variable principal

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} 
#
# Aliases
#
# If your favorite editor is not here, add an elseif and ensure that the directory it is installed in exists in your $env:Path
#
if (Test-CommandExists nvim) {
    $EDITOR='nvim'
} elseif (Test-CommandExists pvim) {
    $EDITOR='pvim'
} elseif (Test-CommandExists vim) {
    $EDITOR='vim'
} elseif (Test-CommandExists vi) {
    $EDITOR='vi'
} elseif (Test-CommandExists code) {
    $EDITOR='code'
} elseif (Test-CommandExists notepad) {
    $EDITOR='notepad'
} elseif (Test-CommandExists notepad++) {
    $EDITOR='notepad++'
} elseif (Test-CommandExists sublime_text) {
    $EDITOR='sublime_text'
}
Set-Alias -Name vim -Value $EDITOR

# Set Some Option for PSReadLine to show the history of our typed commands
Set-PSReadLineOption -PredictionSource History 
Set-PSReadLineOption -PredictionViewStyle ListView 
Set-PSReadLineOption -EditMode Windows 

function ll { Get-ChildItem -Path $pwd -File }
function g { Set-Location $HOME\Documents\Github }
function desktop { Set-Location $HOME\Desktop }
function htdoc { Set-Location c:\xampp\htdocs }
function src { Set-Location 'C:\Program Files\Go\src' }
function home { Set-Location 'C:\' }
function linux { Set-Location '\\wsl$\Ubuntu-20.04\home\pace' }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}
function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}
function uptime {
    #Windows Powershell    
    Get-WmiObject win32_operatingsystem | Select-Object csname, @{
        LABEL      = 'LastBootUpTime';
        EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) }
    }

    #Powershell Core / Powershell 7+ (Uncomment the below section and comment out the above portion)

    <#
        $bootUpTime = Get-WmiObject win32_operatingsystem | Select-Object lastbootuptime
        $plusMinus = $bootUpTime.lastbootuptime.SubString(21,1)
        $plusMinusMinutes = $bootUpTime.lastbootuptime.SubString(22, 3)
        $hourOffset = [int]$plusMinusMinutes/60
        $minuteOffset = 00
        if ($hourOffset -contains '.') { $minuteOffset = [int](60*[decimal]('.' + $hourOffset.ToString().Split('.')[1]))}       
        if ([int]$hourOffset -lt 10 ) { $hourOffset = "0" + $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') } else { $hourOffset = $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') }
        $leftSplit = $bootUpTime.lastbootuptime.Split($plusMinus)[0]
        $upSince = [datetime]::ParseExact(($leftSplit + $plusMinus + $hourOffset), 'yyyyMMddHHmmss.ffffffzzz', $null)
        Get-WmiObject win32_operatingsystem | Select-Object @{LABEL='Machine Name'; EXPRESSION={$_.csname}}, @{LABEL='Last Boot Up Time'; EXPRESSION={$upsince}}
        #>


    #Works for Both (Just outputs the DateTime instead of that and the machine name)
    # net statistics workstation | Select-String "since" | foreach-object {$_.ToString().Replace('Statistics since ', '')}
        
}
function reload-profile {
    & $profile
}
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function zip {
    param(
        [Parameter(Mandatory=$true)]
        [string]$name
    )
    $path = (Get-Location).Path
    Compress-Archive -Path "$path\*" -DestinationPath "$path\..\$name.zip"
}
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
function df {
    get-volume
}
function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
    Get-Process $name
# membuka file explorer
}
function e {
    explorer .
}
# membuka vscode
function v {
    code .
}
# membuka port untuk mengakses apache wsl
function konek {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [int]$listenport = 8000,
        [int]$connectport = 8000
    )
    $listenaddress = $ip.Trim()
    $connectaddress = $($(wsl hostname -I).Trim())
    $cmd = "netsh interface portproxy add v4tov4 listenport=$listenport listenaddress=$listenaddress connectport=$connectport connectaddress=$connectaddress"
    Invoke-Expression $cmd
}
# cek port yang terbuka
function cek {
    netsh interface portproxy show v4tov4
}
# matikan port
function stop {
    netsh interface portproxy reset
}
function web {
    $folderName = Split-Path -Leaf (Get-Location)
    $filePath = "C:\xampp\htdocs\$folderName"
    $url = "http://localhost/$folderName/"
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    & $chromePath $url
}
function local {
    $url = "http://localhost/phpmyadmin/"
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    & $chromePath $url
}
function profile {
    code 'C:\Users\R\Documents\WindowsPowerShell'
}
function xampprun {
    Set-Location 'C:\xampp'
    Start-Process 'apache_start.bat' -WindowStyle Minimized
    Start-Process 'mysql_start.bat' -WindowStyle Minimized
}
function xamppstop {
    Set-Location 'C:\xampp'
    taskkill /f /im httpd.exe
    & '.\mysql\bin\mysqladmin.exe' -u root shutdown
}
function mysql {
    & 'C:\xampp\mysql\bin\mysql.exe' -u root -p
}
function gabung {
    $folder = Get-Location
    $pdfs = Get-ChildItem -Path $folder -Filter *.pdf | Select-Object -ExpandProperty FullName
    $output = Join-Path -Path $folder -ChildPath "output.pdf"
    & "C:\Program Files\gs\gs10.00.0\bin\gswin64c.exe" -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dQUIET -sOutputFile="$output" $pdfs
}
function opdf {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$InputFile,
        
        [Parameter(Mandatory=$true, Position=1)]
        [string]$OutputFile
    )
    
    $arguments = @(
        "-sDEVICE=pdfwrite",
        "-dCompatibilityLevel=1.4",
        "-dPDFSETTINGS=/screen",
        "-dNOPAUSE",
        "-dQUIET",
        "-dBATCH",
        "-sOutputFile=$OutputFile",
        $InputFile
    )
    
    &"C:\Program Files\gs\gs9.54.0\bin\gswin64c.exe" @arguments
    
    if (Test-Path $OutputFile) {
        return $true
    }
    else {
        return $false
    }
}
function p2w {
    # Load Aspose.PDF DLL
    Add-Type -Path "C:\Program Files (x86)\Aspose\Aspose.PDF for .NET\Bin\net4.0\Aspose.PDF.dll"

    # Ask for PDF file location and name
    $pdfFile = Read-Host "Enter the PDF file location and name (e.g. C:\Folder\a.pdf)"

    # Load input PDF file
    $doc = New-Object Aspose.Pdf.Document($pdfFile)

    # Create DOCX save option
    $saveOptions = New-Object Aspose.Pdf.DocSaveOptions
    $saveOptions.Format = "DocX"

    # Construct output file name and location
    $outputFolder = Split-Path $pdfFile
    $outputFile = Join-Path $outputFolder "output.docx"

    # Save PDF to DOCX
    $doc.Save($outputFile, $saveOptions)

    Write-Host "PDF file converted to DOCX. Output file: $outputFile"
}
function j {
    param(
        [string]$DirectoryName
    )

    # Change current directory to 'C:\'
    Set-Location 'C:\'

    # Execute PowerShell command 'z' with the directory name
    Invoke-Expression "z $DirectoryName"
}
function linuxstop {
    wsl --shutdown Ubuntu-20.04
}
function linuxstat {
    wsl --list -v
}
function cirun {
    php spark serve
}
function cp {
    # Get current PowerShell directory
    $currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

    # Ask for file name to copy
    $fileName = Read-Host "Enter the file name to copy"

    # Construct full source file path
    $sourceFilePath = Join-Path $currentDir $fileName

    # Check if source file exists
    if (-not (Test-Path $sourceFilePath)) {
        Write-Host "Error: $fileName not found in $currentDir" -ForegroundColor Red
        return
    }
    # Ask for destination file name
    $destFileName = Read-Host "Enter the destination file name"

    # Construct full destination file path
    $destFilePath = Join-Path $currentDir $destFileName

    # Copy file to destination
    Copy-Item $sourceFilePath $destFilePath

    if (Test-Path $destFilePath) {
        Write-Host "$fileName copied to $destFilePath" -ForegroundColor Green
    } else {
        Write-Host "Error: $fileName copy to $destFilePath failed" -ForegroundColor Red
    }
}
function mv {
    # Get current PowerShell directory
    $currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

    # Ask for file name to move
    $fileName = Read-Host "Enter the file name to move"

    # Construct full source file path
    $sourceFilePath = Join-Path $currentDir $fileName

    # Check if source file exists
    if (-not (Test-Path $sourceFilePath)) {
        Write-Host "Error: $fileName not found in $currentDir" -ForegroundColor Red
        return
    }

    # Ask for destination file name
    $destFileName = Read-Host "Enter the destination file name"

    # Construct full destination file path
    $destFilePath = Join-Path $currentDir $destFileName

    # Move file to destination
    Move-Item $sourceFilePath $destFilePath

    Write-Host "$fileName moved to $destFilePath"
}





function lupa {
    Write-Host "Daftar perintah yang tersedia:" -ForegroundColor Cyan
    Write-Host "home        = lokasi ke disck c" -ForegroundColor Yellow
    Write-Host "local       = membuka localhost/phpmyadmin" -ForegroundColor Yellow
    Write-Host "profile     = menambah kan setingan menggunakan vscode" -ForegroundColor Yellow
    Write-Host "zip         = menzip file" -ForegroundColor Yellow
    Write-Host "unzip       = mengekstrak file" -ForegroundColor Yellow
    Write-Host "g           = github" -ForegroundColor Green
    Write-Host "desktop     = desktop" -ForegroundColor Green
    Write-Host "htdoc       = htdoc xampp" -ForegroundColor Magenta
    Write-Host "src         = src golang" -ForegroundColor Magenta
    Write-Host "linux       = linux file" -ForegroundColor Red
    Write-Host "web         = membuka localhost" -ForegroundColor Yellow
    Write-Host "konek       = membuka port" -ForegroundColor Yellow
    Write-Host "cek         = cek port yang terbuka" -ForegroundColor Yellow
    Write-Host "stop        = matikan port" -ForegroundColor Yellow
    Write-Host "find-file   = find-file($name) menemukan file" -ForegroundColor Yellow
    Write-Host "e           = membuka explorer" -ForegroundColor Yellow
    Write-Host "v           = membuka vscode" -ForegroundColor Yellow
    Write-Host "grep        = grep($regex, $dir) mencari kata" -ForegroundColor Yellow
    Write-Host "gcom        = menambahkan dan meng-commit semua perubahan" -ForegroundColor Yellow
    Write-Host "lazyg       = meng-push perubahan yang sudah dicommit ke repositori Git" -ForegroundColor Yellow
    Write-Host "lazy        = menambahkan dan meng-commit semua perubahan, kemudian meng-push perubahan yang sudah dicommit ke repositori Git" -ForegroundColor Yellow
    Write-Host "xampprun    = menjalankan xampp" -ForegroundColor Yellow
    Write-Host "xamppstop   = menghentikan xampp" -ForegroundColor Yellow
    Write-Host "profile     = menambahkan setingan vscode" -ForegroundColor Yellow
    Write-Host "lupa        = menampilkan perintah" -ForegroundColor Yellow
    Write-Host "mysql       = membuka mysql" -ForegroundColor Yellow
    Write-Host "gabung      = menggabungkan file pdf" -ForegroundColor Yellow
    Write-Host "opdf        = mengoptimasi file pdf" -ForegroundColor Yellow
    Write-Host "p2w         = mengubah file pdf ke word direktory dan nama pdf" -ForegroundColor Yellow
    Write-Host "j           = j($name) menuju folder" -ForegroundColor Yellow
    Write-Host "linuxstop   = menghentikan linux" -ForegroundColor Yellow
    Write-Host "linuxstat   = mengecek status linux" -ForegroundColor Yellow
    Write-Host "cirun       = menjalankan codeigniter" -ForegroundColor Yellow
    Write-Host "cp          = cp($name) menyalin file" -ForegroundColor Yellow
    Write-Host "mv          = mv($name) memindahkan file" -ForegroundColor Yellow
}




## Final Line to set prompt
oh-my-posh init pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
