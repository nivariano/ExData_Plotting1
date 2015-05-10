# Coursera Course Project 1
# Course name: Exploratory Data Analysis (Johns Hopkins University)
# Course edition: May 2015
#
# Assignment description:
# The overall goal is to examine how household energy usage varies over a 2-day 
# period in February, 2007. Your task is to reconstruct four plots, all of which
# were constructed using the base plotting system.
# For each plot you should:
# 1) Construct the plot and save it to a PNG file with a width of 480 pixels 
#    and a height of 480 pixels.
# 2) Name each of the plot files as plot1.png, plot2.png, etc.
# 3) Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the 
#    corresponding plot.
# 4) Add the PNG file and R code file to the top-level folder of your git 
#    repository. 

# Start of script.

# First, make sure the required data is in the working directory.

if (!file.exists("household_power_consumption.txt")) {
    stop("household_power_consumption.txt file not in the working directory!!")
}

# The dataset has 2,075,259 rows and 9 columns.
# We will only be using data from the dates 2007-02-01 and 2007-02-02, so we will
# read the data from just those dates rather than reading in the entire dataset
# and subsetting to those dates.
# Read in the first line of data (not the headers) to calculate starting date.

firstLine <- scan(file = "household_power_consumption.txt", 
                  what = character(), 
                  sep = ";",
                  dec = ".",
                  skip = 1, 
                  nlines = 1)
firstDate <- strptime(paste(firstLine[1], firstLine[2]), "%d/%m/%Y %H:%M:%S")

# Calculate row numbers corresponding to dates 2007-02-01 and 2007-02-02.

rowIni <- as.numeric(difftime(strptime("2007-02-01", "%Y-%m-%d"), firstDate, units = "mins"))
rowFin <- as.numeric(difftime(strptime("2007-02-03", "%Y-%m-%d"), firstDate, units = "mins"))

# Read in the data between the dates 2007-02-01 and 2007-02-02.

dataDF <- read.table("household_power_consumption.txt", 
                     header = FALSE, 
                     sep = ";", 
                     nrows = rowFin - rowIni, 
                     skip = rowIni + 1, 
                     comment.char = "",
                     stringsAsFactors = FALSE)

# Assign orignal column names to this data frame for easier handling.

headersDF <- read.table("household_power_consumption.txt", 
                        header = TRUE, 
                        sep = ";", 
                        nrows = 1, 
                        skip = 0, 
                        comment.char = "",
                        stringsAsFactors = FALSE)
colnames(dataDF) <- names(headersDF)

# Add a column to the data frame with the date and time in POSIXlt format, to
# use it as the x-axis for time-series plots.
# Need to change Time locale first to show weekdays in English.

Sys.setlocale(category = "LC_TIME", locale = "US_us")
dataDF$DateTime <- strptime(paste(dataDF$Date, dataDF$Time), "%d/%m/%Y %H:%M:%S")

# Create PNG file for Plot 4.
# Launch PNG file device, set parameters to include four plots in one graph,
# create the four plots and switch off file device.

png(filename = "plot4.png",
    width = 480, 
    height = 480, 
    units = "px")

par(mfcol = c(2, 2))

plot(dataDF$DateTime, 
     dataDF$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power")

plot(dataDF$DateTime, 
     dataDF$Sub_metering_1, 
     type = "l", 
     col = "black", 
     xlab = "", 
     ylab = "Energy sub metering")
points(dataDF$DateTime, 
       dataDF$Sub_metering_2, 
       type = "l", 
       col = "red")
points(dataDF$DateTime, 
       dataDF$Sub_metering_3, 
       type = "l", 
       col = "blue")
legend("topright", 
       lwd = 1, 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       bty = "n")

plot(dataDF$DateTime, 
     dataDF$Voltage, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Voltage")

plot(dataDF$DateTime, 
     dataDF$Global_reactive_power, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Global_reactive_power")

dev.off()

# End of script.
