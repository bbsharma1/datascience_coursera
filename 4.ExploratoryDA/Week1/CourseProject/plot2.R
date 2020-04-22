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
plot2data <- consump[consump$Date %in% c("1/2/2007","2/2/2007"), ]
#plot2data

## Observation: Date column has changed from character class to date class
## Observation: Format for date will convert it to current year if '%y' is used instead of "%Y"

# Combine Date and Time 
plot2data$Date_Time <- as.POSIXct(strptime(paste(plot2data$Date, plot2data$Time), format = "%d/%m/%Y %H:%M:%S"))

# New data without the seperate Date and Time
plot2data <- plot2data[, c("Date_Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                           "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]


png(filename = "plot2.png", width = 480, height = 480)
plot(plot2data$Date_Time, plot2data$Global_active_power,
     type = 'l', ylab="Global Active Power (Kilowatts)", xlab="")
dev.off()
##################################################################################################################