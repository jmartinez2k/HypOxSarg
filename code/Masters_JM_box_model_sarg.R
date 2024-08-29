# Box Model to Predict Changes in Oxygen Under Increasing Sargassum Biomass and Warming 
# Updated by: Jose Martinez 
# Based on box model written by: Andreas Andersson and Ariel Pezner in 2023
# Last updated: 26 August 2024


library(tidyverse)
library(ggplot2)
library(plotly)
library(dplyr)
library(patchwork)
library(deSolve)
library(oce)
library(respR)


source('C:\\Users\\jamar\\Documents\\R\\UPRM_Masters_Thesis_JM\\calcDOatsat.R') 
source("C:/Users/jamar/Documents/R/UPRM_Masters_Thesis_JM/reefo2dif_JM.R")




# Initialize empty matrices/vectors and scalar variables
num_i <- length(seq(1, 5, by = 4))  # Number of iterations for i
num_j <- length(seq(0, 6, by = 3))
num_k <- length(seq(0, 250, by = 50))# Number of iterations for j


# Adjust the size of matrices and lists
meanO2 <- array(NA, dim = c(num_j, num_i, num_k))  # Initialize mean dissolved oxygen matrix
dresp <- array(NA, dim = c(num_j, num_i, num_k))    # Initialize % change in respiration rate matrix
O2data <- vector("list", length = num_i * num_j * num_k)  # Initialize list for dissolved oxygen data


n <- 1  # Initialize a scalar variable for tracking sensitivity runs

# initialize dataframe for plotting all temp and tau scenarios 
all_results_df <- data.frame(tv = numeric(0), O2 = numeric(0), temp = numeric(0), tau = numeric(0))


for (i in seq(1, 5, by = 4)) {
  tau <-   i
  m <- 1
  
  # Loop for different respiration rates
  for (j in seq(0, 3, by = 3)) {
    # Set up initial variables
    t0 <- 0
    tfinal <- 336
    tspan <- seq(t0, tfinal, by = 0.5)
    temp <- 28 + j
    sal <- 33.1375
    
    #for (k in seq(0, 5000, by = 1250)) {
    for (k in seq(0, 10e+6, by = 1e+6)) {
      sarg <- 0 + k 
      o2_sol <- calcDOatsat_GG(temp, sal)
      reefvol <- 1000
      reefo2 <- o2_sol
      oceanO2 <- o2_sol
      F0 <- reefo2 * 1e-06 * reefvol
    
    # Q10 calculations
      #mol/m2/hr per mg *[sargassum (mg)] by dividing per 5 days # assuming the model uses mol instead of mmol
      sarg_resp = (4.95E-6 * 1e-03)*sarg  
      Q10 <- 2
      R1 <- 12 * 1e-03 + sarg_resp 
      resp <- R1 * Q10^((j) / 10)  
      Rper <- (resp - R1) / R1 * 100
    # Set up parameters
      parms <- list(
        oceanO2 = oceanO2, #o2_sol
        reefvol = reefvol,
        tau = tau
    )
    
    # Solve the differential equation
      result <- ode(y = F0, times = tspan, func = reefo2dif_JM, parms = parms)
    # Extract the results
      tv <- result[, "time"]
      F <- result[, "1"]
    # Create a data frame for the results
    
    
    # Calculate dissolved oxygen
      O2 <- F / parms$reefvol * 1e+06
    
      result_df <- data.frame(tv = result[, "time"], O2 = O2, temp = temp) # for plottnig
    
    # Save each run of dissolved oxygen data (O2) to the O2data list
      O2data <- c(O2data, list(O2))

    
    # Adding na.rm = TRUE to handle missing values
    # Store the minimum oxygen concentration value along with tau and temp values
    # Extract the results and add to the all_results_df data frame
      together_df <- data.frame(tv = result[, "time"], O2 = O2, temp = temp, tau = tau, sarg = sarg) # for plotting
      all_results_df <- rbind(all_results_df, together_df) # for plotting
    
      last_4_days <- all_results_df %>% # Filter the data frame to include only the last 4 days (hours 240 to 336)
        filter(tv >= 240 & tv <= 336)
    
      min_O2_per_day <- last_4_days %>%
        mutate(day = as.integer(tv / 24) - 10) %>%  # Subtracting 9 to index the days from 1 to 4
        group_by(day,tau,temp,sarg) %>%
        summarize(min_O2 = min(O2, na.rm = TRUE)) %>%
        mutate(sarg_kg = sarg / 1e+6)
      
      # Apply conversion to the data
      min_O2_per_day <- min_O2_per_day %>%
        rowwise() %>%
        mutate(min_O2_mg_L = convert_DO(min_O2, from = "umol/kg", to = "mg/L", S = sal, t = temp, P = 1.013253))  # Assuming salinity is constant
    
      m <- m + 1
  }
    n = n+1
  }
  
}


# Plot of all model data

together_DO_Model = ggplot(all_results_df, aes(x = tv, y = O2, color = factor(temp), linetype = factor(tau), shape = factor(sarg))) +
  geom_line() +
  labs(x = "Hour", y =  expression("Dissolved Oxygen (" * mu * "mol kg"^-1 * ")")) +
  scale_color_discrete(name = "Temperature", labels = c("25°C", "28°C", "31°C")) +
  scale_linetype_manual(name = "Residence Time", values = c("1" = "solid", "5" = "dashed", "10" = "dotted"), labels = c("1 hr", "5 hr","10 hr")) +
  theme_minimal()

together_DO_Model

# Nightly Minimum DO plot of last 4 days

min_DO_Model <- ggplot(min_O2_per_day, aes(x = sarg_kg, y = jitter(min_O2), color = factor(temp), shape = factor(tau))) +
  geom_point(size = 2) +
  #geom_line(aes(y = min_O2, x = sarg_kg), color = factor(temp), shape = factor(tau)) +
  geom_hline(yintercept = 61, linetype = "dashed", color = "#e31a1c") +
  geom_hline(yintercept = 92, linetype = "dashed", color = "#969696") +
  geom_hline(yintercept = 122, linetype = "dashed", color = "#bdbdbd") +
  geom_hline(yintercept = 153, linetype = "dashed", color = "#d9d9d9") +
  ylim(0, NA) +
  labs(x = "Sargassum (kg)", y = expression("Daily Min Dissolved Oxygen (" * mu * "mol kg"^-1 * ")")) +
  #scale_color_manual(name = "Temperature", values = c("#8856a7", "#31a354"), labels = c("28°C", "31°C")) +
  scale_color_manual(name = "Temperature", values = c("#2166ac", "#ef8a62"), labels = c("28°C", "31°C")) +
  #scale_shape_manual(name = "Residence Time", values = c("1" = 1, "5" = 16), labels = c("1 hr", "5 hr")) +
  scale_shape_manual(name = "Residence Time", values = c("1" = 1, "5" = 16,"10" = 2), labels = c("1 hr", "5 hr","10 hr")) +
  theme_minimal()

min_DO_Model


