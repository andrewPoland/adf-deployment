param(
    [string]$ResourceGroup,
    [string]$DataFactoryName,
    [string]$TriggerConfig
)

# Read the JSON file
$triggers = Get-Content $TriggerConfig | ConvertFrom-Json

foreach ($trigger in $triggers.enabled) {
    Write-Host "Enabling trigger: $trigger"
    az datafactory trigger start `
        --resource-group $resourceGroup `
        --factory-name $dataFactoryName `
        --name $trigger
}
    
# Disable triggers from the "disabled" list
foreach ($trigger in $triggers.disabled) {
    Write-Host "Disabling trigger: $trigger"
    az datafactory trigger stop `
        --resource-group $resourceGroup `
        --factory-name $dataFactoryName `
        --name $trigger
}    
    
Write-Host "Trigger processing complete."
