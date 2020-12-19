#' clean and/or tokenize your text data in a single function
#' 
#' Takes a text variable from a dataframe and runs a number of standard text preprocessing procedures on it, like removing html tags, removing stopwords, converting to lowercase. Preprocessing techniques and tokenization are applied in an interactive yes/no console session with the user. A list of the procedures used are saved in a local .txt file in directory specified by the user.
#' 
#'  @param textdata a dataframe containing a text variable
#'  @param textvar the name of the column in the first param containing text
#'  @param type right now there is only one type called "docs"
#'  @param language user specified language, determines what tm::stopword dictionary is used
#'  @param outdir the directory that the user wishes to have the output .txt file saved in
#'  @param outname the name of the transformations .txt summary file, defaults to transformations.txt but can be renamed
#'  
#'  @return the dataframe with a cleaned and/or tokenized text variable
#'  
#'  @export
#'  
#'  @import textclean
#'  @import dplyr
#'  @import tidytext
#'  @import textstem
#'  @import SnowballC
#'  @import tibble
#'  @import tm

lazytextprep <- function(textdata, textvar, type = "docs", language = "english", outdir = NA, outname = "/transformations.txt") {

  transformations <- list()

  print("Removing non-UTF8 characters...")

  textdata[[textvar]] <- iconv(textdata[[textvar]],  to="UTF-8", sub="") #remove non-UTF8 chars

  transformations[1] <- "Removed non-UTF8 characters"

  print("Fixing comma spaces...")

  textdata[[textvar]] <- textclean::add_comma_space(textdata[[textvar]]) #add space after commas if missing

  transformations[2] <- "Fixed comma spaces"

  print("Fixing misspelled words...")

  textdata[[textvar]] <- lazycleanr::replace_misspelling(textdata[[textvar]]) #fix spelling mistakes

  transformations[3] <- "Fixed misspelled words"

  print("Removing HTML tags and symbols...")

  textdata[[textvar]] <- textclean::replace_html(textdata[[textvar]]) #remove HTML tags/symbols, e.g., <bold>

  transformations[4] <- "Removed HTML tags and symbols"

  if(type == "docs"){
    ask <- askYesNo("Do you want to convert all text to lower case?")

    if(ask == TRUE){

      print("Converting to lower case...")

      textdata[[textvar]] <- tolower(textdata[[textvar]]) #convert text to lower case

      transformations[5] <- "Converted all text to lower case"
    }
    else{
      ask <- askYesNo("Do you want to convert all text to upper case?")

      if(ask == TRUE){

        print("Converting to upper case...")

        textdata[[textvar]] <- toupper(textdata[[textvar]]) #convert text to upper case

        transformations[6] <- "Converted all text to upper case"
      }
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove remove URLs?")

    if(ask == TRUE){

      print("Removing URLs from text...")

      textdata[[textvar]] <- textclean::replace_url(textdata[[textvar]]) #remove URLs from text

      transformations[7] <- "Removed all URLs"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove numbers?")

    if(ask == TRUE){

      print("Removing numbers from text...")

      textdata[[textvar]] <- gsub("[0-9+]", "", textdata[[textvar]]) #remove numbers from text

      transformations[8] <- "Removed all numbers"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove punctuation?")

    if(ask == TRUE){

      print("Removing punctuation from text...")

      textdata[[textvar]] <- gsub("[[:punct:]]+", "", textdata[[textvar]]) #remove punctutation from text

      transformations[9] <- "Removed all punctuation"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to replace elongated words with the most likely normalization?")

    if(ask == TRUE){

      print("Replacing elongated words...")

      textdata[[textvar]] <- textclean::replace_word_elongation(textdata[[textvar]]) #fix word elongation

      transformations[10] <- "Replaced elongated words with most likely normalization"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove extra extra white space?")

    if(ask == TRUE){

      print("Removing extra white space...")

      textdata[[textvar]] <- trimws(textdata[[textvar]]) #trim trailing/leading white space
      textdata[[textvar]] <- textclean::replace_white(textdata[[textvar]]) #replace one or more white space chars with single space

      transformations[11] <- "Removed extra white space"
    }
  }

  if(type == "docs"){
  ask <- askYesNo("Do you want to tokenize your data?")

    if(ask == TRUE){
      ask <- askYesNo("Do you want to tokenize at the word level? (If you prefer sentence level, type 'no')")

      if(ask == TRUE){

        print("Tokenizing text (word level)...")

        textdata <- {{textdata}} %>%
          tidytext::unnest_tokens(word, {{textvar}}, token = "words") #tokenizer (words)

        transformations[12] <- "Tokenized text (word level)"
      }

      if(ask == TRUE){
        ask <- askYesNo("Do you want to remove stop words?")

        if(ask == TRUE){

          print(glue::glue("Removing {language} stop words from text..."))

          stop.words <- tibble::tibble(word = tm::stopwords(language))

          textdata <- {{textdata}} %>%
            tidytext::anti_join(stop.words, by = "word") #remove stopwords in specified language

          transformations[12] <- glue::glue("Removed {language} stopwords")
        }
      }

      if(ask == TRUE){
        ask <- askYesNo("Do you want to stem your words? (If you prefer to lemmatize, type 'no')")

        if(ask == TRUE){

          print("Stemming words...")

          textdata <- {{textdata}} %>%
            dplyr::mutate(word = SnowballC::wordStem(word)) #stem words

          transformations[13] <- "Stemmed words using SnowballC:: wordstemming algorithm"
        }

        else{
          ask <- askYesNo("Do you want to lemmatize your words?")

          if(ask == TRUE){

            print("Lemmatizing words...")

            textdata <- {{textdata}} %>%
              dplyr::mutate(word = textstem::lemmatize_words(word)) #lemmatize words

            transformations[14] <- "Lemmatized words using textstem:: lemmatization algorithm"

          }
        }
      }

      else{
        ask <- askYesNo("Do you want to tokenize at the sentence level?")

        if(ask == TRUE){

          print("Tokenizing text (sentence) level)...")

          textdata <- {{textdata}} %>%
            tidytext::unnest_tokens(sentences, {{textvar}}, token = "sentences") #tokenizer (sentences)

          transformations[15] <- "Tokenized text (sentence level)"
        }
      }
    }
  }

  tryCatch({ #try saving results
    capture.output(unlist(transformations), file = paste(outdir, outname, sep = ""))},

    warning = function(w){

      print(warnings("To save list of transformations, you need to specify an output directory"))})

  return({{textdata}})
}

