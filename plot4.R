##Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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

#Coal burning related sectors
#"Fuel Comb - Comm/Institutional - Coal"       
#"Fuel Comb - Electric Generation - Coal"     
#"Fuel Comb - Industrial Boilers, ICEs - Coal"

#get SCC numbers for coal burning related sectors
SCCCoalBurn <- SCC[grepl("Fuel Comb.*Coal", SCC$EI.Sector),1]

NEICoalBurn <- data.table(subset(NEI, NEI$SCC %in% SCCCoalBurn))

# sum by year
yearly <- NEICoalBurn[,sum(Emissions), by=year]
setnames(yearly,"V1","totalpm25")

#scale emissions to thousands of tons
yearly[,totalpm25 := totalpm25/1000]

png("plot4.png")

#scatter plot with linear trend
qplot(year, totalpm25, data = yearly,
      main = "Yearly coal combustion related PM2.5 emissions",
      xlab = "Year",
      ylab = "PM2.5 emissions (thousand tons)") + 
    geom_smooth(method="lm")
dev.off()