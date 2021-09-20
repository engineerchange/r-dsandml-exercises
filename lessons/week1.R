# Week 1 exercises


# import ------------------------------------------------------------------
library(tidyverse)
library(kableExtra)
library(gt)

# mendeley - French data on surveying coins in wallets in France
wallet <- read_csv("lessons/data/DB_ESDO_FRANCE_2002-2011.csv")
head(wallet)
wallet <- read_csv2("lessons/data/DB_ESDO_FRANCE_2002-2011.csv")
head(wallet)
# look at metadata
wallet_meta <- read_csv2("lessons/data/metadataDB_ESDO_FRANCE_2002-2011.csv")

# select just columns we want
wallet <- wallet %>% select(SURVEY:STM,contains("FR"))

# make it long form

wallet %>% 
  select(contains("QFRA")) %>%
  pivot_longer(names_to="type",cols = contains("QFRA")) %>%
  ggplot(aes(x=type,y=value)) +
  geom_boxplot(alpha=0) +
  geom_jitter(alpha=0.3, color = "tomato") +
  theme_bw()

wallet_bysurvey = wallet %>% 
  group_by(SURVEY) %>% 
  summarise(count=n(),
            male=sum(SEX==1),female=sum(SEX==2)) %>% ungroup()

age_list = split(wallet$AGE,wallet$SURVEY)

wallet %>% 
  group_by(SURVEY) %>% 
  summarise(count=n(),
            male=sum(SEX==1),female=sum(SEX==2),
            age = list(AGE)) %>% ungroup() %>%
  mutate(
    plot = map(age, ~spec_boxplot(.x,width=300,height=700)),
    plot = map(plot, "svg_text"),
    plot = map(plot, gt::html)
  ) %>% select(-age) %>%
  gt()

wallet %>% 
  group_by(SURVEY) %>% 
  summarise(count=n(),
            male=sum(SEX==1),female=sum(SEX==2),
            age = list(AGE)) %>% ungroup() %>%
  mutate(
    plot = map(age, ~spec_hist(.x,width=300,height=200)),
    plot = map(plot, "svg_text"),
    plot = map(plot, gt::html)
  ) %>% select(-age) %>%
  gt()

wallet %>% 
  group_by(PRO6_FR) %>% 
  summarise(count=n(),
            male=sum(SEX==1),female=sum(SEX==2),
            age = list(AGE)) %>% ungroup() %>%
  mutate(
    plot = map(age, ~spec_hist(.x,width=300,height=200)),
    plot = map(plot, "svg_text"),
    plot = map(plot, gt::html)
  ) %>% select(-age) %>%
  gt()

wallet %>% 
  select(PRO6_FR,contains("QFRA")) %>%
  mutate(row=row_number()) %>%
  pivot_longer(names_to="type",cols = contains("QFRA")) %>%
  mutate(coin=str_extract(type,"[0-9]{1,}")) %>%
  dplyr::filter(value!=0) %>%
  group_by(PRO6_FR) %>%
  summarise(count=n_distinct(row),coins=list(value)) %>%
  ungroup() %>%
  mutate(
    plot = map(coins, ~spec_hist(.x,width=300,height=200)),
    plot = map(plot, "svg_text"),
    plot = map(plot, gt::html)
  ) %>% select(-coins) %>%
  gt()
  
  
  
