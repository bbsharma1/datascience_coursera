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
plot3data <- consump[consump$Date %in% c("1/2/2007","2/2/2007"), ]

plot3data$Date_Time <- as.POSIXct(strptime(paste(plot3data$Date, plot3data$Time), format = "%d/%m/%Y %H:%M:%S"))

# New data without the seperate Date and Time
plot3data <- plot3data[, c("Date_Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                           "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]


png(filename = "plot3.png", width = 480, height = 480)
# Creating plot
with(plot3data, {
  plot(Sub_metering_1 ~ Date_Time, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
  lines(Sub_metering_2 ~ Date_Time, col = "red", type = "l")
  lines(Sub_metering_3 ~ Date_Time, col = "blue", type = "l")
})

# Adding Legend
legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1))
dev.off()
##################################################################################################################