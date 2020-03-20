install.packages("remotes")
remotes::install_github("yiluheihei/ncovmap")

ncov <- ncovmap::get_ncov2(method = "api", latest = FALSE)
ncov_latest <- ncovmap::get_ncov2(method = "api", latest = TRUE)
saveRDS(ncov_latest, "ncov_latest.RDS")
saveRDS(ncov, "ncov.RDS")
readr::write_csv(data.frame(ncov), path = "ncov.csv")
readr::write_csv(data.frame(ncov_latest), path = "ncov_latest.csv")

