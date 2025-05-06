
# 💻 PowerShell – Menu interactif d'administration Active Directory

Ce dépôt contient un ensemble de scripts PowerShell pour automatiser des tâches d'administration dans un environnement Active Directory. Il inclut un **menu interactif** permettant d'exécuter différentes fonctions d’audit, de gestion des utilisateurs et de maintenance système.

Projet réalisé dans le cadre du BTS SIO – option SISR.

---

## 📁 Arborescence du dépôt

```text
PowerShell/
├── Final/
│   └── script1.ps1                      # Script principal avec menu interactif
├── Tests/
│   ├── Inventaire des machines.ps1     # Audit des machines du domaine
│   ├── Nettoyage des objets obsolètes.ps1  # Suppression des objets obsolètes
│   ├── Verification_DISQUE.ps1         # Vérification de l’espace disque
│   ├── Verification_Utilisateurs.ps1   # Vérification des utilisateurs inactifs
│   ├── gpo.ps1
│   ├── script.ps1
│   └── UI.ps1
├── LICENSE
└── README.md
````

---

## 🧠 Fonctions du script `script1.ps1`

Ce script présente un menu interactif proposant les actions suivantes :

1. 🔐 Création d’un utilisateur avec mot de passe temporaire
2. 🔄 Réinitialisation de mots de passe pour plusieurs utilisateurs
3. 📂 Création de dossiers personnels pour les utilisateurs
4. 🏢 Génération automatique de dossiers simulant des OU
5. 👤 Liste des utilisateurs avec une description
6. ⏳ Liste des utilisateurs inactifs depuis plus de 90 jours
7. 🕒 Liste des utilisateurs n’ayant pas changé leur mot de passe depuis plus d’un an
8. 💽 Affichage des statistiques sur l’espace disque restant
9. ❌ Quitter

---

## ▶️ Exécution

1. Ouvrir PowerShell en tant qu’administrateur
2. Se placer dans le dossier `Final` :

```powershell
cd .\Final\
```

3. Lancer le script :

```powershell
.\script1.ps1
```

---

## ⚙️ Prérequis

* Windows avec Active Directory (contrôleur de domaine)
* PowerShell 5.1 ou supérieur
* Droits administrateur sur le domaine
* Outils RSAT (Remote Server Administration Tools) installés

---

## 📄 Licence

Ce projet est distribué sous licence MIT. Voir le fichier `LICENSE` pour plus d’informations.

---

> ✍️ Réalisé dans le cadre du **BTS SIO – Option SISR**
> 📁 Sujet : Automatisation des tâches d'administration système via PowerShell
