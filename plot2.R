if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", mode="wb")
    unzip("FNEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset baltimore
baltimore <- subset(NEI, fips == "24510")

sums <- tapply(baltimore$Emissions,baltimore$year,sum)
yearly <- data.frame(year = as.numeric(names(sums)), pm25tot = sums/(10^3))

png("plot2.png")
plot(yearly$year, 
     yearly$pm25tot,
     pch = 19,
     xlab = "Year", 
     ylab = "Total PM2.5 emissions (Thousand tons)", 
     main = "Total yearly pm2.5 emissions")
abline(lm(pm25tot ~ year, data = yearly))

dev.off()
