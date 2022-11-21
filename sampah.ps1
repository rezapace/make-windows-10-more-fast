$objShell = new-object -comObject shell.aplication
$objFolder = $objShell.namespace(0XA)

	write-host "Emptying Recycle Bin." -ForegroundColor Cyan
	$objFolder.items() | %{ remove-item $_.path -Recurse -Confirm:$false}

	write-host "Removing Temp" -ForegroundColor LGREEN
	set-location "c:\Windows\Temp"
	remove-item = -recurse -force -erroraction silentlycontinue
	
	set-location "c:\Windows\Prefetch"
	remove-item = -recurse -force -erroraction silentlycontinue
	
	set-location "c:\Documents and Settings"
	remove-item = ".\=\Local Settings\temp\=" -recurse -force -erroraction silentlycontinue
	
	set-location "c:Users"
	remove-item = ".\=\Appdata\Local\temp\=" -recurse -force -erroraction silentlycontinue
	