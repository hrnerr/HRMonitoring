# Hudson River Monitoring Data
# This is the server logic

library(shiny)
library(bslib)
library(leaflet)
library(rio)

function(input, output, session) {
# Water Quality Tab
  # Pull in WQ data
  wq <- import("data_locations.xlsx", which=1)
  
  # color palette for map
  pal1 <- colorFactor(palette = c("#F44708", "#048A81"), levels=c("SWMP", "HRECOS"))
  
  # Water Quality Map
  # Render map base once
  output$wq_map <- renderLeaflet({
    leaflet() %>%
      # Add map tiles
      addProviderTiles(provider=providers$Esri.WorldTopoMap) %>%
      # Centers the map on Norrie Point
      setView(lng = -73.941867, lat = 41.83186, zoom = 9)
  })
  
  # Filter data based on checkbox, radio button
  filtered_data <- reactive({
    wq %>% dplyr::filter(network %in% input$network) %>%
      dplyr::filter(
        if (input$status == "No") {
          status== "active"
        } else if (input$status == "Yes") {
          status == status
        }
      )
  })
  
  # Observe changes to "filtered data" and map accordingly
  observe({
    map_data <- filtered_data()
    
    # popup labels for map
    popcon <- paste0("Site name: ", map_data$site_name, "</br>", "Site code: ", map_data$site_id, "</br>",
                     "Years active: ", map_data$years, "</br>",
                     "Get data: ", "<a href='", map_data$url, "'target='_blank'>", map_data$text, "</a>")
    
  
  leafletProxy("wq_map") %>%
    clearMarkers()%>%
    addCircleMarkers(data=map_data,
                     lng=~longitude,
                     lat=~latitude,
                     weight=2,
                     radius=6,
                     opacity = 1,
                     fillOpacity = 1,
                     color="black",
                     fillColor = pal1(map_data$network),
                     popup = popcon
                     )%>% 
    clearControls()%>%
    # Adds legend
    addLegend(position = c("bottomleft"), pal = pal1, values=wq$network, opacity = 1,
            title = "Network")
  })
  
  # Display tables
  # Pull in continuous display data
  wq_disp <- import("data_display.xlsx", which=1)
  
  # Decide what to display
  # Filter data based on checkbox, radio button
  filtered_display <- reactive({
    wq_disp %>% dplyr::filter(Network %in% input$network) %>%
      dplyr::filter(
        if (input$status == "No") {
          Status== "active"
        } else if (input$status == "Yes") {
          Status == Status
        }
      )
  })
  
  # Render display
  output$display_wq <- DT::renderDataTable({
    DT::datatable(filtered_display(), escape=FALSE)
    })
  
  # Pull in nutrient display data
  nut_data <- import("data_display.xlsx", which=2)
  
  # Filter based on chechbox and radio button
  nut_disp <- reactive({
    nut_data %>%
      dplyr::filter(Network %in% input$network)%>%
      dplyr::filter(
      if (input$status=="No") {
        Status == "active"
      } else if (input$status == "Yes"){
        Status == Status
      }
    )
  })
  
  # Render nutrient display
  output$display_nut <- DT::renderDataTable({
    DT::datatable(nut_disp(), escape=FALSE)
    })
  
# Meteorology tab
  # Pull in met data
  met <- import("data_locations.xlsx", which=2)
  
  output$met_map <- renderLeaflet({
    leaflet() %>%
      # Add map tiles
      addProviderTiles(provider=providers$Esri.WorldTopoMap) %>%
      # Centers the map
      setView(lng = -73.9168, lat = 42.08, zoom = 8)
  })
  
  filtered_met <- reactive({
    met %>% dplyr::filter(network %in% input$met_network) %>%
      dplyr::filter(
        if (input$met_status == "No") {
          status== "active"
        } else if (input$met_status == "Yes") {
          status == status
        }
      )
  })

  # Update map based on user interaction
  
  observe({
    met_map_data <- filtered_met()
    
    # popup labels for map
    met_popcon <- paste0("Site name: ", met_map_data$site_name, "</br>", "Site code: ", met_map_data$site_id, "</br>",
                     "Years active: ", met_map_data$years)
    
    
    leafletProxy("met_map") %>%
      clearMarkers()%>%
      addCircleMarkers(data=met_map_data,
                       lng=~longitude,
                       lat=~latitude,
                       weight=2,
                       radius=6,
                       opacity = 1,
                       fillOpacity = 1,
                       color="black",
                       fillColor = pal1(met_map_data$network),
                       popup = met_popcon)%>% 
      clearControls()%>%
      # Adds legend
      addLegend(position = c("bottomleft"), pal = pal1, values=met$network, opacity = 1,
                title = "Network")
    
  })
  # Pull in continuous display data
  met_disp <- import("data_display.xlsx", which=3)
  
  # Decide what to display
  # Filter data based on checkbox, radio button
  filtered_met_display <- reactive({
    met_disp %>% dplyr::filter(Network %in% input$met_network) %>%
      dplyr::filter(
        if (input$status == "No") {
          Status== "active"
        } else if (input$status == "Yes") {
          Status == Status
        }
      )
  })
  
  # Render display
  output$display_met <- DT::renderDataTable({
    DT::datatable(filtered_met_display(), escape=FALSE)
  })
  
# Water Level tab
  # Pull in data
  tides <- import("data_locations.xlsx", which=3)
  # Create popup content
  tide_popup <- paste0("Site: ", tides$site_name, "</br>", "Years active: ", tides$years,
                       "</br>", "<a href='", tides$url, "' target='_blank'>View on NOAA site</a>")
  # Map it
  output$tide_map <-
    renderLeaflet({leaflet() %>%
        # Add map tiles
        addProviderTiles(provider=providers$Esri.WorldTopoMap) %>%
        # Centers the map
        setView(lng = -73.9168, lat = 42.08, zoom = 8)%>%
        addCircleMarkers(data=tides,
                         lng=~longitude,
                         lat=~latitude,
                         weight=2,
                         radius=6,
                         opacity = 1,
                         fillOpacity = 1,
                         color="black",
                         fillColor = "#F44708",
                         popup = tide_popup
          
        )
      
    })
  # Pull in display data
  tides_disp <- import("data_display.xlsx", which=4)
  
  # Render display
  output$display_tides <- DT::renderDataTable({
    DT::datatable(tides_disp)
  })
# Vegetation tab
  # Pull in map data
  veg_locs <- import("data_locations.xlsx", which=4)
  
  veg_popup <- paste0("Site name: ", veg_locs$site_name, "</br>", "Years active: ", veg_locs$years)
  
  # Map locations
  output$veg_map <- renderLeaflet({
    leaflet()%>%
    addProviderTiles(provider=providers$Esri.WorldTopoMap)%>%
    # Centers the map
    setView(lng = -73.9910, lat = 41.503, zoom = 9)%>%
      addCircleMarkers(data=veg_locs,
                       lng=~longitude,
                       lat=~latitude,
                       weight=2,
                       radius=6,
                       opacity = 1,
                       fillOpacity = 1,
                       color="black",
                       fillColor = "#10793F",
                       popup = veg_popup
                       
      )
    
  })
  
  # Pull in display data
  veg_summary <- import("data_display.xlsx", which=5)
  
  # render
  output$veg_site_summary <- DT::renderDataTable({
    DT::datatable(veg_summary)
  })
  
  # Data table: available data
  veg_data_summary <- import("data_display.xlsx", which=6)
  
  output$veg_data <- DT::renderDataTable({
    DT::datatable(veg_data_summary)
    })
}

