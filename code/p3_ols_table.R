dir <- "/Users/tombearpark/Documents/GitHub/geo366/"

# Load required packages
if(!require(pacman)) install.packages("pacman")
pacman::p_load('tidyverse', 'fixest')

# Load data 
df <- read_csv(paste0(dir, "assets/GrowthClimateDataset.csv"))

# Clean variables a tiny bit
df <- df %>% 
  filter(!is.na(growthWDI), !is.na(UDel_temp_popweight)) %>% 
  mutate(temp1 = UDel_temp_popweight,
         temp2   = temp1 * temp1, 
         precip1  = UDel_precip_popweight / 1000, 
         precip2 = precip1 * precip1) %>% 
  rename(y = growthWDI, country = countryname) 

# Run regressions
m0 <- feols(y ~ temp1, df, se = "hetero")
m1 <- feols(y ~ temp1 + precip1, df, se = "hetero")

# Output a table
etable(m0, m1)
