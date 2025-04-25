library(vroom)
library(dplyr)

data.dir <- "C:/Users/xc172/Box/BA952- Finance II/Data"
download_dir <- paste(data.dir, "FDIC_CALL", sep = "/")
data.processed.dir <- "C:/Users/xc172/Box/BA952- Finance II/Data/Data Processed"

data_default <- data.frame()
for (i in 1:23) {
  data <- read.csv(paste0(download_dir, "/data_file(", i, ").csv"))
  data_default <- rbind(data_default, data)
  print(i)
}

data_default <- data_default %>% 
  mutate(year = substr(ID, nchar(ID)-7, nchar(ID)))

download_dir <- paste(data.dir, "FDIC_ID", sep = "/")
data_id <- data.frame()
for (i in 1:23) {
  data <- read.csv(paste0(download_dir, "/data_file(", i, ").csv"))
  data_id <- rbind(data_id, data)
  print(i)
}

data_default_1 <- data_default %>% select(ID, P3AG, P3CI, P9AG, P9CI)
data_id_1 <- data_id %>% select(ID, ACTIVE, RSSDID, OFFDOM, CB)

download_dir <- paste(data.dir, "FDIC_ASSET", sep = "/")
data_asset <- data.frame()
for (i in 1:23) {
  data <- read.csv(paste0(download_dir, "/data_file(", i, ").csv"))
  data_asset <- rbind(data_asset, data)
  print(i)
}

data_asset_1 <- data_asset %>% select(ID, LNAG, LNCI, ASSET)

data_fdic <- left_join(data_default_1, data_id_1)
data_fdic <- left_join(data_fdic, data_asset_1)
data_fdic <- data_fdic %>% filter(is.na(ACTIVE) == FALSE)

saveRDS(data_fdic, paste(data.processed.dir, "3. FDIC_LOAN_MERGE.rds", sep = "/"))




