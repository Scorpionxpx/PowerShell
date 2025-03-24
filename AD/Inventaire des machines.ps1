# Script PowerShell pour générer un rapport d'inventaire des machines


# Obtenir la liste des ordinateurs dans le domaine
$computers = Get-ADComputer -Filter * -Property Name, OperatingSystem, LastLogonDate

# Créer un tableau pour stocker les informations des ordinateurs
$computerInventory = @()

# Parcourir chaque ordinateur et ajouter les informations au tableau
foreach ($computer in $computers) {
    $computerInfo = [PSCustomObject]@{
        Nom             = $computer.Name
        SystemeOperatif = $computer.OperatingSystem
        DerniereConnexion = $computer.LastLogonDate
    }
    $computerInventory += $computerInfo
}

# Définir le chemin du fichier CSV dans le même dossier que le script
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath "InventaireDesMachines.csv"

# Exporter le tableau en fichier CSV
$computerInventory | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Output "Le rapport d'inventaire des machines a été généré avec succès et sauvegardé dans $csvPath"