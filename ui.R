shinyUI(
  
  navbarPage(title = div(  #### NavBar #####
                           div(
                             id = "img-id",
                             tags$a(img(src = "https://tableros.yvera.tur.ar/recursos/logo_sinta.png",
                                        width = 150),href="https://www.yvera.tur.ar/sinta/",target = '_blank'
                             )),
                           icon("montaña"),"ÁREAS PROTEGIDAS", id = "title", class = "navbar1"),
             id="navbar",
             position = "fixed-top",
             windowTitle = "Visitas en Áreas Protegidas Nacionales y Provinciales", 
             collapsible = TRUE,
             header = includeCSS("styles.css"), 
             
             
             tabPanel("RESUMEN",
                      h4(tags$p("El tablero de Visitas en Áreas Protegidas presenta datos agregados sobre las visitas en Argentina. En la pestaña ", tags$b("TABLERO"),
                                "puede conocer por unidad territorial (región del Minturdep y provincia) y según condición de residencia.")),
                     h5(tags$p("El gráfico muestra la evolución mensual de las Visitas en Parques Nacionales según condición de residencia.")),
                      
                       plotOutput("graficoPN")
                      
                      ),
             
             tabPanel("TABLERO",
                      
                      div(id="container-info",
                           
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectAnio", multiple = TRUE,
                                                 label = "Año:",
                                                 choices = sort(unique(areas_protegidas_total$anio)),
                                                 selected = sort(unique(areas_protegidas_total$anio)),
                                                 width = "100%")),
                            
                            
                            
                            column(4, pickerInput(inputId = "selectMes", 
                                                  label = "Mes:",
                                                  choices = sort(unique(areas_protegidas_total$Mes)),
                                                  multiple = T,
                                                  options = c(opciones_picker,
                                                              `selected-text-format` = paste0("count > ", 23)),
                                                  selected = sort(unique(areas_protegidas_total$Mes)),
                                                  width = "100%")),
                            
                            column(4, pickerInput(inputId = "selectCategoria", 
                                                  label = "Categoría Área Protegida:",
                                                  choices = unique(areas_protegidas_total$categoria),
                                                  multiple = T,
                                                  options = opciones_picker,
                                                  selected = unique(areas_protegidas_total$categoria),
                                                  width = "100%"))
                            
                            ),
                            
                            
                          
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectRegion", multiple = TRUE,
                                                 label = "Región:",
                                                 choices = unique(areas_protegidas_total$region),
                                   selected = unique(areas_protegidas_total$region),
                                   width = "100%")
                                   ),
                            
                            
                            column(4, pickerInput(inputId = "selectProvincia", 
                                                  label = "Provincia:",
                                                  choices = sort(unique(areas_protegidas_total$provincia)),
                                                  multiple = T,
                                                  options = c(opciones_picker,
                                                              `selected-text-format` = paste0("count > ", 23)),
                                                  selected = sort(unique(areas_protegidas_total$provincia)),
                                                  width = "100%")),
                            
                            column(4, pickerInput(inputId = "selectAreaProtegida", 
                                                  label = "Área Protegida:",
                                                  choices = unique(areas_protegidas_total$area_protegida),
                                                  multiple = T,
                                                  options = opciones_picker,
                                                  selected = sort(unique(areas_protegidas_total$area_protegida)),
                                                  width = "100%"))
                          ),
                          
                          
                          dataTableOutput(outputId = "tablaAreas")
                          
                      )),
                      
                      tabPanel("METODOLOGÍA",
                               h4(tags$p("Los datos presentados en este tablero surgen de los registros administrativos de la Dirección 
                                         de Mercadeo de la Administración de Parques Nacionales, del Departamento Observatorio
                                         Turístico del Chubut y del Parque Provincial Isghigualasto, encargados de recopilar y procesar
                                         los datos de visitas.")))
             )
  )
 
             # footer = includeHTML("https://tableros.yvera.tur.ar/recursos/footer.html")
  


