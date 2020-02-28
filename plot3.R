library(lubridate); library(dplyr); library(plyr);library(tidyr);library(readr)

#Generating a working directory and unzipping the file into the directory
if(!dir.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/Zip_data")
unzip("./data/Zip_data", exdir="./data")

#reading in the unzipped data - 
powerdata<-read.table("./data/household_power_consumption.txt", sep=";", header = TRUE, na.strings="?")
str(powerdata)
head(powerdata, n=30)
powerdata$Date<-as.Date(powerdata$Date, format="%d/%m/%Y")
powerdata[order(powerdata$Date),]


#Filtering down to the two dates for the project.
powerdata<-tbl_df(powerdata)
powerdata<-filter(powerdata, Date=="2007-02-01"|Date=="2007-02-02")

#Reserving the full data as backup
powerdatashort<-powerdata
powerdatashort$Date<-as.character(powerdatashort$Date)
powerdatashort$Time<-as.character(powerdatashort$Time)
powerdatashort<-unite(data=powerdatashort, col=DateTime, Date:Time, sep=" ") 
powerdatashort$DateTime<-as.POSIXlt(powerdatashort$DateTime)

#Done converting to final dataset, removing cached "pure" dataset
rm(powerdata)

#Plot 3 - energy submetering plot, 3 lines with a legend in top right
with(powerdatashort, plot(DateTime, Sub_metering_1, xlab="", ylab="Energy sub metering", type="n"))
        lines(powerdatashort$DateTime, powerdatashort$Sub_metering_1, col="black")
        lines(powerdatashort$DateTime, powerdatashort$Sub_metering_2, col="red")
        lines(powerdatashort$DateTime, powerdatashort$Sub_metering_3, col="blue")
                        legend("topright", col=c("black", "red","blue"), lwd = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
                dev.copy(png, file = "plot3.png", height = 480, width = 480)
                dev.off()
