param(
    [string]$ResourceGroupName,
    [string]$DataFactoryName,
    [string]$TriggerConfig
)

# Read the JSON file
$triggers = Get-Content $TriggerConfig | ConvertFrom-Json

foreach ($trigger in $triggers.enabled) {
    Write-Host "Enabling trigger: $trigger"
    az datafactory trigger start `
        --resource-group $ResourceGroupName `
        --factory-name $DataFactoryName `
        --name $trigger
}
    
# Disable triggers from the "disabled" list
foreach ($trigger in $triggers.disabled) {
    Write-Host "Disabling trigger: $trigger"
    az datafactory trigger stop `
        --resource-group $ResourceGroupName `
        --factory-name $DataFactoryName `
        --name $trigger
}    
    
Write-Host "Trigger processing complete."
