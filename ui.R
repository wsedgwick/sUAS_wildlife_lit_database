

ui <- navbarPage("sUAS Wildlife Literature Database",
                 tabPanel("About",
                          h2("About This Database"),
                          p("This database was designed to allow researchers, biologists and conservationists to easily search for articles related to drone-based wildlife research, management and conservation. The information was aggregated by Rick Spaulding and the Shiny App was built by Wade Sedgwick."),
                          p("To use this database, go to the 'Search' page at the top. Users can search for articles at the top right, and can also search by year published. The user can easily copy, print or download an excel spreadsheet. Articles per page length can also be adjusted at the top."),
                          p("Users can also look at basic statistics of the database. Go to the 'Stats' page, and the user can visualize the groups and families most often surveyed using drones, or which drone platforms are used most often."),
                          p("Information in this database includes: Author, Year Published, Title, Journal/Report/Book/Conference, Group, Family, and Species, Keywords, Citation, sUAS Platform, sUAS Model, and Sensors used. Not all information is complete.")
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