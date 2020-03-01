install.packages(c("dplyr", "purrr", "jsonlite", "readr", "remotes", "curl"))
remotes::install_github("yiluheihei/ncovmap")

# From https://github.com/pzhaonet/ncovr/blob/master/R/ncovr.R
conv_time <- function(x){
  as.POSIXct('1970-01-01', tz = 'GMT') + x / 1000
}

unnest_province_ncov <- function(x) {
  p_ncov <- dplyr::select(
    x,
    dplyr::starts_with(c("province", "country", "continent")),
    # -countryShortCode,
    # cityName,
    cities,
    currentConfirmedCount:deadCount,
    updateTime
  )
  
  # no cities data, such as beijing, foregin countries
  if (length(p_ncov$cities[[1]]) == 0) {
    p_ncov$cities <- NULL
    p_ncov$cityEnglishName <- NA
    res <- p_ncov
  } else {
    c_ncov <- p_ncov$cities[[1]]
    # data may be incomplete, not contain locationID
    if ("locationId" %in% names(c_ncov)) {
      c_ncov$locationId <- NULL
    }
    # missing some vars
    c_var <- names(c_ncov)
    if (!"cityName" %in% c_var) {
      stop("City name must be listed in the cities ncov")
    }
    count_names <- c(
      "currentConfirmedCount", "confirmedCount",
      "suspectedCount", "curedCount", "deadCount"
    )
    lack_var <- setdiff(count_names, c_var)
    if (length(lack_var) > 0) {
      for (v in lack_var) {
        c_ncov[[v]] <- NA
      }
    }
    if (!"cityEnglishName" %in% names(c_ncov)) {
      city_name_map <- system.file(
        "china_city_list.csv",
        package = "ncovmap") %>%
        readr::read_csv()
      
      index <-
        match(c_ncov$cityName, city_name_map$City, nomatch = 0) +
        match(c_ncov$cityName, city_name_map$City_Admaster, nomatch = 0)
      
      c_ncov$cityEnglishName <- purrr::map_chr(
        index,
        function(x) ifelse(x == 0, NA, city_name_map$City_EN[x])
      )
    }
    
    p_ncov$cities <- NULL
    p_var <- setdiff(
      names(p_ncov),
      names(c_ncov)
    )
    
    for (v in p_var) {
      c_ncov[[v]] <- p_ncov[[v]]
    }
    
    res <- dplyr::bind_rows(p_ncov, c_ncov)
  }
  
  res
}

#' Download ncov 2019 area data from http://lab.isaaclin.cn/nCoV/, and unnest
#' cities var
get_ncov_area <- function(latest = TRUE) {
  api <- "https://lab.isaaclin.cn/nCoV/api/"
  para <- ifelse(latest, "?latest=1", "?latest=0")
  
  ncov <- jsonlite::fromJSON(paste0(api, "area", para))$results
  ncov$updateTime <- conv_time(ncov$updateTime)
  ncov <- purrr::map_dfr(
    1:nrow(ncov),
    ~ unnest_province_ncov(ncov[.x, ])
  )
  
  ncov
}

ncov_area <- get_ncov_area()
readr::write_csv(ncov_area, "ncov_area.csv")



