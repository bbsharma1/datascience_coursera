pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of  the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate"
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  ## NOTE: Do not round the result

  
  ########Checking for valid entry 
  setwd("/Users/bishal/Documents/RStudio/datascience_coursera/Week2/Assignment1/specdata")

  if (directory != "specdata") {
    return(print("Invalid directory. This program will not work correctly"))
  }
  if (directory == "specdata") {
      #paste(c("You selected directory:", directory), collapse=" ")
    }
  
  if ((pollutant == "nitrate") | (pollutant == "sulfate")) {
    #paste(c("valid pollutant:", pollutant), collapse=" ")
    }
  else {
    print ("Invalid pollutant. This program will not work correctly")
    }

  ##Create one file with set of data using for loop and using rbind
  files <- list.files()
      ##files testing & Found all files
  workingfile <- data.frame()
  for (i in id) {
    workingfile <- rbind(workingfile, read.csv(files[i]))
  }
  #workingfile    <- created file test

  ######Now compute the mean, removing NA values
  mean(workingfile[,pollutant], na.rm = TRUE)
  
  
  
}## end of pollutantmean function
  
  