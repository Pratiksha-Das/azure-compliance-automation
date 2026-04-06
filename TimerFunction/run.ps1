param($Timer, $TriggerMetadata)
Write-Host "Timer Function started: $(Get-Date)"
try {
    Connect-AzAccount -Identity
    $query = "PolicyResources | where type == 'microsoft.policyinsights/policystates' | where properties.complianceState == 'NonCompliant' | where properties.policyDefinitionAction == 'audit' | project resourceId = tostring(properties.resourceId), resourceType = tostring(properties.resourceType) | limit 50"
    $results = Search-AzGraph -Query $query
    Write-Host "Found $($results.Count) non-compliant resources"
    $messages = @()
    foreach ($resource in $results) {
        $message = @{ resourceId = $resource.resourceId; resourceType = $resource.resourceType; timestamp = (Get-Date).ToString("o") } | ConvertTo-Json -Compress
        $messages += $message
        Write-Host "Queued: $($resource.resourceId)"
    }
    Push-OutputBinding -Name outputQueueItem -Value $messages
    Write-Host "Timer Function completed. Queued $($messages.Count) resources."
} catch {
    Write-Error "Timer Function failed: $_"
    throw
}
