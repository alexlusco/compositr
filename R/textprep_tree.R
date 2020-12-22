#'  Get decision tree for textprep function
#' 
#'  Generates decision tree for textprep function
#' 
#'  @return a decision tree for the function textprep
#'  
#'  @export
#'  
#'  @import DiagrammeR
#'  

textprep_tree <- function(x){

return(DiagrammeR::grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle]        
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']
      tab6 [label = '@@6']
      tab7 [label = '@@7']
      tab8 [label = '@@8']
      tab9 [label = '@@9']
      tab10 [label = '@@10']
      tab11 [label = '@@11']
      tab12 [label = '@@12']
      tab13 [label = '@@13']
      tab14 [label = '@@14']
      tab15 [label = '@@15']
      tab16 [label = '@@16']
      tab17 [label = '@@17']
      tab18 [label = '@@18']
      
      # edge definitions with the node IDs
      tab1 -> tab2 -> tab3 -> tab4;
      tab4 -> tab5;
      tab4 -> tab6;
      tab5 -> tab7;
      tab6 -> tab7;
      tab7 -> tab8;
      tab8 -> tab9;
      tab9 -> tab10;
      tab10 -> tab11;
      tab11 -> tab12;
      tab11 -> tab17;
      tab12 -> tab13;
      tab13 -> tab14;
      tab13 -> tab15;
      tab14 -> tab16;
      tab15 -> tab16;
      tab14 -> tab18;
      tab15 -> tab18
      
      }
      
      [1]: 'Remove non-UTF8 characters'
      [2]: 'Insert missing comma spaces'
      [3]: 'Replace misspelled words with most likely equivalent'
      [4]: 'Remove HTML tags and symbols'
      [5]: 'Convert text to lower case'
      [6]: 'Convert text to upper case'
      [7]: 'Remove URLs'
      [8]: 'Remove numbers'
      [9]: 'Remove punctuation'
      [10]: 'Replace elongated word with most likely equivalent'
      [11]: 'Remove extra white space'
      [12]: 'Word tokenization'
      [13]: 'Remove stopwords'
      [14]: 'Stem words'
      [15]: 'Lemmatize words'
      [16]: 'Cast data as DocumentTermMatrix'
      [17]: 'Sentence tokenization'
      [18]: 'Cast data as DocumentFeatureMatrix'
      "))
}