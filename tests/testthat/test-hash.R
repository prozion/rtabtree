library(r2r)

test_that("hash", {
  expect_identical(
    hashmap(),
    hash())
  expect_identical(
    hashmap(list("a", "1"), list("b", "2")),
    hash("a", "1", "b", "2"))
  expect_identical(
    hashmap(list("a", "1"), list("b", 1:3)),
    hash("a", "1", "b", 1:3))
})

test_that("hash_keys", {
  expect_identical(
    hash_keys(hash("a", 1, "b", 2, "c", 10)),
    c("a", "b", "c"))
})

test_that("hash_values", {
  expect_identical(
    hash_values(hash("a", 1, "b", 2, "c", 10)),
    list(1, 2, 10))
  expect_identical(
    hash_values(hash("a", hash("x", 1, "y", 2), "b", hash("y", 2))),
    list(hash("x", 1, "y", 2), hash("y", 2)))
})

test_that("is_empty_hash", {
  expect_true(is_empty_hash(hash()))
  # expect_false(is_empty_hash(hash("a")))
  expect_false(is_empty_hash(hash("a", 100)))
})

test_that("hash_set", {
  h1 <- hash()
  expect_identical(
    hash_set(h1, "c", "3"),
    hash("c", "3"))
  h2 <- hash("a", "1", "b", "2")
  expect_identical(
    hash_set(h2, "c", "3"),
    hash("a", "1", "b", "2", "c", "3"))
  expect_identical(
    hash_set(h2, "c", 1:3),
    hash("a", "1", "b", "2", "c", c(1L, 2L, 3L)))
})

test_that("hash_delete", {
  h1 <- hash("a", "1", "b", "2", "c", "3")
  expect_identical(
    hash_delete(h1, "b"),
    hash("a", "1", "c", "3"))
  expect_identical(
    hash_delete(h1, c("b", "a")),
    hash("c", "3"))
})

test_that("hash_ref", {
  h1 <- hash("a", 1, "b", "2", "c", 1:3, "d", list(aa = 5, bb = 12))
  expect_identical(hash_ref(h1, "b"), "2")
  expect_identical(hash_ref(h1, "c"), 1:3)
  expect_identical(hash_ref(h1, "d"), list(aa = 5, bb = 12))
  expect_identical(hash_ref(h1, c("a", "c")), list(1, 1:3))
  expect_null(hash_ref(h1, "e"))
  expect_identical(hash_ref(h1, "e", "default"), "default")
  expect_identical(hash_ref(h1, c("a", "u", "e"), 0), list(1, 0, 0))
})

test_that("hash_union mode = keep", {
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", 10, "c", 3)),
                   hash("a", 1, "b", 2, "c", 3))
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", 10, "c", 3),
                      mode = "keep"),
                   hash("a", 1, "b", 2, "c", 3))
})

test_that("hash_union mode = overwrite", {
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", 10, "c", 3),
                      mode = "overwrite"),
                   hash("a", 10, "b", 2, "c", 3))
})

test_that("hash_union mode = exclude", {
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", 10, "c", 3),
                      mode = "exclude"),
                   hash("b", 2, "c", 3))
})

test_that("hash_union mode = merge", {
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", 10, "c", 3),
                      mode = "merge"),
                   hash("a", c(1, 10), "b", 2, "c", 3))
  expect_identical(hash_union(
                      hash("a", 1, "b", 2),
                      hash("a", "10", "c", 3),
                      mode = "merge"),
                   hash("a", list(1, "10"), "b", 2, "c", 3))
  expect_identical(hash_union(
                      hash("a", hash("foo", "bar"), "b", 2),
                      hash("a", hash("quux", 17), "c", 3),
                      mode = "merge"),
                   hash("a", hash("foo", "bar", "quux", 17), "b", 2, "c", 3))
})
