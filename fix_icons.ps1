Add-Type -AssemblyName System.Drawing
$files = Get-ChildItem -Path "android\app\src\main\res\mipmap-*" -Filter "ic_launcher*"
foreach ($file in $files) {
    try {
        if ($file.Extension -eq '.png' -or $file.Extension -eq '.jpg') {
            $img = [System.Drawing.Image]::FromFile($file.FullName)
            $pngPath = "$($file.DirectoryName)\ic_launcher.png"
            
            if ($file.FullName -ne $pngPath) {
                # Case where we are converting from .jpg back to .png
                $img.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
                $img.Dispose()
                Remove-Item -Path $file.FullName -Force
                Write-Host "Converted and renamed: $($file.FullName) -> $pngPath"
            } else {
                # Case where the file is named .png but is actually a JPEG
                $tempPath = "$($file.FullName).tmp.png"
                $img.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
                $img.Dispose()
                Remove-Item -Path $file.FullName -Force
                Move-Item -Path $tempPath -Destination $file.FullName -Force
                Write-Host "Re-encoded to true PNG: $($file.FullName)"
            }
        }
    } catch {
        Write-Host "Failed: $($file.FullName) - $($_.Exception.Message)"
    }
}
