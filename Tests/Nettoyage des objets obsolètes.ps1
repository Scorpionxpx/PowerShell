# Script PowerShell pour nettoyer les objets obsolètes dans Active Directory et générer un rapport CSV


# Définir la date limite pour considérer un objet comme obsolète (par exemple, 90 jours)
$daysInactive = 90
$dateLimit = (Get-Date).AddDays(-$daysInactive)

# Rechercher les comptes d'utilisateurs inactifs
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $dateLimit} -Properties LastLogonDate

# Rechercher les comptes d'ordinateurs inactifs
$inactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $dateLimit} -Properties LastLogonDate

# Créer une liste pour stocker les objets obsolètes
$obsoleteObjects = @()

# Ajouter les utilisateurs inactifs à la liste
foreach ($user in $inactiveUsers) {
    $obsoleteObjects += [PSCustomObject]@{
        Type = "User"
        Name = $user.SamAccountName
        LastLogonDate = $user.LastLogonDate
    }
}

# Ajouter les ordinateurs inactifs à la liste
foreach ($computer in $inactiveComputers) {
    $obsoleteObjects += [PSCustomObject]@{
        Type = "Computer"
        Name = $computer.Name
        LastLogonDate = $computer.LastLogonDate
    }
}

# Définir le chemin du rapport CSV dans le même dossier que le script
$reportPath = Join-Path -Path $PSScriptRoot -ChildPath "Rapport_Obsoletes.csv"

# Exporter le rapport en CSV
$obsoleteObjects | Export-Csv -Path $reportPath -NoTypeInformation

# Supprimer les utilisateurs inactifs
foreach ($user in $inactiveUsers) {
    Remove-ADUser -Identity $user -Confirm:$false
    Write-Host "Utilisateur supprimé : $($user.SamAccountName)"
}

# Supprimer les ordinateurs inactifs
foreach ($computer in $inactiveComputers) {
    Remove-ADComputer -Identity $computer -Confirm:$false
    Write-Host "Ordinateur supprimé : $($computer.Name)"
}

Write-Host "Nettoyage des objets obsolètes terminé. Rapport enregistré à : $reportPath"