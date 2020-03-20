install.packages("remotes")
remotes::install_github("yiluheihei/ncovmap")

ncov <- ncovmap::get_ncov2(method = "api", latest = FALSE)
ncov_latest <- ncovmap::get_ncov2(method = "api", latest = TRUE)
saveRDS(ncov_latest, "ncov_latest.RDS")
saveRDS(ncov, "ncov.RDS")

