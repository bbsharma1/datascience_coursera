rankhospital <- function(state, outcome, num = 'best') {
  ## set working directory 
  setwd("~/Documents/RStudio/datascience_coursera/Week4/rprog_data_ProgAssignment3-data/")
  
  ## read outcome data
  table <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
  
  ## check that the state, outcome, and num are valid 
  check_state <- state
  states <- unique(table$State)
        USA <- any(check_state == states)
        if (USA == FALSE)
        {
          stop('invalid state')
        } ## end of if USA function
        
        out <- any(outcome == c("heart attack", "heart failure", "pneumonia"))
        if (out == FALSE)
        {
          stop('invalid outcome')
        } ## end of if out function
        
        real_number <- !is.numeric(num)
        if( num != "best" && num != "worst" && real_number )
        {
          stop('invalid num')
        }

  ## return hospital name with lowest 30 day death rate 
        new_data <- table[c(2, 7, 11, 17, 23)]
        names(new_data) <- (c("hospital", "state", "heart attack", "heart failure", "pneumonia"))

        ## Select only the rows for the state indicated, remove NA rows, and convert the outcome column to numeric to sort
        chosenstates <- new_data[(new_data[, "state"] == state), ]
        chosenstates <- chosenstates[!is.na(chosenstates[, outcome]), ]
        chosenstates[outcome] <- as.data.frame(sapply(chosenstates[outcome], as.numeric))

        ## Sort
        chosenstates <- chosenstates[order(chosenstates[, outcome], chosenstates[, "hospital"]), ]
        
        ##Now we want to only select 1 
        maxrows <- nrow(chosenstates)
        if( num == "best" ) {
          rownumber <- 1
        } 
        else if( num == "worst" ) 
        {
          rownumber <- maxrows
        } 
        else 
        {
          rownumber <- num
        }
        ## checking and returning NA if num is > total rows (I was getting error output when using stop function)
        if (rownumber > maxrows)
        {
          return(print(noquote('NA')))
          stop('NA')
        }
    
  ## Finally, return hospital name
  chosenstates[rownumber, 1]

} ## end of rankhospital function 