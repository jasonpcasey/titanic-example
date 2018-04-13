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
  new.row <- data_frame(Survived = 0,
                        Pclass = Pclass,
                        Sex = Sex,
                        Age = Age,
                        SibSp = SibSp,
                        Parch = Parch,
                        Fare = Fare,
                        Embarked = Embarked,
                        Title = Title,
                        FamilySize = FamilySize) %>%
    mutate(Pclass = factor(Pclass, levels=c('1','2','3')),
           Sex = factor(Sex, levels=c('male','female')),
           Embarked = factor(Embarked, levels=c('S','C','Q')),
           Title = factor(Title, levels=c('Mr','Mrs','Miss','Master','Titled')))
  
  # return the dataframe
  return(new.row)
}

createDataSet <- function() {
  set.seed(415)
  
  training.data <- read_csv('data/train.csv') %>%
    mutate(Set = 'train')
  
  testing.data <- read_csv('data/test.csv') %>%
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
           Sex = factor(Sex))

  AgeFit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize,
                  data = combined.data[!is.na(combined.data$Age),],
                  method = 'anova')
  
  combined.data$Age[is.na(combined.data$Age)] <- predict(AgeFit, combined.data[is.na(combined.data$Age),])
  
  # Housekeeping: clear unused objects from memory
  rm(AgeFit)
  
  combined.data <- combined.data %>%
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
           FamilySize)
  
  return(combined.data)
}

df <- createDataSet()

fit <- randomForest( factor(Survived) ~ .,
                     data = df,
                     importance = TRUE,
                     ntree = 2000)

summary(fit)

df.1 <- makeRow('1','male',29.6,1,0,32.20,'S','Mr',2)

mod.pred <- predict(fit,
                    df.1,
                    type = 'prob')

mod.pred[2]