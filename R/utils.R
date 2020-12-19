upper_first_letter <- function(x){
  substring(x, 1, 1) <- toupper(substring(x, 1, 1))
  x
}

na_removal <- function(x) x[!is.na(x)]

replace_misspelling <- function(x, ...){
  
  lower <- text <- replacement <- is_cap <- final <- element_id <- token_id <- NULL
  
  if (!(is.character(x) | is.factor(x))) stop('`x` must be a character vector')
  is_na <- is.na(x)
  dat <- data.frame(text = as.character(x), stringsAsFactors = FALSE)
  
  token_df <- textshape::split_token(dat, lower = FALSE)[,
                                                         lower := tolower(text)]
  
  tokens <- grep('[a-z]', lazycleanr::na_removal(unique(token_df[['lower']])), value = TRUE)
  hits <- !hunspell::hunspell_check(tokens)
  
  misspelled <- tokens[hits]
  
  map <- data.table::data.table(
    lower = misspelled,
    replacement = unlist(lapply(hunspell::hunspell_suggest(misspelled), `[`, 1))
  )
  
  fixed_df <- map[token_df, on = "lower"]
  
  fixed_df_a <- fixed_df[!is.na(replacement),][,
                                               is_cap := substring(text, 1, 1) %in% LETTERS][,
                                                                                             final := ifelse(is_cap,  lazycleanr::upper_first_letter(replacement), replacement)][]
  
  fixed_df_b <- fixed_df[is.na(replacement),][, final := text][]
  
  bound <- rbind(fixed_df_a, fixed_df_b, fill = TRUE)
  
  out <- data.table::setorder(bound, element_id, token_id)[,
                                                           list(`final` = paste(final, collapse = ' ')), by = 'element_id'][,
                                                                                                                            `final` := gsub("(\\s+)([.!?,;:])", "\\2", final, perl = TRUE)][['final']]
  out[is_na] <- NA
  out
}
