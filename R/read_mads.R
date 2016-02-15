#' Read MADS output into a dataframe
#'
#' @param file the name of the file to be read from.
#' @param model Which model was the MADS file made with?
#' @keywords MADS read
#' @export

read_mads <- function(file, model){
  if(anyNA(file)) stop("Which file?")
  if(anyNA(model)) stop("You need to specify which extraction model was used for the MADS file")

  if(model=="analyser") {
    read.csv(file, stringsAsFactors = F) %>%
      mutate(afsendt=as.Date(dmy(afsendt)), modtaget=as.Date(dmy(modtaget)), besvaret=as.Date(dmy(besvaret))) %>%
      separate(afsender, c("hospital", "afdeling", "afsnit"), extra="merge", fill="right", remove=F) %>%
      mutate(hospital = ifelse(str_detect(hospital, "^[0-9]+$"), "AP", hospital),
             afdeling = ifelse(str_detect(afdeling, "^[0-9]+$"), "", hospital),
             hosp_afd = paste(hospital, afdeling))
  }
}
