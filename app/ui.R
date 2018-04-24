fluidPage(
  titlePanel("Titanic Predictor"),
  sidebarLayout(
    sidebarPanel(
      selectInput('Pclass','Cabin Class',
                  choices=c('First Class'="1",
                            'Second Class'="2",
                            'Third Class'="3"),
                  selected=1),
      selectInput(inputId='Sex',
                  label='Sex',
                  choices=c('Male'="male",
                            'Female'="female"),
                  selected=1),
      numericInput(inputId='Age',
                   label='Age (Average = 29.6)',
                   value = 29.6,
                   min = 0.1,
                   max = 80.0,
                   step=0.1),
      numericInput('SibSp', 'Number of siblings/spouses aboard (Average = 1)', value = 1, min = 0, max = 10, step=1),
      numericInput('Parch', 'Number of parents/children aboard  (Average = 0)', value = 0, min = 0, max = 10, step=1),
      numericInput('Fare', 'Fare paid  (Average = 32.20)', value = 32.20, min = 0, max = 515, step=5),
      selectInput('Embarked','Embarkation Point',
                  choices=c('Southampton'="S",
                            'Queenstown'="Q",
                            'Cherbourg'="C"),
                  selected=1),
      selectInput('Title','Title',
                  choices=c('Mr'="Mr",
                            'Mrs'="Mrs",
                            'Miss'="Miss",
                            'Master'='Master',
                            'Titled (e.g.,"Rev","Dr",etc)'='Titled'),
                  selected=1),
      numericInput('FamilySize', 'Number of family members (Average = 2)', value = 2, min = 0, max = 10, step=1)
      ),
    mainPanel(
      textOutput('verdict'),
      textOutput('prob')
      )
    )
  )