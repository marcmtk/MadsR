test_that("Non-empty Data frame from read_mads", {

  df <- read_mads("./data/MADS-like.csv", "analyser")

  expect_is(df, "data.frame")
  expect_gt(length(df)), 0)
  expect_gt(nrow(df), 0)
})
