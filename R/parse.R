library(stringr)
library(magrittr)

ignored_lines <<- c()

get_id <- function(line) {
  str_match(line, "(^[\\t]*)([A-Za-zА-Яа-я0-9_/\\-]+?)( |$)")[3]
}

is_ignored_line <- function(line) {
  grepl("(^\\s*;)|(^\\s*$)", line)
}

parse_pairs <- function(line) {
  t = line %>% str_match_all("(\\S+?):(\"(.+?)\"|(.+?))( |$)") %>% .[[1]]
  if(length(t) != 0) {
    keys = t[,2] %>% unlist %>% unname
    values = ifelse(!is.na(t[,5]), t[,5], t[,4]) %>% unlist %>% unname
    res = hash()
    for (i in seq_along(keys)) {
      vs = values[[i]] |> str_split(",") |> unlist()
      res = hash_set(res, keys[[i]], vs)
    }
    res
  } else {
    return(hash())
  }
}

parse_line <- function(line) {
  tabs = str_match(line, "^([\\t]*)([^\\t])")[2]
  id = get_id(line)
  item = parse_pairs(line)
  hash_union(item, hash("__id", id, "__level", as.character(nchar(tabs))))
}

get_parent_lines <- function(lines_levels, lines) {
  res = c()
  lines = as.integer(lines)
  for(line in lines) {
    if(line == 1) next
    level = lines_levels[[line]]
    for(i in (line-1):1) {
      if(ignored_lines[[i]]) next
      if(lines_levels[[i]] == level - 1) {
        res = c(res, i)
        break
      }
    }
  }
  res
}

add_parents <- function(tabtree) {
  lines_levels = reduce_tabtree(
                  tabtree,
                  function(acc, k, item) {
                    lines = as.integer(hash_ref(item, "__line"))
                    levels = as.integer(hash_ref(item, "__level"))
                    for(i in seq_along(lines)) {
                      acc[[lines[[i]]]] = levels[[i]]
                    }
                    acc
                  },
                  list())
  res = map_tabtree(
          tabtree,
          function(k, item) {
            lines = hash_ref(item, "__line")
            parent_lines = get_parent_lines(lines_levels, lines)
            parent_ids = tabtree |>
                                filter_tabtree(
                                  function(k2, item2) {
                                    as.integer(hash_ref(item2, "__line")) %in% parent_lines
                                  }) |>
                                  hash_keys()
            item = hash_set(item, "__parent", parent_ids)
            item
          })
  res
}

# add_children <- function(tabtree) {
#   tabtree %>%
#   map_tabtree(
#     function(id1, item1) {
#       children = tabtree %>%
#                  filter_list(
#                    function(id2, item2) {
#                      parent_id = item2["__parent"]
#                      return(!is.na(parent_id) && (parent_id == id1))}) %>%
#                  names
#       # print(children)
#       item1["__children"] = ifelse(length(children) != 0, children, c())
#       item1
#     })
# }

#' Parses a tabtree
#'
#' @param filename Tabtree file
#'
#' @return A hashmap as a parsed tabtree file
#' @export
#'
#' @examples
#' tt <- parse_tabtree('~/data/universities.tree')
parse_tabtree <- function(filename) {
  lines <- readLines(filename)
  raw_tabtree <- hash()
  for(i in 1:length(lines)) {
    line <- lines[i]
    if(is_ignored_line(line)) {
      ignored_lines[[i]] <<- T
      next
    } else {
      ignored_lines[[i]] <<- F
    }
    item <- hash_set(parse_line(lines[i]), "__line", as.character(i))
    k <- id(item)
    raw_tabtree <- hash_union(raw_tabtree, hash(k, item), mode = "merge")
  }
  res <- raw_tabtree |> add_parents()
  res
}
