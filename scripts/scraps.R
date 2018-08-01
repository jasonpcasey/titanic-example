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


output$newdat <- renderDataTable({
  GetRow()
})


numericInput(inputId = "cutoff",
             label="Percentage Survived",
             value=0.38,
             min=0.00,
             max=1.00,
             step=0.01),


,
pclass = factor(pclass),
surname = factor(surname),
title = factor(title),
embarked = factor(embarked),
family_id = factor(family_id),
family_id2 = factor(family_id2),
sex = factor(sex)