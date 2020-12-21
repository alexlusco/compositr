#'  clean and/or tokenize your text data in a single function
#' 
#'  Takes a text variable from a dataframe and runs a number of standard text preprocessing procedures on it, like removing html tags, removing stopwords, converting to lowercase. Preprocessing techniques and tokenization are applied in an interactive yes/no console session with the user. A list of the procedures used are saved in a local .txt file in directory specified by the user.
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
#'  @import magrittr
#'  @import crayon
#'  
#'  @examples
#'  \dontrun{
#'  results <- textprep(df, "text", language = "english", outdir = "~/Desktop/files")
#'  }

textprep <- function(textdata, textvar, type = "docs", language = "english", outdir = NA, outname = "/transformations.txt") {

  transformations <- list()
  
  cat(paste(crayon::green("Welcome")), crayon::blue("to"), crayon::red("compositr!"), "A convenient (lazy?), easy-to-use one stop shop\nfor all (okay, most?) of your text preprocessing needs!\n\n")
  
  cat(paste("You'll be asked a number of", crayon::green("questions"), "here in the console about what \noperations you'd like to apply to your text data.\n\n"))
  
  cat(paste("To answer yes/no questions, simply type", crayon::blue("'Yes', 'yes'"), "or", crayon::blue("'y'"), "to answer yes, \nand type", crayon::red("'No', 'no'"), "or", crayon::red("'n'"), "to answer no. You can exit the session at any \ntime by pressing the escape key.\n\n"))
  
  Sys.sleep(5)
  
  cat(crayon::green("Let's get started!\n\n"))
  
  Sys.sleep(2)
  
  if(type == "docs"){
    ask <- askYesNo("Do you want to remove non-UTF8 characters?")
    
    if(ask == TRUE){
      
      cat("Removing non-UTF8 characters...\n")
      
      textdata[[textvar]] <- iconv(textdata[[textvar]],  to="UTF-8", sub="") #remove non-UTF8 chars
      
      transformations[1] <- "Removed non-UTF8 characters"
    }
  }
  
  if(type == "docs"){
    ask <- askYesNo("Do you want to insert missing comma spaces?")
    
    if(ask == TRUE){
      
      cat("Inserting missing comma spaces...\n")
      
      textdata[[textvar]] <- textclean::add_comma_space(textdata[[textvar]]) #add space after commas if missing
      
      transformations[2] <- "Insert missing comma spaces"
    }
  }
  
  if(type == "docs"){
    ask <- askYesNo("Do you want to replace misspelled words with their most likely replacement?")
    
    if(ask == TRUE){
      
      cat("Fixing misspelled words...\n")
      
      textdata[[textvar]] <- replace_misspelling(textdata[[textvar]]) #fix spelling mistakes
      
      transformations[3] <- "Replaced misspelled words with their most likely replacement"
    }
  }
  
  if(type == "docs"){
    ask <- askYesNo("Do you want to remove HTML tags and symbols?")
    
    if(ask == TRUE){
      
      cat("Removing HTML tags and symbols...\n")
      
      textdata[[textvar]] <- textclean::replace_html(textdata[[textvar]]) #remove HTML tags/symbols, e.g., <bold>
      
      transformations[4] <- "Removed HTML tags and symbols"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to convert all text to lower case?")

    if(ask == TRUE){

      cat("Converting to lower case...\n")

      textdata[[textvar]] <- tolower(textdata[[textvar]]) #convert text to lower case

      transformations[5] <- "Converted all text to lower case"
    }
    else{
      ask <- askYesNo("Do you want to convert all text to upper case?")

      if(ask == TRUE){

        cat("Converting to upper case...\n")

        textdata[[textvar]] <- toupper(textdata[[textvar]]) #convert text to upper case

        transformations[6] <- "Converted all text to upper case"
      }
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove remove URLs?")

    if(ask == TRUE){

      cat("Removing URLs from text...\n")

      textdata[[textvar]] <- textclean::replace_url(textdata[[textvar]]) #remove URLs from text

      transformations[7] <- "Removed all URLs"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove numbers?\n")

    if(ask == TRUE){

      cat("Removing numbers from text...\n")

      textdata[[textvar]] <- gsub("[0-9+]", "", textdata[[textvar]]) #remove numbers from text

      transformations[8] <- "Removed all numbers"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove punctuation?")

    if(ask == TRUE){

      cat("Removing punctuation from text...\n")

      textdata[[textvar]] <- gsub("[[:punct:]]+", "", textdata[[textvar]]) #remove punctutation from text

      transformations[9] <- "Removed all punctuation"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to replace elongated words with the most likely normalization?")

    if(ask == TRUE){

      cat("Replacing elongated words...\n")

      textdata[[textvar]] <- textclean::replace_word_elongation(textdata[[textvar]]) #fix word elongation

      transformations[10] <- "Replaced elongated words with most likely normalization"
    }
  }

  if(type == "docs"){
    ask <- askYesNo("Do you want to remove extra white space?")

    if(ask == TRUE){

      cat("Removing extra white space...\n")

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

        cat("Tokenizing text (word level)...\n")

        textdata <- {{textdata}} %>%
          tidytext::unnest_tokens(word, {{textvar}}, token = "words") #tokenizer (words)

        transformations[12] <- "Tokenized text (word level)"
      }

      if(ask == TRUE){
        ask <- askYesNo("Do you want to remove stop words?")

        if(ask == TRUE){

          cat(glue::glue("Removing {language} stop words from text...\n"))

          stop.words <- tibble::tibble(word = tm::stopwords(language))

          textdata <- {{textdata}} %>%
            dplyr::anti_join(stop.words, by = "word") #remove stopwords in specified language

          transformations[12] <- glue::glue("Removed {language} stopwords")
        }
      }

      if(ask == TRUE){
        ask <- askYesNo("Do you want to stem your words? (If you prefer to lemmatize, type 'no')")

        if(ask == TRUE){

          cat("Stemming words...\n")

          textdata <- {{textdata}} %>%
            dplyr::mutate(word = SnowballC::wordStem(word)) #stem words

          transformations[13] <- "Stemmed words using SnowballC:: wordstemming algorithm"
        }

        else{
          ask <- askYesNo("Do you want to lemmatize your words?")

          if(ask == TRUE){

            cat("Lemmatizing words...\n")

            textdata <- {{textdata}} %>%
              dplyr::mutate(word = textstem::lemmatize_words(word)) #lemmatize words

            transformations[14] <- "Lemmatized words using textstem:: lemmatization algorithm"

          }
        }
      }
      
      if(ask == TRUE){
        ask <- askYesNo("Do you want to cast your text data into a DocumentTermMatrix?")
        
        if(ask == TRUE){
          
          cols <- textdata %>%
            select(-word)
          
          ask <- menu(c(glue("{colnames(cols)}")), title = "What is the name of your document variable?")
          
          textdata <- {{textdata}} %>%
            dplyr::count(.[[{{ask}}]], word) %>%
            dplyr::rename(document = {{ask}},
                   term = word,
                   value = n) %>%
            tidytext::cast_dtm(document, term, value)
          
          transformations[15] <- "Cast text data as DocumentTermMatrix"
        }
        
        else({
          ask <- askYesNo("Do you want to cast your text data into a DocumentFeatureMatrix?")
          
          if(ask == TRUE){
            
            cols <- textdata %>%
              select(-word)
            
            ask <- menu(c(glue("{colnames(cols)}")), title = "What is the name of your document variable?")
            
            textdata <- {{textdata}} %>%
              dplyr::count(.[[{{ask}}]], word) %>%
              dplyr::rename(document = {{ask}},
                            term = word,
                            value = n) %>%
              tidytext::cast_dfm(document, term, value)
            
            transformations[17] <- "Cast text data as DocumentFeatureMatrix"
          }
        })
        }
      }

      else{
        ask <- askYesNo("Do you want to tokenize at the sentence level?")

        if(ask == TRUE){

          textdata <- {{textdata}} %>%
            tidytext::unnest_tokens(sentences, {{textvar}}, token = "sentences") #tokenizer (sentences)

          transformations[18] <- "Tokenized text (sentence level)"
        }
      }
  }

  tryCatch({ #try saving results
    capture.output(unlist(transformations), file = paste(outdir, outname, sep = ""))},
    
    warning = function(w){

      warning("To save a list of operations as a separate .txt file, you need to specify an output directory")})
  
  cat(paste(crayon::green("Textprep is now complete!\n"), crayon::blue("Below is a list of transformations that were conducted:\n"), sep = ""))
  
  return({{unlist(transformations)}})

}

