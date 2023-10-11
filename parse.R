#! /usr/bin/env Rscript

library(stringr)
library(purrr)

get_id <- function(line) {
  str_match(line, "(^[\\t]*)([A-Za-zА-Яа-я0-9_/\\-]+?)( |$)")[3]
}

parse_pairs <- function(line) {
  t = line %>% str_match_all("(\\S+?):(\"(.+?)\"|(.+?))( |$)") %>% .[[1]]
  keys = t[,2]
  values = ifelse(!is.na(t[,5]), t[,5], t[,4]) %>% str_split(",")
  setNames(values, keys)
}

parse_line <- function(line) {
  tabs = str_match(line, "^([\\t]*)([^\\t])")[2]
  id = get_id(line)
  pairs = parse_pairs(line)
  res = list()
  append(c("__id" = id, "__level" = nchar(tabs)), pairs)
}

find_parents_n <- function(lines, levels) {
  res = c()
  lines = as.numeric(lines)
  levels = as.numeric(levels)
  for(i in 1:length(lines)) {
    if (levels[i] == 0) {
      res[i] = F
    } else {
      j = i
      while(levels[j] != levels[i] - 1 && j > 0) {
        j = j - 1
      }
      res[i] = ifelse(j > 0, lines[j], F)
    }
  }
  res
}

all_key_values <- function(lst, key) {
  # print(lst %>% lapply(function(x) x[key]))
  lst %>% lapply(function(x) x[key]) %>% unlist(use.names=F)

}

find_parents <- function(tabtree) {
  levels = all_key_values(tabtree, "__level")
  lines = all_key_values(tabtree, "__line")
  # print(levels)
  parents = find_parents_n(lines, levels)
  tabtree = lapply(
              tabtree,
              function(x) {
                line = x[["__line"]]
                parents_line = parents[line]
                x["__parent"] = ifelse(parents_line == 0, NA, tabtree[[parents_line]]["__id"])
                x })
  tabtree
}

parse_tabtree <- function(filename) {
  lines <- readLines(filename)
  res = list()
  for(i in 1:length(lines)) {
    res[[get_id(lines[i])]] = append(parse_line(lines[i]), c("__line" = i))
  }
  res = find_parents(res)
}

res <- parse_tabtree("test_1.tree")
print(res)
# print(res[["Москва"]]["year"])
# print(res[["Москва"]]$twin[2])
