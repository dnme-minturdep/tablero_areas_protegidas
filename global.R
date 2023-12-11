library(shiny)
library(tidyverse)
library(DT)
library(sf)
library(herramientas)
library(lubridate)
library(shinyWidgets)
library(comunicacion)

areas_protegidas <- read_file_srv("/srv/DataDNMYE/areas_protegidas/areas_protegidas_nacionales/pivot_pn.xlsx", sheet= 2)%>%
  select(1:7) %>% 
  #filter(parque_nacional != "los arrayanes") %>% 
  filter(parque_nacional != "nahuel huapi") %>% 
  mutate(Mes = str_to_title(Mes),
         parque_nacional = ifelse(parque_nacional == "nahuel huapi 3p", "nahuel huapi", parque_nacional)) %>% 
  left_join(., data.frame(Mes = c("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"), month = c(1:12))) %>% 
   mutate(fecha = ym(glue::glue("{anio}-{month}"))) 
 
#se pivotea residencia, se ajustan nombres para tabla integrada, se genera el total por area protegida


areas_protegidas1 <- areas_protegidas %>% 
  pivot_wider(names_from = residencia, values_from = visitantes) %>% 
  rename(no_residentes = `no residentes`, area_protegida = parque_nacional) %>% 
  mutate(total = residentes + no_residentes, categoria = "Nacional") %>% 
  select(- c(region, mes, month)) %>% 
  rename(indice_tiempo = fecha) 

  
  
#Importo provincias 
  provincias_2 <- read_file_srv("/srv/DataDNMYE/areas_protegidas/areas_protegidas_nacionales/provincias_2.xlsx")


#se agregan las provincias a la base
  
  areas_protegidas2 <- left_join(areas_protegidas1, provincias_2) %>% 
    select(- area_protegida) %>% 
    rename (area_protegida = parque_nacional)
    

#Se levanta la base de areas naturales del chubut

bases_chubut <- read_file_srv("areas_protegidas/areas_protegidas_provinciales/base_trabajo/bases_chubut.csv") %>% 
  mutate(Mes = str_to_title(Mes), Mes=ifelse(Mes == "Setiembre", "Septiembre", Mes))%>% 
  left_join(., data.frame(Mes = c("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"), month = c(1:12)))

#se generan las variables region y provincia, se pivotean las variables residentes y 
#no residentes

bases_chubut_1 <- bases_chubut %>% 
  mutate(region = "patagonia", provincia = "chubut") %>% 
  pivot_wider(names_from = residencia, values_from = visitantes) %>% 
  mutate(total = residentes + no_residentes, indice_tiempo = ym(glue::glue("{anio}-{month}")), 
         provincia = "Chubut", region = "Patagonia", categoria ="Provincial") %>% 
  select(-month)
  




base_ischigualasto <- read_file_srv("areas_protegidas/areas_protegidas_provinciales/Base_parq_prov_ischigualasto.xlsx", sheet = 2)%>% 
  mutate(anio = year(ym(indice_tiempo)), fecha = ym(indice_tiempo)) %>% 
  select(-c(indice_tiempo, observaciones)) %>% 
  rename(total = visitas, indice_tiempo = fecha) %>% 
  mutate(provincia = "San Juan", area_protegida = "Ischigualasto", region = "Cuyo", 
         Mes = str_to_sentence(month(indice_tiempo, label = T, abbr = F)), categoria = "Provincial")
  

#se juntan las bases

areas_protegidas_total <- bind_rows(areas_protegidas2, bases_chubut_1, base_ischigualasto)


#Opciones de configuración del picker, guardados en un objeto para no pasarlo a cada uno de ellos

opciones_picker <- list(`actions-box` = TRUE,
                        `deselect-all-text` = "Deseleccionar todo",
                        `select-all-text` = "Seleccionar todo",
                        `none-selected-text` = "Sin selección",
                        `live-search`=TRUE,
                        `count-selected-text` = "Todos")