# NOTE: I have placed some Foreground colors for user readability.

$DownloadsDir = "$env:USERPROFILE\Downloads" #You can add \OneDrive before the \Downloads path to display the contents of the Downloads directory with OneDrive included.

Write-Host "Contents of the Downloads folder:" -ForegroundColor Gray
Write-Host "---------------------------------"

Get-ChildItem -Path $DownloadsDir -File -Recurse | Select-Object Name, LastAccessTime

$Files = Get-ChildItem -Path $DownloadsDir -File -Recurse | Select-Object Name, LastAccessTime

$copyFiles = $Files | Where-Object { $_.Name -match '\(\d+\)' }

if ($copyFiles.Count -gt 0) {

    Write-Host "`nDisplaying duplicate copies:" -ForegroundColor Yellow
    Write-Host "---------------------------------"

    $copyFiles | Format-Table Name, LastAccessTime, FullName -AutoSize

    # Single prompt to delete all
    $groupPrompt = Read-Host "`nDelete ALL duplicate copies listed above? (Y/N)"
    if ($groupPrompt -eq 'Y') {
        foreach ($file in $copyFiles) {
            try {
                Remove-Item -Path $file.FullName -Force
                Write-Host "Deleted: $($file.FullName)" -ForegroundColor Green
            } catch {
                Write-Host "Failed to delete: $($file.FullName) -- $_" -ForegroundColor Red
            }
        }
        Write-Host "`nBatch deletion complete." -ForegroundColor Cyan
    } else {
        Write-Host "`nNo files were deleted." -ForegroundColor Yellow
    }

} else {
    Write-Host "`nNo duplicate copies found." -ForegroundColor Green
}
