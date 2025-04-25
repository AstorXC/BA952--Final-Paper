library(httr)


data.dir <- "C:/Users/xc172/Box/BA952- Finance II/Data"
download_dir <- paste(data.dir, "CRA_LOAN", sep = "/")
dir.create(download_dir, showWarnings = FALSE, recursive = TRUE)

years <- 2023:1996
types <- c("trans", "aggr", "discl")

for (year in years) {
  for (type in types) {
    # url
    short_year <- substr(year, 3, 4)
    url <- paste0("https://www.ffiec.gov/sites/default/files/data/cra/flat-files/", short_year, "exp_", type, ".zip")
    
    # save as zip
    file_name <- paste0(year, "_", type, ".zip")
    dest_path <- file.path(download_dir, file_name)
    
    # downloading
    res <- GET(
      url,
      write_disk(dest_path, overwrite = TRUE),
      add_headers("User-Agent" = "Mozilla/5.0")
    )
    
 
  }
}


