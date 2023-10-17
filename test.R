#! /usr/bin/env Rscript

library(stringr)
library(purrr)
library(r2r)

source("R/functions.R")
source("R/hash.R")
source("R/tabtree.R")
source("R/parse.R")

# parse_tabtree("test_1.tree") %>% print
h1 = hashmap(list("a", 1), list("b", 2))
h2 = hashmap(list("a", 3), list("c", 4))
hash_union(h1, h2) %>% .[["c"]]
