power shell keren

https://christitus.com/pretty-powershell/

Buat folder dulu 
trus buka powershell nya di folder nya
(run administrator)

irm "https://github.com/ChrisTitusTech/powershell-profile/raw/main/setup.ps1" | iex

paste command di atas

abis itu yess to all

setelah itu re open , unzip cove.zip

ubah jenis font nya menjadi caskaydiacove nerd front

lalu buka ulang terminal dan tambahkan scrip ini fungsi nya seperti sugest auto complete dari yang pernah kita pake

install-Module PSReadLine -Force

Set-PSReadLineOption -PredictionSource History

Set-PSReadLineOption -PredictionViewStyle ListView

untuk menambah setingan profile 

cek direktory nya
$PROFILE

lalu buka dengan 
notepad C:\Users\R\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

vscode C:\Users\R\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

https://www.nerdfonts.com/

ini font nya

jangan lupa install windows terminal nya 

https://www.microsoft.com/store/productId/9N0DX20HK701

jangan lupa ubah font nya di vscode nya juga

cara nya 

ctrl+shift+p

ketik 
setting.json

pilih yang personal tambahkan
"terminal.integrated.fontFamily": "CaskaydiaCove Nerd Font Mono",