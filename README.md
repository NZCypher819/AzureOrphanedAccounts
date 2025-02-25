## Azure Orphaned Accounts
Azure Orphaned Accounts is a simple tool designed to identify and manage orphaned accounts in Azure. Orphaned accounts are user or service accounts that are no longer associated with an active user or service, often due to changes in personnel or decommissioned services. This tool helps in maintaining security and compliance by ensuring that these accounts are identified and handled appropriately.

## Features
- Scans Azure Roles for orphaned accounts
- Provides a report on identified accounts
- Supports automated remediation actions
- Integrates with existing Azure management workflows

## Getting Started
To get started with AzureOrphanedAccounts, follow these steps:
1. Clone the repository: `git clone https://github.com/yourusername/AzureOrphanedAccounts.git`
2. Navigate to the project directory: `cd AzureOrphanedAccounts`
3. Run the PowerShell Script in PS7
```powershell
.\AzureOrphanedAccounts.ps1 -tenantid <YOUR_TENANT_ID>
```

## Permissions
The following ard the required permissions to execute the script against a Azure Tenant.
- Microsoft.Authorization/roleAssignments/read
- Microsoft.Authorization/roleAssignments/delete