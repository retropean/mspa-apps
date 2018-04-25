library(wordcloud)
library(tm)
setwd('C:/Users/Eric/Desktop/assignment2')
directory_location <- paste(getwd(), "/reviews/", sep = "")

file_names <- dir(directory_location)
text_data_frame <- NULL
for (ifile in seq(along = file_names)) { # begin for-loop for text objects
  # define the file name within the directory text_documents
  this_file <- paste(paste(directory_location, file_names[ifile], sep = ""))
  # read the file and convert all to lowercase letters
  this_text <- tolower(scan(this_file, what = "char", sep = "\n"))
  # messy way to remove HTML characters from text as this is something I scraped in a haphazard way last semester  
  this_nohtml_text <- unlist(strsplit(this_text,"<.*?>"))
  # consider words only
  this_text_words <- unlist(strsplit(this_nohtml_text, "\\W"))
  # words must be greater than 0 characters
  this_text_vector <- this_text_words[which(nchar(this_text_words) > 0)]
  # create data frame with each row being one word
  this_data_frame <- data.frame(document = file_names[ifile], text = this_text_vector,
                                stringsAsFactors = FALSE)
  text_data_frame <- rbind(text_data_frame, this_data_frame)
}  # end for-loop for text objects

print(str(text_data_frame))  # show the structure of the data frame
head(text_data_frame)

# Consistent Color
RED <- "#4C212A"
BLUE <- "#01172F"
GREEN <- "#00635D"
LBLUE <- "#11B5E4"
UBLUE <- "#446DF6"


for (ifile in seq(along = file_names)) { 
  this_file_label <- strsplit(file_names[ifile], ".txt", "")[[1]]
  # there will be a different pdf file for each file being displayed
  pdf(file = paste("word_cloud_", this_file_label, ".pdf", sep = ""),
      width = 8.5, height = 8.5)
  cat("\nPlotting ", this_file_label)    
  this_text_vector <- as.character(subset(text_data_frame, 
      subset = (document == file_names[ifile]), select = text))
  
  # the following is the core word cloud graphics code
  # we assume that this_text_vector is a character vector
  # of words to be displayed in the cloud
  # best practice for word clouds is horizontal text: rot.per = 0.0
  # explore by modifying the min.freq and max.words argument values
  wordcloud(this_text_vector, min.freq = 5,
            max.words = 150, 
            random.order = FALSE,
            random.color = FALSE,
            rot.per = 0.0, # all horizontal text
            colors = c(RED,BLUE,GREEN,LBLUE,UBLUE),
            ordered.colors = FALSE,
            use.r.layout = FALSE,
            fixed.asp = TRUE)
  dev.off()
}  
