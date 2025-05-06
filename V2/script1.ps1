# Menu interactif pour choisir et exécuter un script
function Show-Menu {
    Clear-Host
    Write-Host "=== Menu des Scripts ===" -ForegroundColor Cyan
    Write-Host "1. Création d’un utilisateur avec mot de passe temporaire"
    Write-Host "2. Modification en masse des informations d’utilisateurs"
    Write-Host "3. Réinitialisation de mot de passe pour plusieurs utilisateurs"
    Write-Host "4. Création d’un groupe et ajout d’utilisateurs"
    Write-Host "5. Lister les membres d’un groupe"
    Write-Host "6. Création automatique de dossiers (simulant des OU)"
    Write-Host "7. Lister les utilisateurs ayant une description"
    Write-Host "8. Lister les utilisateurs inactifs depuis plus de 90 jours"
    Write-Host "9. Lister les utilisateurs n'ayant pas changé leur mot de passe depuis plus d'un an"
    Write-Host "0. Quitter"
}

function Execute-Script {
    param (
        [int]$choice
    )

    switch ($choice) {
        1 { 
            Write-Host "Exécution du script 1 : Création d’un utilisateur avec mot de passe temporaire..." -ForegroundColor Green
            $username = "TempUser"
            $password = ConvertTo-SecureString "Temp@1234" -AsPlainText -Force
            $ou = "OU=OU-JULES-EXAM,DC=gsb,DC=coop" 

            # Vérifie si l'OU existe
            if (-Not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue)) {
                Write-Host "L'OU spécifiée n'existe pas : $ou" -ForegroundColor Red
                return
            }

            # Vérifie si l'utilisateur existe déjà
            if (Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue) {
                Write-Host "L'utilisateur $username existe déjà dans Active Directory." -ForegroundColor Yellow
            } else {
                try {
                    # Crée l'utilisateur Active Directory
                    New-ADUser -SamAccountName $username -UserPrincipalName "$username@example.com" `
                        -Name $username -AccountPassword $password -Enabled $true `
                        -Path $ou -GivenName "Temp" -Surname "User" -Description "Compte temporaire"
                    Write-Host "Utilisateur AD créé : $username avec mot de passe temporaire : Temp@1234" -ForegroundColor Green
                } catch {
                    Write-Host "Erreur lors de la création de l'utilisateur : $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
        2 { 
            Write-Host "Exécution du script 2 : Modification en masse des informations d’utilisateurs..." -ForegroundColor Green
            $users = Import-Csv "C:\Users\UpdateUsers.csv"
            foreach ($user in $users) {
                Write-Host "Modification de l’utilisateur : $($user.Name) avec les nouvelles informations."
            }
        }
        3 { 
            Write-Host "Exécution du script 3 : Réinitialisation de mot de passe..." -ForegroundColor Green

            # Demande l'identifiant de l'utilisateur
            $username = Read-Host "Entrez l'identifiant de l'utilisateur pour réinitialiser le mot de passe"

            # Vérifie si l'utilisateur existe
            $user = Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue
            if (-Not $user) {
                Write-Host "L'utilisateur $username n'existe pas dans Active Directory." -ForegroundColor Red
                return
            }

            # Génère un nouveau mot de passe temporaire
            $newPassword = ConvertTo-SecureString "NewTemp@1234" -AsPlainText -Force

            try {
                # Réinitialise le mot de passe
                Set-ADAccountPassword -Identity $username -NewPassword $newPassword -Reset
                Write-Host "Le mot de passe de l'utilisateur $username a été réinitialisé avec succès." -ForegroundColor Green
                Write-Host "Nouveau mot de passe temporaire : NewTemp@1234" -ForegroundColor Yellow
            } catch {
                Write-Host "Erreur lors de la réinitialisation du mot de passe : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        4 { 
            Write-Host "Exécution du script 4 : Création d’un groupe et ajout d’utilisateurs..." -ForegroundColor Green
            $groupName = "IT_Security"
            $users = Get-Content "C:\Users\GroupMembers.txt"
            Write-Host "Groupe créé : $groupName"
            foreach ($user in $users) {
                Write-Host "Ajout de l’utilisateur : $user au groupe $groupName"
            }
        }
        5 { 
            Write-Host "Exécution du script 5 : Lister les membres d’un groupe..." -ForegroundColor Green
            $groupName = "IT_Security"
            Write-Host "Liste des membres du groupe $groupName exportée dans GroupMembers.csv"
        }
        6 { 
            Write-Host "Exécution du script 6 : Création automatique de dossiers..." -ForegroundColor Green
            $folders = @("HR", "IT", "Finance", "Marketing")
            foreach ($folder in $folders) {
                New-Item -ItemType Directory -Path "C:\Structure\$folder" -Force
                Write-Host "Dossier créé : $folder"
            }
        }
        7 { 
            Write-Host "Exécution du script 7 : Lister les utilisateurs ayant une description..." -ForegroundColor Green
            try {
                # Récupère les utilisateurs ayant une description
                $usersWithDescription = Get-ADUser -Filter {Description -like "*"} -Properties Description
                if ($usersWithDescription) {
                    foreach ($user in $usersWithDescription) {
                        Write-Host "Utilisateur : $($user.SamAccountName), Description : $($user.Description)"
                    }
                } else {
                    Write-Host "Aucun utilisateur avec une description trouvée." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "Erreur lors de la récupération des utilisateurs : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        8 { 
            Write-Host "Exécution du script 8 : Lister les utilisateurs inactifs depuis plus de 90 jours..." -ForegroundColor Green
            try {
                # Récupère les utilisateurs inactifs depuis plus de 90 jours
                $inactiveUsers = Get-ADUser -Filter * -Properties LastLogonDate | Where-Object {
                    $_.LastLogonDate -and ($_.LastLogonDate -lt (Get-Date).AddDays(-90))
                }
                if ($inactiveUsers) {
                    foreach ($user in $inactiveUsers) {
                        Write-Host "Utilisateur : $($user.SamAccountName), Dernière connexion : $($user.LastLogonDate)"
                    }
                } else {
                    Write-Host "Aucun utilisateur inactif depuis plus de 90 jours trouvé." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "Erreur lors de la récupération des utilisateurs inactifs : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        9 { 
            Write-Host "Exécution du script 9 : Lister les utilisateurs n'ayant pas changé leur mot de passe depuis plus d'un an..." -ForegroundColor Green
            try {
                # Récupère les utilisateurs n'ayant pas changé leur mot de passe depuis plus d'un an
                $usersWithOldPasswords = Get-ADUser -Filter * -Properties PasswordLastSet | Where-Object {
                    $_.PasswordLastSet -and ($_.PasswordLastSet -lt (Get-Date).AddYears(-1))
                }
                if ($usersWithOldPasswords) {
                    foreach ($user in $usersWithOldPasswords) {
                        Write-Host "Utilisateur : $($user.SamAccountName), Dernier changement de mot de passe : $($user.PasswordLastSet)"
                    }
                } else {
                    Write-Host "Aucun utilisateur n'a changé son mot de passe depuis plus d'un an." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "Erreur lors de la récupération des utilisateurs : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        0 { 
            Write-Host "Quitter le menu. Au revoir !" -ForegroundColor Yellow
            exit
        }
        default { 
            Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red 
        }
    }
}

# Boucle principale du menu
do {
    Show-Menu
    $choice = Read-Host "Entrez votre choix (0-9)"
    Execute-Script -choice $choice
    Pause
} while ($choice -ne 0)