param(
    [string]$ResourceGroupName,
    [string]$DataFactoryName,
    [int]$PollIntervalSeconds = 30
)

# Start time (how far back to look)
$startTime = (Get-Date).AddDays(-1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$endTime = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

do {

    $runningPipelines = az datafactory pipeline-run query-by-factory `
        --resource-group $ResourceGroupName `
        --factory-name $DataFactoryName `
        --last-updated-after $startTime `
        --last-updated-before $endTime `
        --filters operand="Status" operator="Equals" values="InProgress" `
        --query "value[].{PipelineName:pipelineName, RunId:runId}" `
        --output json | ConvertFrom-Json

    if ($runningPipelines) {
        Write-Host "Still running:" -ForegroundColor Yellow
        $runningPipelines | Format-Table -AutoSize
        Start-Sleep -Seconds $PollIntervalSeconds
    }
} while ($runningPipelines)

Write-Host "No pipelines running. Done." -ForegroundColor Green
