# Azure Compliance Automation - Detection Script
param(
    [string]$StorageAccountName = "stgacc123",
    [string]$QueueName = "compliance-queue"
)

Write-Output "Running ARG query..."
$query = "PolicyResources | where type == 'microsoft.policyinsights/policystates' | where properties.complianceState == 'NonCompliant' | project resourceId = tostring(properties.resourceId), resourceType = tostring(properties.resourceType) | limit 10"
$results = Search-AzGraph -Query $query
Write-Output "Found $($results.Count) non-compliant resources"

$storageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName "RGtest"
$ctx = $storageAccount.Context
$queue = Get-AzStorageQueue -Name $QueueName -Context $ctx

foreach ($resource in $results) {
    $msg = $resource.resourceId
    Write-Output "Queued: $msg"
}
Write-Output "Detection complete."
