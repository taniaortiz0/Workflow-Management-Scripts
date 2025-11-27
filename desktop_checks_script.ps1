# Set the Desktop Directory
$DesktopDir = "$env:USERPROFILE\Desktop" #You can add OneDrive if you have one.

Write-Host "Contents of the Desktop folder:" -ForegroundColor Gray
Write-Host "---------------------------------"

# Get all files in Desktop and subfolders
$AllFiles = Get-ChildItem -Path $DesktopDir -File -Recurse |
    Select-Object FullName, Name, CreationTime, LastAccessTime

# Display all files
$AllFiles | Format-Table Name, CreationTime, LastAccessTime -AutoSize

# Detect duplicate copies with number patterns
$copyFiles = $AllFiles | Where-Object { $_.Name -match '\(\d+\)' }

if ($copyFiles.Count -gt 0) {

    Write-Host "`nDisplaying duplicate copies:" -ForegroundColor Yellow
    Write-Host "---------------------------------"

    $copyFiles | Format-Table Name, LastAccessTime, FullName -AutoSize

    # Prompt for deletion one by one
    foreach ($file in $copyFiles) {
        $prompt = Read-Host "`nDo you want to delete this file?`n$($file.FullName)`n[Y/N]"
        if ($prompt -eq 'Y') {
            try {
                Remove-Item -Path $file.FullName -Force
                Write-Host "Deleted: $($file.FullName)" -ForegroundColor Green
            } catch {
                Write-Host "Failed to delete: $($file.FullName) -- $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Skipped deletion for: $($file.FullName)" -ForegroundColor Yellow
        }
    }

    Write-Host "`nPrompt-based deletion complete." -ForegroundColor Cyan

} else {
    Write-Host "`nNo duplicate copies found." -ForegroundColor Green
}
