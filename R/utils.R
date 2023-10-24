remove_na <- function(x) {
  x[!is.na(x)]
}

first <- function(x) {
  head(x, n = 1)
}

last <- function(x) {
  tail(x, n = 1)
}

list_str <- function(l, sep = ", ", kv_sep = ", ") {
  res = "list("
  interval = if(is.null(names(l))) {
    seq_along(l)
  } else {
    names(l)
  }
  for(i in interval) {
    v = l[[i]]
    res = sprintf("%s%s%s%s%s",
                  res,
                  ifelse(i == interval[[1]], "", sep),
                  i,
                  kv_sep,
                  if(is.list(v)) {
                    list_str(v, sep, kv_sep)
                  } else {
                    v
                  })
  }
  res = sprintf("%s)", res)
  res
}

p <- function(..., sep = ", ", kv_sep = " => ") {
  els = list(...)
  res = ""
  for(i in seq_along(els)) {
    el = els[[i]]
    res = sprintf("%s%s%s",
                  res,
                  if(i == 1) {
                    ""
                  } else {
                    sep
                  },
                  if(is_hash(el)) {
                     hash_str(el, kv_sep = kv_sep, right_sep = " )\n")
                  } else if(is.list(el)) {
                     list_str(el)
                  } else {
                     el
                  })
  }
  cat(res, "\n")
}
