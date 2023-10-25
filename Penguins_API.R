# --- Packages ---
# For the data
library(palmerpenguins)

# For the model
library(tidyverse)
library(parsnip)
library(ranger)

# For the API
library(plumber)

# data
d <- penguins

# model
model <- rand_forest() %>%
  set_engine("ranger") %>%
  set_mode("classification") %>%
  fit(species ~ bill_length_mm + bill_depth_mm +
        flipper_length_mm + body_mass_g, data = penguins)


pred_peng <- function(bill_len, bill_dep, flipp_len, bodmass){
  predict(model, new_data = data.frame(bill_length_mm = as.numeric(bill_len), 
                                       bill_depth_mm = as.numeric(bill_dep), 
                                       flipper_length_mm = as.numeric(flipp_len), 
                                       body_mass_g = as.numeric(bodmass)), type = "prob")
}


# API
#* Health Check - Is the API running
#* @get /health-check
status <- function(){
  list(
    status = "All good",
    time = Sys.time()
  )
}


#* Predict species for new penguins
#* @param bill_len The bill length of the penguin in mm
#* @param bill_dep The bill depth of the penguin in mm
#* @param flipp_len The flipper length of the penguin in mm
#* @param bodmass The body mass of the penguin in g
#* @post /predict
function(bill_len, bill_dep, flipp_len, bodmass){
  predict(model, new_data = data.frame(bill_length_mm = as.numeric(bill_len), 
                                       bill_depth_mm = as.numeric(bill_dep), 
                                       flipper_length_mm = as.numeric(flipp_len), 
                                       body_mass_g = as.numeric(bodmass)), type = "prob")
}

# 
# #* Return the sum of two numbers
# #* @param a The first number to add
# #* @param b The second number to add
# #* @post /sum
# function(a, b) {
#   as.numeric(a) + as.numeric(b)
# }


