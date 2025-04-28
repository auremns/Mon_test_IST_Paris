library(shiny)
library(shinythemes)
library(shinyBS) # Pour les infobulles interactives

# Interface utilisateur
ui <- fluidPage(
  theme = shinytheme("cerulean"), # Thème moderne
  
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap",
      rel = "stylesheet"
    ),
    tags$script(HTML("
      $(document).ready(function(){
        $('[data-toggle=\"tooltip\"]').tooltip(); 
      });
    ")),
    tags$style(
      HTML("
        .title-container {
          display: flex;
          align-items: center;
          justify-content: center;
          margin-top: 10px;
          margin-bottom: 20px;
        }
        .custom-title {
          font-family: 'Montserrat', sans-serif;
          font-size: 28px;
          font-weight: bold;
          color: #2C3E50;
          margin-left: 10px; /* Space between image and title */
        }
        .custom-image {
          height: 120px; /* Adjust the size of the image */
        }
        .tooltip-inner {
          max-width: none !important; 
          white-space: normal; 
          text-align: justify; 
          background-color: #f9f9f9; 
          color: #333; 
          border: 1px solid #ddd; 
          padding: 10px; 
        }
        .tooltip {
          opacity: 1; 
        }
      ")
    )
  ),
  
  # Title with Image from URL (Same Line)
  titlePanel(
    div(
      class = "title-container",
      tags$img(src = "https://www.ordre.pharmacien.fr/var/site/storage/images/7/9/8/3/853897-1-fre-FR/7cd6e311cae8-ist.jpg", 
               class = "custom-image"),
      div("Outil d'aide : Quel Test à Qui ?", class = "custom-title")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      h3("Questionnaire", style = "color: #2980B9;"),
      tags$hr(style = "border-color: #2980B9;"),
      
      # Bloc 1: Conditions générales
      div(
        style = "display: flex; align-items: center;",
        checkboxInput("sympt_ist", "Présence de symptômes d'IST", FALSE),
        tags$span(
          icon("info-circle"), 
          style = "color: #2980B9; cursor: pointer;", 
          `data-toggle` = "tooltip", 
          `data-html` = "true", 
          title = paste0(
            "<ul style='padding-left: 15px; margin: 0;'>",
            "<li>Écoulements anormaux (vagin, pénis, anus)</li>",
            "<li>Brûlures en urinant</li>",
            "<li>Ulcères ou plaies génitales</li>",
            "<li>Démangeaisons ou douleurs génitales</li>",
            "<li>Éruptions cutanées</li>",
            "<li>Douleurs abdominales ou pelviennes</li>",
            "<li>Fièvre et ganglions enflés</li>",
            "</ul>"
          )
        )
      ),
      
      checkboxInput("multi_part", "Plus d'un partenaire depuis le dernier test", FALSE),
      checkboxInput("partner_ist", "Partenaire porteur d'une IST", FALSE),
      checkboxInput("stop_condom", "Souhait de dépistage", FALSE),
      tags$hr(),
      
      # Bloc 2: Rapports non protégés
      checkboxInput("rapport_prot", "Rapport non protégé", FALSE),
      checkboxInput("expo_sang", "Exposition accidentelle au sang", FALSE),
      conditionalPanel(
        condition = "input.rapport_prot",
        checkboxInput("pregnant", "Personne pouvant être enceinte", FALSE)
      ),
      
      conditionalPanel(
        condition = "input.rapport_prot || input.expo_sang",
        
        # Personne à risque VIH avec icône info
        div(
          style = "display: flex; align-items: center;",
          checkboxInput("vih_risk", "Personne fortement exposé au VIH", FALSE),
          tags$span(
            icon("info-circle"), 
            style = "color: #2980B9; cursor: pointer;", 
            `data-toggle` = "tooltip", 
            `data-html` = "true", 
            title = paste0(
              "<ul style='padding-left: 15px; margin: 0;'>",
              "<li>Hommes ayant des relations sexuelles avec des hommes (HSH)</li>",
              "<li>Personnes transgenres avec exposition passée, actuelle ou future</li>",
              "<li>Origines ou partenaires de pays à forte endémie (Afrique subsaharienne, Caraïbes, Amérique du Sud)</li>",
              "<li>Multiples partenaires (&gt;1/an) ou partenaires concomitants</li>",
              "<li>Travail du sexe ou échanges sexuels transactionnels</li>",
              "<li>Partenaires de statut VIH inconnu, à risque ou sans charge virale contrôlée</li>",
              "<li>Marqueurs d'exposition : autres IST, antécédents de TPE</li>",
              "<li>Usagers de drogues injectables avec partage de matériel</li>",
              "</ul>"
            )
          )
        ),
        
        radioButtons("delai", "Délai depuis l'exposition :",
                     choices = c("Moins de 48h" = "48",
                                 "Entre 48h et 5 jours" = "72_120",
                                 "Plus de 5 jours" = "120+"),
                     selected = "48")
      ),
      tags$hr(),
      
      # Bloc 3: Vaccination et types de rapports
      selectInput("vacc_vhb", "Statut de vaccination contre l'Hépatite B (VHB)",
                  choices = c("Pas de preuve de vaccination", "Vacciné")),
      checkboxInput("statut_vih", "Vivant avec le VIH", FALSE),
      checkboxGroupInput("type_rapport", "Type de rapports :", 
                         choices = c("Réceptifs oraux", "Réceptifs vaginaux", "Insertifs", "Réceptifs anaux")),
      
      actionButton("submit", "Déterminer les tests et prélèvements", 
                   class = "btn-primary", 
                   style = "color: white; background-color: #2980B9; font-weight: bold;")
    ),
    
    mainPanel(
      h3("Conclusion", style = "color: #2980B9;"),
      tags$hr(style = "border-color: #2980B9;"),
      uiOutput("conclusion"),
      
      h4("Récapitulatif des réponses", style = "color: #2980B9; margin-top: 20px;"),
      tags$hr(),
      tableOutput("recap")
    )
  ),
  
  tags$footer(
    class = "footer",
    div(
      style = "display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; margin-top: 20px;",
      div(style = "font-family: 'Montserrat', sans-serif; font-size: 14px; color: #555;",
          "Pôle de santé sexuelle - Direction de la Santé Publique - Ville de Paris"
      ),
      tags$img(
        src = "https://media.licdn.com/dms/image/v2/D4E0BAQEf028k6wXM_g/company-logo_200_200/company-logo_200_200/0/1664972358583/parissante_logo?e=2147483647&v=beta&t=BOStZH1QN51SH_p6-UjQgTqT-TBcp55J08aa6owKR78",
        style = "height: 60px; margin-top: 10px;"
      )
    )
  )
)  

# Serveur
server <- function(input, output) {
  observeEvent(input$submit, {
    # Variables pour organiser les conclusions
    urgence <- ""
    tests_prelevements <- ""
    prep_recommandation <- ""
    ttt_recommandation <- ""
    
    # Gestion des prélèvements (toujours exécutée)
    prelevements <- c()
    if ("Réceptifs oraux" %in% input$type_rapport) prelevements <- c(prelevements, "prélèvement pharyngé")
    if ("Réceptifs vaginaux" %in% input$type_rapport) prelevements <- c(prelevements, "prélèvement vaginal")
    if ("Insertifs" %in% input$type_rapport) prelevements <- c(prelevements, "prélèvement urinaire")
    if ("Réceptifs anaux" %in% input$type_rapport) prelevements <- c(prelevements, "prélèvement anal")
    if (input$rapport_prot && length(input$type_rapport) == 0) {
      prelevements <- unique(c(prelevements, "prélèvement génital (urinaire ou vaginal)"))
    }
    if (length(prelevements) > 0) {
      tests_prelevements <- paste(
        "🔍 PCR Chlamydia et Gonocoque :", 
        paste(prelevements, collapse = ", ")
      )
    }
    
    # Tests de sérologie pour les conditions générales
    if (input$sympt_ist || input$multi_part || input$partner_ist || input$stop_condom || input$rapport_prot || input$expo_sang) {
      serologies <- c("Syphilis")
      if (!input$statut_vih) {
        serologies <- c("VIH", serologies)
      }
      if (input$vacc_vhb == "Pas de preuve de vaccination") {
        serologies <- c(serologies, "VHB")
      }
      if (input$vih_risk || input$expo_sang) {
        serologies <- c(serologies, paste("<br>", "La recherche de VHC peut également être intéressante, sur prescription."))
      }
      if (input$rapport_prot || input$expo_sang) {
        serologies <- c(serologies, paste("<br>", "Un nouveau test sera nécessaire 6 semaines après l'exposition."))
      }
      tests_prelevements <- paste(tests_prelevements, 
                                  paste0("🔍 Sérologies : ", paste(serologies, collapse = ", ")), 
                                  sep = "<br>")
    }
    
    
    # Mesures d'urgence uniquement si "Rapport non protégé" est coché
    if (input$rapport_prot) {
      if (input$pregnant && input$delai %in% c("48", "72_120")) {
        urgence <- paste0(
          "⚠️ <b>Contraception d'urgence recommandée</b> : Orientez en pharmacie ou en ",
          "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>CSS</a>."
        )
      }
      if (input$vih_risk && input$delai == "48") {
        urgence <- paste(urgence, "⚠️ <b>Orientation urgences TPE</b> : Orienter vers un service d'urgences rapidement.")
      }
    }
    
    # Recommandation PrEP
    if (input$vih_risk) {
      prep_recommandation <- paste0(
        "🟢 <b>Vous pouvez parler de la ",
        "<a href='https://www.sida-info-service.org/dossier-la-prep/' target='blank' style='color: #2980B9; text-decoration: underline;'>PrEP</a></b>",
        " aux personnes présentant un risque élevé d’acquisition du VIH et les orienter en ",
        "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>CSS</a>"
      )
    }
    
    if (input$expo_sang && input$delai == "48") {
      urgence <- paste(urgence, "⚠️ <b>Orientation urgences TPE</b> : Orienter vers un service d'urgences rapidement.")
    }
    
    #Recommandation traitement 
    if (input$sympt_ist || input$partner_ist) {
      ttt_recommandation <- paste0(
        "🩺 <b>Consultation recommandée</b> : Chez le médecin généraliste, en CeGIDD ou en ",
        "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>CSS</a>"
      )
    }
    
    # Affichage dynamique
    output$conclusion <- renderUI({
      tagList(
        if (urgence != "") div(style = "background-color: #FFDDDD; border-left: 5px solid red; padding: 10px; margin-bottom: 10px;", HTML(urgence)),
        if (ttt_recommandation != "") div(style = "background-color: #FFF9C4; border-left: 5px solid #FFC107; padding: 10px; margin-bottom: 10px;", HTML(ttt_recommandation)),
        if (tests_prelevements != "") div(style = "background-color: #EAF2F8; border-left: 5px solid #2980B9; padding: 10px; margin-bottom: 10px;", HTML(paste("<b>Tests et prélèvements recommandés :</b><br>", tests_prelevements))),
        if (prep_recommandation != "") div(style = "background-color: #E8F8E9; border-left: 5px solid green; padding: 10px;margin-bottom: 10px;", HTML(prep_recommandation))
      )
    })
    
    if (!is.null(input$delai)) {
      delai_value <- ifelse(input$delai == "48", "Moins de 48h", 
                            ifelse(input$delai == "72_120", "Entre 48h et 5 jours", "Plus de 5 jours"))
    } else {
      delai_value <- "Non renseigné"
    }
    
    # Récapitulatif des réponses
    recap_data <- data.frame(
      Question = c("Symptômes d'IST", "Plus d'un partenaire depuis le dernier test", "Partenaire porteur d'une IST",
                   "Souhait de dépistage", "Rapport non protégé", "Personne pouvant être enceinte", "Exposition VIH",
                   "Délai depuis l'exposition", "Vivant avec le VIH", "Vaccination VHB", "Types de rapports"),
      Réponse = c(ifelse(input$sympt_ist, "Oui", "Non"), 
                  ifelse(input$multi_part, "Oui", "Non"), 
                  ifelse(input$partner_ist, "Oui", "Non"), 
                  ifelse(input$stop_condom, "Oui", "Non"), 
                  ifelse(input$rapport_prot, "Oui", "Non"), 
                  ifelse(input$pregnant, "Oui", "Non"), 
                  ifelse(input$vih_risk, "Oui", "Non"), 
                  delai_value,  # Correction ici
                  ifelse(input$statut_vih, "Oui", "Non"),
                  input$vacc_vhb, 
                  ifelse(length(input$type_rapport) == 0, "Aucun", paste(input$type_rapport, collapse = ", ")))
    )
    recap_data_filtered <- recap_data[
      recap_data$Réponse == "Oui" | 
        recap_data$Question %in% c("Délai depuis l'exposition", "Vaccination VHB", "Types de rapports"),
    ]
    
    # Rendu du tableau filtré
    output$recap <- renderTable({ recap_data_filtered })
  })
}

# Lancer l'application
shinyApp(ui = ui, server = server)

