library(dplyr)
library(ggplot2)

# Read the CSV file
data <- read.csv("/app/data.csv")

# Group by Species and Calculate Mean Weight
species_mean_weight <- data %>%
    group_by(Species) %>%
    summarise(MeanWeight = mean(Weight))

write.csv(species_mean_weight, "/app/5_R_outputs.txt")

# Perform additional analysis and save results to