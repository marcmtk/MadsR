#' Generating random MADS-like data
#'
#' Outputs a randomly generated dataframe of MADS-like data into ./data/MADS-like.csv.
#' Probably only useful for testing.
#' @param model either \code{analyser} or \code{species+res}
#' @export

generate_MADS_like_data <- function(model = "analyser") {
  if(missing(model) | !model %in% c("analyser", "species+res")) stop("At present, there are two valid models, 'analyser' and 'species+res'")
  set.seed(1456333505)
  if (model == "analyser") {
    df <- data.frame(
      cprnr. = sample.int(350, 1000, replace = T),
      navn = NA,
      afsendt = format(as.Date("2012-01-01") + runif(1000, 0, 700), "%d%m%Y"),
      modtaget = NA,
      besvaret = NA,
      afsender = sample(c(
        paste(sample(c("O", "S"), 700, replace = T),
              sample(LETTERS, 700, replace = T)),
        sprintf("%05d", sample.int(50000, 300, replace = F))
      ), 1000, replace = F),
      result = sample(
        c("Negativ", "Positiv"),
        1000,
        replace = T,
        prob = c(0.9, 0.1)
      )
    )
    write.csv(df, "./data/analyser-like.csv", row.names = F)
  } else if (model == "species+res") {
    df <- data.frame(
      cprnr. = sample.int(350, 1000, replace = T),
      navn = NA,
      afsendt = format(as.Date("2012-01-01") + runif(1000, 0, 700), "%d%m%Y"),
      modtaget = NA,
      besvaret = NA,
      afsender = sample(c(
        paste(sample(c("O", "S"), 700, replace = T), sample(LETTERS, 700, replace = T)),
        sprintf("%05d", sample.int(50000, 300, replace = F))
      ), 1000, replace = F),
      Bakterie = sample(
        c("E. coli", "Klebsiella pneumoniae", "Proteus mirabilis", "Citrobacter freundii", "Enterobacter cloacae"),
        1000,
        replace = T,
        prob = c(0.4, 0.15, 0.1, 0.15, 0.2)
      )
    )
    df <- cbind(df, generate_res(df$Bakterie))
    write.csv(df, "./data/species-like.csv", row.names = F)
  }
}
