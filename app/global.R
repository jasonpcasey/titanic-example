library(rpart)
library(randomForest)
library(party)
library(caret)
library(tidyverse)


makeRow <- function(Pclass,
                    Sex,
                    Age,
                    SibSp,
                    Parch,
                    Fare,
                    Embarked,
                    Title,
                    FamilySize) {
  
  # assign inputted values to new dataframe
  # offcampus is set to NA and will eventually hold the predicted probability
  new.row <- data_frame(Survived = 0,
                        Pclass = Pclass,
                        Sex = Sex,
                        Age = Age,
                        SibSp = SibSp,
                        Parch = Parch,
                        Fare = Fare,
                        Embarked = Embarked,
                        Title = Title,
                        FamilySize = FamilySize)
  
  # new.row$sport2 <- factor(new.row$sport2,
  #                          levels=c("0",
  #                                   "base",
  #                                   "basket",
  #                                   "cheer",
  #                                   "crew",
  #                                   "fence",
  #                                   "foot",
  #                                   "golf",
  #                                   "hockey",
  #                                   "lacross",
  #                                   "manager",
  #                                   "multi",
  #                                   "rowing",
  #                                   "soccer",
  #                                   "swim",
  #                                   "tennis",
  #                                   "track",
  #                                   "volley",
  #                                   "zspin"))
  
  # new.row$offcampus <- as.factor(new.row$offcampus)
  # new.row$dorm_style <- factor(new.row$dorm_style,
  #                              levels=c(0,1,2,3))
  # new.row$famwealth <- factor(new.row$famwealth,
  #                             levels=c(1,2,3,4,5,6))
  
  # return the dataframe
  return(new.row)
}

createDataSet <- function() {
  set.seed(415)
  
  training.data <- read_csv('../data/train.csv') %>%
    mutate(Set = 'train')
  
  testing.data <- read_csv('../data/test.csv') %>%
    mutate(Survived = 1,
           Set = 'test')
  
  combined.data <- training.data %>%
    union(testing.data) %>%
    separate(Name, c('Surname','Title','First'), sep='[.,]') %>%
    mutate(Group = factor(Survived, levels=0:1, labels=c('Perished','Survived')),
           FamilySize = SibSp + Parch + 1,
           Members = FamilySize,
           Title = str_trim(Title),
           Surname = str_trim(Surname),
           FamilyName = Surname,
           First = str_trim(First),
           Title = recode(Title,
                          'Mr' = 'Mr',
                          'Miss' = 'Miss',
                          'Mrs' = 'Mrs',
                          'Master' = 'Master',
                          'Ms' = 'Miss',
                          'Mlle' = 'Miss',
                          'Mme' = 'Mrs',
                          .default = 'Titled'),
           Embarked = ifelse(is.na(Embarked), 'S', Embarked),
           Fare = ifelse(is.na(Fare), median(Fare, na.rm = TRUE), Fare)) %>%
    unite('FamilyID',Members,FamilyName) %>%
    mutate(FamilyID2 = ifelse(FamilySize <= 3, 'Small', FamilyID),
           Pclass = factor(Pclass),
           Surname = factor(Surname),
           Title = factor(Title),
           Embarked = factor(Embarked),
           FamilyID = factor(FamilyID2),
           Sex = factor(Sex)) %>%
    filter(Set == 'train') %>%
    select(Survived,
           Pclass,
           Sex,
           Age,
           SibSp,
           Parch,
           Fare,
           Embarked,
           Title,
           FamilySize,
           FamilyID)
  
  return(combined.data)
}

df <- createDataSet()

