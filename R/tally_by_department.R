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

tally_by_department <- function(data, basis, ..., window="month") {
  if(missing(data)) stop("Specify a MADS dataframe")
  if(missing(basis) | ! basis %in% c("patient", "sample", "case")) stop("Specify a basis, patient, case or sample")
  if(!window %in% c("year", "quarter", "month", "week")) stop("Specify a window, either year, quarter, month or week")

  if(window != "year") {
    skeleton <- tidyr::expand_(data, c(~hosp_afd, lazyeval::interp(~tidyr::nesting(year, window), window=as.name(window))))
  } else {
    skeleton <- tidyr::expand_(data, c(~hosp_afd, ~year))
  }
  window_count <- function(data) count_(data, c(~hosp_afd, ~year, lazyeval::interp(~w, w=as.name(window))))

  ligaments <- function() left_join(skeleton, Positive) %>%
    left_join(Negative) %>%
    tidyr::replace_na(list(Positive=0, Negative=0)) %>%
    tidyr::gather(Result, n, Positive, Negative)

  if(basis == "patient") {
    patients <- filter_cases(data, ...) %>% filter(episode==1)
    Positive <- window_count(patients) %>% rename(Positive=n)
    Negative <- filter(data, ! cprnr. %in% unique(patients$cprnr.)) %>%
      window_count %>%
      rename(Negative=n)
    output <- ligaments()


  } else if(basis == "sample") {
    Negative_indices <- !1:nrow(data) %in% (mutate(data, row=row_number()) %>% filter(...) %>% select(row) %>% .$row)
    Positive <- filter(data, ...) %>% window_count %>% rename(Positive=n)
    Negative <- data[Negative_indices,] %>% window_count %>% rename(Negative=n)
    output <- ligaments()

  } else if(basis == "case") { #Case differs from patient by allowing a positive patient with multiple episodes to be counted multiple times
    cases <- filter_cases(data, ...)
    Positive <- window_count(cases) %>% rename(Positive=n)
    Negative <- filter(data, ! cprnr. %in% unique(cases$cprnr.)) %>%
      window_count %>%
      rename(Negative=n)
    output <- ligaments()
  }
  output
}
