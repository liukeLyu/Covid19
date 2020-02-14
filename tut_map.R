library(tidyverse)
library(hchinamap)

url_Hubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/ncov_hubei.csv"

url_nonHubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/provisional-Hubei.csv"

nCov_Hubei <- read_csv(url_Hubei,
                       col_types = cols(.default = col_character()))
nCov_nonHubei <- read_csv(url_nonHubei,
                          col_types = cols(.default = col_character()))

nCov <- rbind(read_csv(url_Hubei), read_csv(url_nonHubei))

provinceData <- nCov %>% 
  filter(country == "China", province != "China") %>% 
  count(province)

provName_map <- read_csv("province_eng_chi.dat", col_names = c("x")) %>% 
  separate(col = x, into = c("province", "省"))

final <- left_join(provinceData, provName_map, by = "province")

hchinamap(name = final$省, value = round(log10(final$n),1), maxColor = "#ff0000")
