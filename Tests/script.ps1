# Interface principale (Menu)
function Show-Menu {
    Clear-Host
    Write-Host "========================="
    Write-Host "     MENU AD - PowerShell"
    Write-Host "========================="
    Write-Host "1. Créer utilisateurs depuis CSV"
    Write-Host "2. Désactiver comptes inactifs"
    Write-Host "3. Créer dossiers personnels"
    Write-Host "4. Générer rapport utilisateurs"
    Write-Host "5. Réinitialiser mot de passe utilisateurs"
    Write-Host "6. Lister groupes et membres"
    Write-Host "7. Désactiver comptes suspects"
    Write-Host "8. Ajouter un PC au domaine"
    Write-Host "9. Sauvegarder toutes les GPOs"
    Write-Host "10. Vérifier état des services AD"
    Write-Host "0. Quitter"
}

# Script 1
function Create-UsersFromCSV {
    $csvPath = Read-Host "Chemin du fichier CSV"
    Import-Csv $csvPath | ForEach-Object {
        New-ADUser -Name $_.Name -GivenName $_.Prenom -Surname $_.Nom -SamAccountName $_.Login `
            -UserPrincipalName "$($_.Login)@domaine.local" -AccountPassword (ConvertTo-SecureString "MotDePasse123!" -AsPlainText -Force) `
            -Enabled $true -Path "OU=Utilisateurs,DC=domaine,DC=local"
    }
    Write-Host "Utilisateurs créés avec succès."
}

# Script 2
function Disable-InactiveAccounts {
    Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly | Disable-ADAccount
    Write-Host "Comptes inactifs désactivés."
}

# Script 3
function Create-HomeFolders {
    $basePath = "C:\Partage\Users"
    Get-ADUser -Filter * | ForEach-Object {
        $folder = "$basePath\$($_.SamAccountName)"
        
        # Créer le dossier s'il n'existe pas
        if (-not (Test-Path -Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force
        }

        # Configurer les permissions
        $acl = New-Object System.Security.AccessControl.DirectorySecurity
        $ruleUser = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "$($_.SamAccountName)", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )
        $ruleSystem = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )
        $ruleAdmins = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )

        # Ajouter les règles au dossier
        $acl.SetAccessRule($ruleUser)
        $acl.AddAccessRule($ruleSystem)
        $acl.AddAccessRule($ruleAdmins)
        Set-Acl -Path $folder -AclObject $acl
    }
    Write-Host "Dossiers personnels créés avec permissions configurées."
}

# Script 4
function Export-UsersReport {
    Get-ADUser -Filter * -Properties LastLogonDate | 
        Select-Object Name, SamAccountName, Enabled, LastLogonDate |
        Export-Csv "C:\Rapport_Utilisateurs.csv" -NoTypeInformation
    Write-Host "Rapport généré dans C:\Rapport_Utilisateurs.csv"
}

# Script 5
function Reset-AllPasswords {
    Get-ADUser -Filter * | ForEach-Object {
        Set-ADAccountPassword -Identity $_ -NewPassword (ConvertTo-SecureString "MotDePasse123!" -AsPlainText -Force) -Reset
    }
    Write-Host "Mots de passe réinitialisés."
}

# Script 6
function Export-GroupsMembers {
    Get-ADGroup -Filter * | ForEach-Object {
        Get-ADGroupMember $_ | Select-Object Name, SamAccountName, @{Name="Group";Expression={$_.DistinguishedName}} 
    } | Export-Csv "C:\Groupes_Membres.csv" -NoTypeInformation
    Write-Host "Export des groupes et membres terminé."
}

# Script 7
function Disable-SuspiciousAccounts {
    $threshold = (Get-Date).AddDays(-30)
    Get-ADUser -Filter * -Properties LastBadPasswordAttempt | Where-Object {
        $_.LastBadPasswordAttempt -gt $threshold
    } | Disable-ADAccount
    Write-Host "Comptes suspects désactivés."
}

# Script 8
function Add-PCToDomain {
    $pcName = Read-Host "Nom du PC"
    Add-Computer -DomainName "domaine.local" -NewName $pcName -Restart
}

# Script 9
function Backup-AllGPOs {
    Backup-GPO -All -Path "C:\Backup-GPOs"
    Write-Host "Sauvegarde des GPOs terminée."
}

# Script 10
function Check-ADServices {
    $services = @("Netlogon", "NTDS", "DNS")
    foreach ($svc in $services) {
        Get-Service -Name $svc | Select-Object Name, Status
    }
}

# Boucle principale
Do {
    Show-Menu
    $choice = Read-Host "Choisir une option"
    Switch ($choice) {
        "1" { Create-UsersFromCSV }
        "2" { Disable-InactiveAccounts }
        "3" { Create-HomeFolders }
        "4" { Export-UsersReport }
        "5" { Reset-AllPasswords }
        "6" { Export-GroupsMembers }
        "7" { Disable-SuspiciousAccounts }
        "8" { Add-PCToDomain }
        "9" { Backup-AllGPOs }
        "10" { Check-ADServices }
        "0" { Write-Host "Sortie..." }
        Default { Write-Host "Option invalide." }
    }
    if ($choice -ne "0") { Pause }
} While ($choice -ne "0")
