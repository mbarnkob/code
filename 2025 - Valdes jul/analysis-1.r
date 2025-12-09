#Valdes jul kort analse

## 0) Pakker

library(readr)
library(dplyr)
library(ggplot2)
library(ggrepel)

## 1) Læs data
setwd("~/Dropbox/Projekter/2025 - Analyse af Valdes jul kort") # <- MAC
df <- read.csv2("kort_7dec.csv", 
                as.is = TRUE, 
                header = TRUE, 
                sep = ";", 
                row.names = NULL, 
                stringsAsFactors = FALSE)

## 2) Udregn frekvens og gennemsnit

df <- df %>%
  mutate(frequency = Antal / sum(Antal) * 100)

df %>%
  group_by(Antal_symboler) %>%
  summarise(
    mean_frequency  = mean(frequency, na.rm = TRUE),
    median_frequency = median(frequency, na.rm = TRUE),
    count = n()
  )

sum(df$Antal)

# 3) Visualisering af data

pos <- position_jitter(width = 0.3, seed = 2)

ggplot(df, aes(
  x = factor(Antal_symboler),
  y = frequency,
  label = Kort_nr,
  color = factor(Antal_symboler)
)) +
  geom_jitter(size = 3, position = pos) +
  stat_summary(
    fun = mean,
    geom = "crossbar",
    width = 0.6,
    color = "red",
    size = 0.8
  ) +
 geom_text_repel(position = pos, size = 3, box.padding = 0.5, max.overlaps = Inf, min.segment.length = 0) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    x = "Antal symboler på kort",
    y = "Sandsynlighed (%)",
    title = "Hvor sandsynligt er det at få et Valdes Jul kort?",
    color = "Antal symboler"
  )
