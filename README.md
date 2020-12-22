![](https://github.com/alexlusco/compositr/blob/master/compositor.jpg)

# library(compositr)

While computational text analysis is fun, preprocessing and tokenizing text data is generally not. Enter: ```library(compositr)```. Compositr is a one stop shop for all your text preprocessing and tokenization needs.

## Installation
```r
install.packages("devtools") 
devtools::install_github("alexlusco/compositr")
```

## Using compositr

The library consists of three functions: ```textprep```, which does the work of preprocessing and tokenization, ```textprep_tree```, which generates a visual representation of textprep as a decision tree, and ```get_austen_data```, which provides you with an example dataset to test the function on, pulled from ```library(janeaustenr)```. 

At minimum, ```textprep``` takes a dataframe with text variable. If you plan to cast your text data as a DocumentTermMatrix, you'll also need a document IDs variable (e.g., the name of the book the text is from). The exact name of these variables does not matter. ```textprep``` works by asking you a series of questions in the console about what you want to do to your text data. One of these questions requires a selection from a list, the rest are yes/no questions. The function can be used for basic cleaning operations, for cleaning and tokenization, or just tokenization. What the function does will depend on how you answer the prompts in the console.

```textprep``` takes two required arguments, and three optional ones. ```textdata``` takes the name of the dataframe containing your text data (as well as any metadata if you have any). ```textvar``` takes the name of your text variable (the column containing the text in your dataframe). ```language``` takes the language of your text, e.g., "english", "french", "german". Note that this argument only applies if you are planning on removing stopwords from your textdata. If you wish you to keep a record of the preprocesssing operations you applied to your data, you can have these saved in a .txt file on your computer. To do this, you will need to specify a directory (to where you want the .txt file to be saved). You can specify this directory using the ```outdir``` argument. The function defaults to saving this file with the name transformations.txt, but you can also change the name of this file if you wish using the ```outname``` argument. In the future, the ```type``` argument will consist of multiple options, but at this time only consists of the default, "docs".

## Example

```r
library(compositr)

austen_books <- get_austen_data()

textprep_tree()

austen_book_tokens <- textprep(austen_books, "text", language = "english")
```

## Decision tree
![](https://github.com/alexlusco/compositr/blob/master/compositr_decision_tree.png)

## Acknowledgements

Special thanks to Rohan Alexander, Fernando Calderón, Tom Cardoso, Kevin Dick, Jamie Duncan, and Marcus Sibley for their excellent feedback and beta testing.
