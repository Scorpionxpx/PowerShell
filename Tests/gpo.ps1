# Script PowerShell pour générer des rapports CSV, connecter des lecteurs réseaux et déployer d'autres scripts via GPO

# Définir les variables
$rapportCSV = "$PSScriptRoot\rapport.csv"
$lecteurReseau = "\\serveur\partage"
$lettreLecteur = "Z:"
$scriptADéployer = "$PSScriptRoot\autreScript.ps1"

# Fonction pour générer un rapport CSV
function GenererRapportCSV {
    $data = @(
        [PSCustomObject]@{Nom="Utilisateur1"; Action="Connecté"}
        [PSCustomObject]@{Nom="Utilisateur2"; Action="Déconnecté"}
    )
    $data | Export-Csv -Path $rapportCSV -NoTypeInformation
    Write-Output "Rapport CSV généré : $rapportCSV"
}

# Fonction pour connecter un lecteur réseau
function ConnecterLecteurReseau {
    New-PSDrive -Name $lettreLecteur -PSProvider FileSystem -Root $lecteurReseau -Persist
    Write-Output "Lecteur réseau connecté : $lettreLecteur -> $lecteurReseau"
}

# Fonction pour déployer un autre script
function DeployerScript {
    if (Test-Path $scriptADéployer) {
        & $scriptADéployer
        Write-Output "Script déployé : $scriptADéployer"
    } else {
        Write-Output "Le script à déployer n'existe pas : $scriptADéployer"
    }
}

# Appeler les fonctions
GenererRapportCSV
ConnecterLecteurReseau
DeployerScript