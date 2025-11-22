# Set the Desktop Directory
$DesktopDir = "$env:USERPROFILE\Desktop" # You can add \OneDrive before the \Downloads path to display the contents of the Downloads directory within OneDrive included.

Write-Host "Contents of the Desktop folder:" -ForegroundColor Gray
Write-Host "---------------------------------"

# Get all files in Desktop and subfolders
$AllFiles = Get-ChildItem -Path $DesktopDir -File -Recurse 
    Select-Object FullName, Name, CreationTime, LastAccessTime

# Display all files
$AllFiles | Format-Table Name, CreationTime, LastAccessTime -AutoSize

# Detect duplicate copies
$copyFiles = $AllFiles | Where-Object { $_.Name -match '\(\d+\)' }

if ($copyFiles.Count -gt 0) {

    Write-Host "`nDisplaying duplicate copies:" -ForegroundColor Yellow
    Write-Host "---------------------------------"

    $copyFiles | Format-Table Name, LastAccessTime

    # Prompt for deletion one by one
    foreach ($file in $copyFiles) {
        $prompt = Read-Host "`nDo you want to delete this file?`n$($file.Name)`n[Y/N]"
        if ($prompt -eq 'Y') {
            try {
                Remove-Item -Path $file.Name -Force
                Write-Host "Deleted: $($file.Name)" -ForegroundColor Green
            } catch {
                Write-Host "Failed to delete: $($file.Name) -- $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Skipped deletion for: $($file.Name)" -ForegroundColor Yellow
        }
    }
    Write-Host "`nPrompt-based deletion complete." -ForegroundColor Cyan

} else {
    Write-Host "`nNo duplicate copies found." -ForegroundColor Green
}


