#'@export
id <- function(item) {
  hash_ref(item, "__id", NULL)
}

#'@export
item_by_id <- function(tabtree, id) {
  hash_ref(tabtree, id, hash())
}

#'@export
map_tabtree <- function(tabtree, f) {
  res <- hash()
  for(k in hash_keys(tabtree)) {
    hash_set(res, k, f(k, hash_ref(tabtree, k)))
  }
  res
}

#'@export
tabtree_map <- map_tabtree

#'@export
filter_tabtree <- function(tabtree, f) {
  res = hash()
  for(k in hash_keys(tabtree)) {
    v <- hash_ref(tabtree, k)
    if(f(k, v)) {
      res <- hash_set(res, k, v)
    }
  }
  res
}

#'@export
filter_not_tabtree <- function(tabtree, f) {
  filter_tabtree(tabtree, function(k, item) { !f(k, item) })
}

#'@export
reduce_tabtree <- function(tabtree, f, acc = hash()) {
  res = acc
  for(k in hash_keys(tabtree)) {
    v <- hash_ref(tabtree, k)
    res <- f(res, k, v)
  }
  res
}

#'@export
tabtree_to_str <- function(tabtree) {
  res_tabtree = ""
  for(id in hash_keys(tabtree)) {
    item <- hash_ref(tabtree, k)
    # TODO: add tabs
    res_item = sprintf("%s %s", id, hash_str(item, sep = " ", kv_sep = ":"))
    res_tabtree = sprintf("%s%s\n", res_tabtree, res_item)
  }
  res_tabtree
}
