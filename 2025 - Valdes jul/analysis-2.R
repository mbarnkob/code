#Valdes jul kort analse

## 0) Pakker

library(readr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(patchwork)

## 1) Læs data
setwd("~/Dropbox/Projekter/2025 - Analyse af Valdes jul kort") # <- MAC
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

#begge sammen:
p1 + p2

# 5) Monte-carlo analyse af om kort reelt er outliers

risk_card <- 0.034 #1 symbol gruppe gennemsnit frekvens
risk_notcard <- (1-risk_card)
risk_card + risk_notcard #check numbers. Should = 1
num_in_trial = (sum(df$Antal)) #total antal kort indtil videre 
num_of_trials = 10000 #antal gange vi simulerer dette

#Monte Carlo test: chance of two outcomes, card or not card - here represented as 1 or 2.
n <- num_of_trials
sim_pop <- vector("numeric", n)
for (i in 1:n)
{  
  x <- sample(c(1, 2), size = num_in_trial, replace = TRUE, prob = c(risk_card, risk_notcard))
  sim_pop[i] <- sum(x == 1) #count number of cards, eg 1's
}

#Visualize - ggplot for dice examples
df_sim_pop <- as.data.frame(sim_pop)
qts <- quantile(sim_pop,probs=c(.025,.975))

p3 <- ggplot(df_sim_pop, aes(x=sim_pop)) +
  geom_histogram(binwidth = 1, fill="deepskyblue4", col="white") +
  geom_vline(xintercept=qts[1], linetype="dashed", color = "red") +
  geom_vline(xintercept=qts[2], linetype="dashed", color = "red") +
  xlab("Antal ud af 652 tilfældige kort") +
  ylab("Antal simulationer") +
  ggtitle(label = paste("Simuleret fordeling af symbol 1 kort in ", count(df_sim_pop), " simulations"),
          subtitle = paste("Chance for at få kort = ", format(risk_card*100, scientific = FALSE), "%. Antal kort samlet = ", num_in_trial))

p3

#visualiser symbol 1 distribution
df_1symbol <- df[df$Antal_symboler == 1, ]

p4 <- ggplot(df_1symbol, aes(x=Antal)) +
  geom_histogram(binwidth = 1, fill="deepskyblue4", col="white") +
  geom_vline(xintercept=qts[1], linetype="dashed", color = "red") +
  geom_vline(xintercept=qts[2], linetype="dashed", color = "red") +
  xlab("Reel fordeling af kort indsamlet") +
  ylab("") +
  ggtitle(label = paste("Antal symbol 1 kort indsamlet"),
          subtitle = paste("Chance for at få kort = ", format(risk_card*100, scientific = FALSE), "%. Antal kort samlet = ", num_in_trial))

p4

p3 + p4
