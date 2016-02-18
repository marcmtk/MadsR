#' Filters cases from a MADS dataframe
#'
#' Simplifies counting patients instead of samples
#'
#' @param data a MADS dataframe
#' @param positive a logical vector indicating positive samples
#' @param min.days.to.new.episode Minimum number of days between to episodes for it to be considered a new episode
#' @keywords MADS cases filter
#' @export
#' @import dplyr
#'

filter_cases <- function(data, ..., min.days.to.new.episode=14) {
  if (missing(data)) stop("Specify a MADS dataframe")
  if (!class(min.days.to.new.episode) %in% c("integer", "numeric")) stop("Specify an integer minimum number of days")
  filter(data, ...) %>%
    group_by(cprnr.) %>%
    arrange(afsendt) %>%
    mutate(sl = c(NA, diff(afsendt))) %>%
    filter(is.na(sl) | sl >= min.days.to.new.episode) %>%
    mutate(episode = row_number()) %>%
    ungroup
}

