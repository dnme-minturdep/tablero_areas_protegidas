
shinyServer(function(input, output, session) {
  
  #### RESUMEN
  
#se arma el gráfico
  
  output$graficoPN <- renderPlotly({
    
    datos_grafico <- areas_protegidas_total %>% 
      filter(categoria == "Nacional") %>% 
      pivot_longer(cols = c(residentes, no_residentes),
                   names_to = "residencia", values_to = "visitantes") %>% 
      mutate(residencia = ifelse(residencia == "no_residentes", "No residentes", "Residentes")) %>% 
      group_by(indice_tiempo, residencia) %>% 
      summarise(visitantes = round(sum(visitantes, na.rm = TRUE)))
    
    grafico <- ggplot(datos_grafico, aes(indice_tiempo, visitantes, group = residencia,
                              color= residencia, text = paste0("Fecha: ", format(indice_tiempo,"%b-%y"),"<br>",
                                                               format(visitantes, big.mark = "."), " ", residencia)))+
      geom_line()+
      scale_color_manual(values = c("Residentes" = dnmye_colores("rosa"), 
                                   "No residentes" = dnmye_colores("azul verde"))) +
      scale_x_date(date_breaks = "2 years",
                   date_labels = "%b-%y",
                   expand = c(.03,1)) +
      scale_y_continuous(limits = c(0,max(datos_grafico$visitantes)),
                         labels = function(x){format(x, scientific = F, big.mark = ".")} ) +
      theme_minimal() +
      xlab("") + ylab("")
    
    ggplotly(grafico, tooltip = "text")  %>%
      layout(legend = list(orientation = "h", x = 0.3, y = -0.1))
    
  })
  
  #para armar el mapa
  
  etiquetas <- paste0(mapa$parque_nacional, "<br>", 
                      mapa$categoria, "<br>",
                      "Visitantes: ", mapa$total) %>%
    lapply(htmltools::HTML)
  
  output$mapaPN <- renderLeaflet({
    mapa %>% 
      leaflet() %>% 
      leaflet::addTiles(urlTemplate = "https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/mapabase_gris@EPSG%3A3857@png/{z}/{x}/{-y}.png",
                        options = providerTileOptions(minZoom = 2), attribution = "IGN") %>%
      setMaxBounds(lat1 = 85, lat2 = -85.05, lng1 = 180, lng2 = -180) %>% 
      addCircleMarkers(fillColor = ~color, color = ~color, 
                       label = ~etiquetas, 
                       popup = ~etiquetas) %>%
      addLegend("bottomright", colors = c(dnmye_colores("purpura"),
                                          dnmye_colores("pera")),
                labels = c("Registra visitas","No registra visitas"),
                opacity = 1
      )
  })
  
  ## TABLERO
  #filtro base segun input de anio en objeto reactivo
  
  data_anio <- reactive({
    
  req(input$selectAnio)
    
  areas_protegidas_total %>% 
    filter(anio %in% input$selectAnio)
  })
  

  #Actualizo input de mes segun anio
  
  observeEvent(input$selectAnio, {

      #Opciones (unique sobre la variable mes de los años seleccionados)
      opts <- unique(as.character(data_anio()$Mes))
      

      #Actualizando el pickerinput mes con las opciones filtradas
      
      
      updatePickerInput(session = session,
                        inputId = "selectMes",#id del selector de la ui de mes
                        choices = opts,
                        selected = opts,#selected es el valor seleccionado por default
                        options = list(`selected-text-format` = paste0("count > ", length(opts)-1))) #es un formato que cuenta una condición que sea mayor 
      #la cantidad de registros del vector opts -1 para agregarle un texto que definimos que aparezca

  })
  
  # 
  # Filtro datos por mes
  
   data_mes <- reactive({
    
    req(input$selectMes)
    
     data_anio() %>%
      filter(Mes %in% input$selectMes)
  })
   
  
    observeEvent(input$selectMes, {
    
    #Opciones
    opts <- sort(unique(data_mes()$categoria))
    
   
    updatePickerInput(session = session,
                      inputId = "selectCategoria",
                      choices = opts,
                      selected = opts,
                      options = list(`selected-text-format` = paste0("count > ", length(opts)-1)))
    
  })
    
   #Filtro categoria
  
  data_categoria <- reactive({
    
    req(input$selectCategoria)
    
    data_mes() %>% 
    filter(categoria == input$selectCategoria)
    
  })

  
  observeEvent(input$selectCategoria, {
    
    opts <- sort(unique(data_categoria()$region))
    
    updatePickerInput(session = session,
                      inputId = "selectRegion", 
                      choices = opts,
                      selected = opts,
                      options = list(`selected-text-format` = paste0("count > ", length(opts)-1)))
    
    
  })
  
  #Filtrar por región 
  
  data_region <- reactive({
    
    req(input$selectRegion)
    
    data_categoria() %>% 
      
      filter(region %in% input$selectRegion)
    
  })
  
  observeEvent(input$selectRegion, {
    
    opts <- sort(unique(data_region()$provincia))
    
    updatePickerInput(session = session,
                      inputId = "selectProvincia", 
                      choices = opts,
                      selected = opts,
                      options = list(`selected-text-format` = paste0("count > ", length(opts)-1)))
    
  })
    
    #Filtrar por provincia
    
    data_provincia <- reactive({
      
      req(input$selectProvincia)
      
      data_region() %>% 
        
        filter(provincia %in% input$selectProvincia)
      
    })
    
    observeEvent(input$selectProvincia, {
      
      opts <- sort(unique(data_provincia()$area_protegida))
      
      updatePickerInput(session = session,
                        inputId = "selectAreaProtegida", 
                        choices = opts,
                        selected = opts,
                        options = list(`selected-text-format` = paste0("count > ", length(opts)-1)))
      
    }) 
    
    #Filtrar por area protegida
    
    data_ap <- reactive({
      
      req(input$selectAreaProtegida)
      
      data_provincia() %>% 
        filter(area_protegida %in% input$selectAreaProtegida)
      
    })  
 
    observeEvent(input$selectCategoria, {
      
      if(input$selectCategoria == "Provincial") {
        updateSelectInput(session = session,
                        inputId = "selectAgrupamiento", 
                        choices = c(
                          "Año" = "anio",
                          "Mes" = "Mes",
                          "Provincia" = "provincia", 
                          "Áreas Protegidas" = "area_protegida"),
                        selected = "anio"
        )} else{ 
          updateSelectInput(session = session,
                            inputId = "selectAgrupamiento", 
                            choices = c(
                              "Año" = "anio",
                              "Mes" = "Mes",
                              "Región" = "region",
                              "Provincia" = "provincia", 
                              "Áreas Protegidas" = "area_protegida"),
                            selected = "anio")}
      
    })  
    
    data_final <- reactive({
      
    data_ap() %>% 
      # rename("Año" = anio,
      #                      "Categoria" = categoria,
      #                      "Región" = region,
      #                      "Provincia" = provincia,
      #                      "Área Protegida" = area_protegida) %>%  
      group_by_at(.vars = c("anio", input$selectAgrupamiento)) %>%
      summarise("Total" = round(sum(total, na.rm = T)),
                "Residentes" = round(sum(residentes, na.rm = T)),
                "No residentes" = round(sum(no_residentes, na.rm = T))) %>% 
      rename(any_of(c(
        "Año" = "anio",
        "Región" = "region",
        "Provincia" = "provincia",
        "Área Protegida" = "area_protegida"
      ))) %>% 
      ungroup()
    
    })
    
    
  output$tablaAreas <- renderDataTable(
    server = F,{
   datatable(#extensions = 'Buttons',
                  options = list(lengthMenu = c(10, 25, 50), pageLength = 10, #cuantas filas se muestran en la tabla
                                 dom = 'lfrtipB' #para paginado debajo para navegar, la cajita de busqueda 
                                 # buttons = list('copy', 
                                 #                list(
                                 #                  extend = 'collection',
                                 #                  buttons = list(list(extend = 'csv', filename = "area_protegida"), #para descargar la tabla que muestra
                                 #                                 list(extend = 'excel', filename = "area_protegida")),
                                 #                  text = 'Download'
                                 #                ))
                                 ),
                  
                  data_final(),  
                  rownames= FALSE) %>% 
        formatRound(columns = c("Total", "Residentes", "No residentes"),
                    mark = ".", digits = 0 )
    })
  
  output$downloadExcel <- downloadHandler(
    filename = function() {
      "areas_protegidas.xlsx"
    },
    content = function(file) {
      writexl::write_xlsx(data_final(), file)
    }
  )
  
  output$downloadCSV <- downloadHandler(
    filename = function() {
      "areas_protegidas.csv"
    },
    content = function(file) {
      write_csv(data_final(), file)
    }
  )
  
  output$notasDescarga <- downloadHandler(
    filename <- function() {
      paste("notas", "xlsx", sep=".")
    },
    
    content <- function(file) {
      file.copy("/srv/DataDNMYE/areas_protegidas/areas_protegidas_nacionales/notas.xlsx", file)
    }
    
  )
  
  waiter_hide()
  
})
    

     

