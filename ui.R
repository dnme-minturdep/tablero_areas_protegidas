shinyUI(
  
  navbarPage(title = div(  #### NavBar #####
                           div(
                             id = "img-id",
                             tags$a(img(src = "https://tableros.yvera.tur.ar/recursos/logo_sinta.png",
                                        width = 150),href="https://www.yvera.tur.ar/sinta/",target = '_blank'
                             )),
                           icon("tree"),"ÁREAS PROTEGIDAS", id = "title", class = "navbar1"),
             id="navbar",
             position = "fixed-top",
             windowTitle = "Visitas en Áreas Protegidas Nacionales y Provinciales", 
             collapsible = TRUE,
             header = includeCSS("styles.css"), 
             
             
             tabPanel("RESUMEN",
                      
                      div(id="container-info",
                          
                      h4(tags$p("El tablero de ÁREAS PROTEGIDAS presenta información de visitas en parques nacionales y provinciales según condición de residencia en Argentina. Para conocer detalles por Área Protegida, ingresá a la pestaña ", tags$b("TABLERO"), "; para más información sobre las fuentes de datos ingresa a la pestaña ",tags$b("METODOLOGIA."))),
                      
                      h5(tags$p("Evolución mensual de las Visitas en Parques Nacionales según condición de residencia.")),
                      
                      
                      fluidRow(
                        column(width = 6,  plotlyOutput("graficoPN")), 
                        column(width = 6,  leafletOutput("mapaPN"))
                      ),
                      
                      fluidRow(width = 12,
                               tags$p(style="font-size: 14px; text-align: center;", tags$b('Fuente de datos:'),(' La información fue elaborada por la Dirección Nacional de Mercados y Estadística (DNMyE), en base a datos aportados por la Dirección de Mercadeo de la Administración de Parques Nacionales (APN)'))
                               
                      )
                      
                      )
                      
                      
             ),
                      
             
             
             tabPanel("TABLERO",
                      
                      div(id="container-info",
                          
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectAnio", multiple = TRUE,
                                                 label = "Año:",
                                                 choices = sort(unique(areas_protegidas_total$anio)),
                                                 selected = sort(unique(areas_protegidas_total$anio)),
                                                 options = opciones_picker,
                                                 width = "100%")),
                            
                            
                            
                            column(4, pickerInput(inputId = "selectMes", 
                                                  label = "Mes:",
                                                  choices = sort(unique(areas_protegidas_total$Mes)),
                                                  multiple = T,
                                                  options = c(opciones_picker,
                                                              `selected-text-format` = paste0("count > ", 11)),
                                                  selected = sort(unique(areas_protegidas_total$Mes)),
                                                  width = "100%")),
                            
                            column(4, pickerInput(inputId = "selectCategoria", 
                                                  label = "Categoría Área Protegida:",
                                                  choices = unique(areas_protegidas_total$categoria),
                                                  multiple = F,
                                                  options = opciones_picker,
                                                  selected = "Nacional",
                                                  width = "100%"))
                            
                          ),
                          
                          
                          
                          fluidRow(
                            
                            column(4,pickerInput(inputId = "selectRegion", multiple = TRUE,
                                                 label = "Región:",
                                                 choices = unique(areas_protegidas_total$region),
                                                 options = opciones_picker,
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
                          
                          fluidRow(
                          column(4, selectInput(inputId = "selectAgrupamiento",
                                                label = "Mostrar por", 
                                                choices = c(
                                                  "Año" = "anio",
                                                  "Mes" = "Mes",
                                                  "Región" = "region",
                                                  "Provincia" = "provincia", 
                                                  "Áreas Protegidas" = "area_protegida"),
                                                multiple = T,
                                                selected = "anio",
                                                width = "100%"
                          )),
                          
                          column(2, br(),
                                 downloadButton("notasDescarga", label = "Descargar notas"),
                                 offset = 6)
                          
                          ),
                          
                          
                          dataTableOutput(outputId = "tablaAreas")
                          
                      )),
             
             tabPanel("METODOLOGÍA",
                      
                      div(id="container-info",
                      h5(tags$p("Los datos presentados en este tablero surgen de los registros administrativos de la Dirección 
                                         de Mercadeo de la Administración de Parques Nacionales, del Departamento Observatorio
                                         Turístico del Chubut y del Parque Provincial Isghigualasto, encargados de recopilar y procesar
                                         los datos de visitas.")),
                      h5(tags$p("La información suministrada permite la clasificación de las visitas en residentes argentinos y 
                                         no residentes en 41 Parques Nacionales y en 5 Áreas Naturales Protegidas del Chubut y el total 
                                         de visitas en 1 Parque Provincial en San Juan.")),
                      
                      
                   
                          
                          br(),br(),
                          
                          p(style = "text-align: justify;",tags$b(style = "font-size: 15px;", "Aclaraciones metodológicas y marco conceptual")),
                          
                          tags$ul(
                            tags$li(tags$b("Visita:"), " entrada a un parque nacional con cualquier finalidad principal (ocio,negocios u otro motivo personal) y que no deba ser empleado por el parque nacional (cada vez que se cruza la frontera del área protegida, se genera una visita)."),br(),
                            tags$li(tags$b("Unidades de observación:"), "Visitantes."),br(),
                            tags$li(tags$b("Unidades de análisis:"), "41 áreas protegidas que producen información estadística de un total de 50 áreas nacionales en el país (Parques Nacionales, Monumentos Naturales y Reservas Nacionales,Reservas Naturales, Reserva Natural Estricta y Reserva Natural Educativa"),br(),
                            tags$li(tags$b("Forma de colecta:"), "Las áreas protegidas contabilizan las visitas en base a la venta de boletos o al registro de visitantes en los diferentes portales de ingresos (pueden presentar más de un portal de acceso)."),br(),     
                            tags$li(tags$b("Variables de estudio:"), "Cantidad de visitas realizadas de cada área protegida y condición de residencia de los mismos."),br(),
                            tags$li(tags$b("Cobertura geográfica:"), "6 regiones turísticas compuestas por los siguientes Parques Nacionales:"),
                            tags$b("1. Región Buenos Aires:"), "Ciervo de los Pantanos.",br(),
                            tags$b("2. Región Córdoba:"), "Quebrada del Condorito, Traslasierra.",br(),
                            tags$b("3. Región Cuyo:"), "Sierra de las Quijadas, El Leoncito, San Guillermo.",br(),
                            tags$b("4. Región Litoral:"), "Iguazú, El Palmar, Predelta, Río Pilcomayo, Chaco, Mburucuyá, Iberá, El Impenetrable, Colonia Benítez, Formosa, Campo San Juan.", br(),
                            tags$b("5. Región Norte:"), "Talampaya, Los Cardones, Calilegua, Aconquija, El Rey, Baritú,Copo, Laguna de los Pozuelos, El Nogalar de los Toldos, Pizarro.", br(),
                            tags$b("6. Región Patagonia:"), "Los Glaciares, Nahuel Huapi, Tierra del Fuego, Los Alerces,Lago Puelo, Lanín, Laguna Blanca, Lihué Calel, Monte León, Perito Moreno, Bosques Petrificados, Los Arrayanes, Isla Pingüino, Patagonia."
                          ),
                          
                          br(),br(),
                          p(style = "text-align: justify;", tags$b(style = "font-size: 15px;","Fuentes de información:")),
                          
                          tags$ul(
                            tags$li(tags$b("SIAPN:"), "Sistema de Administración de Parques Nacionales"), 
                            tags$li(tags$b("Chubut:"), "Departamento Observatorio Turístico del Chubut"), 
                            tags$li(tags$b("San Juan:"), "Paque Provincial Ischigualasto")) 
                          
                          
                      )
             )
  )
) 
 
             # footer = includeHTML("https://tableros.yvera.tur.ar/recursos/footer.html")
  


