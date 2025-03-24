# PowerShell 🚀

## Structure du projet 📁

```
PowerShell
├── AD
│   ├── Inventaire des machines.ps1
│   ├── Nettoyage des objets obsolètes.ps1
│   ├── Verification_DISQUE.ps1
│   ├── Verification_Utilisateurs.ps1
│   └── gpo.ps1
├── .vscode
│   ├── extensions
│   ├── launch.json
│   ├── tasks.json
│   └── settings.json
├── LICENSE
├── README.md
└── UI.ps1
```

## Fichiers 📄

### AD/Inventaire des machines.ps1
Script pour générer un rapport d'inventaire des machines dans Active Directory et l'exporter en CSV.

### AD/Nettoyage des objets obsolètes.ps1
Script pour nettoyer les objets obsolètes dans Active Directory et générer un rapport en CSV.

### AD/Verification_DISQUE.ps1
Script pour vérifier l'état et le taux de remplissage des disques sur un Active Directory et générer un rapport en CSV.

### AD/Verification_Utilisateurs.ps1
Script pour vérifier l'existence d'utilisateurs inactifs et avec un mot de passe antérieur à 1 an dans Active Directory et générer un rapport en CSV.

### AD/gpo.ps1
Script pour générer des rapports CSV, connecter des lecteurs réseaux et déployer d'autres scripts via GPO.

### UI.ps1
Script PowerShell pour ouvrir d'autres scripts avec une interface graphique.

### .vscode/extensions
Contient la configuration des extensions VSCode.

### .vscode/launch.json
Contient la configuration de lancement de VSCode.

### .vscode/tasks.json
Contient la configuration des tâches de VSCode.

### .vscode/settings.json
Contient la configuration des paramètres de VSCode.

### LICENSE
Licence MIT pour le projet.

### README.md
Ce fichier.

## Licence 📜

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.