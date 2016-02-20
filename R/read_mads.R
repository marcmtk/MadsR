#' Read MADS output into a dataframe
#'
#' @param file the name of the file to be read from.
#' @param model Which model was the MADS file made with?
#' @keywords MADS read
#' @export
#' @import dplyr

read_mads <- function(file, model){
  if(anyNA(file)) stop("Which file?")
  if(anyNA(model)) stop("You need to specify which extraction model was used for the MADS file")

  if(model=="analyser") {
    read.csv(file, stringsAsFactors = F) %>%
      mutate(afsendt=as.Date(lubridate::dmy(afsendt)),
             modtaget=as.Date(lubridate::dmy(modtaget)),
             besvaret=as.Date(lubridate::dmy(besvaret)),
             year=lubridate::year(afsendt),
             quarter=lubridate::quarter(afsendt),
             month=lubridate::month(afsendt, label=T, abbr=F),
             week=lubridate::week(afsendt),
             weekday=lubridate::wday(afsendt, label=T, abbr=F)) %>%
      tidyr::separate(afsender, c("hospital", "afdeling", "afsnit"), extra="merge", fill="right", remove=F) %>%
      mutate(hospital = ifelse(stringr::str_detect(afsender, "^[0-9]+$"), "AP", hospital),
             afdeling = ifelse(stringr::str_detect(afsender, "^[0-9]+$"), "", afdeling),
             hosp_afd = paste(hospital, afdeling))
  }
}
