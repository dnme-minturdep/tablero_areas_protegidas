library(shiny)
library(tidyverse)
library(DT) #para hacer tablas interactivas
library(sf) #para trabajar con datos geograficos
library(herramientas)
library(lubridate) #para trabajar con fechas
library(shinyWidgets) #trae distintos elementos de ui como el picker
library(comunicacion)
library(leaflet)
library(geoAr)
library(plotly)


#se levanta la capa geografica y se le agregan los datos de visitantes del 2022 para mostrar en cada parque

mapa <- read_file_srv("/srv/DataDNMYE/capas_sig/areas_protegidas_nacionales.gpkg")

areas_protegidas_total <- read_file_srv("areas_protegidas/base_shiny/areas_consolidado.rds")

datos_mapa <- areas_protegidas_total %>% 
  filter(anio == 2022) %>% 
  group_by(area_protegida) %>% 
  summarise(total = sum(total, na.rm = T)) %>% 
  ungroup()

mapa <- left_join(mapa, datos_mapa, by = c("parque_nacional" = "area_protegida")) %>% 
  mutate(color = ifelse(registra == "si", dnmye_colores("azul verde"),dnmye_colores("pera")),
         total = ifelse(is.na(total), "Sin registro", as.character(format(total, big.mark = "."))))


notas <- readxl::read_excel("/srv/DataDNMYE/areas_protegidas/areas_protegidas_nacionales/notas.xlsx") %>% 
  mutate(parque = str_to_title(parque),
         indice_tiempo = ym(indice_tiempo)) %>% 
  drop_na(notas)

# areas_protegidas_total <- areas_protegidas_total %>% 
#   left_join(notas, by = c("area_protegida"="parque", "indice_tiempo"))
  
#Opciones de configuración del picker, guardados en un objeto para no pasarlo a cada uno de ellos

opciones_picker <- list(`actions-box` = TRUE,
                        `deselect-all-text` = "Deseleccionar todo",
                        `select-all-text` = "Seleccionar todo",
                        `none-selected-text` = "Sin selección",
                        `live-search`=TRUE,
                        `count-selected-text` = "Todos")