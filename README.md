# BellaBeat Case Study 
**Introduction**: Bellabeat is a health-focused, high-tech manufacturer of products for women. In order to grow the company the Bellabeat executives decided to analyze consumer trends of other fitness trackers to imporve their marketing strategy.
#
# Stages 

### [1. Ask](#Ask)
### [2. Prepare](#Prepare)
### [3. Process](#Process)
### [4. Analyze](#Analyze)
### [5. Share](#Share)
### [6. Act](#Act)
#
## Ask
Business Task: Analyzing consumer trends from non-Bellabeat devices to provide reccomdations to Bellabeat so they can improve their marketing strategy.

Key Stakeholders:
- Urška Sršen: Bellabeat’s cofounder and Chief Creative Officer
- Sando Mur: Mathematician and Bellabeat’s cofounder
- BellaBeat marketing analytics team
- BellaBeat customers 

## Prepare 
The data being used in this case study can be found on Kaggle [here](https://www.kaggle.com/datasets/arashnic/fitbit). This dataset includes information from 30 different fitbit users including: steps, calories, active, and sedentary minutes.

<break>Some limitations of this this data set are: The data is from 2016 and fitness trackers have improved since then, Bellabeat is a company for women but the data doesn't include information about gender, we dont know how the data was collected so certain biases might exist, and some of the datasets have varying amount of different users.

<break> To clean, analyze and visualize the data I will be using R becasue of how much control it gives me and its data visualuzation capabilities 

Packages that I will be using:
```
library(tidyverse)
library(ggplot2)
library(dplyr)
library(lubridate)
```

## Process
I first start by importing the datasets that I want to analyze.
```
activity <- read.csv("dailyActivity_merged.csv")

hourly_calories <- read.csv("hourlyCalories_merged.csv")

sleep <- read.csv("sleepDay_merged.csv")
```
The first thing that I noticed is that the dates in the datasets are stored as 'char', so I change them do the date data type. 

```
activity$ActivityDate <- as.Date(activity$ActivityDate, format = "%m/%d/%Y")

hourly_calories$ActivityHour <- as.POSIXct(hourly_calories$ActivityHour,format="%m/%d/%Y %I:%M:%S %p",tz=Sys.timezone())

sleep$SleepDay <- as.Date(sleep$SleepDay, format = "%m/%d/%Y")
```

## Analyze
To start the analysis phase I will begin by checking to see how many unique IDs in each dataset there are 
```
n_distinct(activity$Id)
n_distinct(hourly_calories$Id)
n_distinct(sleep$Id)
```
The number of unique IDs in each respective dataset:
- 33
- 33
- 24 

Generating some summary statistics:
```
activity %>% select(TotalSteps, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, 
                    SedentaryMinutes, Calories) %>% summary()

hourly_calories %>% select(Calories) %>% summary()

sleep %>% select(TotalTimeInBed, TotalMinutesAsleep) %>% summary()
```

![Screenshot 2023-09-29 184636activity-1](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/59467e4e-b89d-41af-bd62-0b97b98be89b)
![calories](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/e786a59c-9db2-4614-b724-6e07382994f6)
![Screenshot 2023-09-22 212453](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/ea7ab464-cd92-48ec-a6a8-498df3b8e2c2)

Some important information I've collected from these statistics:
- The total daily steps that the average person takes is 7638. 
- Average sedentary minutes is 991.2 which equates to 16.52 hours.
- Average amount of calories burned is 2304 
- Average total active minutes is 226 (21.16 very active minutes, 13.56 fairly active minutes, and 192.8 lightly active minutes)
- Average minutes asleep is 419.5 or 6.9 hours 

## Share 
To see more trends in the data I added a column to each dataset to show what day of week each day falls on.
```
activity$day_of_week <- weekdays(as.Date(activity$ActivityDate))
sleep$day_of_week <- weekdays(as.Date(sleep$SleepDay))
activity$weekend_or_weekday <- ifelse(wday(activity$ActivityDate) %in% c(1,7), "Weekend", "Weekday")
```
Next, I made a scatter plot of daily steps vs. calories to see if there are any correlations. From the graph you can see there is a positive correlation between daily steps and calories burned. However weather it is a weekday or weekend plays no significant difference on calories burned or total steps taken.     
```
activity %>% ggplot(aes(x = TotalSteps, y = Calories)) + geom_point(aes(color = weekend_or_weekday)) + 
  geom_smooth() +ggtitle("Daily Steps and Calories") + xlab("Total Steps") + labs(color='Weekend or Weekday')
```
![daily steps and calories-1](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/f46a8683-53fb-4ddf-9bb0-90c88c7fb62f)
The next few graphs show the relationship between each category of activeness and calories burned. It seems like having very high active minutes correlates the best with calories burned.
```
activity %>% ggplot(aes(x = VeryActiveMinutes, y = Calories)) + geom_point(color ="#A8D6D2") + geom_smooth() +
  ggtitle("Very Active Minutes and Calories") + xlab("Very Active Minutes")

activity %>% ggplot(aes(x = FairlyActiveMinutes, y = Calories)) + geom_point(color = "#FCBA4A") + geom_smooth() +
  ggtitle("Fairly Active Minutes and Calories") + xlab("Fairly Active Minutes")

activity %>% ggplot(aes(x = LightlyActiveMinutes, y = Calories)) + geom_point(color = "#C49ECB") + geom_smooth() +
  ggtitle("Lightly Active Minutes and Calories") + xlab("Lightly Active Minutes")

activity %>% ggplot(aes(x = SedentaryMinutes, y = Calories)) + geom_point(color ="#FE6E40") + geom_smooth() +
  ggtitle("Sedentary Active Minutes and Calories") + xlab("Sedentary Active Minutes")
```
![VeryActive](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/42e13e23-e724-43a2-98ab-7ccc937534d8)
![FairlyActive](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/7a7dfe2d-39c1-4df1-ad88-20de588f1790)
![lighltyactive](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/c304ca22-293c-41a1-b285-ef6741fa4a2d)
![sedentery](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/b5e0df21-afb1-4a54-85bc-f4f789bda35f)

This line graph shows at which hours people burn the most calories on average. There is a huge dip at around 3-4 pm. 
```
hourly_calories_line <- hourly_calories %>% group_by(hour(ActivityHour)) %>% 
  summarise(avg_cal = mean(Calories))

colnames(hourly_calories_line)[1] <- "hour"

ggplot(hourly_calories_line, aes(x = hour, y= avg_cal)) +
  geom_line(linewidth = 1) + xlab("Hour") + ylab("Average Calories Burned") + 
  ggtitle("Average Calories Burned at Different Hours") + scale_x_continuous(breaks=seq(0,23,by=1))
```
![line calories](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/d083661b-4e78-43d9-99e0-2e9f7bb7be91)
The bar graph shows which days people got the most sleep 
```
sleep_avg <- sleep %>% group_by(day_of_week) %>% summarise(avg_mins_asleep = mean(TotalMinutesAsleep),
                                                           avg_time_in_bed = mean(TotalTimeInBed))
sleep_avg$day_of_week <- factor(sleep_avg$day_of_week, levels = 
                              c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))                                       

sleep_avg %>% ggplot(aes(x = day_of_week, y = avg_mins_asleep)) + geom_col(fill = "#7B68EE") +
  ggtitle("Daily Amount of Sleep ") + xlab("Day of Week") + ylab("Average Minutes Asleep")
```
![Rplot02-1](https://github.com/KevinRamsahai/Bellabeat_Case_Study/assets/131219036/2af0cf51-8f9c-48e1-839d-26e13abfb624)
## Act 
To summarize my process so far, I first started by identifying the business task, prepared and verified the data, process and cleaned the data and finally analyzed and visuialized the data.  

Now, From analyzing the data here are some of my insights and suggestions:

-  The first thing I would reccommend is for Bellabeat to add an integrated sleep planner to their Bellabeat app. This is because from the bar char we can see that the FitBit participants did not consistantly get enough sleep
- Enphasizing getting steps in is very importat becasue the data shows that there is a direct correlation between steps taken and calories burned. Encouraging more active minutes is also important.
-  Also, as we saw before there was a big dip in calories being burned in the afternoon for the average person. This gives Bellabeat to improve their notifications and add a feature to remind a person to get up and move a little during this time. 
