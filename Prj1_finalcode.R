library(dplyr)
library(tidyverse)

#0: Upload csv file as data frame
refine <- read_csv("refine_original.csv")
View(refine)

#1: Clean up brand names
#figure out what's there and how many
refine %>% 
  count(company)
#Create new data frame w/ company column showing four distinct values (not 19). (using mutate, str_replace functions)
refine1 <- refine %>%
  mutate(company = str_replace_all(company, c("(.*s|.*S)" = "philips", "(ak .*|ak.*|Ak.*|AK.*)" = "akzo" , "(van .*|Van .*)" = "van houten", "(u.*r|U.*r)" = "unilever")))
refine1 %>% group_by(company) %>% count()
refine1

#2: add two new columns called product_code and product_number (using separate function)
refine2 <- refine1 %>% 
  separate(`Product code / number`, c("product_code", "product_number"), sep = "-")
refine2

#3: add the following product categories (p = Smartphone; v = TV; x = Laptop; q = Tablet)
refine3 <- refine2 %>%
  mutate(product = str_replace_all(product_code, c("p" = "Smartphone", "v" = "TV", "x" = "Laptop", "q" = "Tablet")))
refine3

#4: Add full address for geocoding (using unite)
refine4 <- refine3 %>% 
  unite("full_address", address, city, country, sep = ",")
refine4

#5: Create binary "dummy" columns for "company" and "product" columns (using dummy_cols function)
library(fastDummies)
refine5 <- refine4 %>% 
  dummy_cols(select_columns = "company") %>% 
  dummy_cols(select_columns = "product")
refine5
View(refine5)

#export as csv
write.csv(refine5, "refine_clean.csv")
