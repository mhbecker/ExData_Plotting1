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

par("mfcol" = c(2,2))
        #top left plot
        with(powerdatashort,plot(DateTime, Global_active_power, xlab="", ylab = "Global Active Power", type="n"))
                lines(powerdatashort$DateTime, powerdatashort$Global_active_power)
        #bottom left plot
        with(powerdatashort, plot(DateTime, Sub_metering_1, xlab="", ylab="Energy sub metering", type="n"))
                lines(powerdatashort$DateTime, powerdatashort$Sub_metering_1, col="black")
                lines(powerdatashort$DateTime, powerdatashort$Sub_metering_2, col="red")
                lines(powerdatashort$DateTime, powerdatashort$Sub_metering_3, col="blue")
                legend("topright", col=c("black", "red","blue"), lwd = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
        #top right plot
        with(powerdatashort,plot(DateTime, Voltage, xlab="datetime", ylab = "Voltage", type="n"))
                lines(powerdatashort$DateTime, powerdatashort$Voltage)        
                
        #bottom right plot
        with(powerdatashort,plot(DateTime, Global_reactive_power, xlab="datetime", ylab = "Global_reactive_power", type="n"))
                lines(powerdatashort$DateTime, powerdatashort$Global_reactive_power)
                
                dev.copy(png, file = "plot4.png", height = 480, width = 480)
                dev.off()
                
