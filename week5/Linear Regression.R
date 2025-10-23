library(tidyverse)
library(broom)
library(dplyr)

setwd("/Users/cmdb/qb25-answers/week4")



#Exercise 1
mutation <- tibble(read.csv("aau1043_dnm.csv"))
parent_age <- tibble(read.csv("aau1043_parental_age.csv"))
                        

glimpse(mutation)

mutation_summary <- mutation %>% filter(Phase_combined == "father" | Phase_combined == "mother") %>% group_by(Phase_combined, Proband_id) %>% count()
print(mutation_summary)

data <- left_join(mutation_summary, parent_age, by = "Proband_id" )


#Exercise 2
ex2_a <- ggplot(data = data %>% filter(Phase_combined == "mother"), aes(x = Mother_age, y = n)) + geom_point(color = "pink") + labs(title = "Maternal age vs # of DNMs", y = "# of DNMs", x = "Maternal age")
ggsave("ex2_a.png", plot = ex2_a )

ex2_b<- ggplot(data = data %>% filter(Phase_combined == "father"), aes(x = Father_age, y = n)) + geom_point(color = "lightblue") + labs(title = "Paternal age vs # of DNMs", y = "# of DNMs", x = "Paternal age")
ggsave("ex2_b.png", plot = ex2_b )

data_mother <- data %>% filter(Phase_combined == "mother")
lm(data = data_mother, formula = n ~ 1 + Mother_age) %>% summary()
#slope is 0.38, this is the correlation between the age and the number of de novo mutations
##on average there are 0.38 de novo mutations per year
#this relationship is significant, as the p-value rejects the null hypothesis
##the p-value is the probability that the correlations you are seeing are happening by random chance if there is no real difference, in this case this means the random rate is significantly low (2.2e-16), so we do think the relationship is real and null is rejected.

data_father <- data %>% filter(Phase_combined == "father")
lm(data = data_father, formula = n ~ 1 + Father_age) %>% summary()
#slope is 1.35, this means there are 1.35 de novo mutations accumulating with 1 year in
#p-value is the same, reject the null


#predict 50.5 year old father:
prediction = B0(intercept) + B1
y=mx+b
count=slope(age) + intercept
1.35*50.5 + 10.32 #78.495 DNMs

ex2_c <- ggplot() + geom_histogram(data = data_mother, aes(x = n, fill = "mother"), alpha = 0.5) +
  geom_histogram(data = data_father, aes(x = n, fill = "father"), alpha = 0.5) +
  labs(title = "Distribution of Maternal vs Paternal DNMs", x = "Number of DNMs", y = "Frequency") + scale_fill_manual(values = c("mother" = "pink", "father" = "lightblue")) 
ggsave("ex2_c.png", plot = ex2_c )

t.test(data_mother$n, data_father$n, paired = TRUE)
#2.6.1 Mothers on average have 39.23 less de novo mutations than fathers. This matches with my graph in ex2_c. 
#2.6.2 The difference is significant, with a p value (chance that our observations are occuring due to random chance) of less than 2.2e-16. Typically a significant value is if p < 0.05, or less than 5% chance observation is random.


difference <- data %>% group_by(Proband_id) %>% mutate(difference = n[Phase_combined == "mother"] - n[Phase_combined == "father"])
lm(difference ~ 1, data = difference) %>% summary()
#2.6.3 The intercept estimate is -39.23, which is the mean difference between the maternal and paternal de novo mutation counts. This is identical to the t-test results.



#Exercise 3
##Dungeons and Dragons Monsters (2024)
install.packages("tidytuesdayR")
tuesdata <- tidytuesdayR::tt_load(2025, week = 21)
monsters <- tuesdata$monsters


#Which monsters are the strongest on average?
strength <- monsters %>% group_by(type) %>% summarize(avg_strength = mean(str, na.rm = TRUE)) %>% arrange(desc(avg_strength))
strength_graph <- ggplot(strength, aes(x= reorder(type,avg_strength), y = avg_strength, fill = type)) +   geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Average Strength by Monster Type", x = "Monster Type", y = "Average Strength")
ggsave("ex3_strength.png", plot = strength_graph)

#Which monsters are the most intelligent on average?
intelligence <- monsters %>% group_by(type) %>% summarize(avg_int = mean(int, na.rm = TRUE)) %>% arrange(desc(avg_int))
intelligence_graph <- ggplot(intelligence, aes(x= reorder(type,avg_int), y = avg_int, fill = type)) +   geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Average Intelligence by Monster Type", x = "Monster Type", y = "Average Intelligence")
ggsave("ex3_intelligence.png", plot = intelligence_graph)

#is there a relationship between intelligence and strength?
lm(str ~ int, data = monsters) %>% summary()
#Yes, the p-value is 2.41e-12, which means that intelligence significantly predicts strength in monsters. For each point in intelligence there is an increase in strength by 0.43.


#Which dragons are the most intelligent?
dragons <- monsters %>% filter(type == "Dragon")
dragon_intelligence <- dragons %>% group_by(category) %>% summarize(avg_int = mean(int, na.rm = TRUE)) %>% arrange(desc(avg_int))

dragon_graph <- ggplot(dragon_intelligence, aes(x= reorder(category,avg_int), y = avg_int, fill = category)) + geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Average Intelligence by Dragon Type", x = "Dragon Type", y = "Average Intelligence")
ggsave("ex3_dragons.png", plot = dragon_graph)

#does dragon category have an effect on intelligence

lm(int ~ category, data = dragons) %>% summary()
#Yes. Copper and green dragons have higher average intelligence while White dragons and wyverns have lower average intelligence.
#p-value is 6.052e-05
