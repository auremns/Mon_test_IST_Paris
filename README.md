# Outil d'aide : Quel Test à Qui ?

![Ville de Paris](https://upload.wikimedia.org/wikipedia/fr/thumb/8/8d/Logo_Ville_de_Paris.svg/1280px-Logo_Ville_de_Paris.svg.png)

Ce projet est une application Shiny développée pour aider les professionnels de santé à déterminer rapidement les tests de dépistage des IST (Infections Sexuellement Transmissibles) à proposer en fonction des situations cliniques.

## 🚀 Aperçu de l'application

- Interface moderne utilisant le thème `Cerulean` de Shiny.
- Infobulles interactives pour guider l'utilisateur à chaque étape.
- Résultats dynamiques incluant :
  - Tests recommandés
  - Auto-prélèvements spécifiques (pharyngé, vaginal, urinaire, anal)
  - Mesures d'urgence (TPE, contraception d'urgence)
  - Conseils en matière de PrEP
- Résumé personnalisé des réponses.

Cet outil intègre l'algorithme d'aide au choix de prélèvements de l'arrêté publié pour Mon Test IST (https://www.ameli.fr/laboratoire-danalyses-medicales/exercice-liberal/prise-charge-patients/depistage-ist/mon-test-ist-depistage-en-laboratoire-sans-ordonnance), augmenté par les mesures de prévention et de prise en soin globale pour la santé sexuelle. 

## 📚 Bibliothèques utilisées

- `shiny` — Développement de l'interface web.
- `shinythemes` — Thèmes modernes pour Shiny.
- `shinyBS` — Infobulles et composants Bootstrap pour Shiny.

## 💻 Installation et lancement

1. **Installer les packages R nécessaires** :

```r
install.packages(c("shiny", "shinythemes", "shinyBS"))
```

2. **Lancer l'application** :

Dans RStudio ou R :

```r
library(shiny)
runApp("chemin/vers/le/dossier/Mon_Test_IST")
```

Ou ouvrir le fichier `.R` dans RStudio et cliquer sur **Run App**.

## 🏗️ Structure du projet

- `app.R` : Contient l'intégralité de l'application (UI + serveur).
- **Images** : Les logos et illustrations sont directement chargés depuis des URLs.
- **Fonts** : Utilisation de la police `Montserrat` pour un rendu moderne.

## 🎯 Fonctionnalités principales

- Questionnaire interactif sur les risques d'IST.
- Génération automatique d'une recommandation de dépistage adaptée.
- Système de filtres pour ne montrer que les informations pertinentes.
- Conseils pour l'orientation rapide (TPE, contraception d’urgence, PrEP).


## 🤝 Contribution

N'hésitez pas à proposer des améliorations via Pull Request ou à ouvrir une Issue !

## 📜 Licence

Projet développé pour le **Pôle Santé Sexuelle — Direction de la Santé Publique — Ville de Paris**.  
Utilisation et modifications libres sous réserve de mentionner l'origine.

---
