<#
    This PowerShell script is designed to find roles which have orphaned accounts associated with it. 
    A orphan account normally means that the account has been deleted from Entra ID but the role assignment still exists.

    The script will prompt the user to delete the orphaned role assignments.

    -tenantID: The Azure Tenant ID required for authentication.

    Example: 
    .\AzureOrphanedAccounts.ps1 -tenant <YOUR_TENANT_ID>

    Repo: https://github.com/NZCypher819/AzureOrphanedAccounts

    Author: 
    C Cunningham
    Principal Consultant
    Microsoft ISD EAG
#>

param (
    $tenantID = '', # Azure Tenant ID
    $scriptv = "1.0.2502" # Script Version
)

# Check if the Tenant ID and the SubscriptionID is set
if ($TenantID -eq '') {
    Write-Host "Please provide the Tenant ID using the -TenantID parameter." -ForegroundColor Red
    Exit
}

# Welcome Message
$welcomeMsg = @"
  ___                       _____            _                          _    ___                            _       
 / _ \                     |  _  |          | |                        | |  / _ \                          | |      
/ /_\ \_____   _ _ __ ___  | | | |_ __ _ __ | |__   __ _ _ __   ___  __| | / /_\ \ ___ ___ ___  _   _ _ __ | |_ ___ 
|  _  |_  / | | | '__/ _ \ | | | | '__| '_ \| '_ \ / _` | '_ \ / _ \/ _` | |  _  |/ __/ __/ _ \| | | | '_ \| __/ __|
| | | |/ /| |_| | | |  __/ \ \_/ / |  | |_) | | | | (_| | | | |  __/ (_| | | | | | (_| (_| (_) | |_| | | | | |_\__ \
\_| |_/___|\__,_|_|  \___|  \___/|_|  | .__/|_| |_|\__,_|_| |_|\___|\__,_| \_| |_/\___\___\___/ \__,_|_| |_|\__|___/
                                      | |                                                                           
                                      |_|                                                                           
              
By C. Cunningham 
Version: $scriptv

"@
Clear-Host
Write-Host $welcomeMsg -ForegroundColor Red

# Start the timer
$startTime = [DateTime]::Now
Write-Host -ForegroundColor DarkGreen "Start time: $($startTime.ToString("hh:mm:ss"))"

# Connect to Azure - If not already connected
write-host "Checking for Azure login context." -ForegroundColor DarkYellow
$currentContext = Get-AzContext
if ($currentContext -and $currentContext.Tenant.Id -eq $tenantID) {
    Write-Host "Already logged into the specified tenant and subscription. Switching Az Context to make sure." -ForegroundColor Green
    Set-AzContext -TenantId $tenantID | Out-Null
}
else {
    Write-Host "Logging into the specified tenant." -ForegroundColor Yellow
    Connect-AzAccount -Tenant $tenantID | Out-Null
}

# Retrieve all role assignments in the tenant
Write-Host "Retrieving all role assignments in the tenant..." -ForegroundColor DarkYellow
$roleAssignments = Get-AzRoleAssignment

# Find orphaned role assignments (role assignments without any corresponding user)
Write-Host "Finding orphaned role assignments..." -ForegroundColor DarkYellow
Write-Host ""
$orphanedRoleAssignments = $roleAssignments | Where-Object {
    $_.ObjectType -eq 'Unknown'
}

# Display orphaned role assignments
if ($orphanedRoleAssignments.Count -eq 0) {
    Write-Host "No orphaned role assignments found." -ForegroundColor Green
} else {
    Write-Host "Orphaned role assignments found:" -ForegroundColor Red
    $orphanedRoleAssignments | ForEach-Object {
        Write-Host $_.SignInName $_.ObjectId 'in' $_.RoleDefinitionName -ForegroundColor Red
    }
    Write-Host ""

    # Ask if the user wants to delete the orphaned role assignments
    $deleteRoleAssignmentsPrompt = Read-Host "Do you want to delete the orphaned role assignments from Azure? (yes/no)" 
    if ($deleteRoleAssignmentsPrompt -eq "yes" -or $deleteRoleAssignmentsPrompt -eq "y") {
        Write-Host ""
        Write-Host "Removing orphaned role assignments..." -ForegroundColor DarkYellow
        $orphanedRoleAssignments | ForEach-Object {
            Remove-AzRoleAssignment -ObjectId $_.ObjectId -RoleDefinitionName $_.RoleDefinitionName
            Write-Host "Removed orphaned role assignment: $($_.SignInName) $($_.ObjectId)" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Leaving the role assignments alone" -ForegroundColor Red
    }
}

# End the timer & Finish Up.
$endTime = [DateTime]::Now
$elapsedTime = $endTime - $startTime
$formattedElapsedTime = "{0:hh\:mm\:ss\.ff}" -f $elapsedTime
Write-Host ""
Write-Host "All Jobs Completed." -ForegroundColor DarkGreen
Write-Host -ForegroundColor DarkGreen "Completion Time: $formattedElapsedTime"
# End of Script