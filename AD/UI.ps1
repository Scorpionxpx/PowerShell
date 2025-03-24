# Script PowerShell pour ouvrir d'autres scripts avec une interface graphique

# Charger l'assembly Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Créer le formulaire
$form = New-Object System.Windows.Forms.Form
$form.Text = "Gestion des Scripts AD"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Créer une liste de scripts
$scripts = @(
    "Inventaire des machines.ps1",
    "Nettoyage des objets obsolètes.ps1",
    "Verification_DISQUE.ps1",
    "Verification_Utilisateurs.ps1"
)

# Créer une ListBox pour afficher les scripts
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Size = New-Object System.Drawing.Size(360, 200)
$listBox.Location = New-Object System.Drawing.Point(10, 10)
$listBox.Items.AddRange($scripts)

# Créer un bouton pour exécuter le script sélectionné
$button = New-Object System.Windows.Forms.Button
$button.Text = "Exécuter le script"
$button.Size = New-Object System.Drawing.Size(360, 30)
$button.Location = New-Object System.Drawing.Point(10, 220)

# Ajouter un événement au bouton pour exécuter le script sélectionné
$button.Add_Click({
    $selectedScript = $listBox.SelectedItem
    if ($selectedScript) {
        $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath $selectedScript
        if (Test-Path $scriptPath) {
            Start-Process powershell.exe -ArgumentList "-File `"$scriptPath`""
        } else {
            [System.Windows.Forms.MessageBox]::Show("Le script sélectionné n'existe pas.", "Erreur", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner un script.", "Erreur", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Ajouter les contrôles au formulaire
$form.Controls.Add($listBox)
$form.Controls.Add($button)

# Afficher le formulaire
$form.ShowDialog()