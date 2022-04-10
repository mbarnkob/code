#Risk of death simulations

#Background death in study period
risk_of_death <- (16/21888) #placebo group deaths
risk_of_living <- (1-risk_of_death)
risk_of_death + risk_of_living #check numbers. Should = 1
num_in_trial = 21895 #number of participants in vaccine-group
num_of_trials = 10000

#Monte Carlo test: chance of two outcomes, death or living - here represented as 1 or 2.
set.seed(20220408)
n <- num_of_trials
sim_pop <- vector("numeric", n)
for (i in 1:n)
{  
  x <- sample(c(1, 2), size = num_in_trial, replace = TRUE, prob = c(risk_of_death, risk_of_living))
  sim_pop[i] <- sum(x == 1) #count number of deaths, eg 1's
}

#Calc and visualization

calc_lower = mean(sim_pop) - (1.960*sd(sim_pop))
calc_upper = mean(sim_pop) + (1.960*sd(sim_pop))
df_sim_pop <- as.data.frame(sim_pop)

ggplot(df_sim_pop, aes(x=sim_pop)) +
  geom_histogram(binwidth = 1, fill="deepskyblue4", col="white") +
  geom_vline(xintercept=calc_lower, linetype="dashed", color = "red") +
  geom_vline(xintercept=calc_upper, linetype="dashed", color = "red") +
  xlab("Number of deaths") +
  ylab("Number of simulation") +
  ggtitle(label = paste("Number of deaths in ", count(df_sim_pop), " simulations"),
          subtitle = paste("Control group risk of death = ", format(risk_of_death*100, scientific = FALSE), "%"))

#For counting
calc_lower
calc_upper
sort(table(sim_pop))
sum(sim_pop < 4)/num_of_trials  #count number of trials with less then 4 deaths in current simulation 
