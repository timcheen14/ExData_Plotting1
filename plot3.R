## plot3.R 
## Written by: Timothy M. Amado
## Date: 02/21/2018
##
## Description: This is an R Script for the Exploratory Data Analysis 
## course project. The script does the following: 
## 1. Download a zipped data set (if it does not exist) on a directory
##    called "explo_course_project" on the current working directory  
## 2. Unzip and read the dataset into a data frame called hcp
## 3. Subset the data frame into hpc_subset data frame that contains data on dates 
##    "2007-02-01" to "2007-02-02"
## 4. Combine Date and Time Column to a date-time series using strptime
## 5. Plot a time series for each energy submetering values and 
##    the date-time series created in step 4


#Download and unzip the data set if not yet existing in the directory
url_zip <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!dir.exists("./explo_course_project")){
  dir.create("./explo_course_project")
}


if(!file.exists("./explo_course_project/electric_consumption.zip")){
  download.file(url_zip, destfile = "./explo_course_project/electric_consumption.zip")
}

if(!file.exists("./explo_course_project/household_power_consumption.txt")){
  unzip(zipfile = "./explo_course_project/electric_consumption.zip", exdir = "./explo_course_project")
}

rm(url_zip)

#Read the .txt file into data frame hpc
hpc <- read.table("./explo_course_project/household_power_consumption.txt", 
                  sep = ";", stringsAsFactors = FALSE, header = TRUE)

#Convert column 3 to 9 to numeric
hpc[3:9] <- lapply(hpc[3:9], as.numeric)
hpc <- hpc[complete.cases(hpc), ]

#Subset to target dates, 2007-02-01 to 2007-02-02
hpc_subset <- subset(hpc, hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007")

#create a date-time series
dtseries <- as.POSIXct(strptime(paste(hpc_subset$Date, hpc_subset$Time, sep=" "), 
                                "%d/%m/%Y %H:%M:%S"))

#Set the graphics device to be png with 480 x 480 pixels
png("plot3.png", width = 480, height = 480)

#Plot the timeseries of Energy Submetering
with(hpc_subset, plot(dtseries, Sub_metering_1,
                     type = "n", xlab = "", ylab = "Energy sub metering"))

#Add lines
lines(dtseries,hpc_subset$Sub_metering_1, col = "black")
lines(dtseries,hpc_subset$Sub_metering_2, col = "red")
lines(dtseries,hpc_subset$Sub_metering_3, col = "blue")

#Add Legend
legend("topright", lwd = 1,
                   col = c("black", "red", "blue"), 
                   legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()