# Dépistage IST : Quel test dois-je faire ?

![Ville de Paris](https://upload.wikimedia.org/wikipedia/fr/thumb/8/8d/Logo_Ville_de_Paris.svg/1280px-Logo_Ville_de_Paris.svg.png)

**Version Grand Public** – Application Shiny pour informer sur les tests de dépistage des Infections Sexuellement Transmissibles (IST) en fonction de sa situation, dans un cadre de prévention globale en santé sexuelle.

---

## 🚀 Fonctionnalités principales

- Interface simplifiée et adaptée au grand public.
- Questionnaire interactif pour guider les utilisateurs :
  - Symptômes évocateurs d'IST
  - Nombre de partenaires
  - Rapports protégés ou non
  - Type de prélèvements souhaités
- Conseils personnalisés sur :
  - Les tests à réaliser
  - Les prélèvements recommandés
  - La PrEP et la prise en charge en urgence si besoin
- Possibilité de **télécharger un rapport personnalisé**.

L'idée a été d'adapter la version pour les professionnels avec un langage adapté aux public. De la même façon, cela s'inspire de l'arrêté sur Mon Test IST auquel s'ajoute la prévention et la prise en soin globale en santé sexuelle.

---

## 📚 Bibliothèques R utilisées

- `shiny`
- `shinythemes`
- `shinyBS`
- `shinyjs`
- `tinytex` (pour la génération de rapports téléchargeables)

---

## 💻 Installation et lancement

1. **Installer les packages nécessaires** :

```r
install.packages(c("shiny", "shinythemes", "shinyBS", "shinyjs", "tinytex"))
tinytex::install_tinytex()  # Pour permettre la génération de rapports HTML/PDF
```

2. **Lancer l'application** :

Dans RStudio :

```r
library(shiny)
runApp("chemin/vers/Mon_Test_IST_public")
```

Ou ouvrir le fichier `.R` et cliquer sur **Run App**.

---

## 🏗️ Structure du projet

- `app.R` : L'application principale.
- `template_report.Rmd` : Template pour générer le rapport téléchargeable.
- **Images** et **logos** chargés directement depuis des URLs.

---

## 🎨 UX et Design

- Thème **Cerulean** pour une interface moderne.
- Utilisation de la police **Montserrat**.
- Infobulles explicatives pour aider les utilisateurs.

---

## 📜 Licence

Projet développé par Dr Aurélia Manns pour le **Pôle Santé Sexuelle — Direction de la Santé Publique — Ville de Paris**.  
Utilisation libre sous réserve de mention de l'origine.

---

