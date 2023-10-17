get_id <- function(line) {
  str_match(line, "(^[\\t]*)([A-Za-zА-Яа-я0-9_/\\-]+?)( |$)")[3]
}

clean_lines <- function(lines) {
  lines <- lines[!grepl("(^\\s*;)|(^\\s*$)", lines)]
  lines
}

parse_pairs <- function(line) {
  t = line %>% str_match_all("(\\S+?):(\"(.+?)\"|(.+?))( |$)") %>% .[[1]]
  if(length(t) != 0) {
    keys = t[,2] %>% unlist %>% unname
    values = ifelse(!is.na(t[,5]), t[,5], t[,4]) %>% unlist %>% unname
    return(setNames(values, keys))
  } else {
    return(c())
  }
}

parse_line <- function(line) {
  tabs = str_match(line, "^([\\t]*)([^\\t])")[2]
  id = get_id(line)
  pairs = parse_pairs(line)
  append(c("__id" = id, "__level" = nchar(tabs)), pairs)
}

find_parents_n <- function(lines, levels) {
  res = c()
  lines = as.numeric(lines)
  levels = as.numeric(levels)
  for(line in lines) {
    if (levels[line] == 0) {
      res[line] = F
    } else {
      j = line
      while(!is.na(levels[j]) &&
            levels[j] != levels[line] - 1 &&
            j > 0) {
        j = j - 1
      }
      res[line] = ifelse(j > 0, lines[j], F)
    }
  }
  res
}

add_parent <- function(tabtree) {
  levels = get_values_of_key(tabtree, "__level")
  lines = get_values_of_key(tabtree, "__line")
  parents = find_parents_n(lines, levels)
  tabtree = map_list(
              tabtree,
              function(k, item) {
                line = item["__line"] %>% as.numeric
                parent_line = parents[line]
                item["__parent"] = ifelse(parent_line == 0, NA, get_values_of_key(tabtree, "__id", parent_line))
                item })
  tabtree
}

self_merge <- function(tabtree_list) {
  hashmap(tabtree_list)
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

parse_tabtree <- function(filename) {
  lines <- readLines(filename) %>% clean_lines
  raw_tabtree = list()
  for(i in 1:length(lines)) {
    t = append(parse_line(lines[i]), c("__line" = i))
    raw_tabtree[[get_id(lines[i])]] = t
  }
  tabtree = raw_tabtree %>% add_parent
  tabtree
}
