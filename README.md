# Make Windows 10 Faster

Optimize your Windows 10 by removing bloatware and tweaking the operating system without overclocking.

## Description

This guide provides steps to enhance the performance of Windows 10 by removing unnecessary files and services, and optimizing system settings. Follow the instructions carefully to achieve a faster and more efficient Windows 10 experience.

## Steps

1. **Move Script Files to Local Disk C:**
   - Transfer the script files to the root of Local Disk C.

2. **Open PowerShell as Administrator:**
   - Right-click on PowerShell and select "Run as Administrator".

3. **Navigate to Local Disk C:**
   - Type `CD C:\` and press Enter.

4. **Set Execution Policy:**
   - Type `Set-ExecutionPolicy Unrestricted -Scope CurrentUser` and press Enter.
   - Type `A` and press Enter to confirm.

5. **Unblock Script Files:**
   - Type `ls -Recurse *.ps*1 | Unblock-File` and press Enter. (This may take some time)

6. **Navigate to Scripts Directory:**
   - Type `CD SCRIPTS` and press Enter.

7. **Run the Desired Script:**
   - Type `.\NAMA-SCRIPTS` and press Enter. For example, `.\block-telemetry.ps1` and press Enter. You can use the Tab key for auto-completion.

8. **Available Scripts:**
   - `.\block-telemetry.ps1` (Collects data uploaded to Microsoft)
   - `.\disable-services.ps1` (Disables services required for telemetry)
   - `.\disable-windows-defender.ps1` (Disables Windows Defender)
   - `.\experimental_unfuckery.ps1` (Disables Cortana and other built-in apps)
   - `.\fix-privacy-settings.ps1` (Disables built-in Windows apps like location privacy, etc.)
   - `.\optimize-user-interface.ps1` (Speeds up Windows by removing animations)
   - `.\optimize-windows-update.ps1` (Windows Update with notifications, no auto-download)
   - `.\remove-default-apps.ps1` (Removes rarely used software, the rest can be uninstalled manually)
   - `.\remove-onedrive.ps1` (Disables OneDrive)

9. **Run Additional Commands:**
   - `iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JJ8R4'))`
   - `iwr -useb https://christitus.com/win | iex`

10. **Run Windows10 Boost.bat as Administrator:**
    - This cleans up unnecessary residual files.

11. **Download Microsoft Photos:**
    - [Microsoft Photos](https://www.microsoft.com/store/productId/9WZDNCRFJBH4)

12. **Restart:**
    - Restart your computer to apply all changes.

## Additional Resources

- [ChrisTitusTech Winutil](https://github.com/ChrisTitusTech/winutil)
- [W4RH4WK Debloat-Windows-10](https://github.com/W4RH4WK/Debloat-Windows-10)
- [Google Drive Source](https://drive.google.com/file/d/108hUshW0v-s3yjjWCAK0Zhmu5TZ0Mk_W/view)