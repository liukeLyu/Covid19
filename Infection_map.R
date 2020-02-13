library(tidyverse)
library(magrittr)
library(hchinamap)

url_Hubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/ncov_hubei.csv"
url_nonHubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/provisional-Hubei.csv"

nCov_Hubei <- read_csv(url_Hubei,
                       col_types = cols(.default = col_character()))
nCov_nonHubei <- read_csv(url_nonHubei,
                          col_types = cols(.default = col_character()))

nCov <- full_join(nCov_Hubei, nCov_nonHubei) %>% type_convert
nCov <- nCov %>% 
  mutate(age = as.numeric(age))

provinceData = nCov %>% 
  filter(country == "China") %>% 
  count(province)

raw_province <- read_csv("province_eng_chi.dat", col_names = F)
(eng_chi <- raw_province %>% 
    separate(col = X1,
             into = c("province", "chinese_province")))

provinceData_chi <- left_join(provinceData, eng_chi, by = "province") %>% 
  filter(province != "China")

provinceData_chi %$% 
  hchinamap(name = chinese_province, value = round(log10(n),1), itermName = "province",
            width = "100%", height = "400px",
            title = "Covid19 China Disease Confirmation", region = "China", 
            min=0, maxColor = "#FF0000", 
            legendTitle = "Number of People Confirmed (10^n)")

