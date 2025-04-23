## Azure Orphaned Accounts
Orphaned accounts are user accounts that are no longer associated with an active user. These accounts can pose significant security risks if not properly managed. In Microsoft Entra, it is crucial to look for and remove orphaned accounts to maintain a secure and efficient environment.

Orphaned accounts can be exploited by malicious actors to gain unauthorized access to sensitive information and resources. These accounts may still have permissions and access rights that can be used to compromise the system. Regularly auditing and removing orphaned accounts helps to mitigate these risks.

Orphaned accounts are user or service accounts that are no longer associated with an active user or service, often due to changes in personnel or decommissioned services. This tool helps in maintaining security and compliance by ensuring that these accounts are identified and handled appropriately.

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