#' Generating resistances by bacterium
#'
#' Takes a vector of bacterial names, outputs a dataframe of simulated resistances
#' Intended for use with generate_MADS_like_data, specifically in the species+res model
#' @param bakterier a vector of bacterial names.
#' @export

generate_res <- function(bakterier) {
  if (any(
    !bakterier %in% c(
      "E. coli",
      "Klebsiella pneumoniae",
      "Proteus mirabilis",
      "Citrobacter freundii",
      "Enterobacter cloacae"
    )
  ))
    stop("Unknown organism in call")
  generate_res_by_species <- function(bakterie) {
    if (bakterie %in% c("E. coli", "Proteus mirabilis")) {
      AMP.SIR <- sample(c("S", "R"), 1, prob = c(0.52, 0.48))
      CXM.SIR <- sample(c("S", "R"), 1, prob = c(0.91, 0.09))
      CIP.SIR <- sample(c("S", "R"), 1, prob = c(0.86, 0.14))
      MEC.SIR <- sample(c("S", "R"), 1, prob = c(0.90, 0.10))
    } else if (bakterie %in% c("Citrobacter freundii", "Enterobacter cloacae")) {
      AMP.SIR <- sample(c("S", "R"), 1, prob = c(0.00, 1.00))
      CXM.SIR <- sample(c("S", "R"), 1, prob = c(0.00, 1.00))
      CIP.SIR <- sample(c("S", "R"), 1, prob = c(0.86, 0.14))
      MEC.SIR <- sample(c("S", "R"), 1, prob = c(0.90, 0.10))
    } else if (bakterie == "Klebsiella pneumoniae") {
      AMP.SIR <- sample(c("S", "R"), 1, prob = c(0.00, 1.00))
      CXM.SIR <- sample(c("S", "R"), 1, prob = c(0.86, 0.14))
      CIP.SIR <- sample(c("S", "R"), 1, prob = c(0.88, 0.12))
      MEC.SIR <- sample(c("S", "R"), 1, prob = c(0.88, 0.12))
    }
    data.frame(AMP.SIR, CXM.SIR, CIP.SIR, MEC.SIR, stringsAsFactors = F)
  }
  df <- do.call("rbind", lapply(bakterier, generate_res_by_species))
  colnames(df) <- c("AMP.SIR", "CXM.SIR", "CIP.SIR", "MEC.SIR")
  df
}
