

ui <- navbarPage("sUAS Wildlife Literature Database",
                 tabPanel("About",
                          h2("About This Database"),
                          p("This database was designed to allow researchers, biologists and conservationists to easily search for articles related to wildlife research, management and conservation using drones. The information was aggregated together by Rick Spaulding and the Shiny App was built by Wade Sedgwick."),
                          p("To use this database, go to the 'Search' bar. Articles can be filtered by Year, on the left, or can be searched by keyword or by their title. The user can easily copy, print, download an excel spreadsheet, or print a PDF of the articles visible. Articles per page length can also be adjusted at the top.")
                 ),
                 tabPanel("Search",
                          mainPanel(
                            DTOutput("searchResults"),
                            width = 12
                          )
                 ),
                 tabPanel("Stats",
                          h2("Statistics on this Database"),
                          selectInput("selectedColumn", "Select Column",
                                      choices = c("Year", "Group", "Family", "sUAS.Platform", "sUAS.Model", "Sensors")),
                          numericInput("topN", "Number of Top Entries", value = 10, min = 1),
                          plotOutput("freqPlot"))
)