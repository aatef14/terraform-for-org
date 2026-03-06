# PowerShell script to synchronize Terraform files from dev to stg and prod environments.
# Development purpose: Maintain consistency across environments.

$SourceDir = Join-Path $PSScriptRoot "..\environments\dev"
$TargetDirs = @(
    (Join-Path $PSScriptRoot "..\environments\stg"),
    (Join-Path $PSScriptRoot "..\environments\prod")
)

foreach ($TargetDir in $TargetDirs) {
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "Created directory: $TargetDir" -ForegroundColor Cyan
    }

    Write-Host "Synchronizing files to: $TargetDir" -ForegroundColor Yellow

    # Copy *.tf files
    Get-ChildItem -Path $SourceDir -Filter "*.tf" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $TargetDir -Force
        Write-Host "  Copying: $($_.Name)"
    }

    # Copy *.tfvars files
    Get-ChildItem -Path $SourceDir -Filter "*.tfvars" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $TargetDir -Force
        Write-Host "  Copying: $($_.Name)"
    }
}

Write-Host "Synchronization complete!" -ForegroundColor Green
