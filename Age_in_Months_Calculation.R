# install.packages("zoo")
# install.packages("labelled")
# install.packages("anytime")
# install.packages("eeptools")
# install.packages("gtsummary")
library(zoo)
library(labelled)
library(anytime)
library(eeptools)
library(gtsummary)

setwd("~/Documents/GitHub/Age-in-Months-Calculation-R")
data <- read_csv("sample_data.csv")

look_for(data)



# ------------------------------------
# create a year-month birth variable like "Feb 2008"
data$birth_month_year <- 
  zoo::as.yearmon(paste(data$birth_year, data$birth_month), "%Y %m")
head(data$birth_month_year)

# create an year-month birth variable like "2008-02"
data <- within(data, birth_year_month <- 
                 sprintf("%d-%02d", birth_year, birth_month))
head(data$birth_year_month)

# create an year-month birth variable like "2008-02"
data <- within(data, todays_year_month <- 
                 sprintf("%d-%02d", todays_year, todays_month))
head(data$todays_year_month)



# ------------------------------------
# calculate age in month

# set 1st day of the month for sake of simplicity
# https://www.rdocumentation.org/packages/eeptools/versions/1.2.4/topics/age_calc
data$birth_year_month <- anytime::anydate(data$birth_year_month)
data$todays_year_month <- anytime::anydate(data$todays_year_month)

data$age_in_month <- 
  floor(age_calc(data$birth_year_month, data$todays_year_month, units = "months"))



# ------------------------------------
# summary

data %>% 
  select(age_in_month, todays_year) %>%
  tbl_summary(by = todays_year) 
