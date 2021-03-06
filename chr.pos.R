library(namedCapture)

subject <- 
  c("chr10:213,054,000-213,055,000",
    "chrM:111,000-222,000",
    "foo bar",
    NA,
    "chr1:110-111 chr2:220-222")

## The .* pattern means to match 0 or more of any characters. If there
## are several matches, it will match as much as possible. This does
## not give the desired result for the last subject.
pattern.greedy.stars <- paste0(
  "(?<chrom>chr.*)",
  ":",
  "(?<chromStart>.*)",
  "-",
  "(?<chromEnd>.*)")
str_match_named(subject, pattern.greedy.stars)

## Using a character class [] assumes you know all possible values
## that you want to match. May not match all possible things you want
## to match (e.g. chrM does not match the chrom group below).
pattern.greedy.class <- paste0(
  "(?<chrom>chr[0-9]+)",
  ":",
  "(?<chromStart>[0-9,]+)",
  "-",
  "(?<chromEnd>[0-9,]+)")
str_match_named(subject, pattern.greedy.class)

## You can specify the pattern using a negated character class
## (beginning with ^) but that is repetitive. For example you have to
## specify the : separator twice (once in the negated character class,
## and once after the group).
pattern.greedy.negated <- paste0(
  "(?<chrom>chr[^:]+)",
  ":",
  "(?<chromStart>[^-]+)",
  "-",
  "(?<chromEnd>[^ ]*)")
str_match_named(subject, pattern.greedy.negated)

## I prefer using the .*? non-greedy match. Like .* it matches 0 or
## more of any characters, but it prefers the smallest possible match.
pattern.not.greedy <- paste0(
  "(?<chrom>chr.*?)",
  ":",
  "(?<chromStart>.*?)",
  "-",
  "(?<chromEnd>[0-9,]*)")
str_match_named(subject, pattern.not.greedy)

## Specify a list of conversion functions as the third argument if you
## want a data.frame with non-character columns.
keep.digits <- function(x)as.integer(gsub("[^0-9]", "", x))
conversion.list <- list(chromStart=keep.digits, chromEnd=keep.digits)
(match.df <- str_match_named(subject, pattern.not.greedy, conversion.list))
str(match.df)

## Note that str_match_named above returned only the first match in
## every subject string. If you want EVERY match, use
## str_match_all_named instead.
(match.mat.list <- str_match_all_named(subject, pattern.not.greedy))
str(match.mat.list)

## str_match_all_named also accepts a list of conversion functions as
## its third argument.
(match.df.list <- str_match_all_named(subject, pattern.not.greedy, conversion.list))
str(match.df.list)

