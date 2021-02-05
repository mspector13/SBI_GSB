# libraries ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(glue, here, lubridate, matthewsilk/CMRnet, readr, tidyverse) # , timeDate)
#timeDate <- timeDate::timeDate

# paths ----

locs_all_csv <- here("data/locs_all.csv")
locs_run_csv <- here("data/locs_run.csv")
net_dttm_rds <- here("data/net_dttm.rds")
net_day_rds  <- here("data/net_day.rds")

redo_run_csv = F

# read and wrangle ----
if (!file.exists(locs_run_csv) | redo_run_csv){
  
  d_locs_all <- read_csv(locs_all_csv, na="NULL")
  # head(d_locs_all)
  
  d_locs_run <- d_locs_all %>% 
    #rename 2x columns to match "cmrData"
    select(id, loc=sta_id, x, y, date = dt) %>%
    filter(id %in% c(
      "A69-1602-9719",
      "A69-1602-9720",
      "A69-1602-9721", 
      "A69-1602-9723", 
      "A69-1602-9722",
      "A69-1602-9716",
      "A69-1602-9718",
      "A69-1602-9712",
      "A69-1602-9714",
      "A69-1602-16712",
      "A69-1602-16716",
      "A69-1602-16715",
      "A69-1602-16718",
      "A69-1602-16710"))
  
  # update x,y to same for all loc to avoid error from dist() and have single locations:
  #   [DynamicNetCreate.R#L102](https://github.com/matthewsilk/CMRnet/blob/4686eaadb0583f18c426628529adcaf527cd3e63/R/DynamicNetCreate.R#L102)
  d_locs_run <- d_locs_run %>% 
    select(-x, -y) %>% 
    left_join(
      d_locs_run %>% 
        group_by(loc) %>% 
        summarize(
          x = first(x),
          y = first(y)),
      by = "loc") %>% 
    select(id, loc, x, y, date)
  
  # summarize by day. before: nrows = 99,980; after: nrows = 3,678
  d_locs_run <- d_locs_run %>% 
    mutate(
      datetime = date,
      date     = date(date)) %>% 
    group_by(id, loc, x, y, date) %>% 
    summarize(n_detections = n()) %>% 
    arrange(desc(n_detections))
  
  write_csv(d_locs_run, file = locs_run_csv)
}

# Construct co-capture networks ----
d_locs_run <- read_csv(locs_run_csv, na="NULL") %>% 
  select(-n_detections)

# CMRnet params
mindate     <- min(date(d_locs_run$date)) %>% as.character() # "2018-08-13"
maxdate     <- max(date(d_locs_run$date)) %>% as.character() # "2019-10-17"
intwindow   <- 3 # length of time (in days) w/in which individuals are considered co-captured
netwindow   <- 4 # length of each network window in months
overlap     <- 2 # overlap between network windows in months
spacewindow <- 0 # spatial tolerance for defining co-captures

# debug
source("CMRnet_debug/DynamicNetCreate.R")
net_day <- DynamicNetCreate(
  data        = d_locs_run,
  intwindow   = intwindow,
  mindate     = mindate,
  maxdate     = maxdate,
  netwindow   = netwindow,
  overlap     = overlap,
  spacewindow = spacewindow,
  index       = F)

write_rds(net_day, net_day_rds)

net_windows <- tibble(
  starts = c("2018-08-13", "2018-10-13", "2018-12-13", "2019-02-13", "2019-04-13", "2019-06-13"),
  ends   = c("2018-12-13", "2019-02-13", "2019-04-13", "2019-06-13", "2019-08-13", "2019-10-13")) %>% 
  mutate(
    `Network Window` = 1:length(starts))
net_windows

source("CMRnet_debug/cmr_igraph.R")
net_social <- cmr_igraph(net_day, type="social")

cmrSocPlot(nets=net_social) # , fixed_locs=T, dynamic=F, rows=4, vertex.label=NA)

# devtools::session_info() # on Ben's laptop
# ─ Session info ────────────────────────────────────────────────────────────────────────────────────────────
# setting  value                       
# version  R version 4.0.2 (2020-06-22)
# os       macOS  10.16                
# system   x86_64, darwin17.0          
# ui       RStudio                     
# language (EN)                        
# collate  en_US.UTF-8                 
# ctype    en_US.UTF-8                 
# tz       America/Los_Angeles         
# date     2021-02-05                  
# 
# ─ Packages ────────────────────────────────────────────────────────────────────────────────────────────────
# package     * version    date       lib source                             
# assertthat    0.2.1      2019-03-21 [1] CRAN (R 4.0.0)                     
# backports     1.2.0      2020-11-02 [1] CRAN (R 4.0.2)                     
# broom         0.7.2      2020-10-20 [1] CRAN (R 4.0.2)                     
# callr         3.5.1      2020-10-13 [1] CRAN (R 4.0.2)                     
# cellranger    1.1.0      2016-07-27 [1] CRAN (R 4.0.0)                     
# cli           2.3.0      2021-01-31 [1] CRAN (R 4.0.2)                     
# CMRnet      * 0.1.0      2021-02-05 [1] Github (matthewsilk/CMRnet@4686eaa)
# colorspace    2.0-0      2020-11-11 [1] CRAN (R 4.0.2)                     
# crayon        1.4.0      2021-01-30 [1] CRAN (R 4.0.2)                     
# DBI           1.1.1      2021-01-15 [1] CRAN (R 4.0.2)                     
# dbplyr        2.0.0      2020-11-03 [1] CRAN (R 4.0.2)                     
# desc          1.2.0      2018-05-01 [1] CRAN (R 4.0.0)                     
# devtools      2.3.1      2020-07-21 [1] CRAN (R 4.0.2)                     
# digest        0.6.27     2020-10-24 [1] CRAN (R 4.0.2)                     
# dplyr       * 1.0.3      2021-01-15 [1] CRAN (R 4.0.2)                     
# ellipsis      0.3.1      2020-05-15 [1] CRAN (R 4.0.0)                     
# fansi         0.4.2      2021-01-15 [1] CRAN (R 4.0.2)                     
# forcats     * 0.5.0      2020-03-01 [1] CRAN (R 4.0.0)                     
# fs            1.5.0      2020-07-31 [1] CRAN (R 4.0.2)                     
# generics      0.1.0      2020-10-31 [1] CRAN (R 4.0.2)                     
# ggplot2     * 3.3.3      2020-12-30 [1] CRAN (R 4.0.2)                     
# glue          1.4.2      2020-08-27 [1] CRAN (R 4.0.2)                     
# gtable        0.3.0      2019-03-25 [1] CRAN (R 4.0.0)                     
# haven         2.3.1      2020-06-01 [1] CRAN (R 4.0.0)                     
# hms           1.0.0      2021-01-13 [1] CRAN (R 4.0.2)                     
# httr          1.4.2      2020-07-20 [1] CRAN (R 4.0.2)                     
# jsonlite      1.7.2      2020-12-09 [1] CRAN (R 4.0.2)                     
# lifecycle     0.2.0      2020-03-06 [1] CRAN (R 4.0.0)                     
# lubridate   * 1.7.9.2    2020-11-13 [1] CRAN (R 4.0.2)                     
# magrittr      2.0.1      2020-11-17 [1] CRAN (R 4.0.2)                     
# memoise       1.1.0      2017-04-21 [1] CRAN (R 4.0.0)                     
# modelr        0.1.8      2020-05-19 [1] CRAN (R 4.0.0)                     
# munsell       0.5.0      2018-06-12 [1] CRAN (R 4.0.0)                     
# pillar        1.4.7      2020-11-20 [1] CRAN (R 4.0.2)                     
# pkgbuild      1.2.0      2020-12-15 [1] CRAN (R 4.0.2)                     
# pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.0.0)                     
# pkgload       1.1.0      2020-05-29 [1] CRAN (R 4.0.0)                     
# prettyunits   1.1.1      2020-01-24 [1] CRAN (R 4.0.0)                     
# processx      3.4.5      2020-11-30 [1] CRAN (R 4.0.2)                     
# ps            1.5.0      2020-12-05 [1] CRAN (R 4.0.2)                     
# purrr       * 0.3.4      2020-04-17 [1] CRAN (R 4.0.0)                     
# R6            2.5.0      2020-10-28 [1] CRAN (R 4.0.2)                     
# Rcpp          1.0.6      2021-01-15 [1] CRAN (R 4.0.2)                     
# readr       * 1.4.0      2020-10-05 [1] CRAN (R 4.0.2)                     
# readxl        1.3.1      2019-03-13 [1] CRAN (R 4.0.0)                     
# remotes       2.2.0      2020-07-21 [1] CRAN (R 4.0.2)                     
# reprex        0.3.0      2019-05-16 [1] CRAN (R 4.0.0)                     
# rlang         0.4.10     2020-12-30 [1] CRAN (R 4.0.2)                     
# rprojroot     2.0.2      2020-11-15 [1] CRAN (R 4.0.2)                     
# rstudioapi    0.13       2020-11-12 [1] CRAN (R 4.0.2)                     
# rvest         0.3.6      2020-07-25 [1] CRAN (R 4.0.2)                     
# scales        1.1.1      2020-05-11 [1] CRAN (R 4.0.0)                     
# sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 4.0.0)                     
# stringi       1.5.3      2020-09-09 [1] CRAN (R 4.0.2)                     
# stringr     * 1.4.0      2019-02-10 [1] CRAN (R 4.0.0)                     
# testthat      3.0.1      2020-12-17 [1] CRAN (R 4.0.2)                     
# tibble      * 3.0.6      2021-01-29 [1] CRAN (R 4.0.2)                     
# tidyr       * 1.1.2      2020-08-27 [1] CRAN (R 4.0.2)                     
# tidyselect    1.1.0      2020-05-11 [1] CRAN (R 4.0.0)                     
# tidyverse   * 1.3.0      2019-11-21 [1] CRAN (R 4.0.2)                     
# timeDate      3043.102   2018-02-21 [1] CRAN (R 4.0.2)                     
# usethis       1.6.1.9001 2020-08-19 [1] Github (r-lib/usethis@860c1ea)     
# utf8          1.1.4      2018-05-24 [1] CRAN (R 4.0.0)                     
# vctrs         0.3.6      2020-12-17 [1] CRAN (R 4.0.2)                     
# withr         2.4.1      2021-01-26 [1] CRAN (R 4.0.2)                     
# xml2          1.3.2      2020-04-23 [1] CRAN (R 4.0.0)
