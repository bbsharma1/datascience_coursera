
## Write a function called best that take two arguments: the 2-character abbreviated name of a state and an
## outcome name. 
## The function reads the outcome-of-care-measures.csv file and returns a character vector
## with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the specified outcome
## in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can
## be one of “heart attack”, “heart failure”, or “pneumonia”. Hospitals that do not have data on a particular
## outcome should be excluded from the set of hospitals when deciding the rankings.
## Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital names should
## be sorted in alphabetical order and the first hospital in that set should be chosen (i.e. if hospitals “b”, “c”,
## and “f” are tied for best, then hospital “b” should be returned).
## The function should use the following template.

best <- function (state,  outcome)
{
  ## set working directory 
  setwd("~/Documents/RStudio/datascience_coursera/Week4/rprog_data_ProgAssignment3-data/")
  
  ## read outcome data
  table <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
  
  ## check that the state and outcome are valid 
  check_state <- state
  states <- unique(table$State)
          ## create list of states using sapply, check that the state entered is found in that list
         USA <- any(check_state == states)
         if (USA == FALSE)
         {
           return(print('invalid state'))
         } ## end of if USA function
         
  out <- any(outcome == c("heart attack", "heart failure", "pneumonia"))
        if (out == FALSE)
        {
          return(print('invalid outcome'))
        } ## end of if out function
  
  
  ## return hospital name with lowest 30 day death rate 
  new_data <- data.frame()
  new_data <- cbind(table$Hospital.Name, "State" = table$State, 
                    "Heart Attack" = table$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack,
                    "Heart Failure" = table$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure,
                    "Pneumonia" = table$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia) 
  
  
          if(outcome == 'heart attack') {
            i <- 3
          }
          else if(outcome == 'heart failure') {
            i <- 4
          }
          else if(outcome == 'pneumonia') {
            i <- 5
          }
          else {
            stop('invalid outcome')
          }

  
          ## Select only the rows for the state indicated
          is.na(new_data) # original data had all Not Applicable, so we can set it as NA 
          chosenstates <- new_data[(new_data[, "State"] == state), ]
          ##str(chosenstates)

          ## Convert column to numberic, remove NA values, and select the minimum
          chosenstates[, i] <- as.numeric(chosenstates[, i])
          chosenstates <- chosenstates[!is.na(chosenstates[, i]), ]
          chosenstates <- chosenstates[which.min(chosenstates[, i]), ]
          chosenstates[1]
          
} ## end of best function 