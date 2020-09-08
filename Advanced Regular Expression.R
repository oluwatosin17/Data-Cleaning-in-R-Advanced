hn <- read_csv("hacker_news.csv")
library(stringr)
m <- str_detect("hand","and")
m
m <- str_detect("antidote", "and")
m
string_vector <- c("Julie's favorite color is green", "Keli's favorite color is Blue", "Craig favorite color is red and blue")
pattern <- "Blue"
m <- str_detect(string_vector,pattern)
m
library(dplyr)

pattern <- "Amazon"
titles <- hn$title
matches <- str_detect(titles, pattern)
hn_matches <- if_else(matches,"Match","No Match")


# Set of characters in regular expression
string_vector <- c("Julie's favorite color is green", "Keli's favorite color is Blue", "Craig favorite color is red and blue")
pattern <- "[Bb]lue"
m <- str_detect(string_vector,pattern)
m

blue_mentions <- sum(m)
blue_mentions

pattern <- "[Aa]mazon"
titles <- hn$title
matches <- str_detect(titles, pattern)
amazon_mentions <- sum(matches)
amazon_mentions

#Alternative patterns
string_vector <-  c("Julie's favorite color is green", "Keli's favorite color is Blue", "Craig favorite color is red and blue")
pattern <- "Blue|blue"
m <- str_detect(string_vector,pattern)
m


pattern <- "2010|2011|2012"
matches <- str_detect(titles, pattern)
hn_matches <- if_else(matches, "2010-2012","Other")
hn_gr <- hn %>% mutate(year_group = hn_matches)

library(tidyverse)
view(hn_gr)


pattern <- "2000|2005|2010"
matches <- str_detect(titles, pattern)
hn_matches <- if_else(matches, "Match","No Match")
hn_group <- hn %>% mutate(year_group = hn_matches)

view(hn_group)


#Using Regular Expression to select data
titles <- hn$title
amazon_titles_logical <- str_detect(titles, "[Aa]mazon")
amazon_titles <- titles[amazon_titles_logical]
print(head(amazon_titles))

hn_amazon <- hn %>% filter(amazon_titles_logical)
print(head(hn_amazon$title))


google_titles_logical <- str_detect(titles, "[Gg]oogle")
google_titles <- titles[google_titles_logical]
hn_google <- hn %>% filter(google_titles_logical)
print(head(google_titles))
print(head(hn_google$title))


#Quantifiers
# ? the optional quantifier to specify the - character
pattern <- "e(-)?mail"
email_logical <- str_detect(titles, pattern)
email_count <- sum(email_logical)
print(email_count)
email_titles <- hn %>% filter(email_logical)
print(head(email_titles$title))
view(email_titles)

#Character Classes 
pattern <- "\\[\\w+\\]"
tag_logical <- str_detect(titles, pattern)
tag_titles <- titles[tag_logical]
print(head(tag_titles))
tag_count <- sum(tag_logical)
print(tag_count)

#Accessing matching Text with Capture groups

tag_matches <- str_extract(head(tag_titles), pattern)
print(tag_matches)

pattern <- "\\[(\\w+)\\]"
tag_matches <- str_match(head(tag_titles), pattern)
print(tag_matches)

tag_text_matches <- tag_matches[,2]
print(tag_text_matches)

tags_freq <- table(tag_text_matches)
print(tags_freq)


tag_titles <- titles[str_detect(titles, "\\[(\\w+)\\]")]
pattern <- "\\[(\\w+)\\]"
tags_text_matches <- str_match(tag_titles)
tags_freq <- table(tags_text_matches[,2])
print(tags_freq)


#Negative Character  class
first_10_matches <- function(data, pattern){
  matches <- str_detect(data, pattern)
  matched_df <- data[matches]
  head(matched_df, 10)
  
}
first_10_matches(titles, "[Jj]ava")
first_10_matches(titles, "[Jj]ava[^sS]")


#word boundaries 
string <- "Sometimes people confuse Javascript with Java"
pattern_1 <- "Java[^S]"
m_1 <- str_detect(string, pattern_1 )
m_1
pattern_2 <- "\\bJava\\b"
m_1 <- str_detect(string, pattern_2 )
m_1

pattern_3 <- boundary("Java")
m_3 <- str_detect(string, pattern_3 )
m_3


first_10_matches(titles, "\\b[jJ]ava\\b")


#Matching at the Start and End of Strings

#^abc matches abc only at the start of the string
#abc$ matches abc at the end of the string

test_cases <- c('Red Nose Day is a well-known fundraising event', 'My favorite color is Red','My Red Car was purchased three years ago')
print(test_cases)

print(str_detect(test_cases, "^Red"))
print(str_detect(test_cases, "Red$"))


pattern <- "^\\[(\\w+)\\]"
beginner <- str_detect(titles, pattern)
beginner_logical <- titles[beginner]
beginner_count <- sum(beginner)
beginner_count

pattern <- "\\[(\\w+)\\]$"
ending <- str_detect(titles, pattern)
ending_logical <- titles[ending]
ending_count <- sum(ending)
ending_count


# Challenge: Using Flags to Modify Regex Patterns
email_test <- c("email","Email", "eMail",'EMAIL')
#(?i) it is called ignore case flag
print(str_detect(email_test, "(?i)email"))

email_tests <-  c("email","Email", "eMail",'EMAIL','e Mail','e mail','E-mail','e-mail','E-Mail','EMAIL')
print(str_detect(email_tests, "(?i)e(-)?( )?mail"))
print(str_detect(email_tests, "(?i)e(.)?mail"))
email_mention <- sum((str_detect(titles, "(?i)e(.)?mail")))
email_mention


pattern <- "[Pp]ython"
python_counts <- sum(str_detect(titles, pattern))
print(python_counts)

pattern <- "Python|python"
python_counts <- sum(str_detect(titles, pattern))
print(python_counts)

pattern <- "(?i)python"
python_counts <- sum(str_detect(titles, pattern))
print(python_counts)

pattern <- "(?i)sql"
sql_counts <- sum(str_detect(titles, pattern))
print(sql_counts)


#Capture Groups
pattern <- "(?i)(SQL)"
sql_capitalizations <- str_match(titles, pattern)[,2]
sql_capitalizations_freq <- table(sql_capitalizations)
print(sql_capitalizations_freq)


pattern <- "(?i)(\\w+SQL)"
sql_flavors <- str_match(titles, pattern)[,2]
sql_flavors_freq <- table(sql_flavors)
print(sql_flavors_freq)

sql_flavors_freq <- table(str_to_lower(sql_flavors))
print(sql_flavors_freq)


pattern <- "(?i)(python [\\d])"
python_flavors <- str_match(titles, pattern)[,2]
python_titles_freq <- table(str_to_lower(python_flavors))
print(python_titles_freq)


pattern <- "(?i)(python( )\\d+)"
python_flavors <- str_match(titles, pattern)[,2]
python_titles_freq <- table(str_to_lower(python_flavors))
print(python_titles_freq)


# Using Capture Groups to Extract Data

python_titles <- titles[str_detect(titles, "[pP]ython [\\d\\.]+")]
python_sample <- "[pP]ython ([\\d\\.]+)"
python_versions <- str_match(python_titles, python_sample)[,2]
python_versions_freq <- table(python_versions)

python_versions_freq
python_versions
python_titles


#Counting Mentions of the "C" language

first_10_matches <- function(data,pattern){
  matches <- str_detect(data,pattern)
  
  matched_df <- data[matches]
  
  head(matched_df, 10)
}
c_10_matches <- first_10_matches(titles, "\\b[Cc]\\b")
print(c_10_matches)

c_10_matches <- first_10_matches(titles, "\\b[Cc]\\b[^.+]")
print(c_10_matches)


#Using Lookarounds to Control Matches Based on Surrounding Text
test_cases <- c("Red_Green_Blue","Yellow_Green_Red","Red_Green_Red","Yellow_Green_Blue","Green")
run_test_cases <- function(data,pattern){
  data_matches <- str_match(data,pattern)
  
  data_matches[is.na(data_matches)] <- "NO MATCH"
  # Assigning "NO MATCH" to mismatch pattern
  data_matches 
}

#Positive Lookahead
run_test_cases(test_cases,"Green(?=_Blue)")
#Negative Lookahead
run_test_cases(test_cases,"Green(?!_Red)")
#Positive Lookbehind
run_test_cases(test_cases,"(?<=Red_)Green")
#Negative lookbehind
run_test_cases(test_cases,'(?<!Yellow_)Green')


first_10_matches(titles, "(?<!Series )\\b[Cc]\\b[^.+]")
first_10_matches(titles, "\\b[Cc]\\b(?!Series)[^.+]")

pattern <-  "(?<!Series )\\b[Cc]\\b(?!\\w+)(?![\\.\\+])"
c_mentions <- sum(str_detect(titles,pattern))
c_mentions

#BackReferences: Using Capture Groups in a Regex Pattern
test_cases <- c("I'm going to read a book.",
                "Green is my favourite color.",
                "My name is Aaron.",
                 "No doubles here",
                "I have a pet eel.")

print(str_match(test_cases, "(\\w)\\1"))

library(readr)
library(tidyverse)
      
pattern <- "\\b(\\w+)\\s+\\1\\b"
repeated_words <- titles[str_detect(titles, pattern)]
repeated_words

#Challenge: Cleaning our dataset
pattern <- "(?<=[\\w+])(?i)(SQL)"
sql_flavors <- titles[str_detect(titles,pattern)]
view(hn_sql)
hn_sql<- hn %>% filter(str_detect(title,pattern))
hn_sql <- hn_sql %>% mutate(flavor = str_extract(title,"(?i)(\\w+SQL)" ) ) 
hn_sql <- hn_sql %>% mutate(flavor = str_to_lower(flavor)) 
hn_sql_flavor_avg <- hn_sql %>% group_by(flavor)%>%summarise(avg = mean(num_comments)) 
hn_sql_flavor_avg


#Substituting Regular Expression Matches
string <- "aBcDEfGHIj"
print(str_replace(string, "[A-Z]","-"))
print(str_replace_all(string,"[A-Z]","-"))

sql_variations <- c("SQL","sql","Sql")
sql_uniform <- str_replace(sql_variations,"(?i)sql","SQL")
sql_uniform

email_variation <- c("email",'Email','eMail',"e mail","E-mail","e-mail","E-Mail","EMAIL")
email_uniform <- str_replace(email_variation,"(?i)e( )?(-)?mail","email")
email_uniform
titles_clean <- str_replace(titles,"(?i)e( )?(-)?mail","email")

test_urls  <-  c(
  'https://www.amazon.com/Technology-Ventures-Enterprise-Thomas-Byers/dp/0073523429',
  'http://www.interactivedynamicvideo.com/',
  'http://www.nytimes.com/2007/11/07/movies/07stein.html?_r=0',
  'http://evonomics.com/advertising-cannot-maintain-internet-heres-solution/',
  'HTTPS://github.com/keppel/pinn',
  'Http://phys.org/news/2015-09-scale-solar-youve.html',
  'https://iot.seeed.cc',
  'http://www.bfilipek.com/2016/04/custom-deleters-for-c-smart-pointers.html',
  'http://beta.crowdfireapp.com/?beta=agnipath',
  'https://www.valid.ly'
)
pattern <- "(?i)https?://([\\w\\.\\-]+)"
str_match(test_urls,pattern)
domains <- str_match(hn$url,pattern)[,2]

top_domains <- head(table(domains),20)
top_domains

#Extracting URL Parts Using Multiple Capture Groups

created_at <- head(hn$created_at)
print(created_at)
pattern <- "(.+)\\s(.+)"
date_times <- str_match(created_at,pattern)
print(date_times)


pattern <- "(.+)://([\\w\\.]+)/?(.*)"
test_url_parts <- str_match(test_urls,pattern)
test_url_parts

hn_urls <- hn %>% mutate(protocol = str_match(url ,pattern)[,2]) %>% mutate(domain = str_match(url,pattern)[,3]) %>% mutate(page_path = str_match(url,pattern)[,4])
view(hn_urls)

