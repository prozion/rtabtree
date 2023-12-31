% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse.R
\name{parse_tabtree}
\alias{parse_tabtree}
\title{Parses a tabtree}
\usage{
parse_tabtree(filename)
}
\arguments{
\item{filename}{Tabtree file}
}
\value{
A hashmap as a parsed tabtree file
}
\description{
Parses a tabtree
}
\examples{
tt <- parse_tabtree('~/data/universities.tree')
}
