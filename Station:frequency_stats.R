library(datapasta)
library(tidyverse)
library(tibble)
library(ggplot2)
library(RColorBrewer)

Station_stats <- tibble::tribble(
                     ~Station, ~Frequency, ~Group,
              "Mound Inshore",      9202L,     5L,
             "Mound Offshore",     10389L,     5L,
                 "MPA Corner",      2518L,     6L,
                       "SB-1",      8305L,     5L,
                       "SB-2",      3740L,     2L,
                       "SB-3",      1549L,     1L,
                       "SB-4",       354L,     1L,
                       "SB-5",       162L,     4L,
                       "SB-6",       210L,     7L,
                       "SB-7",       285L,     7L,
                       "SB-8",       713L,     6L,
                       "SB-9",     16787L,     6L,
                     "SB-9.5",     20134L,     3L,
                      "SB-10",     36353L,     5L,
                      "Sutil",        17L,     7L,
                    "UW Arch",        24L,     1L,
                       "WR-C",       227L,     1L,
                       "WR-E",        41L,     1L,
                       "WR-W",        10L,     1L
             )

head(Station_stats)


Station_stats %>% 
  ggplot(aes(x=reorder(Station, -Group), y=Frequency, fill = factor(Group))) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold")) +
  scale_x_discrete(name = "Station") +
  scale_fill_brewer(palette="Blues") +
  theme(panel.background = element_rect(fill = 'lightgrey', colour = 'black')) +
  labs(fill = "Grouping")
  

levels(Station_stats)

res.aov <- aov(~Frequency ~ Group, data = Station_stats)
summary(res.aov)
plot(res.aov, 2)
aov_residuals <- residuals(object = res.aov)
shapiro.test(x=aov_residuals)
kruskal.test(Frequency ~ Group, data = Station_stats)

