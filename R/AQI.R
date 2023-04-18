#' Calculate daily mean concentration of 6 pollutants
#'
#' @param Pollu name of pollutants now supports `SO2`, `NO2`, `CO`, `PM2.5`, `PM10` and `O3`
#' @param Conc a 24-long vector of hourly average concentrations
#'
#' @return a number of daily mean concentration of 6 pollutants in which `O3` is calculated by maximum 8-hour average
#' @importFrom zoo rollapply
#' @export
#'
#' @examples
#' C <- rnorm(24, 35, 5)
#' DaliyMeanConc("PM2.5", C)
DaliyMeanConc <- function(Pollu, Conc) {
  if (length(Conc) < 24)
    warning("请提供完整的每日24小时监测值！")
  else if (length(Conc) > 24)
    warning("请提供仅单日的24小时监测值！")
  else if (Pollu == "O3")
    return(max(rollapply(Conc, 8, mean, partial = TRUE, align = 'right')))
  else return(mean(Conc))
}


#' Calculate hourly IAQI for given pollutant
#'
#' @param Pollu name of pollutants now supports `SO2`, `NO2`, `CO`, and `O3`.
#' @param Conc a number of hourly mean concentration of the pollutant.
#'
#' @return the hourly IAQI index score of the give pollutant.
#' @importFrom utils head
#' @importFrom utils tail
#' @export
#'
#' @examples
#' IAQI_hourly("O3", 142)
IAQI_hourly <- function(Pollu, Conc){

  if (Pollu %in% c("PM2.5", "PM25", "PM10")) {
    warning(paste(Pollu, "不是时均IAQI的计算项目",sep = ''))
    return(Inf)
  } else{
    AQI_table <- list(
      AQI = c(0,  50, 100, 150,  200,  300,  400,  500, Inf),
      SO2 = c(0, 150, 500, 650,  800, Inf),
      NO2 = c(0, 100, 200, 700, 1200, 2340, 3090, 3840, Inf),
      CO =  c(0,   5,  10,  35,   60,   90,  120,  150, Inf),
      O3 =  c(0, 160, 200, 400,  800, 1000, 1200,  Inf)
    )

    i_min <- AQI_table[[Pollu]][which(AQI_table[[Pollu]] < Conc) %>% tail(1)]
    i_max <- AQI_table[[Pollu]][which(AQI_table[[Pollu]] >= Conc) %>% head(1)]

    a_min <- AQI_table[["AQI"]][which(AQI_table[[Pollu]] < Conc) %>% tail(1)]
    a_max <- AQI_table[["AQI"]][which(AQI_table[[Pollu]] >= Conc) %>% head(1)]

    if (i_max == Inf) return(Inf)
    else return(a_min + (a_max - a_min) * (Conc - i_min) / (i_max - i_min))
  }
}

#' Calculate the hourly AQI score and the featured pollutants based on 4 pollutants' concentration
#'
#' @param SO2 hourly concentration of `SO2`, μg/m3
#' @param NO2 hourly concentration of `NO2`, μg/m3
#' @param CO hourly concentration of `CO`, mg/m3
#' @param O3 hourly concentration of `O3`, μg/m3
#'
#' @return a named number of the hourly AQI score, the name is the featured pollutant
#' @export
#'
#' @examples
#' Calc_Hourly_AQI(SO2 = 55, NO2 = 23, CO = 140, O3 = 122)
Calc_Hourly_AQI <- function(SO2, NO2, CO, O3){

  IAQIs <- c(
    SO2 = IAQI_hourly("SO2",SO2),
    NO2 = IAQI_hourly("NO2",NO2),
    CO = IAQI_hourly("CO",CO),
    O3 = IAQI_hourly("O3",O3)
  )

  return(IAQIs[which.max(IAQIs)])
}


#' Calculate daily IAQI for given pollutant
#'
#' @param Pollu name of pollutants now supports `SO2`, `NO2`, `CO`, `O3`, `PM2.5` and `PM10`.
#' @param Conc a number of daily mean concentration of the pollutant.
#'
#' @return the daily IAQI index score of the give pollutant.
#' @export
#'
#' @examples
#' IAQI_Daily("O3", 142)
#'
IAQI_Daily <- function(Pollu, Conc) {

  AQI_table <- list(
    AQI =   c(0,  50, 100, 150, 200,  300,  400,  500, Inf),
    SO2 =   c(0,  50, 150, 475, 800, 1600, 2100, 2620, Inf),
    NO2 =   c(0,  40,  80, 180, 280,  565,  750,  940, Inf),
    O3 =    c(0, 100, 160, 215, 265,  800,  Inf),
    CO =    c(0,   2,   4,  14,  24,   36,   48,   60, Inf),
    PM10 =  c(0,  50, 150, 250, 350,  420,  500,  600, Inf),
    PM2.5 = c(0,  35,  75, 115, 150,  250,  350,  500, Inf)
  )

  i_min <- AQI_table[[Pollu]][which(AQI_table[[Pollu]] < Conc) |> tail(1)]
  i_max <- AQI_table[[Pollu]][which(AQI_table[[Pollu]] >= Conc) |> head(1)]

  a_min <- AQI_table[["AQI"]][which(AQI_table[[Pollu]] < Conc) |> tail(1)]
  a_max <- AQI_table[["AQI"]][which(AQI_table[[Pollu]] >= Conc) |> head(1)]

  if (i_max == Inf) return(Inf)
  else return(a_min + (a_max - a_min) * (Conc - i_min) / (i_max - i_min))

}

#' Calculate the daily AQI score and the featured pollutants based on 6 pollutants' concentration
#'
#' @param SO2 daily concentration of `SO2`, μg/m3
#' @param NO2 daily concentration of `NO2`, μg/m3
#' @param CO daily concentration of `CO`, mg/m3
#' @param O3 daily concentration of `O3`, μg/m3
#' @param PM10 daily concentration of `PM10`, μg/m3
#' @param PM2.5 daily concentration of `PM2.5`, μg/m3
#'
#' @return a named number of the daily AQI score, the name is the featured pollutant
#' @export
#'
#' @examples
#' Calc_Daily_AQI(SO2 = 55, NO2 = 23, CO = 12, O3 = 122, PM2.5 = 35, PM10 = 55)
Calc_Daily_AQI <- function(SO2,NO2,CO,PM10,PM2.5,O3){
  IAQIs <- c(
    SO2 = IAQI_Daily("SO2",SO2),
    NO2 = IAQI_Daily("NO2",NO2),
    CO = IAQI_Daily("CO",CO),
    PM10 = IAQI_Daily("PM10",PM10),
    PM2.5 = IAQI_Daily("PM2.5",PM2.5),
    O3 = IAQI_Daily("O3",O3)
  )

  return(IAQIs[which.max(IAQIs)])
}
