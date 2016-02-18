#' Tally positive and negative cases by department
#'
#' Patient count: counts such that any patient which one positive test will be counted as positive
#'
#' Sample count: counts individual samples
#'
#' @param data a MADS dataframe
#' @param basis Two bases: "Patient" which counts by patient, such that any patient with one positive test will be counted as positive. "Sample": Samples are counted individually
#' @param positive a logical vector indicating positive samples
#' @keywords MADS tally count
#' @export
#' @import dplyr
#'

tally_by_department <- function(data, basis, ...) {
  if(missing(data)) stop("Specify a MADS dataframe")
  if(missing(basis) | ! basis %in% c("patient", "sample", "case")) stop("Specify a basis, patient, case or sample")
  #if(class(positive) != "logical") stop("Specify a logical vector indicating positive samples")

  if(basis == "patient") {

    data %>% group_by(hospital, afdeling, indicator) %>% distinct(cprnr.) %>% count


  } else if(basis == "sample") {
    Positive <- count(data[positive, ], hosp_afd)
    Negative <- count(data[!positve, ], hosp_afd)
    output <- full_join(Positive, Negative)
  } else if(basis == "case") { #Case differs from patient by allowing a positive patient with multiple episodes to be counted multiple times
    cases <- filter_cases(data, ...)
    skeleton <- tidyr::expand(data, hosp_afd, year, month)
    Positive <- count(cases, hosp_afd, year, month) %>% rename(Positive=n)
    Negative <- filter(data, ! cprnr. %in% unique(cases$cprnr.)) %>%
      count(hosp_afd, year, month) %>%
      rename(Negative=n)
    output <- left_join(skeleton, Positive) %>%
      left_join(Negative) %>%
      tidyr::replace_na(list(Positive=0, Negative=0)) %>%
      tidyr::gather(Result, n, Positive, Negative)
  }
  output
}
