##################################################################################################################
## Install and load packages
install.packages("filesstrings")
library(filesstrings) ## to move/copy files in directory
##################################################################################################################

##################################################################################################################
# Download file and backup original
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("./PowerConsumption.zip") | (!file.exists("./archive/PowerConsumption.zip")))
{
  download.file(fileUrl, destfile = "./PowerConsumption.zip",  mode = "wb", method = "curl")
  if(!file.exists("./archive")){dir.create("./archive")}
  Powerconsum_dw_time <- date()
  print("File downloaded, now unzipping")
  unzip("PowerConsumption.zip")
  file.move("./PowerConsumption.zip", "./archive/", overwrite = TRUE)  ## backup original file
} else if (file.exists("./archive/PowerConsumption.zip") & !file.exists("./household_power_consumption.txt")) {
  print("Zip file found but no txt file, unzipping!")
  unzip("PowerConsumption.zip")
  file.move("./PowerConsumption.zip", "./archive/", overwrite = TRUE)
} else {
  print("Files found, not downloading")
  file.move("./PowerConsumption.zip", "./archive/", overwrite = TRUE)
}
##################################################################################################################

##################################################################################################################
# Calculate rough estimate of required memory
## Z = (# rows) x (# columns) x 8 byts/numeric
## Y = (Z/(2^20)) in Megabytes
## MemG = (Y/(2^10)) in Gigs

Z <-  (2075259)*(9)*8
Y <- (Z/(2^20))
MemG <- (Y/(2^10)) 
MemG
## Observation: .139 Gigs required to process the entire document.
##################################################################################################################

##################################################################################################################
## Read the Data 
consump <- read.table("./household_power_consumption.txt", sep = ";", 
                      header = TRUE, na.strings = "?", stringsAsFactors = FALSE)
##################################################################################################################

##################################################################################################################
## Get only data that we need, from 2007-02-01 to 2007-02-02

plot1data <- consump[consump$Date %in% c("1/2/2007","2/2/2007"), ]
## Observation: 2880 rows were pulled

## plot1data$Time <- strptime(x = finalData$Time, format = "%H:%M:%S")
## Observation: The above converted Time from HMS to YMD HMS (with the current year of 2020)

# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot1.png", width = 480, height = 480)
hist(finalData$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", main = "Global Active Power")
dev.off()
##################################################################################################################