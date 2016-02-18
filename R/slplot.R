#' Provide a "since last new case" plot
#'
#' Counts on a patient, not a sample, basis.
#'
#' @param sldata a "since last new case" dataframe
#' @keywords MADS since last plot
#' @export
#' @import ggplot2
#'

slplot <- function(sldata) {
  ggplot(sldata, aes(afsendt, sl)) + geom_point() + geom_smooth() +
    scale_x_date(breaks = scales::date_breaks("months")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(x = "", y = "Days since last new case")
}
