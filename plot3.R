##Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
##variable, which of these four sources have seen decreases in emissions from 1999–2008 
##for Baltimore City? Which have seen increases in emissions from 1999–2008? 
##Use the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)
library(data.table)

#download data if needed
if(!file.exists("summarySCC_PM25.rds")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip", mode="wb")
    unzip("FNEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
NEI <- data.table(NEI)


#subset Baltimore City
baltimore <- subset(NEI, fips == "24510")

#calculate sums per year and type
setkey(baltimore,year,type)
sums <- baltimore[,sum(Emissions),by=key(baltimore)]

png("plot3.png")

qplot(year,totalpm25,data=sums,facets=.~type)+geom_smooth(method = "lm")
dev.off()