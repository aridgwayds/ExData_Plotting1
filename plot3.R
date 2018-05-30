library(dplyr)
library(sqldf)
library(lubridate)

setwd("./data")
# download zip file containing data
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"

# download zip file (only if the file is not already in the working directory/data location)
if (!file.exists(zipFile)) {
        download.file(zipUrl, zipFile, mode = "wb")
}

# unzip data file (only if the file is not already in the working directory/data location)
dataPath <- "household_power_consumption"
if (!file.exists(dataPath)) {
        unzip(zipFile)
}

#read data
file<-"household_power_consumption.txt"
mdf<-as.data.table(read.csv.sql(file,sql="select * from file where Date=='1/2/2007' OR Date=='2/2/2007'",header=TRUE, sep=";"))
mdf<-mutate(mdf,dateval=dmy(mdf$Date),timeval=hms(mdf$Time),dayval=wday(mdf$Date),dtime=as.POSIXct(paste(mdf$Date,mdf$Time), format("%d/%m/%Y %H:%M:%S"),tz="EST"))

png(file = "Plot3.png", bg = "transparent",width = 480, height = 480, units = "px", pointsize = 12)

#plot3
with(mdf,plot(mdf$dtime,mdf$Sub_metering_1,xlab=' ',ylab="Energy sub metering",type="n"))
lines(mdf$dtime,mdf$Sub_metering_1,col="black")
lines(mdf$dtime,mdf$Sub_metering_2,col="red")
lines(mdf$dtime,mdf$Sub_metering_3,col="blue")
legend("topright",lty=1,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()