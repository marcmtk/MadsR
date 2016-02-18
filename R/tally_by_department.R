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
#'

tally_by_department <- function(data, basis, indicator, window="month") {
  if(is.na(data)) stop("Specify a MADS dataframe")
  if(is.na(basis) | ! basis %in% c("patient","sample")) stop("Specify a basis, patient or sample")
  if(class(positive) != "logical") stop("Specify a logical vector indicating positive samples")

  if(basis == "patient") {

    data %>% group_by(hospital, afdeling, indicator) %>% distinct(cprnr.) %>% count


  } else if(basis == "sample") {
    pos <- count(data[positive, ], hosp_afd)
    neg <- count(data[!positve, ], hosp_afd)
    output <- full_join(pos, neg)
  }
  output
}
