library(igraph)  # network/graph methods
library(network)  # network representations
library(intergraph)  # for exchanges between igraph and network

finished_paths <-read.table("C:/Users/00811289/Desktop/assignment4/data/paths_finished.tsv", header=TRUE, sep="\t")
paths <- finished_paths[,4]
paths_string <- as.character(paths)

links <- data.frame(p1=0, p2=0)
for (row in paths_string){
  # split each row into a list variable
  split_row <- strsplit(as.character(row), ";")
  i <- 2
  while (i<lengths(split_row)){
    links[nrow(links) + 1,] <- c((split_row[[1]][i]),(split_row[[1]][i-1]))
    i <- i+1  
  }
}

# Delete links that just are returns since that is not useful for what we're doing
links_cleaned <- links[- c(grep("<", links$p1),grep("<", links$p2)),]
# And remove the first row that I added during the initilization
links_cleaned <- links_cleaned[-1,]
# Check to make sure no self referring nodes
links_cleaned <- subset(links_cleaned, subset = (p1 != p2))
cat("\n\nNumber of Valid Links: ", nrow(links_cleaned)) #208742

wiki_net <- network(as.matrix(links_cleaned), matrix.type = "edgelist", directed = TRUE, multiple = TRUE)
#wiki_net2 <- network(as.matrix(links_cleaned), matrix.type = "edgelist", directed = TRUE, multiple = TRUE)
wiki_graph <- asIgraph(wiki_net)

wiki_graph_test <- asIgraph(wiki_net, vertices=vertex.names)

# set up node reference table/data frame for later subgraph selection
node_index <- as.numeric(V(wiki_graph))
V(wiki_graph)$name <- node_name <- as.character(V(wiki_graph))

# Key for vertex names
vertex_names <- (network.vertex.names(wiki_net))
vertex_name_df <- data.frame(node_name=0, name=0)
y <- 0
while (y < length(vertex_names)){
  vertex_name_df[nrow(vertex_name_df) + 1,] <- c(y,vertex_names[y])
  y <- y+1
}

node_name <- as.character(node_index)



node_reference_table <- data.frame(node_index, node_name)

node_1 <- induced.subgraph(wiki_graph, neighborhood(wiki_graph, order = 1, nodes = 1)[[1]])

# Check name of node 1
network.vertex.names(wiki_net)[1] #"%C3%85land"

# Different methods
#pdf(file = "fig_ego_1_mail_network_four_ways.pdf", width = 5.5, height = 5.5)
#par(mfrow = c(1,1))  # four plots on one page
set.seed(9999)  # for reproducible results
plot(node_1, vertex.size = 10, vertex.color = "yellow", 
     vertex.label = NA, edge.arrow.size = 0.25,
     layout = layout.fruchterman.reingold)
title("Fruchterman-Reingold Layout")   
set.seed(9999)  # for reproducible results
plot(node_1, vertex.size = 10, vertex.color = "yellow", 
     vertex.label = NA, edge.arrow.size = 0.25, 
     layout = layout.kamada.kawai)  
title("Kamada-Kawai Layout")    
set.seed(9999)  # for reproducible results
plot(node_1, vertex.size = 10, vertex.color = "yellow", 
     vertex.label = NA, edge.arrow.size = 0.25, 
     layout = layout.circle)
title("Circle Layout")     
set.seed(9999)  # for reproducible results
plot(node_1, vertex.size = 10, vertex.color = "yellow", 
     vertex.label = NA, edge.arrow.size = 0.25,
     layout = layout.reingold.tilford)    
title("Reingold-Tilford Layout")       
plot(node_1, vertex.size = 15, vertex.color = "yellow", 
     vertex.label.cex = 0.9, edge.arrow.size = 0.25, 
     edge.color = "black", layout = layout.kamada.kawai)

# add number of adjacent edges
node_reference_table$node_degree <- degree(wiki_graph)
print(str(node_reference_table))

# Finally added in variable names
ultimate_reference <- merge(node_reference_table, vertex_name_df, by="node_name")

sorted_node_reference_table <- 
  ultimate_reference[sort.list(ultimate_reference$node_degree, 
                                 decreasing = TRUE),]
# check on the sort, looks like USA #1! Followed by Europe, UK and Earth
print(head(sorted_node_reference_table))
print(tail(sorted_node_reference_table))

# Set top 10 articles
K <- 10

top_node_indices <- sorted_node_reference_table$node_index[1:K]
print(top_node_indices)


top_wiki_graph <- induced.subgraph(wiki_graph, top_node_indices)
# examine alternative layouts for plotting the top_enron_graph 
set.seed(9999)  # for reproducible results
plot(top_wiki_graph, 
     vertex.size = 15, 
     vertex.color = "orange", 
     vertex.label = V(top_wiki_graph)$vertex.names, 
     vertex.label.color = "black", 
     vertex.label.cex = 0.5, 
     edge.arrow.size = 0.15,
     layout = layout.fruchterman.reingold)
title("Top 10 Wikipedia Articles")   