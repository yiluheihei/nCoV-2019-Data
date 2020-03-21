install.packages("remotes")
remotes::install_github("tidyverse/dplyr")
install.packages(c("purrr", "jsonlite", "readr"))
install.packages("curl")
library(dplyr)

# from https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}

#' Download ncov 2019 data from
#' https://github.com/BlankerL/DXY-COVID-19-Data/ (csv) or
#' https://github.com/yiluheihei/nCoV-2019-Data (RDS)
#'
#' @param latest logical, download the latest or all time-series ncov data,
#' default \code{TRUE}
#' @param method character
#'
#' @export
get_ncov2 <- function(latest = TRUE, method = c("ncov", "api")) {
  method <- match.arg(method)
  from <- ifelse(
    method == "ncov",
    "https://github.com/yiluheihei/nCoV-2019-Data",
    "https://github.com/BlankerL/DXY-COVID-19-Data"
  )
  
  if (method == "ncov") {
    file <- ifelse(latest, "ncov_latest.RDS", "ncov.RDS")
    ncov <- readRDS(gzcon(url(file.path(from, "raw", "master", file))))
  } else {
    if (latest) {
      ncov <- jsonlite::fromJSON(
        file.path(from, "raw", "master", "json", "DXYArea.json")
      )
      ncov <- ncov$results
      
      # unnest cities
      ncov <- purrr::map_df(
        1:nrow(ncov),
        ~ unnest_province_ncov(ncov[.x, ])
      )
    } else {
      file <- "DXYArea.csv"
      ncov <- readr::read_csv(file.path(from, "raw", "master", "csv", file))
    }
  }
  
  ncov <- structure(
    ncov,
    class = c("ncov", "data.frame"),
    type = "All",
    from = from
  )
  
  ncov
}


# unnest the cities data, keep inconsistent with csv data in
# https://github.com/BlankerL/DXY-COVID-19-Data
unnest_province_ncov <- function(x) {
  counts_vars <- c(
    "confirmedCount", "suspectedCount",
    "curedCount", "deadCount"
  )
  
  province_dat <- select(
    x,
    continentName:countryEnglishName,
    provinceName, provinceEnglishName,
    province_zipCode = locationId,
    one_of(counts_vars)
  )
  # rename province count
  province_dat <- rename_with(
    province_dat,
    ~ paste0("province_", .x),
    one_of(counts_vars)
  )
  
  # no cities data, such as taiwan, foregin countries
  if (length(x$cities[[1]]) == 0) {
    city_vars <- c(
      "cityName", "cityEnglishName",
      paste0("city_", counts_vars)
    )
    province_dat[city_vars] <- NA
    province_dat$city_zipCode <- NA
    province_dat$updateTime <- conv_time(x$updateTime)
    
    return(province_dat)
  } else {
    c_ncov <- x$cities[[1]]
    
    city_dat <-select(
      c_ncov,
      cityName, cityEnglishName,
      one_of(counts_vars)
    ) %>%
      rename_with(~ paste0("city_", .x), one_of(counts_vars))
    
    city_dat$city_zipCode <- c_ncov$locationId
    city_dat$updateTime <- conv_time(x$updateTime)
    
    unnest_cities_dat <- bind_cols(province_dat, city_dat)
  }
  
  unnest_cities_dat
}

ncov <- get_ncov2(method = "api", latest = FALSE)
ncov_latest <- get_ncov2(method = "api", latest = TRUE)
saveRDS(ncov_latest, "ncov_latest.RDS")
saveRDS(ncov, "ncov.RDS")
readr::write_csv(data.frame(ncov), path = "ncov.csv")
readr::write_csv(data.frame(ncov_latest), path = "ncov_latest.csv")

