# Install Microsoft Graph module - skip or comment out if you already have MS Graph module installed
# Install-Module Microsoft.Graph -Scope CurrentUser -AllowClobber

# Load the Microsoft Graph module
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module Microsoft.Graph.Users.Actions

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

# CSV path
$csvPath = "C:\Users\au23138\Documents\new_users_template_with_manager.csv"

# Process each user in the CSV
Import-Csv -Path $csvPath | ForEach-Object {
    Write-Host "Creating user: $($_.DisplayName)"

    # Create user using splatting
    $passwordProfile = @{
        Password = $_.Password
        ForceChangePasswordNextSignIn = $true
    }

    $userParams = @{
        DisplayName       = $_.DisplayName
        UserPrincipalName = $_.UserPrincipalName
        MailNickname      = $_.MailNickname
        AccountEnabled    = $true
        PasswordProfile   = $passwordProfile
        UsageLocation     = $_.UsageLocation
        GivenName         = $_.GivenName
        Surname           = $_.Surname
        JobTitle          = $_.JobTitle
        Department        = $_.Department
    }

    try {
        $user = New-MgUser @userParams
        Write-Host "User created: $($_.UserPrincipalName)"
    } catch {
        Write-Warning "❌ Failed to create user $($_.UserPrincipalName): $_"
        return
    }

    # Assign manager if provided
    if ($_.ManagerUPN -and $_.ManagerUPN -ne "") {
        try {
            $manager = Get-MgUser -UserId $_.ManagerUPN
            if ($manager) {
                Write-Host "Assigning manager: $($_.ManagerUPN)"
                Set-MgUserManagerByRef -UserId $user.Id -BodyParameter @{
                    "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($manager.Id)"
                }
            }
        } catch {
            Write-Warning "Could not assign manager $($_.ManagerUPN) for $($_.UserPrincipalName): $_"
        }
    } else {
        Write-Warning "❌ Skipping manager assignment because user creation failed or no ManagerUPN provided."
    }
}

Write-Host "All users processed!"

# --------------END --------------