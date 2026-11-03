# Hudson River Monitoring Data
# This is the user-interface

library(shiny)
library(bslib)
library(leaflet)
library(htmltools)

page_navbar(title="Hudson River Monitoring Data", id="tab",
# Water quality tab
    nav_panel("Water Quality", 
              fluidPage(
                  fluidRow(
                    column(width=4,
                  # Check boxes
                        checkboxGroupInput(inputId="network",label="Choose a network",
                                      choices=c("SWMP", "HRECOS"),
                                      selected=c("SWMP", "HRECOS")),
                  # Toggle active / inactive
                        radioButtons(inputId="status", label="Show inactive locations?", 
                                     choices=c("Yes", "No"),
                                     selected="No"),
                        h2("About water quality data"),
                        p("HRNERR has been collecting 15-minute water quality 
                          data and monthly nutrient data since 1995 as part of the 
                          System-wide Monitoring Program (SWMP). In 2008, the Hudson River 
                          Environmental Conditions Observing System (HRECOS) expanded 
                          15-minute data to sites beyond the boundaries of HRNERR. 
                          All data are freely available to the public using the links below.")
                ),
                  # Map output
                  column(width=8,
                        leafletOutput("wq_map", height="600px")
                )
                ),
                  # Data table that changes along with map
                  fluidRow(h2("Available data:"),
                          h4("Continuous (15-minute) data:"),
                           DT::dataTableOutput("display_wq")
                ),
                  fluidRow(h4("Monthly grab samples:"),
                           DT::dataTableOutput("display_nut"))
                            )
    ),
# Meteorology tab
nav_panel("Meteorology",
          fluidPage(
            fluidRow(
              column(width=4,
                     # Check boxes
                     # Selection is set to NULL to circumvent rendering issue
                     checkboxGroupInput(inputId="met_network",label="Choose a network",
                                        choices=c("SWMP", "HRECOS"),
                                        selected=NULL),
                     # Toggle active / inactive
                     radioButtons(inputId="met_status", label="Show inactive locations?", 
                                  choices=c("Yes", "No"),
                                  selected="No"),
                     h2("About meteorological data"),
                     p("HRNERR has been collecting 15-minute meteorological
                        data since 1995 as part of the System-wide Monitoring Program (SWMP). 
                        In 2008, the Hudson River Environmental Conditions Observing System (HRECOS) expanded 
                        15-minute data to sites beyond the boundaries of HRNERR. 
                        All data are freely available to the public using the links below.")
              ),
              column(width=8,
                     leafletOutput("met_map", height="600px"))
            ),
            fluidRow(h2("Available data:"),
                     h4("Continuous (15-minute) data:"),
                     DT::dataTableOutput("display_met"))
          )
  ),
# Water level tab
    nav_panel("Water Levels", 
          fluidPage(
            fluidRow(
              column(width=4,
                     h2("About water level data"),
                     p("Our tide stations are part of the NOAA Hudson River Estuary (HRE) Physical Oceanographic
                       Real-Time System (PORTS) Network. Stations are managed and operated by HRNERR, with data 
                       management, QAQC, data products, and support by NOAA. Check out the", 
                       a("HREPORTS", href="https://tidesandcurrents.noaa.gov/ports/index.html?port=hr", target="blank"), 
                       "webpage for more."),
            ),
              column(width=8,
                     leafletOutput("tide_map", height="600px"))
            ),
            fluidRow(
              column(width=12,
                     DT::dataTableOutput("display_tides"))
            )
          )
  ), 
# Vegetation tab
    nav_panel("Vegetation",
              fluidPage(
                fluidRow(
                  column(width=4,
                      h2("About vegetation data"),
                      p("Researchers at HRNERR monitor emergent tidal wetland vegetation and 
                      submerged aquatic vegetation at some of our component sites to track the 
                      ecological functions of habitats and how they are changing. Data can be 
                      explored on the Centralized Data Management Office", 
                      a("(CDMO)", href="https://cdmo.baruch.sc.edu/get/vegetation_index.cfm", target="blank"), "website. 
                      HRNERR also coordinates vegetation mapping efforts in the estuary. To learn more check out the HRNERR", 
                      a("website.", href="https://hrnerr.org/research-monitoring/mapping/", target="blank"))
                  ),
                  column(width=8,
                         leafletOutput("veg_map", height="600px"))
                  
                ),
                fluidRow(
                  h2("Site summary:"),
                  DT::dataTableOutput("veg_site_summary"),
                  h2("Available data:"),
                  DT::dataTableOutput("veg_data")
                )
              )),
# About tab
    nav_panel("About",
              fluidPage(
                fluidRow(
                  column(width=8, h2("About the Hudson River National Estuarine Research Reserve (HRNERR)"),
                         p(a("HRNERR's", href="https://hrnerr.org/", target="blank"), "mission is to improve the health and resilience of the Hudson River Estuary 
                         by conserving estuarine habitats through integrated education, training, 
                         stewardship, restoration, monitoring, and research programs."),
                         p("As part of the System-Wide Monitoring Program (SWMP), we collect site-specific 
                           data including water quality, nutrients, weather, and vegetation communities.Our data is freely available to the public.
                           You can download datasets from the Centralized Data Management Office", a("(CDMO)", href="https://cdmo.baruch.sc.edu/", target="blank")),
                         p("In 2008, HRNERR partnered with several organizations to establish the Hudson River Environmental Conditions Observing System", 
                           a("(HRECOS)", href="https://hrecos.org/about/", target="blank"),
                           "which extended continuous water quality data to areas beyond the scope of the HRNERR's component sites."),
                         p("In 2024, HRNERR and NOAA partnered to establish the Hudson River Estuary PORTS", 
                         a("(HREPORTS)", href="https://tidesandcurrents.noaa.gov/ports/index.html?port=hr", target="blank"), "network, which brought localized
                           water level data to the Hudson.")
                ),
                  column(width=4,
                         h4("About this app"),
                         p("Explore available datasets from HRNERR."),
                         p("Developed with Shiny for R by", a("Brittney Flaten", href="https://github.com/bkflat", target="blank")),
                )
              ),
              fluidRow(column(width=8,
                              h4("Data sources"),
                              p(HTML("<b>SWMP: water quality, meteorology, nutrients, and vegetation</b>")),
                              p("Centralized Data Management Office", a("(CDMO)", href="https://cdmo.baruch.sc.edu/", target="blank")),
                              p(HTML("<b>Water level</b>")),
                              p("NOAA PORTS", a("website", href="https://tidesandcurrents.noaa.gov/ports/index.html?port=hr", target="blank")),
                              p(HTML("<b>HRECOS</b>")),
                              p("HRECOS", a("website", href="https://hrecos.org/about/", target="blank"))
                      ),
                       column(width=4,
                              h4("Contacts"),
                              p(HTML("<b>SWMP data: water quality, meteorology, and nutrients</b>")),
                              p("Chris Mitchell,", a("christopher.mitchell@dec.ny.gov", href="mailto:christopher.mitchell@dec.ny.gov")),
                              p(HTML("<b>SWMP data: vegetation</b>")),
                              p("Christina Pacella,", a("christina.pacella@dec.ny.gov", href="mailto:christina.pacella@dec.ny.gov")),
                              p(HTML("<b>Water levels</b>")),
                              p("Chris Mitchell,", a("christopher.mitchell@dec.ny.gov", href="mailto:christopher.mitchell@dec.ny.gov")),
                              p(HTML("<b>HRECOS</b>")),
                              p("Brittney Flaten,", a("brittney.flaten@dec.ny.gov", href="mailto:brittney.flaten@dec.ny.gov")))
              )
    )
    )
)
