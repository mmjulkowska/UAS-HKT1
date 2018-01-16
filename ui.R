

shinyUI(fluidPage(

  # Application title
  titlePanel("UAS-HKT1 RNAseq data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # Select gene(s) to plot:
      selectizeInput("gene_select", "Select the gene to plot", choices = gene_list, multiple = F),
      # Select the plot type - box plot / bar plot
      selectInput("graph_type", "Select the plot type", choices = c("box plot", "bar plot")),
      # if bar plot - then add error bar drop down menu - SE / StDev
      uiOutput("error_barsy"),
      numericInput("threshold_p_value", label = "Enter threshold p-value", max = 0.1, value = 0.01),
      # download plot as pdf button
      downloadButton("Download_plot", "Download .pdf file"),
      # download underlying data
      downloadButton("Download_csv", "Download underlying data")
    ),

    # Show a plot of the generated distribution
    mainPanel(navbarPage("",
    tabPanel("Absolute expression",                     
      
      # table (temporary)
      # dataTableOutput("data_table"),
      # Plot
      plotOutput("Main_plot"),
      # gene description from annotation file
      # tableOutput("Gene_annotation"),
      # Tukey table of significance
      verbatimTextOutput("ANOVA_message")),
    tabPanel("Relative expression vs. control conditions",
      plotOutput("Relative_to_C_plot"),
    verbatimTextOutput("ANOVA_message_relative_to_C")),
    tabPanel("Relative expression vs. background",
             plotOutput("Relative_to_bckgrnd_plot"),
             verbatimTextOutput("ANOVA_message_relative_to_bckgrnd")       
             )
    )
  ))
))
