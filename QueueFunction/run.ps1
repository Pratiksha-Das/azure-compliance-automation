param([string] $QueueItem, $TriggerMetadata)
Write-Host "Queue Function triggered"
try {
    $resource = $QueueItem | ConvertFrom-Json
    $resourceId = $resource.resourceId
    Write-Host "Processing: $resourceId"
    Connect-AzAccount -Identity
    $existingTags = (Get-AzResource -ResourceId $resourceId -ErrorAction SilentlyContinue).Tags
    if ($null -eq $existingTags) { Write-Host "Resource not found — skipping"; return }
    if ($existingTags.ContainsKey("Environment")) { Write-Host "Already compliant — skipping"; return }
    Update-AzTag -ResourceId $resourceId -Tag @{ Environment = "Untagged-AutoRemediated" } -Operation Merge
    $logEntry = @{ resourceId = $resourceId; status = "SUCCESS"; action = "Tag added: Environment=Untagged-AutoRemediated"; timestamp = (Get-Date).ToString("o") } | ConvertTo-Json
    Write-Host $logEntry
} catch {
    $logEntry = @{ resourceId = $resourceId; status = "FAILED"; error = $_.ToString(); timestamp = (Get-Date).ToString("o") } | ConvertTo-Json
    Write-Error $logEntry
    throw
}
