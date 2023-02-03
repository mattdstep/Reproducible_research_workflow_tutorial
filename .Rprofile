.First <- function() {
  dir.create(paste0(getwd(), "/00-metadata"), showWarnings = F)
  dir.create(paste0(getwd(), "/01-data-raw"), showWarnings = F)
  dir.create(paste0(getwd(), "/02-data-processed"), showWarnings = F)
  dir.create(paste0(getwd(), "/03-analysis-scripts"), showWarnings = F)
  dir.create(paste0(getwd(), "/04-analysis-products"), showWarnings = F)
  dir.create(paste0(getwd(), "/05-manuscript"), showWarnings = F)
  
  if (!("renv" %in% list.files())) {
    renv::init()
  } else {
    source("renv/activate.R")
  }
  
  cat("\nWelcome to your R-Project:", basename(getwd()), "\n")
}