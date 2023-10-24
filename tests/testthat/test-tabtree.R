# library(purrr)
# library(magrittr)

tabtree1 <- hash("a", hash("a1", 1, "b2", 2), "b", hash("b1", 3, "b4", 4))

test_that("id", {
  expect_identical(id(hash("__id", "foo", "a", 3)), "foo")
  expect_null(tabtree1 |> hash_ref("a") |> id())
})

test_that("item_by_id", {
  expect_identical(item_by_id(tabtree1, "b"), hash("b1", 3, "b4", 4))
  expect_identical(item_by_id(tabtree1, "c"), hash())
})

test_that("map_tabtree", {
  expect_identical(
    tabtree1 |>
      map_tabtree(
        function(k, item) {
          hash_union(item, hash("__id", "id123", "a1", 100), mode = "overwrite")
        }),
    hash("a", hash("a1", 100, "b2", 2, "__id", "id123"), "b", hash("b1", 3, "b4", 4, "a1", 100, "__id", "id123")))
})

test_that("filter_tabtree", {
  expect_identical(
    filter_tabtree(
      tabtree1,
      function(k, item) {
        (hash_values(item) |> unlist() |> sum()) > 3
      }),
    hash("b", hash("b1", 3, "b4", 4)))
})

test_that("filter_not_tabtree", {
  expect_identical(
    filter_not_tabtree(
      tabtree1,
      function(k, item) {
        (hash_values(item) |> unlist() |> sum()) > 3
      }),
    hash("a", hash("a1", 1, "b2", 2)))
})

test_that("reduce_tabtree", {
  expect_identical(
    reduce_tabtree(
      tabtree1,
      function(acc, k, item) {
        acc + ( item |> hash_values() |> remove_na() |> as.double() |> sum() )
      },
      0),
    10)
})
