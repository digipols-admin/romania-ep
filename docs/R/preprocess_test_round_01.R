# Create Round 1 party data
library(tidyverse)
library(googledrive)
library(readxl)
library(here)

# check google 
drive_ls(n=3)

# Set the folder ID
folder_id <- "1aofkAx5VdE1EAsdZO6lFGw_z5tGceZLH"

# List all files in the folder
files <- drive_ls(as_id(folder_id), type = "xlsx")

# Download files
# lapply(files$id, function(id) {
#   drive_download(as_id(id), path = paste0("~/digipols/romania-ep/data/round_01/", drive_get(as_id(id))$name))
# })

# Download files using `purrr::map` instead of `lapply`
files$id %>%
  map(~ drive_download(as_id(.x), 
                       path = paste0("~/digipols/romania-ep/data/round_01/",
                                     drive_get(as_id(.x))$name)))




# List downloaded Excel files
file_paths <- list.files("~/digipols/romania-ep/data/round_01/", 
                         pattern = "\\.xlsx$", full.names = TRUE)


# Read and merge all files using `purrr::map_df` to automatically combine them
df <- map_df(file_paths, ~ read_excel(.x) %>%
                     mutate(file_name = basename(.x))) %>% 
  select(1:9) %>% 
  mutate(
    file_name = str_remove(file_name,".xlsx")) %>% 
  separate(file_name, into = c("coder", "party"), sep = "_")

save(df,file = here("data/round_01/df.rda"))


