#Assignment 1 

#Task 1: Retriving data 2020 and 2021 
request<- "https://api.census.gov/data/2021/pep/population?get=GEO_ID,DENSITY_2020,DENSITY_2021,POP_BASE2020,POP_2020,POP_2021,NAME&for=state:*"
result <- jsonlite::fromJSON(request)

#Task 2: putting the data into a dataframe
result <- as.data.frame(result, stringsAsFactors = FALSE) #converting the result to a data frame
result <- result[,-8] #removing state ID as the state Name is requested for analysis

#Task 3
#General data analysis
summary(result) #Interesting to note that even numerical variables (e.g., Density) are saved as character data types

result[!complete.cases(result),] #only one row (row 40) has missing density estimation for both 2020 and 2021
sum(is.na(result)) #this confirms the result of the complete.cases formula --> only two missing observations 

sum(sapply(result, is.infinite)) #using the sapply formula we can get a matrix which shows all infinite values

sapply(result, is.nan) #also here, there are no NAN instances 

#columns and row adjustment
colnames(result) <- result[1,]
result <- result[-1,] 
rownames(result) <- NULL

#Task 4: Converting certain columns to numeric
result_copy <- result #from now I am going to work on the result data frame but keep a copy just in case 

result$DENSITY_2020 <- as.numeric(result$DENSITY_2020)
result$DENSITY_2021 <- as.numeric(result$DENSITY_2021)
result$POP_BASE2020 <- as.numeric(result$POP_BASE2020)
result$POP_2020 <- as.numeric(result$POP_2020)
result$POP_2021 <- as.numeric(result$POP_2021)

summary(result) 
#Task 5: Computations on the data 
population_estimate_sum_2020 <- sum(result$POP_2020)
population_estimate_sum_2021 <- sum(result$POP_2021)
population_estimate_sum_2021 > population_estimate_sum_2020 #population estimation has increased

average_density_2020 <- mean(result$DENSITY_2020, na.rm = TRUE)
average_density_2021 <- mean(result$DENSITY_2021, na.rm = TRUE)
average_density_2021 > average_density_2020 #density has been decreasing 

#Task 6 
result$DENSITY_2020[is.na(result$DENSITY_2020)] <- average_density_2020
result$DENSITY_2021[is.na(result$DENSITY_2021)] <- average_density_2021

#check
sum(is.na(result))

#Task 7 
larger_population <- as.data.frame(result[result$POP_2021 > result$POP_BASE2020, c(4,6,7)])

