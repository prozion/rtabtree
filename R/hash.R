hash_keys <- hashmap::keys
hash_values <- hashmap::values

hash_union <- function(h1, h2) {
  res = hashmap::hashmap()
  for(k in keys(h1)) {
    res[[k]] = append(res[[k]], h1[[k]])
  }
  for(k in keys(h2)) {
    res[[k]] = append(res[[k]], h2[[k]])
  }
  res
}
