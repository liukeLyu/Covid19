library(tidyverse)

url_Hubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/ncov_hubei.csv"
url_nonHubei <- "https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/provisional-Hubei.csv"

nCov_Hubei <- read_csv(url_Hubei,
                       col_types = cols(.default = col_character()))
nCov_nonHubei <- read_csv(url_nonHubei,
                          col_types = cols(.default = col_character()))

nCov <- full_join(nCov_Hubei, nCov_nonHubei) %>% type_convert
nCov <- nCov %>% 
  mutate(age = as.numeric(age))

# Date
nCov %>% 
  mutate(date = parse_date(date_confirmation, "%d.%m.%Y")) %>% 
  filter(!is.na(date)) %>% 
  count(date) %>% 
  ggplot(mapping = aes(x = date, y=n))+
  geom_line()


nCov %>%
  filter(!is.na(age)) %>% 
  ggplot(mapping = aes(x=age))+
  geom_histogram(bins=20)

nCov %>%
  filter(sex %in% c("male","female")) %>% 
  ggplot(mapping = aes(x=sex))+
  geom_bar()

nCov %>%
  filter(province == "Hubei") %>% 
  filter(!is.na(city)) %>% 
  ggplot(mapping = aes(x=city))+
  geom_bar()+
  coord_flip()

nCov %>%
  filter(province != "Hubei") %>% 
  count(province) %>% 
  filter(n>100) %>% 
  ggplot(mapping = aes(x=province, y=n))+
  geom_col()+
  coord_flip()

