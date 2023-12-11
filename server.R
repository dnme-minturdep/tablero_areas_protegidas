
shinyServer(function(input, output, session) {
  
  #### RESUMEN
  
  output$graficoPN <- renderPlot({
    datos_grafico <- areas_protegidas2 %>% 
      pivot_longer(cols = c(residentes, no_residentes),
                   names_to = "residencia", values_to = "visitantes") %>% 
      group_by(indice_tiempo, residencia) %>% 
      summarise(visitantes = round(sum(visitantes, na.rm = TRUE)))
    
    ggplot(datos_grafico, aes(indice_tiempo, visitantes, group = residencia,
                              color= residencia))+
      geom_line()+
      scale_color_manual(values = c("residentes" = dnmye_colores("rosa"), 
                                   "no_residentes" = dnmye_colores("azul verde"))) +
      scale_x_date(date_breaks = "1 year",
                   date_labels = "%b%y",
                   expand = c(.03,1)) +
      scale_y_continuous(limits = c(0,max(datos_grafico$visitantes)),
                         labels = function(x){format(x, scientific = F)} ) +
      theme_minimal() 
    
  })
    

  
  
  
  # output$tablaResumen <- renderTable({
  # 
  # 
  # areas_protegidas_anio <- reactive({
  #   
  #   req(input$buscadorAnio)
  # 
  #   areas_protegidas_total %>%
  #     filter(anio %in% input$selectAnio)
    
    
  #})
  #Actualizo input de mes segun anio
  #observeEvent(input$buscadorMes, {
    
    #Opciones
    # opts <- sort(unique(data_provincia_perfil()$departamento_partido))
    
    #Actualizando el pickerinput con las opciones filtradas
    # updatePickerInput(session = session,
    #                   inputId = "buscadorDepto",
    #                   choices = opts,
    #                   selected = opts,
    #                   options = list(`selected-text-format` = paste0("count > ", length(opts)-1)))
    # 
  # }) 
    
  # 
  # #### TABLERO
  # data_provincia_perfil <- reactive({
  #   
  # 
  # output$tablaAreas <- renderDataTable({
  #   areas_protegidas_anio()})
  #   
})
