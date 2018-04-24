function(input, output) {

  GetRow <- reactive({
    # make a new row from inputted values
    cutoff <- as.numeric(input$cutoff)
    Pclass <- as.character(input$Pclass)
    Sex <- as.character(input$Sex)
    Age <- as.numeric(input$Age)
    SibSp <- as.integer(input$SibSp)
    Parch <- as.integer(input$Parch)
    Fare <- as.numeric(input$Fare)
    Embarked <- as.character(input$Embarked)
    Title <- as.character(input$Title)
    FamilySize <- as.integer(input$FamilySize)
    
    this.row <- makeRow(Pclass,
                        Sex,
                        Age,
                        SibSp,
                        Parch,
                        Fare,
                        Embarked,
                        Title,
                        FamilySize)
    
    return(this.row)
  })
  
  kickMe <- reactive({
    # update prediction
    myPred <- updatePrediction(GetRow())
    return(myPred[2])
  })
  
  myVerdict <- reactive({
    # update prediction
    myPred <- as.numeric(kickMe())
    output.text <- ifelse(myPred >= 0.5, 'survived', 'perished')
    
    return(output.text)
  })
  
  output$verdict <- renderText({
    paste('This person likely', myVerdict())
  })
  
  output$prob <- renderText({
    paste('Survival probability = ', round(kickMe(),2))
    #ifelse(kickMe()[2] > (1 - as.numeric(input$cutoff)), 'Survived','Died')
    # summary(fit)
  })
  

}

