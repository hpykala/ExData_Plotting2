##How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(ggplot2)
library(data.table)

#download data if needed
if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", mode="wb")
    unzip("FNEI_data.zip")
}

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Motor vehicle sectors:
#Mobile - On-Road Gasoline Light Duty Vehicles      
#Mobile - On-Road Gasoline Heavy Duty Vehicles     
#Mobile - On-Road Diesel Light Duty Vehicles        
#Mobile - On-Road Diesel Heavy Duty Vehicles  

#get SCC numbers for motor vehicles
SCCVehicle <- SCC[grepl("Vehicle", SCC$EI.Sector),1]

NEIVehicle <- data.table(subset(NEI, NEI$SCC %in% SCCVehicle))
NEIVehBalt <- subset(NEIVehicle, fips == "24510")

yearly <- NEIVehBalt[,sum(Emissions), by=year]
setnames(yearly,"V1","totalpm25")

png("plot5.png")

#scatter plot with linear trend
qplot(year, totalpm25, data = yearly,
      main = "Yearly motor vehicle related PM2.5 emissions in the Baltimore City",
      xlab = "Year",
      ylab = "PM2.5 emissions (tons)") + 
    geom_smooth(method="lm")
dev.off()