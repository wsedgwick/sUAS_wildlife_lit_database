
# Assuming 'drone_wildlife_lit_database.csv' is in the working directory of the R session
data <- read.csv('data/drone_wildlife_lit_database.csv', stringsAsFactors = FALSE)

# wrangle data
data <- data %>%
  filter(!is.na(`sUAS.Platform`), `sUAS.Platform` != "Not Provided") %>%
  mutate(`sUAS.Platform` = str_replace_all(`sUAS.Platform`, "\\n", " ")) %>%
  mutate(`sUAS.Platform` = str_replace_all(`sUAS.Platform`, "^[0-9]+\\)\\s*", "")) %>% 
  mutate(`sUAS.Platform` = str_to_title(as.character(`sUAS.Platform`))) %>% 
  mutate(`Group` = str_to_title(as.character(`Group`))) %>% 
  mutate(`Family` = str_to_title(as.character(`Family`))) %>% 
  mutate(`sUAS.Model` = str_replace_all(`sUAS.Model`, "Aerial Imaging Solutions ", ""))

years <- sort(unique(data$Year[!is.na(data$Year)]), decreasing = TRUE)

server <- function(input, output, session) {
  
  # Populate the 'yearFilter' select input with unique years from the dataset
  updateSelectInput(session, "yearFilter", choices = c("All" = "All", years))
  
  # Define a reactive expression for filtered data
  filteredData <- reactive({
    df <- data
    
    # Filter by Year if "All" is not selected
    if (!"All" %in% input$yearFilter && !is.null(input$yearFilter) && length(input$yearFilter) > 0) {
      df <- df %>% filter(Year %in% input$yearFilter)
    }
    
    df # Return the filtered dataset
  })
  
  # Reactively render the DataTable when 'searchButton' is clicked or other inputs change
  output$searchResults <- renderDT({
    df <- filteredData() # This will re-run when inputs change due to reactivity
    
    # Replace dots in column names with spaces for display purposes
    colnames(df) <- gsub("\\.", " ", colnames(df))
    
    datatable(df, extensions = 'Buttons', options = list(
      autoWidth = TRUE,
      scrollX = TRUE,
      dom = 'Blrftip',
      buttons = c('copy', 'csv', 'excel'),
      lengthMenu = list(c(5, 10, 20, 50, -1), c('5', '10', '20', '50', 'All')),
      pageLength = 20,
      columnDefs = list(
        list(width = '400px', targets = which(colnames(df) == "Title")),
        list(width = '200px', targets = which(colnames(df) == "Authors")),
        list(width = '150px', targets = which(colnames(df) == "Keywords")),
        list(width = '200px', targets = which(colnames(df) == "Species")),
        list(width = '200px', targets = which(colnames(df) == "Sensors")))
    ))
  })
  
  output$freqPlot <- renderPlot({
    # Ensure selected column is available and not empty
    if (!input$selectedColumn %in% names(data) || input$selectedColumn == "") {
      return(NULL)
    }
    
    # Data manipulation to count frequencies in the selected column, excluding NAs
    if (input$selectedColumn %in% names(data)) {
      
      # Use all_of() for safe variable evaluation inside dplyr verbs
      freq_data <- data %>%
        select(all_of(input$selectedColumn)) %>%
        filter(!is.na(!!sym(input$selectedColumn)), 
               !!sym(input$selectedColumn) != "", 
               !!sym(input$selectedColumn) != "Not Provided") %>%
        group_by(!!sym(input$selectedColumn)) %>%
        summarise(Frequency = n(), .groups = 'drop') %>%
        arrange(desc(Frequency)) %>%
        slice_max(order_by = Frequency, n = input$topN)
      
      # Plotting
      ggplot(freq_data, aes(x = fct_reorder(!!sym(input$selectedColumn), Frequency), y = Frequency)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        theme_minimal() +
        labs(title = paste("Top", input$topN, "Frequencies in", input$selectedColumn),
             x = input$selectedColumn,
             y = "Frequency") +
        coord_flip() # For horizontal bars
    } else {
      # Return an empty plot or a message indicating the selection is invalid
      return(ggplot() + ggtitle("Please select a valid column."))
    }
    })
 
  observeEvent(input$searchButton, {
   
  })

}