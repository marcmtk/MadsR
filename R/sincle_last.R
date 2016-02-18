#' Provide a "since last new case" dataframe
#'
#' Counts on a patient, not a sample, basis.
#'
#' @param data a MADS dataframe
#' @param positive a logical vector indicating positive samples
#' @param min.days.to.new.episode Minimum number of days between to episodes for it to be considered a new episode
#' @keywords MADS since last
#' @export
#' @import dplyr
#'
since_last <- function (data) {
  if (missing(data)) stop("Specify a MADS dataframe of cases")
  data %>%
    arrange(afsendt) %>%
    mutate(sl = c(NA, diff(afsendt)))
}
