
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chnaqir

<!-- badges: start -->
<!-- badges: end -->

The goal of chnqir is to calculate Air Quality Index according to
regulations and standards of Ministry of Ecology and Environment of
China.

## Installation

You can install the development version of chnqir like so:

``` r
devtools::install.package("evanliu3594/cnaqir")
```

## CHNAQIR

根据中华人民共和国生态环境部《环境空气质量指数（AQI）技术规定（HJ633—2012）》中的相关标准和方法，提供五个用于计算AQI的函数

### `DaliyMeanConc()`

`DaliyMeanConc()` calculates daily mean concentration of 6 pollutants.
Note that average `O3` concentration for one day is presented by maximum
8-hour average concentration.

> Note: units of $SO_2$, $NO_2$, $PM_10$, $PM_2.5$ and $O_3$ input are
> $μg/m^3$

> unit of $CO$ is $mg/m^3$

``` r
library(chnaqir)

C <- rnorm(24, 35, 5)
DaliyMeanConc("PM2.5", C)
#> [1] 33.55292
```

### `IAQI_hourly()`

`IAQI_hourly()` is for calculate hourly IAQI for a given pollutant

``` r
IAQI_hourly("O3", 142)
#> [1] 44.375
```

### `AQI_Hourly()`

`AQI_Hourly()` calculates the hourly AQI score and the featured
pollutants based on 4 pollutants’ concentration.

``` r
AQI_Hourly(SO2 = 300,NO2 = 200,CO = 100,O3 = 120)
#>       CO 
#> 333.3333
```

### `IAQI_Daily()`

`IAQI_Daily()` calculates daily IAQI for given pollutant

``` r
IAQI_Daily("O3", 142)
#> [1] 85
```

### `AQI_Daily()`

`AQI_Daily()` calculate the daily AQI score and the featured pollutants
based on 6 pollutants’ concentration.

``` r
AQI_Daily(SO2 = 55, NO2 = 23, CO = 12, O3 = 122, PM2.5 = 35, PM10 = 55)
#>  CO 
#> 140
```

### A sample workflow with AQI series functions in `tidyr` syntax.

#### generating sample data

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.1     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors

set.seed(3594)

sampleConc <- data.frame(
  Time = 0:23,
  SO2 = rnorm(24, mean = 300, sd = 20),
  NO2 = rnorm(24, mean = 800, sd = 100),
  O3 = rnorm(24, mean = 50, sd = 15),
  CO = rnorm(24, mean = 25, sd = 10),
  PM2.5 = rnorm(24, mean = 200, sd = 50),
  PM10 = rnorm(24, mean = 350, sd = 100)
)

sampleConc
#>    Time      SO2       NO2       O3        CO    PM2.5     PM10
#> 1     0 282.6336  725.9022 26.81392 31.808906 203.6997 112.8879
#> 2     1 308.5550  882.4118 66.07455 33.801632 243.8070 432.4884
#> 3     2 297.1028  789.9174 31.48264 20.298789 188.1988 372.0612
#> 4     3 313.0599  940.6195 45.81785 37.278949 183.5013 257.4157
#> 5     4 291.9301  831.5420 56.17956 38.267967 149.9136 133.4147
#> 6     5 318.8297  816.8969 57.94609 23.530815 198.9590 362.9265
#> 7     6 285.2910  896.0794 69.18587 22.571036 244.9179 366.0634
#> 8     7 295.5645  777.8727 62.78614 41.581982 230.9641 166.2338
#> 9     8 315.4174  858.6175 66.43275 30.852286 201.4643 378.6020
#> 10    9 321.0564  679.0508 39.26804 28.623032 153.3312 334.5678
#> 11   10 334.9376  946.8561 68.17154 31.063777 290.7204 369.8164
#> 12   11 284.7465  789.9956 68.17813  2.242978 145.1945 340.2189
#> 13   12 332.3311  864.3152 42.35006 15.853442 266.9659 380.3320
#> 14   13 319.5366  612.8492 35.15732 23.514248 203.7449 211.3560
#> 15   14 287.6997  983.9330 81.22990 27.727077 273.1174 254.1899
#> 16   15 316.2936  847.6682 54.26281 19.497845 201.6686 232.9685
#> 17   16 303.5366  951.6857 56.99189 31.199044 154.0529 400.0613
#> 18   17 305.6755  845.5181 56.30190 30.766344 176.0894 370.8452
#> 19   18 302.2794  786.6620 51.27125 26.879688 180.7333 442.5318
#> 20   19 253.9591 1006.0020 49.39657 23.214658 162.1812 400.7118
#> 21   20 329.5264  709.0154 62.83895 34.491416 156.5542 475.9367
#> 22   21 286.5990  775.0531 59.48596 29.028170 221.5060 192.5748
#> 23   22 282.2197  933.5219 44.26432 35.629945 249.4632 363.7812
#> 24   23 272.4587  812.0440 46.08659 30.791025 174.8789 368.5642
```

#### Calculate hourly IAQI

``` r
sampleConc %>% 
  pivot_longer(-Time, names_to = 'Pollu', values_to = 'Conc') %>% rowwise() %>% 
  mutate(IAQI_h = IAQI_hourly(Pollu = Pollu, Conc = Conc)) %>% select(-Conc) %>% 
  pivot_wider(names_from = 'Pollu', values_from = 'IAQI_h')
#> Warning: There were 48 warnings in `mutate()`.
#> The first warning was:
#> ℹ In argument: `IAQI_h = IAQI_hourly(Pollu = Pollu, Conc = Conc)`.
#> ℹ In row 5.
#> Caused by warning in `IAQI_hourly()`:
#> ! PM2.5不是时均IAQI的计算项目
#> ℹ Run ]8;;ide:run:dplyr::last_dplyr_warnings()dplyr::last_dplyr_warnings()]8;; to see the 47 remaining warnings.
#> # A tibble: 24 × 7
#>     Time   SO2   NO2    O3    CO PM2.5  PM10
#>    <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1     0  68.9  153.  8.38  144.   Inf   Inf
#>  2     1  72.7  168. 20.6   148.   Inf   Inf
#>  3     2  71.0  159.  9.84  121.   Inf   Inf
#>  4     3  73.3  174. 14.3   155.   Inf   Inf
#>  5     4  70.3  163. 17.6   157.   Inf   Inf
#>  6     5  74.1  162. 18.1   127.   Inf   Inf
#>  7     6  69.3  170. 21.6   125.   Inf   Inf
#>  8     7  70.8  158. 19.6   163.   Inf   Inf
#>  9     8  73.6  166. 20.8   142.   Inf   Inf
#> 10     9  74.4  148. 12.3   137.   Inf   Inf
#> # ℹ 14 more rows
```

#### Calculate Hourly AQI

``` r
sampleConc %>% rowwise() %>% mutate(
  AQI_h = AQI_Hourly(SO2 = SO2, NO2 = NO2,CO = CO,O3 = O3), .keep = 'none'
)
#> # A tibble: 24 × 1
#> # Rowwise: 
#>    AQI_h
#>    <dbl>
#>  1  153.
#>  2  168.
#>  3  159.
#>  4  174.
#>  5  163.
#>  6  162.
#>  7  170.
#>  8  163.
#>  9  166.
#> 10  148.
#> # ℹ 14 more rows
```

#### Calculate Daily Concentration and daily AQI

``` r
sampleConc_daily_mean <- sampleConc %>% select(-Time) %>% 
  imap_dbl(~DaliyMeanConc(Pollu = .y, Conc = .x))

sampleConc_daily_mean
#>       SO2       NO2        O3        CO     PM2.5      PM10 
#> 301.71833 836.00124  61.01851  27.93813 202.31781 321.68959
```

#### Calculate daily IAQI

``` r
sampleConc_daily_mean %>% imap_dbl(~IAQI_Daily(Pollu = .y, Conc = .x))
#>       SO2       NO2        O3        CO     PM2.5      PM10 
#> 123.34128 445.26381  30.50926 232.81773 252.31781 185.84479
```

#### Calculate Daily AQI

``` r
AQI_Daily(SO2 = sampleConc_daily_mean[["SO2"]],
          NO2 = sampleConc_daily_mean[["NO2"]],
          CO = sampleConc_daily_mean[["CO"]],
          PM10 = sampleConc_daily_mean[["PM10"]],
          PM2.5 = sampleConc_daily_mean[["PM2.5"]],
          O3 = sampleConc_daily_mean[["O3"]])
#>      NO2 
#> 445.2638
```
