#Valdes jul kort analse

## 0) Pakker

library(readr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(patchwork)

## 1) Læs data
setwd("~/Desktop") # <- MAC
df <- read.csv2("kort_11dec.csv", 
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

p1 <- ggplot(df, aes(
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

p1

# 4) Analyse uden kort 38, 35, 3, 9, 26 og 33

uden_underlige_kort <- c(38, 35, 3, 9, 26, 33)

df_uden <- df %>%
  filter(!Kort_nr %in% uden_underlige_kort)

df_uden %>%
  group_by(Antal_symboler) %>%
  summarise(
    mean_frequency  = mean(frequency, na.rm = TRUE),
    median_frequency = median(frequency, na.rm = TRUE),
    count = n()
  )

sum(df_uden$Antal)

pos <- position_jitter(width = 0.3, seed = 2)

p2 <- ggplot(df_uden, aes(
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
    title = "Uden outlier kort",
    color = "Antal symboler"
  )

p2

#vis begge plots sammen:
p1 + p2

