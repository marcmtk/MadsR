#' Generating random MADS-like data
#'
#' Outputs a randomly generated dataframe of MADS-like data into ./data/MADS-like.csv.
#' Probably only useful for testing.

generate_MADS_like_data <- function() {
  df <- data.frame(cprnr.=sample.int(350, 1000, replace=T),
                 navn=NA,
                 afsendt=format(as.Date("2012-01-01") + runif(1000,0,700), "%d%m%Y"),
                 modtaget=NA,
                 besvaret=NA,
                 afsender=sample(c(paste(sample(c("O", "S"), 700, replace=T), sample(LETTERS, 700, replace =T)),
                                   sprintf("%05d", sample.int(50000, 300, replace=F))), 1000, replace=F),
                 result=sample(c("Negativ", "Positiv"), 1000, replace=T, prob=c(0.9,0.1)))
write.csv(df, "./data/MADS-like.csv", row.names = F)
}
