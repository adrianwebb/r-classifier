
#-------------------------------------------------------------------------------
# Operations

Text.cluster <- function(notes, bucket.list = numeric(30), data.name = 'cluster') {
  cluster.lists <- list()
  bucket.list <- sort(bucket.list, decreasing = TRUE)
  
  options(mc.cores = 1)

  for (index in 1:length(bucket.list)) {
    cluster.list <- Text.cluster_buckets(notes, bucket.list[index], data.name)
    
    if (index < length(bucket.list)) {
      notes <- Text.summary_text(cluster.list)
    }
    cluster.lists[[as.character(bucket.list[index])]] <- cluster.list
  }
  
  cluster.tree <- Text.build_tree(cluster.lists)
  Text.render_clusters(cluster.tree, data.name)  
}

Text.cluster_buckets <- function(notes, buckets, data.name) {
  internal <- Text.process(notes, stopwords = TRUE, stem = TRUE)
  
  cluster.data <- Text.cluster_data(notes, internal, k = buckets)
  write.csv(cluster.data, file = file.path("data", paste(data.name, buckets, "csv", sep = ".")))
  
  Text.map_clusters(cluster.data)
}

Text.summary_text <- function(cluster.list) {
  cluster.renders <- lapply(cluster.list, function(element) {
    paste(as.character(element[['notes']]), collapse = "\n")    
  })
  as.character(cluster.renders)
}

Text.build_tree <- function(cluster.lists) {
  test.ids <- as.character(sort(as.numeric(names(cluster.lists)), decreasing = FALSE))
  cluster.tree <- Text.build_tree_recursive(cluster.lists[[test.ids[1]]], cluster.lists, test.ids[2:length(test.ids)])
  list('root' = cluster.tree)
}

Text.build_tree_recursive <- function(base.list, cluster.lists, test.ids) {
  cluster.list <- cluster.lists[[test.ids[1]]]
  tree <- list()

  for (name in names(base.list)) {
    cluster <- base.list[[name]]
    child.list <- list()
    
    tree[[name]] <- cluster
    
    for (index in 1:length(cluster[['index']])) {
      child.list[[as.character(index)]] <- cluster.list[[cluster[['index']][index]]]
    }
    
    if (length(test.ids) > 1) {
      tree[[name]][['children']] <- Text.build_tree_recursive(child.list, cluster.lists, test.ids[2:length(test.ids)])      
    }
    else {
      tree[[name]][['children']] <- child.list 
    }
  }
  tree
}

#-------------------------------------------------------------------------------
# Utilities

Text.process <- function(notes, stopwords = TRUE, stem = FALSE) {
  definition <- Corpus(VectorSource(notes))
  
  # Transform to lower case
  internal <- tm_map(definition, content_transformer(tolower))
  
  # Remove potentially problematic symbols
  toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x)) })
  
  internal <- tm_map(internal, toSpace, "-")
  internal <- tm_map(internal, toSpace, ":")
  internal <- tm_map(internal, toSpace, "‘")
  internal <- tm_map(internal, toSpace, "•")
  internal <- tm_map(internal, toSpace, "•    ")
  internal <- tm_map(internal, toSpace, " -")
  internal <- tm_map(internal, toSpace, "\"")
  
  # Remove punctuation
  internal <- tm_map(internal, removePunctuation)
  
  # Strip digits
  internal <- tm_map(internal, removeNumbers)
  
  # Remove whitespace
  internal <- tm_map(internal, stripWhitespace)
  
  # Remove stopwords
  if (stopwords) {
    internal <- tm_map(internal, removeWords, stopwords("english"))
  }
  
  # Stem corpus
  if (stem) {
    internal <- tm_map(internal, stemDocument, language = "english")
  }
  internal
}

Text.cluster_data <- function(notes, corpus, k = 20) {
  tdm <- TermDocumentMatrix(corpus, control = list(tokenizer = Text.tokenizer))

  # MDS with LSA
  td.matrix <- as.matrix(tdm)
  td.matrix.lsa <- lw_logtf(td.matrix) * entropy(td.matrix)  # weighting
  lsa.space <- lsa(td.matrix.lsa)  # create LSA space
  note.dist <- dist(t(as.textmatrix(lsa.space)))  # compute distance matrix

  cluster <- hclust(note.dist, method = "ward.D2")
  data.frame(note = notes, cluster = as.character(cutree(cluster, k = k)))
}

Text.map_clusters <- function(cluster.data) {
  cluster.list <- list()
  
  for(index in 1:nrow(cluster.data)) {
    element <- cluster.data[index,]
    note <- as.character(element[['note']])
    
    if (length(note) > 0) {
      note <- paste(toupper(substr(note, 1, 1)), substr(note, 2, nchar(note)), sep="")
      cluster <- element[['cluster']]

      if (!(cluster %in% names(cluster.list))) {
        cluster.list[[cluster]] <- list(notes = c(), index = c())
      }
      cluster.list[[cluster]][['notes']] <- c(cluster.list[[cluster]][['notes']], note)
      cluster.list[[cluster]][['index']] <- c(cluster.list[[cluster]][['index']], index)
    }
  }
  cluster.list  
}

Text.cluster_name <- function(notes) {
  internal <- Text.process(notes, stopwords = TRUE, stem = FALSE)
  tdm.matrix <- as.matrix(TermDocumentMatrix(internal, control=list(tokenizer = Text.tokenizer)))
  
  frequency <- sort(rowSums(tdm.matrix), decreasing=TRUE)
  expression <- as.character(names(frequency)[1:5])
  #quantity <- as.numeric(value(frequency)[1:5])
  
  paste(expression, collapse = " | ")
}

Text.render_clusters <- function(cluster.tree, data.name, top.label = 'Top') {
  text.render <- c(top.label, Text.render_clusters_recursive(cluster.tree[['root']], indent = "  "))
  cat(text.render, file = file.path("reports", paste(data.name, "txt", sep = ".")), sep = "\n")
}

Text.render_clusters_recursive <- function(cluster.tree, indent = "") {
  text.render <- c()
  sub.indent <- paste(indent, "  ", sep = "")
  
  for (bucket.id in names(cluster.tree)) {
    bucket <- cluster.tree[[bucket.id]]
    text.render <- c(text.render, paste(indent, Text.cluster_name(bucket[['notes']]), sep = ""))

    if ('children' %in% names(bucket)) {
      text.render <- c(text.render, Text.render_clusters_recursive(bucket[['children']], indent = sub.indent))
    }
    else {
      text.render <- c(text.render, as.character(lapply(bucket[['notes']], function(element) {
        paste(sub.indent, gsub("(^\\s+|\\s+$)", "", element, perl = TRUE))        
      })))      
    }
  }
  text.render
}

Text.tokenizer <- function(x) {
  NGramTokenizer(x, Weka_control(min = 2, max = 3))
}
