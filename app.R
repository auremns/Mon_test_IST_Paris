library(shiny)
library(shinythemes)
library(shinyBS) 
library(tinytex)
library(shinyjs)

# Interface utilisateur
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  
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
      div("Dépistage IST : quel test dois-je faire ?", class = "custom-title")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      width = 7,
      h3("Questionnaire", style = "color: #2980B9;"),
      tags$hr(style = "border-color: #2980B9;"),
      
      # Bloc 1: Conditions générales
      
      h4("Un depistage : Pourquoi ?"),
      div(
        style = "display: flex; align-items: center;",
        checkboxInput("sympt_ist", "J'ai des symptômes évocateurs d'IST", FALSE),
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
      
      checkboxInput("multi_part", "J'ai eu plus d'un partenaire depuis le dernier test", FALSE),
      checkboxInput("partner_ist", "J'ai eu un partenaire porteur d'une IST", FALSE),
      checkboxInput("stop_condom", "Je souhaite me faire dépister", FALSE),
      tags$hr(),
      
      # Bloc 2: Rapports non protégés
    
      checkboxInput("rapport_prot", "J'ai eu un rapport sans préservatif", FALSE),
      checkboxInput("expo_sang", "J'ai eu un accident d'exposition au sang", FALSE),
      conditionalPanel(
        condition = "input.rapport_prot",
        checkboxInput("pregnant", "Je peux être enceinte", FALSE)
      ),
      
      conditionalPanel(
        condition = "input.rapport_prot || input.expo_sang",
        # Personne à risque VIH avec icône info
        selectInput("risque_vih", "Mon exposition au risque VIH :",
                    choices = c("Aucune de ces propositions", 
                                "Je suis un homme cis ou une personne trans ayant des relations sexuelles avec des hommes", 
                                "Je suis originaire d'un pays à forte endémie du VIH, ou mon partenaire l'est", 
                                "Je suis travailleuse-eur du sexe", 
                                "J'utilise des drogues injectables", 
                                "Je pense être à haut risque VIH", 
                                "Plusieurs de ces propositions"),
                    selected = "Aucune de ces propositions"),
      
        
        radioButtons("delai", "Délai depuis le rapport:",
                     choices = c("Moins de 48h" = "48",
                                 "Entre 48h et 5 jours" = "72_120",
                                 "Plus de 5 jours" = "120+"),
                     selected = character(0))
      ),
      tags$hr(),
      
      # Bloc 3: Vaccination et types de rapports
      h4("Ma situation"),
      selectInput("vacc_vhb", "Je suis vacciné.e contre l'Hépatite B (VHB)",
                  choices = c("Je n'ai pas la preuve de ma vaccination Hepatite B", "Oui")),
      checkboxInput("statut_vih", "Je vis avec le VIH", FALSE),
      checkboxGroupInput("type_rapport", "Je souhaite un prélèvement :", 
                         choices = c("Au niveau de la gorge", 
                                     "Au niveau du vagin (auto-prélèvement)", 
                                     "Urinaire", 
                                     "Au niveau de l'anus (auto-prelevement)")),
      
      actionButton("submit", "Déterminer les tests et prélèvements", 
                   class = "btn-primary", 
                   style = "color: white; background-color: #2980B9; font-weight: bold;")
    ),
    
    mainPanel(
      width = 5,
      h3("Conclusion", style = "color: #2980B9;"),
      tags$hr(style = "border-color: #2980B9;"),
      uiOutput("conclusion"),
      
      h4("Récapitulatif des réponses", style = "color: #2980B9; margin-top: 20px;"),
      tags$hr(),
      tableOutput("recap"),
      downloadButton("download_html", "Télécharger le rapport", class = "btn-primary")
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
server <- function(input, output, session) {
  observe({
    selected <- input$type_rapport
    shinyjs::enable(selector = "input[value='Urinaire']")
    shinyjs::enable(selector = "input[value='Au niveau du vagin (auto-prélèvement)']")
    
    if ("Urinaire" %in% selected) {
      shinyjs::disable(selector = "input[value='Au niveau du vagin (auto-prélèvement)']")
    }
    if ("Au niveau du vagin (auto-prélèvement)" %in% selected) {
      shinyjs::disable(selector = "input[value='Urinaire']")
    }
  })
  
  observeEvent(input$submit, {
    # Variables pour organiser les conclusions
    urgence <- ""
    tests_prelevements <- ""
    prep_recommandation <- ""
    ttt_recommandation <- ""
    
    risque_vih_selected <- input$risque_vih != "Aucune de ces propositions"
    
    # Gestion des prélèvements (toujours exécutée)
    prelevements <- c()
    if ("Au niveau de la gorge" %in% input$type_rapport) prelevements <- c(prelevements, "prélèvement au niveau de la gorge")
    if ("Au niveau du vagin (auto-prélèvement)" %in% input$type_rapport) prelevements <- c(prelevements, "auto-prélèvement vaginal")
    if ("Urinaire" %in% input$type_rapport) prelevements <- c(prelevements, "auto-prélèvement urinaire")
    if ("Au niveau de l'anus (auto-prelevement)" %in% input$type_rapport) prelevements <- c(prelevements, "auto-prélèvement anal")
    if (input$rapport_prot && length(input$type_rapport) == 0) {
      prelevements <- unique(c(prelevements, "auto-prélèvement génital (urinaire ou vaginal)"))
    }
    if (length(prelevements) > 0) {
      tests_prelevements <- paste(
        "🔍 Recherche de Chlamydia et Gonocoque :", 
        paste(prelevements, collapse = ", ")
      )
    }
    
    # Tests de sérologie pour les conditions générales
    if (input$sympt_ist || input$multi_part || input$partner_ist || input$stop_condom || input$rapport_prot) {
      serologies <- c("Syphilis")
      if (!input$statut_vih) {
        serologies <- c("VIH", serologies)
      }
      if (input$vacc_vhb == "Je n'ai pas la preuve de ma vaccination Hepatite B") {
        serologies <- c(serologies, "VHB")
      }
      if (risque_vih_selected || input$expo_sang) {
        serologies <- c(serologies, paste0(
          "Vous pourriez également bénéficier d'un dépistage de l'Hepatite C sur prescription de votre médecin généraliste, en CeGIDD ou en ",
          "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>CSS</a>"
        ))
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
          "⚠️ <b>Contraception d'urgence recommandée</b> : Veuillez vous rendre en pharmacie ou en ",
          "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>CSS</a>."
        )
      }
      if (risque_vih_selected && input$delai == "48") {
        urgence <- paste(urgence, "⚠️ <b> Traitement post-exposition recommandé</b> : Veuillez vous rendre dans un service d'urgences rapidement.")
      }
    }
    
    # Recommandation PrEP
    if (risque_vih_selected) {
      prep_recommandation <- paste0(
        "🟢 <b>Vous pouvez parler de la ",
        "<a href='https://www.sida-info-service.org/dossier-la-prep/' target='blank' style='color: #2980B9; text-decoration: underline;'>PrEP</a></b>",
        " à votre médecin généraliste ou en ",
        "<a href='https://www.paris.fr/pages/l-offre-de-sante-dans-les-equipements-parisiens-22190' target='_blank' style='color: #2980B9; text-decoration: underline;'>centre de santé sexuelle</a>"
      )
    }
    
    #Recommandation traitement 
    if (input$sympt_ist || input$partner_ist) {
      ttt_recommandation <- paste0(
        "🩺 <b>Consultation recommandée</b> : Veuillez vous rendre chez le médecin généraliste, en CeGIDD ou en ",
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
    reactive_conclusion <- reactive({
      list(
        urgence = urgence,
        tests_prelevements = tests_prelevements,
        prep_recommandation = prep_recommandation,
        ttt_recommandation = ttt_recommandation
      )
    })
    
    if (input$rapport_prot || input$expo_sang) {
      delai_value <- switch(input$delai,
                            "48" = "Moins de 48h",
                            "72_120" = "Entre 48h et 5 jours",
                            "120+" = "Plus de 5 jours")
    } else {
      delai_value <- NULL  
    }
    
    # Récapitulatif des réponses
    recap_data <- data.frame(
      Question = c("Symptômes d'IST", "Plus d'un partenaire depuis le dernier test", "Partenaire porteur d'une IST",
                   "Souhait de dépistage", "Rapport non protégé", "Personne pouvant être enceinte", "Exposition VIH",
                   if (!is.null(delai_value)) "Délai depuis le rapport", "Vivant avec le VIH", "Vaccination VHB", "Types de rapports"),
      Réponse = c(ifelse(input$sympt_ist, "Oui", "Non"), 
                  ifelse(input$multi_part, "Oui", "Non"), 
                  ifelse(input$partner_ist, "Oui", "Non"), 
                  ifelse(input$stop_condom, "Oui", "Non"), 
                  ifelse(input$rapport_prot, "Oui", "Non"), 
                  ifelse(input$pregnant, "Oui", "Non"), 
                  ifelse(risque_vih_selected, "Oui", "Non"), 
                  if (!is.null(delai_value)) delai_value,
                  ifelse(input$statut_vih, "Oui", "Non"),
                  input$vacc_vhb, 
                  ifelse(length(input$type_rapport) == 0, "Aucun", paste(input$type_rapport, collapse = ", ")))
    )
    recap_data_filtered <- recap_data[
      recap_data$Réponse == "Oui" | 
        recap_data$Question %in% c("Délai depuis le rapport", "Vaccination VHB", "Types de rapports"),
    ]
    
    # Rendu du tableau filtré
    output$recap <- renderTable({ recap_data_filtered })
    
    reactive_filtered <- reactive(recap_data_filtered)
    reactive_unfiltered <- reactive(recap_data)
    
    
    # ✅ Bouton pour générer le PDF
    output$download_html <- downloadHandler(
      filename = function() {
        paste0("IST_Report_", Sys.Date(), ".html")
      },
      content = function(file) {
        # Create a temporary working directory
        temp_dir <- tempdir()
        temp_rmd <- file.path(temp_dir, "template_report.Rmd")
        
        # Copy the Rmd template to the temporary directory
        file.copy("template_report.Rmd", temp_rmd, overwrite = TRUE)
        
        # Render the Rmd file using rmarkdown
        out_file <- rmarkdown::render(
          input = temp_rmd,
          output_format = "html_document",
          params = list(
            conclusion = reactive_conclusion(),
            recap_table = reactive_unfiltered()
          ),
          envir = new.env(parent = globalenv())
        )
        
        # Copy the output file to the destination file
        file.copy(out_file, file, overwrite = TRUE)
      }
    )
    
    
    
    
    
    
    
    
  })
}
    
    

# Lancer l'application
shinyApp(ui = ui, server = server)

