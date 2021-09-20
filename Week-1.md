Week 1: Data Import, Manipulation, and GitHub
================

<!--
html_document:
    df_print: paged
  html_notebook: default
  pdf_document: default
-->
<!-- output: rmarkdown::github_document -->

# Objectives:

-   Set up and configure GitHub for use within RStudio.  
-   Importing data in R (a quick overview).  
-   Data manipulation in R (a quick overview).

# Setup GitHub

Follow instructions on [Using Git with
RStudio](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html).

For a Windows machine, generally, it is:

-   Download and install [Git](https://git-scm.com/download/win).  
-   In RStudio, create an SSH key pair (follow instructions
    [here](https://happygitwithr.com/ssh-keys.html#create-an-ssh-key-pair)):
    -   Go to Tools &gt; Global Options… &gt; Git/SVN.  
    -   Point to the executable “git.exe” (/Program Files/Git/)  
    -   Create RSA key in RStudio.  
    -   Copy RSA key. Add the generated key by clicking “new SSH key”
        into GitHub under your profile’s settings &gt; SSH and GPG keys,
        and pasting it.
-   Open git bash executable, and change directory (`cd`) to the folder
    you want to save the repo in.  
-   Run the following:  

<!-- -->

    git clone https://github.com/engineerchange/r-dsandml-exercises.git

-   Open .Rproj file in RStudio.  
-   Then go to Tools &gt; Project Options… &gt; Git/Svn to configure.  
-   From there, you should see a “Git” tab in the Environment pane where
    you can Commit, Pull, and Push.

# Importing

<!-- read_csv, read_csv2, read_delim, data.table, dtplyr, arrow/parquet -->

Load in necessary libraries.

Data is sourced from Euro Spatial Diffusion Observatory (ESDO) in-person
surveys between 2002 and 2011 in France. From
[Mendeley](https://data.mendeley.com/datasets/f257j67ym6/2).

``` r
library(tidyverse)
library(arrow)
library(microbenchmark) # to do simple benchmarking

df = read_csv2("lessons/data/DB_ESDO_FRANCE_2002-2011.csv") # initial un-cached dataset
```

Tidyverse’s read\_csv() function, which is 10x faster than base’s
read.csv() function.

Compare both:

``` r
# note we use read.csv2 and read_csv2 because these files are delineated with semi-colons.

func1 <- function(){read.csv2("lessons/data/DB_ESDO_FRANCE_2002-2011.csv")}
func2 <- function(){read_csv2("lessons/data/DB_ESDO_FRANCE_2002-2011.csv")}

microbenchmark(times=20, unit="ms", func1(), func2())
```

    ## Unit: milliseconds
    ##     expr      min       lq     mean   median       uq       max neval
    ##  func1() 459.2584 498.2758 506.6187 501.8630 507.9663  594.0674    20
    ##  func2() 107.7680 111.1065 166.7157 114.9281 116.2653 1099.8099    20

Can potentially speed up operations after by saving as RDS or arrow’s
parquet.

``` r
df = read_csv2("lessons/data/DB_ESDO_FRANCE_2002-2011.csv")

func1 <- function(){write_rds(df,"lessons/data/out.RDS")}
func2 <- function(){write_parquet(df,"lessons/data/out.parquet")}

microbenchmark(times=20, unit="ms", func1(), func2())
```

    ## Unit: milliseconds
    ##     expr     min       lq     mean   median      uq      max neval
    ##  func1() 50.3580 51.25625 63.64561 54.92670 60.2827 210.7234    20
    ##  func2() 73.2662 80.39425 84.89773 82.98825 86.6318 133.1385    20

Can potentially speed up read times with parquet over standard RDS.

``` r
func1 <- function(){read_rds("lessons/data/out.RDS")}
func2 <- function(){read_parquet("lessons/data/out.parquet")}

microbenchmark(times=20, unit="ms", func1(), func2())
```

    ## Unit: milliseconds
    ##     expr     min       lq     mean   median       uq     max neval
    ##  func1() 32.5613 35.51110 48.55886 38.37850 44.07980 95.1056    20
    ##  func2() 21.3563 22.14585 26.94362 22.95755 24.22495 83.3990    20

Try just reading in specific columns starting with QFRA.

``` r
func1 <- function(){read_rds("lessons/data/out.RDS") %>% select(starts_with("QFRA"))}
func2 <- function(){read_parquet("lessons/data/out.parquet",col_select = starts_with("QFRA"))}

microbenchmark(times=20, unit="ms", func1(), func2())
```

    ## Unit: milliseconds
    ##     expr     min       lq      mean   median      uq     max neval
    ##  func1() 34.2907 37.63685 53.837790 39.90935 70.9364 97.7284    20
    ##  func2()  8.1781  8.52835  9.528405  8.62365  8.8421 25.0865    20

# Data Manipulation

Get an idea of what data there is.

``` r
head(df,5)
```

    ## # A tibble: 5 x 158
    ##   SURVEY       SEX   AGE AGGL_FR_5 NUTS3  NPF5   E15 PRO6_FR PRO6_FR_CF SIT_SAL
    ##   <chr>      <dbl> <dbl>     <dbl> <chr> <dbl> <dbl>   <dbl>      <dbl>   <dbl>
    ## 1 01/03/2002     2    47         1 FR711     4     0       6          5       0
    ## 2 01/03/2002     2    34         1 FR711     3     1       4          3       2
    ## 3 01/03/2002     1    25         3 FR711     3     1       5          5       2
    ## 4 01/03/2002     1    55         3 FR711     2     0       6          6       2
    ## 5 01/03/2002     1    61         3 FR711     2     0       6          6       2
    ## # ... with 148 more variables: SAL <dbl>, TPS_FR <dbl>, SIT_CF <dbl>,
    ## #   SAL_CF <dbl>, TPS_FR_CF <dbl>, COUPLE <dbl>, STM <dbl>, DIPLIN_FR <dbl>,
    ## #   HAB_TYP <dbl>, HAB_STAT <dbl>, REVR_FR <dbl>, Weight <chr>, QFRA_1c <dbl>,
    ## #   QFRA_2c <dbl>, QFRA_5c <dbl>, QFRA_10c <dbl>, QFRA_20c <dbl>,
    ## #   QFRA_50c <dbl>, QFRA_1e <dbl>, QFRA_2e <dbl>, QALL_1c <dbl>, QALL_2c <dbl>,
    ## #   QALL_5c <dbl>, QALL_10c <dbl>, QALL_20c <dbl>, QALL_50c <dbl>,
    ## #   QALL_1e <dbl>, QALL_2e <dbl>, QBEL_1c <dbl>, QBEL_2c <dbl>, ...

``` r
# read metadata

df2 = read_csv2("lessons/data/metadataDB_ESDO_FRANCE_2002-2011.csv")
head(df2,20)
```

    ## # A tibble: 20 x 2
    ##    SURVEY     `Month and year of the survey`                                    
    ##    <chr>      <chr>                                                             
    ##  1 SEX        "1) Man 2) Woman"                                                 
    ##  2 AGE        "Age in years"                                                    
    ##  3 AGGL_FR_5  "Place of residence type of agglomeration in 5 categories: 1) Rur~
    ##  4 NUTS3      "Place of residence location according to the European Nomenclatu~
    ##  5 NPF5       "Size of the household in 5 categories : 1) 1 person 2) 2 persons~
    ##  6 E15        "Number of children under age 15 in 6 categories: 0) none 1) 1 ch~
    ##  7 PRO6_FR    "Profession in 6 categories: 1) Farmer 2) Craftsman - seller 3) M~
    ##  8 PRO6_FR_CF "Profession of the head of the family, if the head of household i~
    ##  9 SIT_SAL    "Current or past salary situation in 2 categories: 1) On your acc~
    ## 10 SAL        "Employer type in 3 categories: 1) state or local community 2) pu~
    ## 11 TPS_FR     "Working time: 1) Full time 2) Part-time"                         
    ## 12 SIT_CF     "Current or past salary status of the head of household, if the h~
    ## 13 SAL_CF     "Employer type of the head of household, if the head of household~
    ## 14 TPS_FR_CF  "Working time of the head of household, if the head of household ~
    ## 15 COUPLE     "Lives as a couple: 1) Yes 2) No"                                 
    ## 16 STM        "Marital status in 3 categories: 1) Married or living in a marria~
    ## 17 DIPLIN_FR  "Highest diploma obtained according to the following response mod~
    ## 18 HAB_TYP    "Habitat type according in 6 categories: 1) A farm 2) A detached ~
    ## 19 HAB_STAT   "Property status in 4 categories: 1) Ownership, including co-owne~
    ## 20 REVR_FR    "In the first 15 surveys (March 2002 to October 2008), the respon~

``` r
head(df2 %>% slice(20:nrow(df2)),20)
```

    ## # A tibble: 20 x 2
    ##    SURVEY   `Month and year of the survey`                                      
    ##    <chr>    <chr>                                                               
    ##  1 REVR_FR  "In the first 15 surveys (March 2002 to October 2008), the responde~
    ##  2 Weight   "Weighting variables constructed by ISL"                            
    ##  3 QFRA_1c  "Number of 01 cent coins minted in France contained in the wallet"  
    ##  4 QFRA_2c  "Number of 02 cents coins minted in France contained in the wallet" 
    ##  5 QFRA_5c  "Number of 05 cents coins minted in France contained in the wallet" 
    ##  6 QFRA_10c "Number of 10 cents coins minted in France contained in the wallet" 
    ##  7 QFRA_20c "Number of 20 cents coins minted in France contained in the wallet" 
    ##  8 QFRA_50c "Number of 50 cents coins minted in France contained in the wallet" 
    ##  9 QFRA_1e  "Number of 1 euro coins minted in France contained in the wallet"   
    ## 10 QFRA_2e  "Number of 2 euros coins minted in France contained in the wallet"  
    ## 11 QALL_1c  "Number of 01 cent coins minted in Germany contained in the wallet" 
    ## 12 QALL_2c  "Number of 02 cents coins minted in Germany contained in the wallet"
    ## 13 QALL_5c  "Number of 05 cents coins minted in Germany contained in the wallet"
    ## 14 QALL_10c "Number of 10 cents coins minted in Germany contained in the wallet"
    ## 15 QALL_20c "Number of 20 cents coins minted in Germany contained in the wallet"
    ## 16 QALL_50c "Number of 50 cents coins minted in Germany contained in the wallet"
    ## 17 QALL_1e  "Number of 1 euro coins minted in Germany contained in the wallet"  
    ## 18 QALL_2e  "Number of 2 euros coins minted in Germany contained in the wallet" 
    ## 19 QBEL_1c  "Number of 01 cent coins minted in Belgium contained in the wallet" 
    ## 20 QBEL_2c  "Number of 02 cents coins minted in Belgium contained in the wallet"

Apparently, there are a lot of columns of extra data, so we exclude to
just the France coin related columns and demographics we want.

``` r
df = df %>% select(SURVEY:AGE,starts_with("QFRA"))
head(df)
```

    ## # A tibble: 6 x 11
    ##   SURVEY    SEX   AGE QFRA_1c QFRA_2c QFRA_5c QFRA_10c QFRA_20c QFRA_50c QFRA_1e
    ##   <chr>   <dbl> <dbl>   <dbl>   <dbl>   <dbl>    <dbl>    <dbl>    <dbl>   <dbl>
    ## 1 01/03/~     2    47       0       0       0        0        0        0       0
    ## 2 01/03/~     2    34       1       2       0        0        2        0       1
    ## 3 01/03/~     1    25       2       1       2        0        0        0       0
    ## 4 01/03/~     1    55       1       1       1        5        1        0       4
    ## 5 01/03/~     1    61       3       0       0        0        3        0       0
    ## 6 01/03/~     1    37       4       0       2        0        3        0       0
    ## # ... with 1 more variable: QFRA_2e <dbl>

We may want to get an idea of the average proportion of different coin
types by individual. So we can graph that.

``` r
# Make data in long form

df_long = df %>%
  mutate(Person=row_number()) %>%
  pivot_longer(cols=starts_with("QFRA"),names_to = "Coin", values_to = "Count")
head(df_long,5)
```

    ## # A tibble: 5 x 6
    ##   SURVEY       SEX   AGE Person Coin     Count
    ##   <chr>      <dbl> <dbl>  <int> <chr>    <dbl>
    ## 1 01/03/2002     2    47      1 QFRA_1c      0
    ## 2 01/03/2002     2    47      1 QFRA_2c      0
    ## 3 01/03/2002     2    47      1 QFRA_5c      0
    ## 4 01/03/2002     2    47      1 QFRA_10c     0
    ## 5 01/03/2002     2    47      1 QFRA_20c     0

``` r
# Separate out column Coin

df_long = df_long %>%
  separate(Coin,sep="_",into = c("Lbl","Coin"))
head(df_long,5)
```

    ## # A tibble: 5 x 7
    ##   SURVEY       SEX   AGE Person Lbl   Coin  Count
    ##   <chr>      <dbl> <dbl>  <int> <chr> <chr> <dbl>
    ## 1 01/03/2002     2    47      1 QFRA  1c        0
    ## 2 01/03/2002     2    47      1 QFRA  2c        0
    ## 3 01/03/2002     2    47      1 QFRA  5c        0
    ## 4 01/03/2002     2    47      1 QFRA  10c       0
    ## 5 01/03/2002     2    47      1 QFRA  20c       0

``` r
# remove column Lbl

df_long = df_long %>% select(-Lbl)
head(df_long,5)
```

    ## # A tibble: 5 x 6
    ##   SURVEY       SEX   AGE Person Coin  Count
    ##   <chr>      <dbl> <dbl>  <int> <chr> <dbl>
    ## 1 01/03/2002     2    47      1 1c        0
    ## 2 01/03/2002     2    47      1 2c        0
    ## 3 01/03/2002     2    47      1 5c        0
    ## 4 01/03/2002     2    47      1 10c       0
    ## 5 01/03/2002     2    47      1 20c       0

``` r
# rearrange columns

df_long = df_long %>% select(Person,SURVEY,SEX,AGE,everything())
head(df_long,5)
```

    ## # A tibble: 5 x 6
    ##   Person SURVEY       SEX   AGE Coin  Count
    ##    <int> <chr>      <dbl> <dbl> <chr> <dbl>
    ## 1      1 01/03/2002     2    47 1c        0
    ## 2      1 01/03/2002     2    47 2c        0
    ## 3      1 01/03/2002     2    47 5c        0
    ## 4      1 01/03/2002     2    47 10c       0
    ## 5      1 01/03/2002     2    47 20c       0

``` r
# make initial bar chart

df_long %>% group_by(Coin,Count) %>% count() %>% ungroup() %>%
  ggplot() + theme_bw() +
  geom_bar(aes(x=Coin,y=n,fill=as.character(Count)),stat='identity',position='stack')
```

![](Week-1_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
# make bar chart ignoring 0 counts

df_long %>% dplyr::filter(Count!="0") %>%
  group_by(Coin,Count) %>% count() %>% ungroup() %>%
  ggplot() + theme_bw() +
  geom_bar(aes(x=Coin,y=n,fill=as.character(Count)),stat='identity',position='stack')
```

![](Week-1_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

``` r
# group coins into buckets

df_long %>% dplyr::filter(Count!="0") %>%
  mutate(Count=case_when(
    Count %in% c(1,2,3) ~ "1-3",
    Count %in% c(4,5,6) ~ "4-6",
    Count %in% c(7,8,9) ~ "7-9",
    TRUE ~ "10+"
  )) %>%
  group_by(Coin,Count) %>% count() %>% ungroup() %>%
  ggplot() + theme_bw() +
  geom_bar(aes(x=Coin,y=n,fill=Count),stat='identity',position='stack')
```

![](Week-1_files/figure-gfm/unnamed-chunk-8-3.png)<!-- -->

``` r
# clean up: add axis labels, title, scale axis, viridis discrete scale

df_long %>% dplyr::filter(Count!="0") %>%
  mutate(Count=case_when(
    Count %in% c(1,2,3) ~ "1-3",
    Count %in% c(4,5,6) ~ "4-6",
    Count %in% c(7,8,9) ~ "7-9",
    TRUE ~ "10+"
  )) %>% 
  group_by(Coin,Count) %>% count() %>% ungroup() %>%
  ggplot() + theme_bw() +
  geom_bar(aes(x=factor(Coin, level = c("1c","1e","2c","2e","5c","10c","20c","50c")),y=n,fill=Count),
           stat='identity',position='stack') +
  scale_x_discrete(name="French coins") +
  scale_y_continuous(name="Count of coins",labels = scales::comma) +
  ggtitle("Count of French coins per person") +
  scale_fill_viridis_d(name="Count per person")
```

![](Week-1_files/figure-gfm/unnamed-chunk-8-4.png)<!-- -->

<!-- pivot_wider, pivot_longer, separate, unite -->

# Exploratory Data Analysis (EDA)

<!-- geom_point, geom_histogram, geom_boxplot, gt, left_join, anti_join -->

# Resources

## GitHub

-   [Using Git with
    RStudio](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html),
    Jenny Bryan  
-   [Happy Git with R](https://happygitwithr.com/), Jenny Bryan

## Importing

-   [R for Data Science - Data
    Import](https://r4ds.had.co.nz/data-import.html)  
-   [Efficient
    input/output](https://csgillespie.github.io/efficientR/input-output.html)  
-   [Apache Arrow](https://arrow.apache.org/docs/r/reference/index.html)
