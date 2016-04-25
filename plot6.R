##Compare emissions from motor vehicle sources in Baltimore City with emissions 
##from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
##Which city has seen greater changes over time in motor vehicle emissions?

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

#subset for vehicle SCC's and fips Baltimore and LA
NEIVehicle <- data.table(subset(NEI, NEI$SCC %in% SCCVehicle))
NEIVehBaltLA <- subset(NEIVehicle, fips %in% c("24510","06037"))

#make variable city to be factor of fips with descriptive labels
NEIVehBaltLA[,city := factor(fips, levels = c("24510","06037"), labels = c("Baltimore City", "Los Angeles"))]

#calculate yearly sums by city
yearly <- NEIVehBaltLA[,sum(Emissions), by=c("year","city")]
setnames(yearly,"V1","totalpm25")


png("plot6.png")

#faceted scatter plot with linear trend
qplot(year, totalpm25, data = yearly,
      facets = .~city,
      main = "Yearly motor vehicle related PM2.5 emissions, Baltimore vs. LA",
      xlab = "Year",
      ylab = "PM2.5 emissions (tons)") + 
    geom_smooth(method="lm")
dev.off()