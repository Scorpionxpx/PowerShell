# Script PowerShell pour vérifier l'existence d'utilisateurs inactifs et avec un mot de passe antérieur à 1 an dans Active Directory
# et générer un rapport au format CSV

# Définir la date limite pour les mots de passe (1 an en arrière)
$dateLimite = (Get-Date).AddYears(-1)

# Récupérer les utilisateurs inactifs ou avec un mot de passe antérieur à 1 an
$utilisateurs = Get-ADUser -Filter {Enabled -eq $false -or PasswordLastSet -lt $dateLimite} -Properties DisplayName, LastLogonDate, PasswordLastSet

# Créer une liste pour stocker les résultats
$resultats = @()

# Parcourir les utilisateurs et ajouter les informations à la liste des résultats
foreach ($utilisateur in $utilisateurs) {
    $resultat = [PSCustomObject]@{
        NomComplet       = $utilisateur.DisplayName
        DerniereConnexion = $utilisateur.LastLogonDate
        DernierMotDePasse = $utilisateur.PasswordLastSet
    }
    $resultats += $resultat
}

# Exporter les résultats au format CSV
$cheminRapport = "C:\Rapports\UtilisateursInactifs.csv"
$resultats | Export-Csv -Path $cheminRapport -NoTypeInformation -Encoding UTF8

Write-Output "Le rapport a été généré avec succès : $cheminRapport"
