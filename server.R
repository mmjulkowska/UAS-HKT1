shinyServer(function(input, output) {


  output$error_barsy <- renderUI({
    
    if(input$graph_type == "box plot"){
      return()
    }
    else{
      selectInput("Errors",
                  label = "Error bars represent :",
                  choices = c("Standard Deviation", "Standard Error"),
                  selected = "Standard Error")
    }
  })
  
  data <- reactive({
    bem <- subset(final, final$gene == input$gene_select)
  })
  
  output$data_table <- renderDataTable({
    data <- data()
    data_sum <- summaryBy(value ~ geno + condition, data = data, FUN=function(x){c(m = mean(x), sd=sd(x), se=std.error(x))})  
    data_sum
  })
  
  barPlot <- reactive({
    data <- data()
    data_sum <- summaryBy(value ~ geno + condition, data = data, FUN=function(x){c(m = mean(x), sd=sd(x), se=std.error(x))})  
    benc <- ggplot(data = data_sum, aes(x = geno, y=value.m, fill = geno))
    benc <- benc + geom_bar(stat="identity", position = position_dodge(1))
    
    if(input$Errors == "Standard Deviation"){
      benc <- benc + geom_errorbar(aes(ymin = value.m - value.sd, ymax = value.m + value.sd), position = position_dodge(1))  
    }
    
    if(input$Errors == "Standard Error"){
      benc <- benc + geom_errorbar(aes(ymin = value.m - value.se, ymax = value.m + value.se), position = position_dodge(1))  
    }
    
    benc <- benc + facet_wrap(~ condition, scale = "fixed")
    benc <- benc + ggtitle(input$gene_select)
    benc
  })
  
  boxPlot <- reactive({
    data <- data()
    benc <- ggplot(data = data, aes(x = geno, y = value, fill = geno))
    benc <- benc + geom_boxplot()
    benc <- benc + facet_wrap(~ condition, scale = "fixed")
    benc <- benc + ggtitle(input$gene_select)
    benc
  })
  
  output$Main_plot <- renderPlot({
    
    if(input$graph_type == "bar plot"){
      plotski <- barPlot()
    }
    
    if(input$graph_type == "box plot"){
      plotski <- boxPlot()
    }
  
    plotski
  })
  
  output$Gene_annotation <- renderTable({
  table <- gene_anno
  gen <- input$gene_select
  final_table <- table[table$Gene %in% gen,]
  final_table
  #table
  })

  
  output$ANOVA_message <- renderPrint({
  temp <- data()
  thres <- input$threshold_p_value
  amod <- aov(value ~ geno + condition + geno*condition, data = temp)
  
  cat("ANOVA report")
  cat("\n")
  if(summary(amod)[[1]][[5]][1] < thres){
    cat("The effect of genotype is SIGNIFICANT on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][1], ".")
  }
  if(summary(amod)[[1]][[5]][1] > thres){
    cat("The effect of genotype is NOT significant on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][1], ".")
  }
  
  if(summary(amod)[[1]][[5]][2] < thres){
    cat("\n")
    cat("The effect of condition is SIGNIFICANT on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][2], ".")
  }
  if(summary(amod)[[1]][[5]][2] > thres){
    cat("\n")
    cat("The effect of condition is NOT significant on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][2], ".")
  }
  
  if(summary(amod)[[1]][[5]][3] < thres){
    cat("\n")
    cat("The interaction between genotype and condition is SIGNIFICANT on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][3], ".")
  }  
  if(summary(amod)[[1]][[5]][3] > thres){
    cat("\n")
    cat("The interaction between genotype and condition is NOT significant on ", input$model_trait_plot, "with a p-value of ", summary(amod)[[1]][[5]][3], ".")
  }
  })
  
# end of the APP - no text beyond this point!    
})

