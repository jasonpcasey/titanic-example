function(input, output) {

  xrow <- reactive({
    # make a new row from inputted values
    Pclass <- as.character(input$Pclass)
    Sex <- as.character(input$Sex)
    Age <- as.numeric(input$Age)
    SibSp <- as.integer(input$SibSp)
    Parch <- as.integer(input$Parch)
    Fare <- as.numeric(input$Fare)
    Embarked <- as.character(input$Embarked)
    Title <- as.character(input$Title)
    FamilySize <- as.integer(input$FamilySize)
    
    
    myRow <- makeRow(Pclass,
                     Sex,
                     Age,
                     SibSp,
                     Parch,
                     Fare,
                     Embarked,
                     Title,
                     FamilySize)
  })
  
  kickMe <- reactive({
    # update prediction
    myPred <- updatePrediction(xrow())
    return(myPred)
  })

    #output$tab <- renderDataTable(df)
  output$prob <- renderPrint({
    ifelse(kickMe()[2] > (1 - as.numeric(input$cutoff)), 'Survived','Died')
  })

}

