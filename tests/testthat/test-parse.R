tabtree_test_1 <- parse_tabtree("../fixtures/test_1.tree")

test_that("test_1.tree", {
  expect_identical(
    tabtree_test_1,
    hash(
      "cities", hash("__id", "cities", "__level", "0", "__line", "1"),
      "Moscow", hash(
                  "alt", "Москва",
                  "twin", c("Beijing", "Belgrade", "Berlin"),
                  "year", "1147",
                  "phrase", "Москва не сразу строилась",
                  "__id", "Moscow",
                  "__parent", "cities",
                  "__level", "1",
                  "__line", "2"
                ),
      "Zelenograd", hash(
                  "__id", "Zelenograd",
                  "__parent", "Moscow",
                  "__level", "2",
                  "__line", "3"
                ),
      "Belyaevo", hash(
                  "__id", "Belyaevo",
                  "__parent", "Moscow",
                  "__level", "2",
                  "__line", "4"
                ),
      "Saint-Petersburg", hash(
                  "alt", c("Petrograd", "Leningrad"),
                  "year", "1703",
                  "phrase", "В Питере - пить!",
                  "__id", "Saint-Petersburg",
                  "__parent", "cities",
                  "__level", "1",
                  "__line", "6"
                ),
      "Berlin", hash(
                  "year", "1237",
                  "d", "The capital of Germany",
                  "__id", "Berlin",
                  "__parent", "cities",
                  "__level", "1",
                  "__line", "8"
                ),
      "Grasshopper", hash(
                  "__id", "Grasshopper",
                  "__parent", c("Berlin", "Belyaevo"),
                  "__level", c("3", "2"),
                  "__line", c("5", "9")
                )
    ))
})
