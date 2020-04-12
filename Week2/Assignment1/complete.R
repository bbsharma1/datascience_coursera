complete <- function (directory, id = 1:332) { 
  ## directory is  a character vector of  length 1 indicating  
  ## location of the CSV  files
  
  ## id is an integer vector indicating  the monitor ID numbers to be used

  ## return dataframe of the frame
  ## id nobs
  ##  1 117
  ##  2 1041
  ## where  id is the monitor number and nobs is number of complete cases

  ########Checking for valid entry 
  if (directory != "specdata") {
    return(print("Invalid directory. This program will not work correctly, exiting."))
  }
  if (directory == "specdata") {
    #paste(c("You selected directory:", directory), collapse=" ")
  }
  
  ##reads a directory full of files
  allfiles <- list.files(full.names = TRUE)
  #allfiles
  workingfile <- data.frame()
  
  ## Will need to read every row of the file/files and count how many have complete values, where id is the fileid,
  ## and nobs is the number of  lines that has complete data in the file.
  ## complete.cases can be used to output non NA values
  
  for (i in id) {
    ##print("test") used for testing error
    onefile <- read.csv(allfiles[i],  header = TRUE)
    ##print("test2") used for testing error
    nobs <- sum(complete.cases(onefile))
    df <- data.frame(i, nobs)
    workingfile <- rbind(workingfile, df)
    
  } ## end of for loop
  colnames(workingfile) <- c("id", "nobs")
  workingfile
  
  } ## end of complete function 