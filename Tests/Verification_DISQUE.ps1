# Script pour vérifier l'état et le taux de remplissage des disques sur un Active Directory et générer un rapport en CSV

# Obtenir tous les ordinateurs du domaine
$ordinateurs = Get-ADComputer -Filter *

# Initialiser une liste pour stocker les résultats
$resultats = @()

foreach ($ordinateur in $ordinateurs) {
    $nomOrdinateur = $ordinateur.Name

    # Vérifier si l'ordinateur est en ligne
    if (Test-Connection -ComputerName $nomOrdinateur -Count 1 -Quiet) {
        Write-Host "Vérification des disques sur $nomOrdinateur"

        # Obtenir les informations sur les disques
        $disques = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $nomOrdinateur -Filter "DriveType=3"

        foreach ($disque in $disques) {
            $deviceID = $disque.DeviceID
            $taille = [math]::round($disque.Size / 1GB, 2)
            $espaceLibre = [math]::round($disque.FreeSpace / 1GB, 2)
            $espaceUtilisé = $taille - $espaceLibre
            $pourcentageLibre = [math]::round(($espaceLibre / $taille) * 100, 2)

            # Ajouter les informations à la liste des résultats
            $resultats += [PSCustomObject]@{
                Ordinateur       = $nomOrdinateur
                Disque           = $deviceID
                TailleGB         = $taille
                EspaceUtiliséGB  = $espaceUtilisé
                EspaceLibreGB    = $espaceLibre
            PourcentageLibre = $pourcentageLibre
        }
    } else {
        Write-Host "$nomOrdinateur est hors ligne"
    }
}

# Exporter les résultats en fichier CSV
$resultats | Export-Csv -Path "rapport_disques.csv" -NoTypeInformation -Encoding UTF8
}
