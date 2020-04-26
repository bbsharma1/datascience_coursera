rankall <- function(outcome, num = 'best') {
  ## set working directory 
  setwd("~/Documents/RStudio/datascience_coursera/Week4/rprog_data_ProgAssignment3-data/")
  
  ## read outcome data
  table <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
      
  ## check that the outcome and num are valid 
  out <- any(outcome == c("heart attack", "heart failure", "pneumonia"))
  if (out == FALSE)
  {
    stop('invalid outcome')
  } 
  
  real_number <- !is.numeric(num)
  if( num != "best" && num != "worst" && real_number )
  {
    stop('invalid num')
  } 

  ## Return a data frame with the hospital names and the abbreviated state names  [should be 1 entry per state!!] 
          ## Sort in order by hospital from each state
          ## split the tables to view by state

          selection <- outcome
          if (selection == 'heart attack')
          {
          selection <- 11
          } else if (selection == 'heart failure')
          {
            selection <- 17
          } else 
          {
            selection <- 23
          }
          
          ## Grab relevant data, change outcome to numeric, and remove NA values from outcome
          new_data = table[,c(2, 7, selection)]
          names(new_data) <- c("Hospital", "State", outcome)
          new_data[,outcome] <- as.numeric(new_data[,outcome])
          new_data <- new_data[!is.na(new_data[, outcome]), ]

          ## Sort
              ## If two hospitals have the same rate, sort Hospitals by alphabetical order
          new_data <- new_data[order(new_data[, "Hospital"]), ]
          new_data <- new_data[order(new_data[, outcome]), ]
          new_data <- new_data[order(new_data[, "State"]), ] 
                              ##head(new_data) ## test. Looks good!


          ## Seperate the data:
          seperate_states <- split(new_data, new_data[, "State"])
                              ## splitting <- lapply(seperate_states, function(x) x[1,]) 
                              ## states <- lapply(splitting, function(x) x[, 2])
                              ## Hospital <- lapply(splitting, function(x) x[, 1])
                              ## didnt work as expected

          if( num == "best" ) {
            num <- 1
          } 
          
          ## Go through each state to find the row# and output the name 
          final <- sapply(seperate_states, function(x){
            if(num == "worst"){
              num <- nrow(x[outcome])-sum(is.na(x[outcome]))
            }
            x[num,1]
  }) ## end of final function
  outcome <- data.frame(hospital=final, state=names(final), row.names=names(final))
  outcome
          
} ## end of rankall function