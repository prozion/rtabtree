break_into_pairs <- function(v) {
  if (length(v) == 0) {
    list()
  }
  else if (length(v) == 1) {
    list(v[[1]], NA)
  }
  else {
    c(list(list(v[[1]], v[[2]])), break_into_pairs(v[c(-1, -2)]))
    }
}

is_hash <- function(h) {
  "r2r_hashmap" %in% class(h)
}

#' @export
is_empty_hash <- function(h) {
  length(hash_keys(h)) == 0
}

#' @export
hash <- function(...) {
  h <- do.call(r2r::hashmap, break_into_pairs(list(...)))
  r2r::on_missing_key(h) <- "default"
  h
}

#' @export
hash_keys <- function(h) {
  h |> r2r::keys() |> unlist()
}

#' @export
hash_values <- function(h) {
  h |> r2r::values()
}

#' @export
hash_set <- function(h, k, v) {
  if (is.null(v)) {
    h
  } else {
    r2r::insert(h, k, v)
    h
  }
}

#' @export
hash_delete <- function(h, ks) {
  if (length(ks) > 1) {
    new_h <- h
    r2r::delete(new_h, ks[[1]])
    hash_delete(new_h, ks[-1])
  }
  else {
    r2r::delete(h, ks)
    h
  }
}

#' @export
# "In statistical data sets, we often encounter missing data, which we represent in R with the value NA. NULL, on the other hand, represents that the value in question simply doesn’t exist, rather than being existent but unknown." - The Art of R Programming
hash_ref <- function(h, ks, default_value = NULL) {
  default(h) <- default_value
  if (length(ks) > 1) {
    h[ks]
  } else {
    h[[ks]]
  }
}

merge <- function(v1, v2, mode = "keep") {
  if(is_hash(v1) && is_hash(v2)) {
    hash_union(v1, v2, mode)
  } else if(typeof(v1) == typeof(v2)) {
    if(v1 == v2) {
      v1
    } else {
      c(v1, v2)
    }
  } else {
    list(v1, v2)
  }
}

#' @export
hash_union <- function(h1, h2, mode = "keep") {
  keys1 <- hash_keys(h1)
  keys2 <- hash_keys(h2)
  switch(mode,
    keep = {
              keys2_uni <- setdiff(keys2, keys1)
              res <- h1
              for (k in keys2_uni) {
                res = hash_set(res, k, hash_ref(h2, k))
              }
              res
           },
    overwrite = {
              keys1_uni <- setdiff(keys1, keys2)
              res <- h2
              for (k in keys1_uni) {
                res = hash_set(res, k, hash_ref(h1, k))
              }
              res
           },
    exclude = {
              keys1_uni <- setdiff(keys1, keys2)
              keys2_uni <- setdiff(keys2, keys1)
              res <- hash()
              for (k in keys1_uni) {
                res = hash_set(res, k, hash_ref(h1, k))
              }
              for (k in keys2_uni) {
                res = hash_set(res, k, hash_ref(h2, k))
              }
              res
           },
    merge = {
              res <- hash_union(h1, h2, mode = "exclude")
              keys12 <- intersect(keys1, keys2)
              for (k in keys12) {
                res = hash_set(res, k, merge(hash_ref(h1, k), hash_ref(h2, k), mode))
              }
              res
           }
  )
}

hash_str <- function(h, kv_sep = " => ", sep = ", ", left_sep = "( ", right_sep = " )") {
  res = left_sep;
  for(k in hash_keys(h)) {
    v = hash_ref(h, k)
    res = sprintf("%s%s%s%s%s",
                  res,
                  k,
                  kv_sep,
                  if(is_hash(v)) {
                    hash_str(v, kv_sep, sep, left_sep, right_sep)
                  } else if (is.list(v)) {
                    list_str(v)
                  } else {
                    is_scalar = (length(v) == 1)
                    sprintf("%s%s%s",
                            if(is_scalar) "" else "(",
                            paste0(v, collapse = sep),
                            if(is_scalar) "" else ")")
                  },
                  if(k == last(hash_keys(h))) {
                    ""
                  } else {
                    sep
                  })
  }
  res = sprintf("%s%s", res, right_sep)
  res
}
