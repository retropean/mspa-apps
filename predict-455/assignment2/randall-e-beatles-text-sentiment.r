  library(wordcloud)
  library(tm)
  library(tidytext)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  setwd('C:/Users/00811289/Documents/github/mspa-apps/predict-455/assignment2')
  directory_location <- paste(getwd(), "/reviews/", sep = "")
  
  file_names <- dir(directory_location)
  beatles_reviews <- NULL
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
    beatles_reviews <- rbind(beatles_reviews, this_data_frame)
  }  # end for-loop for text objects
  
  print(str(beatles_reviews))  # show the structure of the data frame
  head(beatles_reviews)
  
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
  this_text_vector <- as.character(subset(beatles_reviews, 
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
  
# Stop words from the tidytext package
data("stop_words")
# Only add in words that are not in the stop_words dataframe

beatles_reviews_clean <- beatles_reviews[is.na(match(beatles_reviews$text,stop_words$word)),]

beatles_reviews_clean %>% count(text, sort = TRUE) 

names(beatles_reviews_clean) <- c("album", "word")
beatles_reviews_clean$album[beatles_reviews_clean$album == "hard_days_night.txt"] <- "Hard Day's Night"
beatles_reviews_clean$album[beatles_reviews_clean$album == "please_please_me.txt"] <- "Please Please Me"
beatles_reviews_clean$album[beatles_reviews_clean$album == "with_the_beatles.txt"] <- "With the Beatles"
beatles_reviews_clean$line <- seq.int(nrow(beatles_reviews_clean))

beatles_review_sentiment <- beatles_reviews_clean %>%
  inner_join(get_sentiments("bing"), by = "word") %>% 
  count(album, index = line %/% 40, sentiment) %>% 
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)
  
# Plot of sentiments by album over words
ggplot(beatles_review_sentiment, aes(index, sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE, fill = GREEN) +
  facet_wrap(~album, ncol = 1, scales = "free") +
  ggtitle("Sentiment of Beatles Albums") +
  labs(x = "Review Text", y = "Sentiment") + 
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank())

head(beatles_reviews_clean)
beatles_word_count <- beatles_reviews_clean %>% group_by(album, word) %>% summarize(count=n())
bing_sentiments <- get_sentiments("bing")

# Check overall sentiment by album
beatles_word_count %>%
  inner_join(bing_sentiments, by = (term = "word")) %>%
  count(album, sentiment, wt = count) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(sentiment)

HDN$album[beatles_reviews_clean$album == "Hard Day's Night"] <- "Hard Day's Night"
HDN <- beatles_word_count[which(beatles_word_count$album=="Hard Day's Night"), ]
PPM <- beatles_word_count[which(beatles_word_count$album=="Please Please Me"), ]
WTB <- beatles_word_count[which(beatles_word_count$album=="With the Beatles"), ]

# Relative Freq graph between Hard Day's Night and Please Please Me
HDN_PPM_compare <- inner_join(PPM,HDN, by = "word")
HDN_PPM_compare["relativefreq.x"] <- HDN_PPM_compare["count.x"]/sum(HDN_PPM_compare["count.x"])
HDN_PPM_compare["relativefreq.y"] <- HDN_PPM_compare["count.y"]/sum(HDN_PPM_compare["count.y"])
head(HDN_PPM_compare)

library(scales)
ggplot(HDN_PPM_compare, aes(relativefreq.x, relativefreq.y)) +
  geom_point(alpha = 0.5) +
  geom_text(aes(label = word), size = 3, check_overlap = TRUE,
            vjust = 1, hjust = 1) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  ggtitle("Relative Frequency of Keywords in Beatles Reviews") +
  labs(x = "Please Please Me", y = "Hard Day's Night")

# Relative Freq graph between Hard Day's Night and With The Beatles
HDN_WTB_compare <- inner_join(WTB,HDN, by = "word")
HDN_WTB_compare["relativefreq.x"] <- HDN_WTB_compare["count.x"]/sum(HDN_WTB_compare["count.x"])
HDN_WTB_compare["relativefreq.y"] <- HDN_WTB_compare["count.y"]/sum(HDN_WTB_compare["count.y"])
head(HDN_WTB_compare)

library(scales)
ggplot(HDN_WTB_compare, aes(relativefreq.x, relativefreq.y)) +
  geom_point(alpha = 0.5) +
  geom_text(aes(label = word), size = 3, check_overlap = TRUE,
            vjust = 1, hjust = 1) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  ggtitle("Relative Frequency of Keywords in Beatles Reviews") +
  labs(x = "With the Beatles", y = "Hard Day's Night")
