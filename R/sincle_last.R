#' Provide a "since last new case" plot
#'
#' Counts on a patient, not a sample, basis.
#'
#' @param data a MADS dataframe
#' @param basis Two bases: "Patient" which counts by patient, such that any patient with one positive test will be counted as positive. "Sample": Samples are counted individually
#' @param positive a logical vector indicating positive samples
#' @keywords MADS tally count
#' @export
#'
since_last <- function(data, positive, min.days.to.new.episode=14, plot=F) {
  if(missing(data)) stop("Specify a MADS dataframe")
  if(class(positive) != "logical") stop("Specify a logical vector indicating positive samples")

  sl <- data[positive,] %>% group_by(cprnr.) %>% arrange(afsendt) %>%
    mutate(sl=c(NA, diff(afsendt))) %>% #Per case difference - correction for multiple positive samples
    filter(is.na(sl) | sl > min.days.to.new.episode) %>%
    ungroup() %>%
    arrange(afsendt) %>%
    mutate(sl=c(NA, diff(afsendt))) #Difference between any new cases
  if(plot) {
    ggplot(sl, aes(afsendt, sl)) + geom_point() + geom_smooth() +
      scale_x_date(breaks = date_breaks("months")) +
      theme(axis.text.x = element_text(angle=45, hjust=1)) +
      labs(x = "", y="Days since last new case")
  }
}
