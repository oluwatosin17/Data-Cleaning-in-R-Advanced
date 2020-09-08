library(readr)
library(tidyverse)

mvc <- read_csv("nypd_mvc_2018.csv")
head(mvc,4)

#how to check for missing values
df <- data.frame(A = c(NA,NA,1.0), B = c(NA,1,NA), C = c(1,NA,NA))
print(df)
is.na(df)
sum(is.na(df))

na_logical <- is.na(mvc)
sum(na_logical)


#Summing values over rows
df <- data.frame(A = c(NA,NA,1.0), B = c(NA,1,NA), C = c(1,NA,NA))
colSums(is.na(df))
rowSums(is.na(df))

library(dplyr)
df_na <- data.frame(is.na(df))
na_row_sums <- df_na %>% mutate(ABsum = rowSums(.[1:3]))
# the period(.) represents all the dataset, and then we take its subset
na_row_sums


mvc_na <- data.frame(is.na(mvc))
colnames(mvc_na)
mvc_na_injured <- mvc_na %>% mutate(total_na_injured = rowSums(.[9:11]))
view(mvc_na_injured)4

#Verifying the total columns

#Let us calculate the percentage values in each column.
na_counts <- mvc %>% is.na() %>% colSums()
na_counts_pct <- na_counts *100 / nrow(mvc)

# We will add both the counts and percentages to a dataframe to make them easier to compare

na_df <- data.frame(na_counts = na_counts, na_pct = na_counts_pct)

#Rotate the dataframe so that rows become columns and vice - versa
na_df <- data.frame(t(na_df))
print(na_df)

na_df_killed <- na_df %>% select(ends_with("_killed"))
print(na_df_killed)

killed <- mvc %>% select(ends_with("killed"))

killed_non_eq <- killed %>%
  mutate(manual_sum = rowSums(.[1:3])) %>% 
  filter(manual_sum != total_killed | is.na(total_killed))


#filling and verifying the killed and injured data

library(tibble)
fruits <- tibble(name = c("Apple","Banana","Banana"))
banana_check <- fruits$name == "Banana"

banana_check

fruits <- fruits %>% mutate(name = if_else(name == "Banana","Pear",name))
fruits

nums <- c("one","two","three")
fruits <- fruits %>% mutate(name = if_else(name == "Pear",nums, name))
fruits

killed_non_eq <- killed_non_eq %>% mutate(total_killed = if_else(is.na(total_killed),manual_sum,total_killed))

killed_non_eq <- killed_non_eq %>% mutate(total_killed = if_else(is.na(total_killed)!= manual_sum,NaN,total_killed))
print(killed_non_eq)


injured <- mvc %>% select(ends_with("_injured"))
injured_non_eq <- injured %>% mutate(manual_sum = rowSums(.[1:3])) %>% filter(manual_sum != total_injured | is.na(total_injured)) 

injured_non_eq

injured_non_eq <- injured_non_eq %>% mutate(total_injured = if_else(is.na(total_injured),manual_sum,total_injured))
injured_non_eq <- injured_non_eq %>% mutate(total_injured = if_else(total_injured != manual_sum, NaN, total_injured))

#Preparing Data For Missing Data Visualization
library(tidyr)
library(purrr)
mvc_na <- map_df(mvc, function(x){
  as.numeric(is.na(x))
})

df <- data.frame("A" = c(1,2,3,4,5), "B" = c(2,4,6,8,10), "C" = c(3,6,9,12,15))
print(df)

df_heat <- df %>% pivot_longer(cols = everything(),names_to = "x") %>% group_by(x) %>% mutate(y = row_number())
df_heat

mvc_na_heat <- mvc_na %>% pivot_longer(cols = everything(),names_to = "x") %>% group_by(x) %>% mutate(y = row_number())
view(mvc_na_heat)

k <- mvc_na_heat %>% ungroup() %>% mutate(x = factor(x,levels = colnames(df)))
view(k)

#Visualizing Missing Data with HeatMaps 

plot_na_matrix <- function(df){
  #Preparing data frame for heat maps 
  df_heat <- df %>% 
    pivot_longer(cols =  everything(), names_to = "x") %>%
  group_by(x) %>%
    mutate(y = row_number())
 
   #Ensuring the order of columns is kept as it is
  df_heat <- df_heat %>% ungroup() %>%
    mutate(x = factor(x, levels  = colnames(df)))
  
  #Plotting data
  g <- ggplot(data = df_heat, aes(x = x, y=y, fill = value))+geom_tile()+
    theme(legend.position = "none",
          axis.title.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_text(angle = 90, hjust = 1)
            )
  #Returning Plot
  g
  
}

#Plottting the first row out of the mvc dataframe
plot_na_matrix(mvc_na[1, ])

#Plotting for the whole dataframe
plot_na_matrix(mvc_na)

mvc_vehicle <- mvc_na %>% select(starts_with("vehicle_"))

plot_na_matrix(mvc_vehicle)

#Visualizing Correlation
cols_with_missing_vals <- colnames(mvc)[colSums(mvc_na)>0]
cols_with_missing_vals

missing_corr <- round(cor(mvc_na[cols_with_missing_vals]),6)
view(missing_corr)

plot_na_correlation <- function(df){
  #Taking the lower triangle of the correlation matrix
  missing_corr_up <- df
  missing_corr_up[lower.tri(missing_corr_up)] <- NA
  missing_corr_up <- data.frame(missing_corr_up)
  
  #Preparing the dataframe for heatmaps
  col_names <- colnames(missing_corr_up)
  missing_corr_up_heat <- missing_corr_up %>% 
    pivot_longer(cols = everything(),names_to = "x") %>%
    group_by(x) %>%
    mutate(y = col_names[row_number()])%>%
    na.omit
  
  #Ordering Triangle
  ordered_cols_asc <- col_names[order(colSums(is.na(missing_corr_up)))]
  ordered_cols_desc <- col_names[order(-colSums(is.na(missing_corr_up)))]
  
  missing_corr_up_heat <- missing_corr_up_heat %>% ungroup() %>%
    mutate(x = factor(x,levels = ordered_cols_asc)) %>%
    mutate(y = factor(y,levels = ordered_cols_desc))
  
  #Plotting Heatmaps
  g <- ggplot(data = missing_corr_up_heat, aes( x=x, y=y, fill = value))+
    geom_tile()+geom_text(aes(label = value))+theme_minimal()+scale_fill_gradientn(colours = c("white",'yellow','red'),values = c(-1,0,1)) + 
    theme(legend.position = "none",
          axis.title.y =  element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_text(angle = 90, hjust = 1))
  g

}
plot_na_correlation(missing_corr)

mvc_vehicle <- mvc %>% select(contains("vehicle_"))
mvc_vehicle <- colnames(mvc_vehicle)
missing_vehicle_corr <-  round(cor(mvc_na[mvc_vehicle]),2)
plot_na_correlation(missing_vehicle_corr)
mvc_vehicle

mvx <- mvc_na %>% select(contains("vehicle_"))
missing_vehicle_corrx <-  round(cor(mvx),2)
plot_na_correlation(missing_vehicle_corrx)

#Analyzing Correlation in Missing Data

col_labels <- c("v_number", "vehicle_missing", "cause_missing")
v_fun <- function(x){
  v_col <- paste("vehicle",x,sep = "_")
  c_col <- paste("cause_vehicle",x,sep = "_")
  sum(is.na(mvc[v_col]) & !is.na(mvc[c_col]))
}
v_na <- map_int(1:5,v_fun)

c_fun <- function(x){
  v_col <- paste("vehicle",x,sep = "_")
  c_col <- paste("cause_vehicle",x,sep = "_")
  sum(!is.na(mvc[v_col]) & is.na(mvc[c_col]))
}
c_na <- map_int(1:5,c_fun)
v <- 1:5
vc_na_df <- tibble(v,v_na,c_na)
colnames(vc_na_df) <- col_labels
vc_na_df


#Finding the most common values across multiple columns
cause <- mvc %>% select(starts_with("cause_"))
head(cause)


cause_1d <- cause %>% pivot_longer(cols = everything())
head(cause_1d)

cause_counts <- table(cause_1d$value)
top5_causes <- head(sort(cause_counts, decreasing = T),5)
print(top5_causes)

vehicles <- mvc %>% select(starts_with("vehicle_"))
head(vehicles)

vehicles_1d <- vehicles %>% pivot_longer(cols = everything())
head(vehicles_1d)
vehicles_count <- table(vehicles_1d$value)
top10_vehicles <- head(sort(vehicles_count, decreasing = T),10)
print(top10_vehicles)

#Filling Unknown Values with a Placeholder

#create a logical vector for each column

v_missing_logical <- is.na(mvc["vehicle_1"]) & !is.na(mvc["cause_vehicle_1"])
c_missing_logical <- !is.na(mvc["vehicle_1"]) & is.na(mvc["cause_vehicle_1"])

#replace the values matchig the logical vector for each column

mvc <- mvc %>% mutate(vehicle_1 = if_else(v_missing_logical,"Unspecified",vehicle_1))
mvc <- mvc %>% mutate(cause_vehicle_1 = if_else(c_missing_logical, "Unspecified", cause_vehicle_1))

view(mvc)



v_fun <- function(x){ 
  v_col <- paste('vehicle', x,  sep = "_" )
  c_col <- paste('cause_vehicle', x,  sep = "_" )
  sum(is.na(mvc[v_col]) & !is.na(mvc[c_col]))
}


c_fun <- function(x){ 
  v_col <- paste('vehicle', x,  sep = "_" )
  c_col <- paste('cause_vehicle', x,  sep = "_" )
  sum(!is.na(mvc[v_col]) & is.na(mvc[c_col]))
}


summarize_missing <- function(){
  library(purrr)
  
  col_labels  <-  c('v_number', 'vehicle_missing', 'cause_missing')
  
  v_na <- map_int(1:5, v_fun )
  c_na <- map_int(1:5, c_fun )
  
  vc_na_df  <-  tibble(1:5, v_na, c_na)
  colnames(vc_na_df) <- col_labels
  vc_na_df
}


summary_before  <-  summarize_missing() 


# for (x in 1:5 ){
#    v_col <- paste('vehicle', x,  sep = "_" )
#    c_col <- paste('cause_vehicle', x,  sep = "_" )
for (x in 1:5 ){
  v_col <- paste('vehicle', x,  sep = "_" )
  c_col <- paste('cause_vehicle', x,  sep = "_" )
  
  # create a logical vector for each column
  v_missing_logical  <-  is.na(mvc[v_col]) & !is.na(mvc[c_col])
  c_missing_logical  <-  !is.na(mvc[v_col]) & is.na(mvc[c_col])
  
  # replace the values matching the logical vector for each column
  mvc <- mvc %>%
    mutate_at(c(v_col), function(x) if_else(v_missing_logical,"Unspecified", v_col ))
  
  mvc <- mvc %>%
    mutate_at(c(c_col), function(x) if_else(c_missing_logical,"Unspecified", c_col ))
}


summary_after  <-  summarize_missing()
summary_after


#Missing Data in the "Location" Columns
mvc_na_vehicle <- mvc_na %>% select(contains("vehicle"))
missing_vehicle_corr <- round(cor(mvc_na_vehicle),2)
plot_na_correlation(missing_vehicle_corr)


location_cols <- c("borough","location","on_street","off_street","cross_street")
location_data <- mvc[location_cols]
head(location_data)

colSums(is.na(location_data))

mvc_na_location <- mvc_na[location_cols]
missing_location_corr <- round(cor(mvc_na_location),2)
plot_na_correlation(missing_location_corr)


mvc_na_location <- mvc_na[location_cols] %>% arrange_all(desc)
plot_na_matrix(mvc_na_location)

sup_data <- read_csv("supplemental_data.csv")
head(sup_data)

#Let's look at the NA matrix for the supplementary data
sup_data_na <- map_df(sup_data , function(x) as.numeric(is.na(x)))
plot_na_matrix(sup_data_na)

#if the unique key column in both the original and sup data has the same value in the same order, we'll be able to use the mutate function and if_else function

mvc_keys <- mvc["unique_key"]
sup_keys <- sup_data["unique_key"]

set_equal <- setequal(mvc_keys,sup_keys)
set_equal

na_before <-colSums(is.na(mvc[location_cols]))

location_cols <- c("borough","location","on_street","off_street")

for (i in location_cols) {
  mvc[is.na(mvc[i]),i] <- sup_data[is.na(mvc[i]),i]
}

na_after <-colSums(is.na(mvc[location_cols]))
na_after
