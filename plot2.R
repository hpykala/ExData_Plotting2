##Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
##from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#download data if needed
if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", mode="wb")
    unzip("FNEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")

#subset Baltimore City
baltimore <- subset(NEI, fips == "24510")

#calculate yearly sums to find total pm2.5 emissions
sums <- tapply(baltimore$Emissions,baltimore$year,sum)

#make dataframe and scale total emissions to thousands of tons
yearly <- data.frame(year = as.numeric(names(sums)), pm25tot = sums/(10^3))

png("plot2.png")

#scatterplot
plot(yearly$year, 
     yearly$pm25tot,
     pch = 19,
     xlab = "Year", 
     ylab = "Total PM2.5 emissions (Thousand tons)", 
     main = "Total yearly pm2.5 emissions in the Baltimore City")

#add trend line to show clear downward trend
abline(lm(pm25tot ~ year, data = yearly))

dev.off()
