#' Create a heatmap, intented for use with tally_by_department
#'
#' A convenience function that provides access to a specific ggplot
#'
#' @param data a dataframe to be plotted, expects values hosp_afd and either month or week
#' @param ... used for providing a window, either month or week, defaults to month
#' @keywords MADS tally count heatmap
#' @export
#' @import ggplot2
#'

tally_map <- function(data) {
  if(missing(data) | !is.data.frame(data)) stop("Crashed and burned")
  ggplot(data, aes_(~hosp_afd, lazyeval::interp(~w, w=as.name(colnames(data[,3]))), fill=~n)) +
  geom_tile() + coord_equal() + viridis::scale_fill_viridis(name="# Events", option="inferno")
}

