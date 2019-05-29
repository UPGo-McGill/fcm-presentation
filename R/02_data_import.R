### New daily and property file imports

library(tidyverse)
library(sf)


## Raw daily file import
#daily <- read_csv(
#  "data/ca_Daily_Match_2019-05-28.csv", 
#  col_types = cols_only(
#    `Property ID` = col_character(),
#    Date = col_date(format = ""),
#    Status = col_factor(levels = c("U", "B", "A", "R")),
#    `Price (USD)` = col_double(),
#    `Airbnb Property ID` = col_double(),
#    `HomeAway Property ID` = col_character())) %>% 
#  set_names(
#    c("Property_ID", "Date", "Status", "Price", "Airbnb_PID",
#      "HomeAway_PID")) %>% 
#  filter(!(is.na(Status) | is.na(Property_ID) | is.na(Date))) %>% 
#  arrange(Property_ID)

## Processed daily file import
daily <- read_csv("data/Canada_daily_2019.csv",
                  col_types = cols(
                    Property_ID = col_character(),
                    Date = col_date(format = ""),
                    Status = col_factor(levels = c("U", "B", "A", "R")),
                    Price = col_double(),
                    Airbnb_PID = col_double(),
                    HomeAway_PID = col_character(),
                    Listing_Type = col_factor(),
                    Created = col_date(format = ""),
                    Scraped = col_date(format = ""),
                    Airbnb_HID = col_double(),
                    HomeAway_HID = col_character(),
                    winner = col_double()
                  ))

property <- read_csv(
  "data/ca_Property_Match_2019-05-28.csv",
  col_type = cols_only(
    `Property ID` = col_character(),
    `Listing Title` = col_character(),
    `Property Type` = col_character(),
    `Listing Type` = col_factor(),
    `Created Date` = col_date(format = ""),
    `Last Scraped Date` = col_date(format = ""),
    Latitude = col_double(),
    Longitude = col_double(),
    `Airbnb Property ID` = col_double(),
    `Airbnb Host ID` = col_double(),
    `HomeAway Property ID` = col_character(),
    `HomeAway Property Manager` = col_character())) %>% 
  set_names(
    c("Property_ID", "Listing_Title", "Property_Type", "Listing_Type",
      "Created", "Scraped", "Latitude", "Longitude", "Airbnb_PID", "Airbnb_HID",
      "HomeAway_PID", "HomeAway_HID")) %>% 
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_transform(3347) %>% 
  filter(Property_Type %in% c(
    "House", "Private room in house", "Apartment", "Cabin",
    "Entire condominium", "Townhouse", "Condominium", "Entire apartment",
    "Private room", "Loft", "Place", "Entire house", "Villa", "Guesthouse",
    "Private room in apartment", "Guest suite", "Shared room in dorm",
    "Chalet", "Dorm", "Entire chalet", "Shared room in loft", "Cottage",
    "Resort", "Serviced apartment", "Other", "Bungalow", "Farm stay",
    "Private room in villa", "Entire loft", "Entire villa",
    "Private room in guesthouse", "Island", "Entire cabin", "Vacation home",
    "Entire bungalow", "Earth house", "Nature lodge", "In-law",
    "Entire guest suite", "Shared room in apartment", "Private room in loft",
    "Tiny house", "Castle", "Earth House", "Private room in condominium",
    "Entire place", "Shared room", "Hut", "Private room in guest suite",
    "Private room in townhouse", "Timeshare", "Entire townhouse",
    "Shared room in house", "Entire guesthouse", "Shared room in condominium",
    "Cave", "Private room in cabin", "Dome house",
    "Private room in vacation home", "Private room in dorm",
    "Entire serviced apartment", "Private room in bungalow",
    "Private room in serviced apartment", "Entire Floor", "Entire earth house",
    "Entire castle", "Shared room in chalet", "Shared room in bungalow",
    "Shared room in townhouse", "Entire cottage", "Private room in castle",
    "Private room in chalet", "Private room in nature lodge", "Entire in-law",
    "Shared room in guesthouse", "Casa particular", "Serviced flat", "Minsu",
    "Entire timeshare", "Shared room in timeshare", "Entire vacation home",
    "Entire nature lodge", "Entire island", "Private room in in-law",
    "Shared room in serviced apartment", "Shared room in cabin", "Entire dorm",
    "Entire cave", "Private room in timeshare", "Shared room in guest suite",
    "Private room in cave", "Entire tiny house",
    "Private room in casa particular (cuba)", "Casa particular (cuba)",
    "Private room in cottage", "Private room in tiny house",
    "Entire casa particular", "")) %>% 
  arrange(Property_ID)

property <-
  property %>% 
  filter(Property_ID %in% daily$Property_ID) %>% 
  left_join(raffle)

#daily <-
#  property %>% 
#  select(-Listing_Title, -Property_Type) %>% st_drop_geometry() %>%
#  inner_join(daily, .) %>% 
#  filter(Date >= Created, Date <= Scraped)

DA <- get_census(
  dataset = 'CA16', regions = list(C = "01"), level = 'DA', 
  geo_format = "sf") %>%
  st_transform(3347) 

