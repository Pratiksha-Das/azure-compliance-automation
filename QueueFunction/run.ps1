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
    Write-Host "SUCCESS: Tag applied to $resourceId"
} catch {
    Write-Error "FAILED: $_"
    throw
}
