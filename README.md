# 🚀 Entra ID Bulk User Creation Script

This PowerShell script automates the creation of new Entra ID (Azure AD) user accounts from a CSV file. It also handles manager assignment, and group membership — even auto-creates missing groups!

---

## 📂 Files

- `Create-EntraID-Users.ps1` — The main script.
- `new_users_template_with_manager_and_groups.csv` — Sample input CSV file. Customize it with your users.

---

## 📋 CSV Template Format

Here's what the CSV file should include:

| DisplayName | GivenName | Surname | UserPrincipalName           | MailNickname   | Password      | JobTitle       | Department  | UsageLocation  | ManagerUPN                      | GroupMembership       |
|-------------|------------|---------|-----------------------------|---------------|----------------|---------------|-------------|----------------|---------------------------------|-----------------------|
| John Doe    | John       | Doe     | john.doe@yourdomain.com     | johndoe       | TempPass123!   | Developer     | IT          | US             | jane.manager@yourdomain.com     | IT Team; DevOps Squad |
| Mary Smith  | Mary       | Smith   | mary.smith@yourdomain.com   | marysmith     | TempPass456!   | HR Manager    | HR          | UK             | john.doe@yourdomain.com         | HR Team               |

**What the Script Does**
Creates each user in Entra ID with a temporary password.

Assigns job title, department, and usage location.

Sets their manager if ManagerUPN is specified.

Adds the user to one or more groups (and creates the group if missing).

**🚨 Notes**
Make sure you have appropriate admin permissions.

Double-check the UPNs and group names to avoid duplication or errors.

Newly created accounts will require the user to change their password at first sign-in


