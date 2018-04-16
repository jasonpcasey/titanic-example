xrow <- reactive({
  # make a new row from inputted values
  # cutoff <- as.numeric(input$cutoff)
  Pclass <- as.character(input$Pclass)
  Sex <- as.character(input$Sex)
  Age <- as.numeric(input$Age)
  SibSp <- as.integer(input$SibSp)
  Parch <- as.integer(input$Parch)
  Fare <- as.numeric(input$Fare)
  Embarked <- as.character(input$Embarked)
  Title <- as.character(input$Title)
  FamilySize <- as.integer(input$FamilySize)
  
  # Sex <- 'male'
  # Age <- 29.6
  # SibSp <- 1
  # Parch <- 0
  # Fare <- 32.20
  # Embarked <- 'S'
  # Title <- 'Mr'
  # FamilySize <- 2
  
  this.row <- makeRow(Pclass,
                      Sex,
                      Age,
                      SibSp,
                      Parch,
                      Fare,
                      Embarked,
                      Title,
                      FamilySize)
  
  #return(myRow)
})

kickMe <- reactive({
  # update prediction
  # myPred <- updatePrediction()
  # return(myPred[2])
})
