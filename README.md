# make-windows-10-more-fast
dengan cara menghapus file blotware serta tweak pada sistem operasi windos nya tanpa ada nya over clock

1)	PINDAHKAN FILE SCRIP KE LOCAL DISK C
2)	BUKA POWERSHELL (RUN ADMINIST TRATOR)
3)	KETIK ( CD C:\ ) ENTER
4)	KETIK ( Set-ExecutionPolicy Unrestricted -Scope CurrentUser ) ENTER
5)	KETIK ( A )
6)	KETIK ( ls -Recurse *.ps*1 | Unblock-File ) ENTER ( INI LUMAYAN LAMA )
7)	KETIK ( CD SCRIPTS )
8)	KETIK ( .\NAMA-SCRIPTS ) CONTOH ( .\block-telemetry.ps1 ) ENTER CARA CEPAT BISA PENCET TAB 
9)	.\block-telemetry.ps1			( NGUMPULIN DATA YANG DI UPLOD KE MICROSOFT )
	
	.\disable-services.ps1			( DISABLE SERVICE YANG DI BUTUHKAN TELEMETRY )
	
	.\disable-windows-defender.ps1		( MENGHILANGKAN WINDOWS DEVENDER )
	
	.\experimental_unfuckery.ps1		( DISABLE APLIKASI DI PRODUC DAN CORTANA )
	
	.\fix-privacy-settings.ps1		( DISABLE APLIKASI BAWAAN WINDOWS KAYA PRIVASI LOKASI DLL )
	
	.\optimize-user-interface.ps1		( MEMPERCEPAT WINDOWS MENGHILANGKAN ANIMASI )
	
	.\optimize-windows-update.ps1		( WINDOWS UPDATE TP NGASI NOTIFIKASI NGAK AUTO DOWNLOAD )
	
	.\remove-default-apps.ps1		( MENGAHAPUS SOFTWARE YANG JARANG DI GUNAKAN SISA NYA UNINSTAL MANUAL )
	
	.\remove-onedrive.ps1			( DISABLE ONEDRIVE )

iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))

iwr -useb https://christitus.com/win | iex

10)	RUN AS ADMINIST TRATOR ( Windows10 Boost.bat ) ( MEMBERSIHKAN FILE FILE SISA YANG TIDAK BERGUNA )
11)	DOWNLOAD MICROSOFT PHOTOS ( https://www.microsoft.com/store/productId/9WZDNCRFJBH4 )
12) RESTART

iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))

LINK SOURCE

https://github.com/ChrisTitusTech/winutil

https://github.com/W4RH4WK/Debloat-Windows-10

https://drive.google.com/file/d/108hUshW0v-s3yjjWCAK0Zhmu5TZ0Mk_W/view
