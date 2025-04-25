library(vroom)
library(dplyr)

data.dir <- "C:/Users/xc172/Box/BA952- Finance II/Data"
download_dir <- paste(data.dir, "CRA_LOAN", sep = "/")
data.processed.dir <- "C:/Users/xc172/Box/BA952- Finance II/Data/Data Processed"

# disclose data --------------------------------


for (year in 1996:2023) {
  unzip(paste0(download_dir, "/discl/", year, "_discl.zip"), # the zipped file
        exdir = paste0(download_dir, "/discl/", year))   # direction to save the extracted doc
  print(year)
}



for (year in 1997:2015) {
  data_path <- paste0(download_dir, "/discl/", year)
  file_path <- list.files(path = data_path, pattern = "\\.dat$", full.name = TRUE)
  data <- read.delim(file_path, header = FALSE)
  
  data <- vroom_fwf(file_path, fwf_widths(c(5, 10, 1, 4, 1, 
                                            1, 2, 3, 4, 4, 
                                            1, 1, 1, 3, 3, 
                                            6, 8, 6, 8, 6, 
                                            8, 6, 8, 6, 8)),
                    col_types = cols(.default = "c"))
  
  
  names(data) <- c("TableID", "RespondentID", "AgencyCode", "ActivityYear", "LoanType",
                   "ActionTakenType", "State", "County", "MSA_MD", "AssessmentAreaNumber",
                   "PartialCountyIndicator", "SplitCountyIndicator", "PopulaitonClassification",
                   "IncomeGroupTotal", "ReportLevel",
                   "NumLnBelow100k","AmtLnBelow100k",
                   "NumLnBelow250k","AmtLnBelow250k",
                   "NumLnBelow1m","AmtLnBelow1m",
                   "NumLnRevBelow1m","AmtLnRevBelow1m",
                   "NumLnAff","AmtLnAff")

  saveRDS(data, paste0(download_dir, "/discl/", year, ".rds"))
  print(year)
  
}


for (year in 2017:2023) {
  data_path <- paste0(download_dir, "/discl/", year)
  file_path <- list.files(path = data_path, pattern = "\\.dat$", full.name = TRUE)
  
  data_merge <- data.frame()
  for (i in 1:length(file_path)) {

    data <- vroom_fwf(file_path[i], fwf_widths(c(5, 10, 1, 4, 1, 
                                              1, 2, 3, 5, 4, 
                                              1, 1, 1, 3, 3, 
                                              10, 10, 10, 10, 10, 
                                              10, 10, 10, 10, 10)),
                      col_types = cols(.default = "c"))
    
    
    names(data) <- c("TableID", "RespondentID", "AgencyCode", "ActivityYear", "LoanType",
                     "ActionTakenType", "State", "County", "MSA_MD", "AssessmentAreaNumber",
                     "PartialCountyIndicator", "SplitCountyIndicator", "PopulaitonClassification",
                     "IncomeGroupTotal", "ReportLevel",
                     "NumLnBelow100k","AmtLnBelow100k",
                     "NumLnBelow250k","AmtLnBelow250k",
                     "NumLnBelow1m","AmtLnBelow1m",
                     "NumLnRevBelow1m","AmtLnRevBelow1m",
                     "NumLnAff","AmtLnAff")
    data_merge <- rbind(data_merge, data)
  }
  saveRDS(data_merge, paste0(download_dir, "/discl/", year, ".rds"))
  print(year)
  
}


data$value <- iconv(data$value, from = "", to = "UTF-8", sub = "byte")

county_data <- data.frame()

for (year in 1997:2023) {
  data <- readRDS(paste0(download_dir, "/discl/", year, ".rds"))
  data <- data %>% filter(TableID %in% c("D1-1", "D1-2", "D2-1", "D2-2"))
  data <- data %>% filter(is.na(State) == FALSE) # because if it is NA, then it is the asset across all states
  data <- data %>% filter(is.na(County) == FALSE) # same reason as previous
  data <- data %>% filter(ReportLevel == "040")
  county_data <- rbind(county_data, data)
  print(year)
}

saveRDS(county_data, paste(data.processed.dir, "2. CRA_LOAN_MERGE.rds", sep = "/"))
