#loading tidyverse library 
library(tidyverse)
library(ggplot2)
library (dplyr)

#importing csv files 
activity <- read.csv("dailyActivity_merged.csv")
hourly_calories <- read.csv("hourlyCalories_merged.csv")
sleep <- read.csv("sleepDay_merged.csv")

#formatting the date correctly 
activity$ActivityDate <- as.Date(activity$ActivityDate, format = "%m/%d/%Y")
hourly_calories$ActivityHour <- as.POSIXct(hourly_calories$ActivityHour,format="%m/%d/%Y %I:%M:%S %p",tz=Sys.timezone())
sleep$SleepDay <- as.Date(sleep$SleepDay, format = "%m/%d/%Y")

#seeing the amount of unique observations in each data set
n_distinct(activity$Id)
n_distinct(hourly_calories$Id)
n_distinct(sleep$Id)

#generating some quick summary statistics
activity %>% select(TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, 
                    SedentaryMinutes, Calories) %>% summary()
hourly_calories %>% select(Calories) %>% summary()
sleep %>% select(TotalTimeInBed, TotalMinutesAsleep) %>% summary()

#added a column to each data set to show what day of week each day falls on.
activity$day_of_week <- weekdays(as.Date(activity$ActivityDate))
sleep$day_of_week <- weekdays(as.Date(sleep$SleepDay))
activity$weekend_or_weekday <- ifelse(wday(activity$ActivityDate) %in% c(1,7), "Weekend", "Weekday")

#scatter plot that shows relationship between  
activity %>% ggplot(aes(x = TotalSteps, y = Calories)) + geom_point(aes(color = weekend_or_weekday)) + 
  geom_smooth() +ggtitle("Daily Steps and Calories") + xlab("Total Steps") + labs(color='Weekend or Weekday')

#the following four graphs shows the relationship between each of different activeness categories and calories burnt
activity %>% ggplot(aes(x = VeryActiveMinutes, y = Calories)) + geom_point(color ="#A8D6D2") + geom_smooth() +
  ggtitle("Very Active Minutes and Calories") + xlab("Very Active Minutes")

activity %>% ggplot(aes(x = FairlyActiveMinutes, y = Calories)) + geom_point(color = "#FCBA4A") + geom_smooth() +
  ggtitle("Fairly Active Minutes and Calories") + xlab("Fairly Active Minutes")

activity %>% ggplot(aes(x = LightlyActiveMinutes, y = Calories)) + geom_point(color = "#C49ECB") + geom_smooth() +
  ggtitle("Lightly Active Minutes and Calories") + xlab("Lightly Active Minutes")

activity %>% ggplot(aes(x = SedentaryMinutes, y = Calories)) + geom_point(color ="#FE6E40") + geom_smooth() +
  ggtitle("Sedentary Active Minutes and Calories") + xlab("Sedentary Active Minutes")

#line graph to show average calories burned at each hour of the day. 
hourly_calories_line <- hourly_calories %>% group_by(hour(ActivityHour)) %>% 
  summarise(avg_cal = mean(Calories))

colnames(hourly_calories_line)[1] <- "hour"

ggplot(hourly_calories_line, aes(x = hour, y= avg_cal)) +
  geom_line(linewidth = 1) + xlab("Hour") + ylab("Average Calories Burned") + 
  ggtitle("Average Calories Burned at Different Hours") + scale_x_continuous(breaks=seq(0,23,by=1))

#bar graph for average amout of sleep for each day. 
sleep_avg <- sleep %>% group_by(day_of_week) %>% summarise(avg_mins_asleep = mean(TotalMinutesAsleep),
                                                           avg_time_in_bed = mean(TotalTimeInBed))
sleep_avg$day_of_week <- factor(sleep_avg$day_of_week, levels = 
                              c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))                                       

sleep_avg %>% ggplot(aes(x = day_of_week, y = avg_mins_asleep)) + geom_col(fill = "#7B68EE") +
  ggtitle("Daily Amount of Sleep ") + xlab("Day of Week") + ylab("Average Minutes Asleep") 

