##Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
##Using the base plotting system, make a plot showing the total PM2.5 emission 
##from all sources for each of the years 1999, 2002, 2005, and 2008.
library(data.table)

#download data if needed
if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", mode="wb")
    unzip("FNEI_data.zip")
}

#read data
NEI <- readRDS("summarySCC_PM25.rds")
NEI <- data.table(NEI)

#calculate yearly sums to find total pm2.5 emissions
yearly <- NEI[,sum(Emissions), by = year]
setnames(yearly, "V1", "pm25tot")

#scale total emissions to millions of tons
yearly[,pm25tot := pm25tot/10^6]

png("plot1.png")

#scatterplot
plot(yearly$year, 
     yearly$pm25tot,
     pch = 19,
     xlab = "Year", 
     ylab = "Total PM2.5 emissions (Million tons)", 
     main = "Total yearly PM2.5 emissions")

#add trend line to show clear downward trend
abline(lm(pm25tot ~ year, data = yearly))

dev.off()
