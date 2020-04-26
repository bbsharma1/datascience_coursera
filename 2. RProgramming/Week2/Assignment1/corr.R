corr  <-  function  (directory, threshold =  0) {
  ## directory is  a character   of vector length 1 indicating  
  ## location of the CSV  files
  
  ## threshold is  a numeric vector of length 1 indicating  the number of completly observed  observations  
  ## on all variables required to compute the correlation between nitrate  and sulfate; default is 0
  ## Return numerical vector of correlations (DO NOT ROUND)
  
  
  ########Checking for valid entry 
  if (directory != "specdata") {
    return(print("Invalid directory. This program will not work correctly, exiting."))
  }
  if (directory == "specdata") {
    #paste(c("You selected directory:", directory), collapse=" ")
  }
  
  ## reads directory full of files and create vector as  opposed to data frame now (we are returning a number)
  setwd("/Users/bishal/Documents/RStudio/datascience_coursera/Week2/Assignment1/specdata/")
  #getwd() 
  allfiles <- list.files(full.names = TRUE)
  #allfiles
  correlation <- as.numeric(vector(length = 0)) ## 0 by default  
  #correlation
  
  for (i in 1:length(allfiles)) {
    onefile <- read.csv(allfiles[i],  header = TRUE)
    sulfate <- !(is.na(onefile$sulfate))
    nitrate <- !(is.na(onefile$nitrate))
    both <- sum(sulfate & nitrate)  # increment count if both sulfate and nitrate are NA
    
    if (both > threshold) {
      filter1 <- onefile[which(sulfate),  ]
      total <- filter1[which((!is.na(filter1$nitrate))), ]
      
      #finally:
      correlation <- c(correlation, cor(total$sulfate,total$nitrate))
    }
    }
  correlation
    
} # end of corr function 
