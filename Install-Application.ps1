$path = "\\PARAG-ISWALKAR\Software\"
$softwares = import-csv "\\PARAG-ISWALKAR\Software\pkgs.csv" -Delimiter "," -Header 'Installer','switch' | Select-Object Installer,Switch

foreach($software in $softwares) {
	$softexec = $software.Installer
	$softexec = $softexec.ToString()
	
	$pkgs = Get-ChildItem $path$softexec | Where-Object {$_.Name -eq $softexec}
	
	foreach($pkg in $pkgs) {
		$ext = [System.IO.Path]::GetExtension($pkg)
		$ext = $ext.ToLower()
		
		$switch = $software.Switch
		$switch = $switch.ToString()
		
		if($ext -eq ".msi") {
			mkdir C:\Temp\Softwares -Force
			Copy-Item "$path$softexec" -Recurse C:\Temp\Softwares -Force
			Write-host "Installing $softexec silently, please wait...." -foregroundColor Yellow
			Start-Process "C:\Temp\Softwares\$softexec" -ArgumentList "$switch" -wait
			
			Remove-item "C:\Temp\Softwares\$softexec" -Recurse -Force
			Write-host "Installation of $softexec Completed" -foregroundColor Green			
		}else {
			mkdir C:\Temp\Softwares -Force
			Copy-Item "$path$softexec" -Recurse C:\Temp\Softwares -Force
			Write-host "Installing $softexec silently, please wait...." -foreroundColor Yellow
			Start-Process "C:\Temp\Softwares\$softexec" -ArgumentList "$switch" -wait -NoNewWindow
			
			Remove-item "C:\Temp\Softwares\$softexec" -Recurse -Force
			Write-host "Installation of $softexec Completed" -foregroundColor Green
		}
	}
}