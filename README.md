![](https://github.com/alexlusco/compositr/blob/master/img/compositor.jpg)

# library(compositr)

While *analyzing* text data can be a lot fun, *preprocessing* text data is generally not. Enter: library(compositr). 

Compositr is a one stop shop for all your text preprocessing needs. In a single, painless interactive session, compositr will clean your data up for analysis, and can even convert your data into various formats, such a DocumentFeatureMatrix. Compositr will also provide you with a summary print out of what you did to your text data (in the console, but also as a .txt file saved locally if you wish). 

The library works by integrating a number of incredible R libraries behind the scenes, including ![tidytext](https://cran.r-project.org/web/packages/tidytext/index.html), ![texclean](https://cran.r-project.org/web/packages/textclean/index.html), and ![tm](https://cran.r-project.org/web/packages/tm/index.html), among others. 

People who are new to computational text analysis or the R programming language may find compositr especially useful. Compositr may also serve as a useful pedagogical tool. 

## Installation
```r
install.packages("devtools") 
devtools::install_github("alexlusco/compositr")
```

## Using compositr

Library(compositr) consists of three functions: ```textprep()```, which does the work of preprocessing and tokenization, ```textprep_tree()```, which generates a visual representation of textprep as a decision tree, and ```get_austen_data()```, which provides you with an example dataset to test the function on (a dataframe of Jane Austen books, pulled from ![janeaustenr](https://cran.r-project.org/web/packages/janeaustenr/index.html)). 

At minimum, ```textprep()``` takes a dataframe with a text variable. If you plan to cast your text data as a DocumentTermMatrix or DocumentFeatureMatrix, you'll also need a document IDs variable (e.g., the name of the book the text is from). The exact name of these variables does not matter. ```textprep()``` works by asking you a series of questions in the console about what you want to do to your text data. One of these questions requires a selection from a list, the rest are yes/no questions. The function can be used for basic cleaning operations, for cleaning and tokenization, or just tokenization. What the function does will depend on how you answer the prompts in the console.

```textprep()``` takes two required arguments, and three optional ones. ```textdata``` takes the name of the dataframe containing your text data (as well as any metadata if you have any). ```textvar``` takes the name of your text variable (the column containing the text in your dataframe). ```language``` takes the language of your text, e.g., "english", "french", "german". Note that this argument only applies if you are planning on removing stopwords from your textdata. 

If you wish you to keep a record of the preprocesssing operations you applied to your data, you can have these saved in a .txt file on your computer. To do this, you will need to specify a directory (to where you want the .txt file to be saved). You can specify this directory using the ```outdir``` argument. The function defaults to saving this file with the name transformations.txt, but you can also change the name of this file if you wish using the ```outname``` argument. In the future, the ```type``` argument will consist of multiple options, but at this time only consists of the default, "docs".

## Example

```r
library(compositr)

austen_books <- get_austen_data()

textprep_tree()

austen_book_tokens <- textprep(textdata = austen_books, textvar = "text", language = "english")
```

## Decision tree
![](https://github.com/alexlusco/compositr/blob/master/img/compositr_decision_tree.png)

## Acknowledgements

Special thanks to Rohan Alexander, Fernando Calderón, Tom Cardoso, Kevin Dick, Jamie Duncan, and Marcus Sibley for their feedback and beta testing.
