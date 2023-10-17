get_item_k <- function(item, k) {
  item[k] %>% unname
}

id <- function(item) {
  get_item_k(item, "__id")
}

item_by_id <- function(tabtree, id) {
  tabtree[[id]]
}

map_tabtree <- map_list
filter_tabtree <- filter_list
reduce_tabtree <- reduce_list

get_values_of_key <- function(tabtree, k, ids = c()) {
  if (length(ids) != 0) {
    tabtree = tabtree[ids]
  }
  res = tabtree %>%
        reduce_tabtree(function(id, item, acc) { append(acc, get_item_k(item, k)) }, c()) %>%
        remove_na
  res
}
