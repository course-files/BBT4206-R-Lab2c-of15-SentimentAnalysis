# *****************************************************************************
# Lab 2.c.: Sentiment Analysis ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# **[OPTIONAL] Initialization: Install and use renv ----
# The R Environment ("renv") package helps you create reproducible environments
# for your R projects. This is helpful when working in teams because it makes
# your R projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# "renv" It can be installed as follows:
# if (!is.element("renv", installed.packages()[, 1])) {
#   install.packages("renv", dependencies = TRUE) # nolint
# }
# require("renv") # nolint

# Once installed, you can then use renv::init() to initialize renv in a new
# project.

# The prompt received after executing renv::init() is as shown below:
# This project already has a lockfile. What would you like to do?

# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
# renv::init() # nolint

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open the project.

# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()

# One of the libraries should be a folder inside the project if you are using
# renv

# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)

# This can also be configured using the RStudio GUI when you click the project
# file, e.g., "BBT4206-R.Rproj" in the case of this project. Then
# navigate to the "Environments" tab and select "Use renv with this project".

# As you continue to work on your project, you can install and upgrade
# packages, using either:
# install.packages() and update.packages or
# renv::install() and renv::update()

# You can also clean up a project by removing unused packages using the
# following command: renv::clean()

# After you have confirmed that your code works as expected, use
# renv::snapshot(), AT THE END, to record the packages and their
# sources in the lockfile.

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# [OPTIONAL]
# Execute the following code to reinstall the specific package versions
# recorded in the lockfile (restart R after executing the command):
# renv::restore() # nolint

# [OPTIONAL]
# If you get several errors setting up renv and you prefer not to use it, then
# you can deactivate it using the following command (restart R after executing
# the command):
# renv::deactivate() # nolint

# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):
if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

# Methods used for sentiment analysis include:
# (i) Training a known dataset
# (ii) Creating your own classifiers with rules
# (iii) Using predefined lexical dictionaries (lexicons); a lexicon approach

# Levels of sentiment analysis include:
# (i) Document
# (ii) Sentence
# (iii) Word


# STEP 1. Install and Load the Required Packages ----
# The following packages can be installed and loaded before proceeding to the
# subsequent steps.

## dplyr - For data manipulation ----
if (!is.element("dplyr", installed.packages()[, 1])) {
  install.packages("dplyr", dependencies = TRUE)
}
require("dplyr")

## ggplot2 - For data visualizations using the Grammar for Graphics package ----
if (!is.element("ggplot2", installed.packages()[, 1])) {
  install.packages("ggplot2", dependencies = TRUE)
}
require("ggplot2")

## ggrepel - Additional options for the Grammar for Graphics package ----
if (!is.element("ggrepel", installed.packages()[, 1])) {
  install.packages("ggrepel", dependencies = TRUE)
}
require("ggrepel")

## ggraph - Additional options for the Grammar for Graphics package ----
if (!is.element("ggraph", installed.packages()[, 1])) {
  install.packages("ggraph", dependencies = TRUE)
}
require("ggraph")

## tidytext - For text mining ----
if (!is.element("tidytext", installed.packages()[, 1])) {
  install.packages("tidytext", dependencies = TRUE)
}
require("tidytext")

## tidyr - To tidy messy data ----
if (!is.element("tidyr", installed.packages()[, 1])) {
  install.packages("tidyr", dependencies = TRUE)
}
require("tidyr")

## widyr - To widen, process, and re-tidy a dataset ----
if (!is.element("widyr", installed.packages()[, 1])) {
  install.packages("widyr", dependencies = TRUE)
}
require("widyr")

## gridExtra - to arrange multiple grid-based plots on a page ----
if (!is.element("gridExtra", installed.packages()[, 1])) {
  install.packages("gridExtra", dependencies = TRUE)
}
require("gridExtra")

## knitr - for dynamic report generation ----
if (!is.element("knitr", installed.packages()[, 1])) {
  install.packages("knitr", dependencies = TRUE)
}
require("knitr")

## kableExtra - for nicely formatted output tables ----
if (!is.element("kableExtra", installed.packages()[, 1])) {
  install.packages("kableExtra", dependencies = TRUE)
}
require("kableExtra")

## formattable -  To create a formattable object ----
# A formattable object is an object to which a formatting function and related
# attributes are attached.
if (!is.element("formattable", installed.packages()[, 1])) {
  install.packages("formattable", dependencies = TRUE)
}
require("formattable")

## circlize - To create a cord diagram or visualization ----
# by Gu et al. (2014)
if (!is.element("circlize", installed.packages()[, 1])) {
  install.packages("circlize", dependencies = TRUE)
}
require("circlize")

## memery - For creating data analysis related memes ----
# The memery package generates internet memes that optionally include a
# superimposed inset plot and other atypical features, combining the visual
# impact of an attention-grabbing meme with graphic results of data analysis.
if (!is.element("memery", installed.packages()[, 1])) {
  install.packages("memery", dependencies = TRUE)
}
require("memery")

## magick - For image processing in R ----
if (!is.element("magick", installed.packages()[, 1])) {
  install.packages("magick", dependencies = TRUE)
}
require("magick")

## yarrr - To create a pirate plot ----
if (!is.element("yarrr", installed.packages()[, 1])) {
  install.packages("yarrr", dependencies = TRUE)
}
require("yarrr")

## radarchart - To create interactive radar charts using ChartJS ----
if (!is.element("radarchart", installed.packages()[, 1])) {
  install.packages("radarchart", dependencies = TRUE)
}
require("radarchart")

## igraph - To create ngram network diagrams ----
if (!is.element("igraph", installed.packages()[, 1])) {
  install.packages("igraph", dependencies = TRUE)
}
require("igraph")

## wordcloud2 - For creating wordcloud by using 'wordcloud2.JS ----
if (!is.element("wordcloud2", installed.packages()[, 1])) {
  install.packages("wordcloud2", dependencies = TRUE)
}
require("wordcloud2")

## textdata - Download sentiment lexicons and labeled text data sets ----
if (!is.element("textdata", installed.packages()[, 1])) {
  install.packages("textdata", dependencies = TRUE)
}
require("textdata")

## readr - Load datasets from CSV files ----
if (!is.element("readr", installed.packages()[, 1])) {
  install.packages("readr", dependencies = TRUE)
}
require("readr")

# STEP 2. Customize the Visualizations, Tables, and Colour Scheme ----
# The following defines a blue-grey colour scheme for the visualizations:
## shades of blue and shades of grey
blue_grey_colours_11 <- c("#27408E", "#304FAF", "#536CB5", "#6981c7", "#8da0db",
                          "#dde5ec", "#c8c9ca", "#B9BCC2", "#A7AAAF", "#888A8E",
                          "#636569")

blue_grey_colours_6 <- c("#27408E", "#304FAF", "#536CB5",
                         "#B9BCC2", "#A7AAAF", "#888A8E")

blue_grey_colours_4 <- c("#27408E", "#536CB5",
                         "#B9BCC2", "#888A8E")

blue_grey_colours_2 <- c("#27408E",
                         "#888A8E")

blue_grey_colours_1 <- c("#6981c7")

# Custom theme for visualizations
blue_grey_theme <- function() {
  theme(
    axis.ticks = element_line(
                              linewidth = 1, linetype = "dashed",
                              lineend = NULL, color = "#dfdede",
                              arrow = NULL, inherit.blank = FALSE),
    axis.text = element_text(
                             face = "bold", color = "#3f3f41",
                             size = 12, hjust = 0.5),
    axis.title = element_text(face = "bold", color = "#3f3f41",
                              size = 14, hjust = 0.5),
    plot.title = element_text(face = "bold", color = "#3f3f41",
                              size = 16, hjust = 0.5),
    panel.grid = element_line(
                              linewidth = 0.1, linetype = "dashed",
                              lineend = NULL, color = "#dfdede",
                              arrow = NULL, inherit.blank = FALSE),
    panel.background = element_rect(fill = "#f3eeee"),
    legend.title = element_text(face = "plain", color = "#3f3f41",
                                size = 12, hjust = 0),
    legend.position = "right"
  )
}

# Customize the text tables for consistency using HTML formatting
kable_theme <- function(dat, caption) {
  kable(dat, "html", escape = FALSE, caption = caption) %>%
    kable_styling(bootstrap_options = c("striped", "condensed", "bordered"),
                  full_width = FALSE)
}

# STEP 3. Load the Dataset ----
student_performance_dataset <-
  read_csv("data/20230412-20230719-BI1-BBIT4-1-StudentPerformanceDataset.CSV",
           col_types =
           cols(
                class_group = col_factor(levels = c("A", "B", "C")),
                gender = col_factor(levels = c("1", "0")),
                YOB = col_date(format = "%Y"),
                regret_choosing_bi = col_factor(levels = c("1", "0")),
                drop_bi_now = col_factor(levels = c("1", "0")),
                motivator = col_factor(levels = c("1", "0")),
                read_content_before_lecture =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                anticipate_test_questions =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                answer_rhetorical_questions =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                find_terms_I_do_not_know =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                copy_new_terms_in_reading_notebook =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                take_quizzes_and_use_results =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                reorganise_course_outline =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                write_down_important_points =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                space_out_revision =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                studying_in_study_group =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                schedule_appointments =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                goal_oriented = col_factor(levels = c("1", "0")),
                spaced_repetition =
                col_factor(levels = c("1", "2", "3", "4")),
                testing_and_active_recall =
                col_factor(levels = c("1", "2", "3", "4")),
                interleaving = col_factor(levels = c("1", "2", "3", "4")),
                categorizing = col_factor(levels = c("1", "2", "3", "4")),
                retrospective_timetable =
                col_factor(levels = c("1", "2", "3", "4")),
                cornell_notes = col_factor(levels = c("1", "2", "3", "4")),
                sq3r = col_factor(levels = c("1", "2", "3", "4")),
                commute = col_factor(levels = c("1", "2", "3", "4")),
                study_time = col_factor(levels = c("1", "2", "3", "4")),
                repeats_since_Y1 = col_integer(),
                paid_tuition = col_factor(levels = c("0", "1")),
                free_tuition = col_factor(levels = c("0", "1")),
                extra_curricular = col_factor(levels = c("0", "1")),
                sports_extra_curricular = col_factor(levels = c("0", "1")),
                exercise_per_week = col_factor(levels = c("0", "1", "2", "3")),
                meditate = col_factor(levels = c("0", "1", "2", "3")),
                pray = col_factor(levels = c("0", "1", "2", "3")),
                internet = col_factor(levels = c("0", "1")),
                laptop = col_factor(levels = c("0", "1")),
                family_relationships =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                friendships = col_factor(levels = c("1", "2", "3", "4", "5")),
                romantic_relationships =
                col_factor(levels = c("0", "1", "2", "3", "4")),
                spiritual_wellnes =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                financial_wellness =
                col_factor(levels = c("1", "2", "3", "4", "5")),
                health = col_factor(levels = c("1", "2", "3", "4", "5")),
                day_out = col_factor(levels = c("0", "1", "2", "3")),
                night_out = col_factor(levels = c("0", "1", "2", "3")),
                alcohol_or_narcotics =
                col_factor(levels = c("0", "1", "2", "3")),
                mentor = col_factor(levels = c("0", "1")),
                mentor_meetings = col_factor(levels = c("0", "1", "2", "3")),
                `Attendance Waiver Granted: 1 = Yes, 0 = No` =
                col_factor(levels = c("0", "1")),
                GRADE = col_factor(levels = c("A", "B", "C", "D", "E"))),
           locale = locale())

View(student_performance_dataset)

## Create a filtered subset of the data ----

# Function to expand contractions
expand_contractions <- function(doc) {
  doc <- gsub("I'm", "I am", doc, ignore.case = TRUE)
  doc <- gsub("you're", "you are", doc, ignore.case = TRUE)
  doc <- gsub("he's", "he is", doc, ignore.case = TRUE)
  doc <- gsub("she's", "she is", doc, ignore.case = TRUE)
  doc <- gsub("it's", "it is", doc, ignore.case = TRUE)
  doc <- gsub("we're", "we are", doc, ignore.case = TRUE)
  doc <- gsub("they're", "they are", doc, ignore.case = TRUE)
  doc <- gsub("I'll", "I will", doc, ignore.case = TRUE)
  doc <- gsub("you'll", "you will", doc, ignore.case = TRUE)
  doc <- gsub("he'll", "he will", doc, ignore.case = TRUE)
  doc <- gsub("she'll", "she will", doc, ignore.case = TRUE)
  doc <- gsub("it'll", "it will", doc, ignore.case = TRUE)
  doc <- gsub("we'll", "we will", doc, ignore.case = TRUE)
  doc <- gsub("they'll", "they will", doc, ignore.case = TRUE)
  doc <- gsub("won't", "will not", doc, ignore.case = TRUE)
  doc <- gsub("can't", "cannot", doc, ignore.case = TRUE)
  doc <- gsub("n't", " not", doc, ignore.case = TRUE)
  return(doc)
}

# Select the class group, gender, average course evaluation rating,
# and most importantly, the likes and wishes from the original dataset
evaluation_likes_and_wishes <- student_performance_dataset %>%
  mutate(`Student's Gender` =
           ifelse(gender == 1, "Male", "Female")) %>%
  rename(`Class Group` = class_group) %>%
  rename(Likes = `D - 1. \nWrite two things you like about the teaching and learning in this unit so far.`) %>% # nolint
  rename(Wishes = `D - 2. Write at least one recommendation to improve the teaching and learning in this unit (for the remaining weeks in the semester)`) %>% # nolint
  select(`Class Group`,
         `Student's Gender`, `Average Course Evaluation Rating`,
         Likes, Wishes) %>%
  filter(!is.na(`Average Course Evaluation Rating`)) %>%
  arrange(`Class Group`)

evaluation_likes_and_wishes$Likes <- sapply(
                                            evaluation_likes_and_wishes$Likes,
                                            expand_contractions)
evaluation_likes_and_wishes$Wishes <- sapply(
                                             evaluation_likes_and_wishes$Wishes,
                                             expand_contractions)

head(evaluation_likes_and_wishes, 10)

# Function to remove special characters and convert all text to a standard
# lower case
remove_special_characters <- function(doc) {
  gsub("[^a-zA-Z0-9 ]", "", doc, ignore.case = TRUE)
}

evaluation_likes_and_wishes$Likes <- sapply(evaluation_likes_and_wishes$Likes,
                                            remove_special_characters)
evaluation_likes_and_wishes$Wishes <- sapply(evaluation_likes_and_wishes$Wishes,
                                             remove_special_characters)

# Convert everything to lower case (to standardize the text)
evaluation_likes_and_wishes$Likes <- sapply(evaluation_likes_and_wishes$Likes,
                                            tolower)
evaluation_likes_and_wishes$Wishes <- sapply(evaluation_likes_and_wishes$Wishes,
                                             tolower)

# After removing special characters and converting everything to lower case
head(evaluation_likes_and_wishes,10)

write.csv(evaluation_likes_and_wishes,
          file = "data/evaluation_likes_and_wishes.csv",
          row.names = FALSE)

# Function to censor/remove unwanted words
undesirable_words <- c("wow", "lol", "none", "na")

# unnest and remove stopwords, undesirable words, and short words
evaluation_likes_filtered <- evaluation_likes_and_wishes %>% # nolint
  unnest_tokens(word, Likes) %>%
  # do not join where the word is in the list of stopwords
  anti_join(stop_words, by = c("word")) %>%
  distinct() %>%
  filter(!word %in% undesirable_words) %>%
  filter(nchar(word) > 3) %>%
  rename(`Likes (tokenized)` = word) %>%
  select(-Wishes)

write.csv(evaluation_likes_filtered,
          file = "data/evaluation_likes_filtered.csv",
          row.names = FALSE)

evaluation_wishes_filtered <- evaluation_likes_and_wishes %>% # nolint
  unnest_tokens(word, Wishes) %>%
  # do not join where the word is in the list of stopwords
  anti_join(stop_words, by = c("word")) %>%
  distinct() %>%
  filter(!word %in% undesirable_words) %>%
  filter(nchar(word) > 3) %>%
  rename(`Wishes (tokenized)` = word) %>%
  select(-Likes)

write.csv(evaluation_wishes_filtered,
          file = "data/evaluation_wishes_filtered.csv",
          row.names = FALSE)

# STEP 4. Load the Required Lexicon (NRC) ----
# Sentiment analysis, also known as opinion mining, is a Natural Language
# Processing (NLP) technique used to determine and extract subjective
# information from text data. The goal of sentiment analysis is to assess and
# quantify the sentiment or emotional tone expressed in a piece of text, such
# as a sentence, paragraph, or document. It involves determining whether the
# text expresses a positive, negative, or neutral sentiment. It can also
# provide a more granular analysis, such as identifying specific emotions like
# joy, anger, sadness, or surprise.

# Methods used to perform sentiment analysis include:
#   (i) training a known dataset
#   (ii) creating your own classifiers with rules
#   (iii) using predefined lexical dictionaries (lexicons).

# There are also different levels of analysis based on the text. These are:
#   (i) document
#   (ii) sentence
#   (iii) word

# We will perform sentiment analysis using lexicons at the word level.

# A lexical dictionary (lexicon), specifically a sentiment lexicon, contains
# words or phrases and assigns sentiment or emotional polarity to each entry.
# Words are typically labeled as positive, negative, neutral, joy, anger,
# sadness, surprise, etc., to aid in sentiment analysis tasks.

# NOTE: No lexicon can have all words, nor should it. Many words are considered
# neutral and would not have an associated sentiment.

## Sample Sentiment Lexicons ----
# 3 common lexicons include:
### NRC ----
# By Mohammad & Turney (2013)
# Assigns words into one or more of the following ten categories:
# positive, negative, anger, anticipation, disgust, fear, joy, sadness,
# surprise, and trust.
nrc <- get_sentiments("nrc")
View(nrc)

### AFINN ----
# Assigns words with a score that runs between -5 and 5. Negative scores
# indicate negative sentiments and positive scores indicate positive sentiments
afinn <- get_sentiments(lexicon = "afinn")
View(afinn)

### Bing ----
# Assigns words into positive and negative categories only
bing <- get_sentiments("bing")
View(bing)

### Loughran ----
# By Loughran & McDonald, (2010)
# The Loughran lexicon is specifically designed for financial text analysis and
# categorizes words into different financial sentiment categories.
loughran <- get_sentiments("loughran")
View(loughran)

# If you get an error locating the Loughran lexicon using the code above,
# then you can download it manually from the University of Notre Dame here:
# URL: https://sraf.nd.edu/loughranmcdonald-master-dictionary/
loughran <- read_csv("data/LoughranMcDonald_MasterDictionary_2018.csv")
View(loughran)

# STEP 5. Inner Join the Likes/Wishes with the Corresponding Sentiment(s) ----
evaluation_likes_filtered_nrc <- evaluation_likes_filtered %>%
  inner_join(get_sentiments("nrc"),
             by = join_by(`Likes (tokenized)` == word),
             relationship = "many-to-many")

evaluation_wishes_filtered_nrc <- evaluation_wishes_filtered %>%
  inner_join(get_sentiments("nrc"),
             by = join_by(`Wishes (tokenized)` == word),
             relationship = "many-to-many")


# ############################### ----
## Pirate Plot from the "yarrr" package ----
# A pirate plot is an advanced method of plotting a continuous dependent
# variable, such as the word count, as a function of a categorical independent
# variable, such as the student's group or gender.
# This combines raw data points, descriptive and inferential statistics into a
# single effective plot.

word_summary <- evaluation_likes_filtered %>%
  group_by(`Student's Gender`) %>%
  mutate(word_count = n_distinct(`Likes (tokenized)`)) %>%
  select(`Likes (tokenized)`, `Student's Gender`, `Class Group`, word_count) %>%
  distinct() %>% # To obtain one record per comment
  ungroup()

pirateplot(formula =  word_count ~ `Student's Gender`,
           data = word_summary,
           xlab = "Gender and Class Group", ylab = "Distinct Word Count",
           main = "Lexical Diversity Per Gender",
           pal = "google", # Color scheme
           point.o = .2, # Points
           avg.line.o = 1, # Turn on the Average/Mean line
           theme = 0, # Theme
           point.pch = 16, # Point `pch` type
           point.cex = 1.5, # Point size
           jitter.val = .1, # Turn on jitter to see the comments better
           cex.lab = .9, cex.names = .7) #Axis label size



# ############################### ----
prince_data <- read.csv('data/prince_new.csv', stringsAsFactors = FALSE, row.names = 1)
glimpse(prince_data) #Transposed version of `print()`
#Created in the first tutorial
undesirable_words <- c("prince", "chorus", "repeat", "lyrics",
                       "theres", "bridge", "fe0f", "yeah", "baby",
                       "alright", "wanna", "gonna", "chorus", "verse",
                       "whoa", "gotta", "make", "miscellaneous", "2",
                       "4", "ooh", "uurh", "pheromone", "poompoom", "3121",
                       "matic", " ai ", " ca ", " la ", "hey", " na ",
                       " da ", " uh ", " tin ", "  ll", "transcription",
                       "repeats", "la", "da", "uh", "ah")

#Create tidy text format: Unnested, Unsummarized, -Undesirables, Stop and Short words
prince_tidy <- prince_data %>%
  unnest_tokens(word, lyrics) %>% #Break the lyrics into individual words
  filter(!word %in% undesirable_words) %>% #Remove undesirables
  filter(!nchar(word) < 3) %>% #Words like "ah" or "oo" used in music
  anti_join(stop_words) #Data provided by the tidytext package

# ############################### ----
word_summary <- prince_tidy %>%
  mutate(decade = ifelse(is.na(decade),"NONE", decade)) %>%
  group_by(decade, song) %>%
  mutate(word_count = n_distinct(word)) %>%
  select(song, Released = decade, Charted = charted, word_count) %>%
  distinct() %>% #To obtain one record per song
  ungroup()

pirateplot(formula =  word_count ~ Released + Charted, #Formula
   data = word_summary, #Data frame
   xlab = NULL, ylab = "Song Distinct Word Count", #Axis labels
   main = "Lexical Diversity Per Decade", #Plot title
   pal = "google", #Color scheme
   point.o = .2, #Points
   avg.line.o = 1, #Turn on the Average/Mean line
   theme = 0, #Theme
   point.pch = 16, #Point `pch` type
   point.cex = 1.5, #Point size
   jitter.val = .1, #Turn on jitter to see the songs better
   cex.lab = .9, cex.names = .7) #Axis label size

# ############################### ----

songs_year <- prince_data %>%
  select(song, year) %>%
  group_by(year) %>%
  summarise(song_count = n())

id <- seq_len(nrow(songs_year))
songs_year <- cbind(songs_year, id)
label_data = songs_year
number_of_bar = nrow(label_data) #Calculate the ANGLE of the labels
angle = 90 - 360 * (label_data$id - 0.5) / number_of_bar #Center things
label_data$hjust <- ifelse(angle < -90, 1, 0) #Align label
label_data$angle <- ifelse(angle < -90, angle + 180, angle) #Flip angle
ggplot(songs_year, aes(x = as.factor(id), y = song_count)) +
  geom_bar(stat = "identity", fill = alpha("purple", 0.7)) +
  geom_text(data = label_data, aes(x = id, y = song_count + 10, label = year, hjust = hjust), color = "black", alpha = 0.6, size = 3, angle =  label_data$angle, inherit.aes = FALSE ) +
  coord_polar(start = 0) +
  ylim(-20, 150) + #Size of the circle
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-4,4), "in"),
        plot.title = element_text(margin = margin(t = 10, b = -10)))

# ############################### ----
my_colors <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7", "#D55E00", "#D65E00")

decade_chart <-  prince_data %>%
  filter(decade != "NA") %>% #Remove songs without release dates
  count(decade, charted)  #Get SONG count per chart level per decade. Order determines top or bottom.

circos.clear() #Very important - Reset the circular layout parameters!
grid.col = c("1970s" = my_colors[1], "1980s" = my_colors[2], "1990s" = my_colors[3], "2000s" = my_colors[4], "2010s" = my_colors[5], "Charted" = "grey", "Uncharted" = "grey") #assign chord colors
# Set the global parameters for the circular layout. Specifically the gap size
circos.par(gap.after = c(rep(5, length(unique(decade_chart[[1]])) - 1), 15,
                         rep(5, length(unique(decade_chart[[2]])) - 1), 15))

chordDiagram(decade_chart, grid.col = grid.col, transparency = .2)
title("Relationship Between Chart and Decade")

# ############################### ----

data(sentiments)
head(sentiments)

new_sentiments <- sentiments %>% #From the tidytext package
  group_by(sentiment) %>%
  mutate(words_in_lexicon = n_distinct(word)) %>%
  ungroup()

new_sentiments %>%
  group_by(sentiment, words_in_lexicon) %>%
  summarise(distinct_words = n_distinct(word)) %>%
  ungroup() %>%
  spread(sentiment, distinct_words) %>%
  # mutate(sentiment = color_tile("lightblue", "lightblue")(sentiment),
  #        words_in_lexicon = color_bar("lightpink")(words_in_lexicon)) %>%
  kable_theme(caption = "Word Counts Per Lexicon")


# ############################### ----
install.packages("textdata", dependencies=TRUE)
AFINN <- get_sentiments("afinn") %>%
  select(word, afinn_score = value)

# ############################### ----

prince_nrc <- prince_tidy %>%
  inner_join(get_sentiments("nrc"),
             by = join_by(word == word),
             relationship = "many-to-many")

# ############################### ----

# [OPTIONAL] **Deinitialization: Create a snapshot of the R environment ----
# Lastly, as a follow-up to the initialization step, record the packages
# installed and their sources in the lockfile so that other team-members can
# use renv::restore() to re-install the same package version in their local
# machine during their initialization step.
# renv::snapshot() # nolint

# References ----
## Ashton, D., Porter, S., library), N. D. (chart js, library), T. L. (chart js, & library), W. E. (chart js. (2016). radarchart: Radar Chart from ‘Chart.js’ (0.3.1) [Computer software]. https://cran.r-project.org/package=radarchart # nolint ----

## Auguie, B., & Antonov, A. (2017). gridExtra: Miscellaneous Functions for ‘Grid’ Graphics (2.3) [Computer software]. https://cran.r-project.org/package=gridExtra # nolint ----

## Bevans, R. (2023b). Sample Crop Data Dataset for ANOVA (Version 1) [Dataset]. Scribbr. https://www.scribbr.com/wp-content/uploads//2020/03/crop.data_.anova_.zip # nolint ----

## Csárdi, G., Nepusz, T., Traag, V., Horvát, S., Zanini, F., Noom, D., Müller, K., Salmon, M., & details, C. Z. I. igraph author. (2023). igraph: Network Analysis and Visualization (1.5.1) [Computer software]. https://cran.r-project.org/package=igraph # nolint ----

## Gu, Z., Gu, L., Eils, R., Schlesner, M., & Brors, B. (2014). Circlize Implements and Enhances Circular Visualization in R. Bioinformatics (Oxford, England), 30(19), 2811–2812. https://doi.org/10.1093/bioinformatics/btu393 #nolint ----

## Gu, Z. (2022). circlize: Circular Visualization (0.4.15) [Computer software]. https://cran.r-project.org/package=circlize # nolint ----

## Lang, D., & Chien, G. (2018). wordcloud2: Create Word Cloud by ‘htmlwidget’ (0.2.1) [Computer software]. https://cran.r-project.org/package=wordcloud2 # nolint ----

## Leonawicz, M. (2023). memery: Internet Memes for Data Analysts (0.5.7) [Computer software]. https://cran.r-project.org/package=memery # nolint ----

## Mohammad, S. M., & Turney, P. D. (2013). Crowdsourcing a Word-Emotion Association Lexicon. Computational Intelligence, 29(3), 436–465. https://doi.org/10.1111/j.1467-8640.2012.00460.x # nolint ----

## Ooms, J. (2023). magick: Advanced Graphics and Image-Processing in R (2.7.5) [Computer software]. https://cran.r-project.org/package=magick # nolint ----

## Pedersen, T. L., & RStudio. (2022). ggraph: An Implementation of Grammar of Graphics for Graphs and Networks (2.1.0) [Computer software]. https://cran.r-project.org/package=ggraph # nolint ----

## Phillips, N. (2017). yarrr: A Companion to the e-Book ‘YaRrr!: The Pirate’s Guide to R’ (0.1.5) [Computer software]. https://cran.r-project.org/package=yarrr # nolint ----

## Queiroz, G. D., Fay, C., Hvitfeldt, E., Keyes, O., Misra, K., Mastny, T., Erickson, J., Robinson, D., Silge  [aut, J., & cre. (2023). tidytext: Text Mining using ‘dplyr’, ‘ggplot2’, and Other Tidy Tools (0.4.1) [Computer software]. https://cran.r-project.org/package=tidytext # nolint ----

## Ren, K., & Russell, K. (2021). formattable: Create ‘Formattable’ Data Structures (0.2.1) [Computer software]. https://cran.r-project.org/package=formattable # nolint ----

## Robinson, D., Misra, K., Silge  [aut, J., & cre. (2022). widyr: Widen, Process, then Re-Tidy Data (0.1.5) [Computer software]. https://cran.r-project.org/package=widyr # nolint ----

## Slowikowski, K., Schep, A., Hughes, S., Dang, T. K., Lukauskas, S., Irisson, J.-O., Kamvar, Z. N., Ryan, T., Christophe, D., Hiroaki, Y., Gramme, P., Abdol, A. M., Barrett, M., Cannoodt, R., Krassowski, M., Chirico, M., & Aphalo, P. (2023). ggrepel: Automatically Position Non-Overlapping Text Labels with ‘ggplot2’ (0.9.3) [Computer software]. https://cran.r-project.org/package=ggrepel # nolint ----

## Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., Posit, & PBC. (2023). ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics (3.4.3) [Computer software]. https://cran.r-project.org/package=ggplot2 # nolint ----

## Wickham, H., François, R., Henry, L., Müller, K., Vaughan, D., Software, P., & PBC. (2023). dplyr: A Grammar of Data Manipulation (1.1.3) [Computer software]. https://cran.r-project.org/package=dplyr # nolint ----

## Wickham, H., Vaughan, D., Girlich, M., Ushey, K., Posit, & PBC. (2023). tidyr: Tidy Messy Data (1.3.0) [Computer software]. https://cran.r-project.org/package=tidyr # nolint ----

## Xie  [aut, Y., cre, Sarma, A., Vogt, A., Andrew, A., Zvoleff, A., Al-Zubaidi, A., http://www.andre-simon.de), A. S. (the C. files under inst/themes/ were derived from the H. package, Atkins, A., Wolen, A., Manton, A., Yasumoto, A., Baumer, B., Diggs, B., Zhang, B., Yapparov, B., Pereira, C., Dervieux, C., Hall, D., … PBC. (2023). knitr: A General-Purpose Package for Dynamic Report Generation in R (1.44) [Computer software]. https://cran.r-project.org/package=knitr # nolint ----

## Zhu  [aut, H., cre, Travison, T., Tsai, T., Beasley, W., Xie, Y., Yu, G., Laurent, S., Shepherd, R., Sidi, Y., Salzer, B., Gui, G., Fan, Y., Murdoch, D., & Evans, B. (2021). kableExtra: Construct Complex Table with ‘kable’ and Pipe Syntax (1.3.4) [Computer software]. https://cran.r-project.org/package=kableExtra # nolint ----

# **Required Lab Work Submission** ----

# NOTE: The lab work should be done in groups of between 2 and 5 members using
#       Git and GitHub.

## Part A ----
# Create a new file in the project's root folder called
# "Lab2-Submission-ExploratoryDataAnalysis.R".
# Use this file to provide all the code you have used to perform an exploratory
# data analysis of the "Class Performance Dataset" provided on the eLearning
# platform.

## Part B ----
# Upload *the link* to your "Lab2-Submission-ExploratoryDataAnalysis.R" hosted
# on Github (do not upload the .R file itself) through the submission link
# provided on eLearning.

## Part C ----
# Create a markdown file called "Lab-Submission-Markdown.Rmd"
# and place it inside the folder called "markdown". Use R Studio to ensure the
# .Rmd file is based on the "GitHub Document (Markdown)" template when it is
# being created.

# Refer to the following file in Lab 1 for an example of a .Rmd file based on
# the "GitHub Document (Markdown)" template:
#     https://github.com/course-files/BBT4206-R-Lab1of15-LoadingDatasets/blob/main/markdown/BIProject-Template.Rmd # nolint

# Include Line 1 to 14 of BIProject-Template.Rmd in your .Rmd file to make it
# displayable on GitHub when rendered into its .md version

# It should have code chunks that explain only *the most significant*
# analysis performed on the dataset.

# The emphasis should be on Explanatory Data Analysis (explains the key
# statistics performed on the dataset) as opposed to
# Exploratory Data Analysis (presents ALL the statistics performed on the
# dataset). Exploratory Data Analysis that presents ALL the possible statistics
# re-creates the problem of information overload.

## Part D ----
# Render the .Rmd (R markdown) file into its .md (markdown) version by using
# knitR in RStudio.

# You need to download and install "pandoc" to render the R markdown.
# Pandoc is a file converter that can be used to convert the following files:
#   https://pandoc.org/diagram.svgz?v=20230831075849

# Documentation:
#   https://pandoc.org/installing.html and
#   https://github.com/REditorSupport/vscode-R/wiki/R-Markdown

# By default, Rmd files are open as Markdown documents. To enable R Markdown
# features, you need to associate *.Rmd files with rmd language.
# Add an entry Item "*.Rmd" and Value "rmd" in the VS Code settings editor.

# Documentation of knitR: https://www.rdocumentation.org/packages/knitr/

# Upload *the link* to "Lab-Submission-Markdown.md" (not .Rmd)
# markdown file hosted on Github (do not upload the .Rmd or .md markdown files)
# through the submission link provided on eLearning.

