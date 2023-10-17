remove_na <- function(x) {
  x[!is.na(x)]
}

list_keys <- function(tabtree) {
  names(tabtree)
}

list_values <- function(tabtree) {
  unlist(tabtree, use.names=F)
}

map_list <- function(tabtree, f) {
  for(id in names(tabtree)) {
    item = tabtree[[id]]
    tabtree[[id]] = f(id, item)
  }
  tabtree
}

filter_list <- function(tabtree, f) {
  mask = c()
  res = list()
  for(id in names(tabtree)) {
    item = tabtree[[id]]
    if (f(id, item)) {
      res[[id]] = item
    }
  }
  res
}

reduce_list <- function(tabtree, f, acc) {
  res = acc
  for(id in names(tabtree)) {
    item = tabtree[[id]]
    res = f(id, item, res)
  }
  res
}
