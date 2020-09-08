# Data-Cleaning-in-R-Advanced

## Regular Expression Basics: 

**REGULAR EXPRESSION IN R**
Loading stringr package:

`library(stringr)`

Searching a string for a regex pattern:

`str_detect("Rhythm and blues", "blue")`

Searching a vector (of strings) for a regex pattern:

`str_detect(c("Rhythm and blues", "Red light"), "blue")`

Counting the mentions of a regex pattern:

`sum( str_detect( c("Rhythm and blues", "Red light"), "blue") )`

Returning the matches pattern from a vector or dataframe:

`data[str_detect(strings, pattern)]`

Extracting the matching string to the pattern:

`str_extract(strings, pattern)`

Extracting a regex capture group from vector:

`str_match(strings, pattern_with_capture_group)[,2]`

**USING REGULAR EXPRESSION CLASSES IN R**
double the backslashe to avoid R interpretation error. For example, use `\\w` instead of `\w`.

**ESCAPING CHARACTERS**

Treating special characters as ordinary text using backslashes:

\\[pdf\\]
  

| Character Class |    Pattern      |   Explanation   |
| --------------- |   ----------    |  -------------- | 
|Set	|[fud]	|Either f, u, or d|
|Range	|[a-e]	|Any of the characters a, b, c, d, or e|
|Range	|[0-3]	|Any of the characters 0, 1, 2, or 3|
|Range	|[A-Z]	|Any uppercase letter|
|Set + Range	|[A-Za-z]	|Any uppercase or lowercase character|
|Digit	|\d	|Any digit character (equivalent to [0-9])|
|Word	|\w	|Any digit, uppercase, or lowercase character (equivalent to [A-Za-z0-9])|
|Whitespace	|\s	|Any space, tab or linebreak character|
|Dot	|.	|Any character except newline|


| Quantifier	| Pattern	| Explanation  |
| ----------    | --------      | ------------ |
|Zero or more	|a*	|The character a zero or more times|
|One or more	|a+	|The character a one or more times|
|Optional	|a?	|The character a zero or one times|
|Numeric	|a{3}	|The character a three times|
|Numeric	|a{3,5}	|The character a three, four, or five times|
|Numeric	|a{,3}	|The character a one, two, or three times|
|Numeric	|a{8,}	|The character a eight or more times|


| Character Class	| Pattern	| Explanation  |
| ---------------       | --------      | ------------ |
|Negative Set	|[^fud]	|Any character except f, u, or d|
|Negative Set	|[^1-3Z\s]	|Any characters except 1, 2, 3, Z, or whitespace characters|
|Negative Digit	|\D	|Any character except digit characters|
|Negative Word	|\W	|Any character except word characters|
|Negative Whitespace	|\S	|Any character except whitespace characters|

|Anchor	|Pattern	|Explanation|
|------ |-------        |-----------|
|Beginning	|^abc	|Matches abc only at the start of a string|
|End	|abc$	|Matches abc only at the end of a string|
|Word boundary	|s\b	|Matches s only when it's followed by a word boundary|
|Word boundary	|s\B	|Matches s only when it's not followed by a word boundary|



|Flag	|Pattern	|Explanation|
|-----  |-------        |-----------|
|Ignorcase	|(?i)abc	|Matches all different capitalizations of the word abc: Abc, ABC, abC, etc|
|Ignoring white spaces and comments	|(?x)a b c	|Matches abc|

## Advanced Regular Expressions

**CAPTURE GROUPS**
Extracting text using a capture group:

`str_match(strings, pattern_with_capture_group)`

Extracting text using multiple capture groups:

`str_match(strings, pattern_with_multiple_capture_groups)`

Cleaning text using

`str_to_lower(strings)`
`str_to_upper(strings)`

**SUBSTITUTION**
Substituting a regex match:

`str_replace(strings, pattern, replacement_text)`
`str_replace_all(strings, pattern, replacement_text)`

**CLEANING DATAFRAME**
Using dplyr package:

`library(dplyr)`

Filtering out undesired rows by nesting `filter()` and `str_detect()` functions:

`filter(str_detect(colum_name, pattern))`

Creating new column in the dataframe containing extrated mentions of a pattern by nesting mutate() and str_match() functions:

`mutate(new_column_name = str_match(column_name, pattern_with_capture_group))`

Creating new column in the dataframe containing clean text by nesting mutate() and str_to_lower() functions:

`mutate(new_column_name = str_to_lower(column_name))`

Selecting and summarizing data chaining select(), group_by() and summarise() functions:

`new_data <- data %>%
    select(one_column_name, another_column_name, ...) %>%
    group_by(a_column_name_from_the_selection) %>%
    summarise(new_column_name = mean(a_column_name_from_the_selection))`


Capture groups allow us to specify one or more groups within our match that we can access separately. 
|Pattern	|Explanation|
|-------        |-----------|
|(yes)no	|Matches yesno, capturing yes in a single capture group.|
|(yes)(no)	|Matches yesno, capturing yes and no in two capture groups|

Backreferences allow us to repeat a capture group within our regex pattern by referring to them with an integer in the order they are captured. 
|Pattern	|Explanation|
|-------        |-----------|
|(yes)no\1	|Matches yesnoyes|
|(yes)(no)\2\1	|Matches yesnonoyes|


Lookarounds let us define a positive or negative match before or after our string. 
|Pattern	|Explanation|
|-------        |-----------|
|zzz(?=abc)	|Matches zzz only when it is followed by abc|
|zzz(?!abc)	|Matches zzz only when it is not followed by abc|
|(?<=abc)zzz	|Matches zzz only when it is preceded by abc|
|(?<!zzz)abc	|Matches zzz only when it is not preceded by abc|



# Working with Missing Data

Summing a subset of dataframe over rows:

`df %>% mutate( new_column_name = rowSums(.[1:3]) )`

Selecting a subset of a dataframe which variable names match with a string:

`df %>% select( contains( string ) )
df %>% select( starts_with( string ) )
df %>% select( ends_with( string ) )`

Replacing matching values with a single value:

`df %>% mutate( colname = if_else(condition, val_if_true, val_if_false) )`

Replacing matching values with corresponding values from a vector:

`df %>% mutate( colname = if_else(condition, list_of_values_if_true, list_of_values_if_false) )`

Preparing data for heatmaps visualization:

`df_na <- map_df(df, function(x) as.numeric(is.na(x)))
 df_na_heat <- df_na %>%
    pivot_longer(cols = everything(),
           names_to = "x") %>%
    group_by(x) %>%
    mutate(y = row_number())`

Creating a function to plot NA matrix as a heatmap:

`plot_na_matrix <- function(df) {
     # Preparing the dataframe for heatmaps 
    df_heat <- df %>%
        pivot_longer(cols = everything(),
           names_to = "x") %>%
        group_by(x) %>%
        mutate(y = row_number())
     # Ensuring the order of columns is kept as it is
    df_heat <- df_heat %>%
        ungroup() %>%
        mutate(x = factor(x,levels = colnames(df)))
     # Plotting data
    g <- ggplot(data = df_heat, aes(x=x, y=y, fill=value)) + 
        geom_tile() + 
        theme(legend.position = "none",
              axis.title.y=element_blank(),
              axis.text.y =element_blank(),
              axis.ticks.y=element_blank(),
              axis.title.x=element_blank(),
              axis.text.x = element_text(angle = 90, hjust = 1))
     # Returning the plot
    g
 }`

Computing the correlation matrix with cor() function:

`missing_corr  <-  cor(df_na)`

Creating a function to plot NA correlation matrix as a heatmap:

`plot_na_correlation <- function(df) {
     # Taking the lower triangle of the correlation matrix
    missing_corr_up <- df
    missing_corr_up[lower.tri(missing_corr_up)] <- NA
    missing_corr_up <- data.frame(missing_corr_up)
     # Preparing the dataframe for heatmaps 
    col_names <- colnames(missing_corr_up)
    missing_corr_up_heat <- missing_corr_up %>%
        pivot_longer(cols = everything(),
           names_to = "x") %>%
        group_by(x) %>%
        mutate(y = col_names[row_number()])  %>%
        na.omit
     # Ordering triangle
    ordered_cols_asc <- col_names[order(colSums(is.na(missing_corr_up)))]
    ordered_cols_desc <- col_names[order(-colSums(is.na(missing_corr_up)))]
    missing_corr_up_heat <- missing_corr_up_heat %>%
        ungroup() %>%
        mutate(x = factor(x,levels = ordered_cols_asc)) %>%
        mutate(y = factor(y,levels = ordered_cols_desc))
     # Plotting heatmaps
    g <- ggplot(data = missing_corr_up_heat, aes(x=x, y=y, fill=value)) + 
        geom_tile() + 
        geom_text(aes(label=value)) +
        theme_minimal() +
        scale_fill_gradientn(colours = c("white", "yellow", "red"), values = c(-1,0,1)) +
        theme(legend.position = "none",
              axis.title.y=element_blank(),
              axis.title.x=element_blank(),
              axis.text.x = element_text(angle = 90, hjust = 1))
     # Returning the plot
    g
}`

## MAP FUNCTIONS
Use map functions as a powerfull alternative to loop
- map() function for any type list output
- map_df() function for dataframe output
- map_lgl() for logical vector output
- map_int() for integer vector output
- map_dbl() for double vector output
- map_chr() for character vector output
