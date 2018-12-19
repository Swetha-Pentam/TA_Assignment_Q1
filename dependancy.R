if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}

library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

ud_model_english <- udpipe_download_model(language = "english")  # 3.05 secs
ud_model_spanish <- udpipe_download_model(language = "spanish")  #  secs
ud_model_hindi <- udpipe_download_model(language = "hindi")

