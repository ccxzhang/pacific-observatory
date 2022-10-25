# library(RColorBrewer)
# library(zoo)

library(dplyr)
library(ggplot2)
library(here)
library(showtext)
library(scales)
library(lubridate)
library(hrbrthemes)

# font_add("Andes", regular = "Andes-Regular.otf")
# font_add("Roboto Condensed", regular = "Roboto-Thin.ttf")
font_add_google("Roboto Condensed", "Roboto Condensed")

p = ggplot(NULL, aes(x = 1, y = 1)) + ylim(0.8, 1.2) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank()) +
  annotate("text", 1, 0.9, label = 'Chinese for "Hello, world!"',
           family = "Roboto Condensed", size = 12)
p


here()
df <- read.csv("../../data/ntl_adm0_pct_cloud.csv", row.names=1)
df$date <- as.Date(df$date)
df$year <- as.integer(format(df$date, "%Y"))
df <- df %>% filter(year>2018)
df$pct_inv = 1-df$pct
# df[df$year=="2021",]

for (country in unique(df$WB_ADM0_NA)) {
  df.filt <- df[df$WB_ADM0_NA==country,]
  plt <- ggplot(data=df.filt, aes(x=date, y=pct_inv)) +
    geom_col(alpha=0.75, width=20) +
    scale_y_continuous(labels = scales::percent, breaks = c(0,.25,.5,.75,1), limits=c(0,1)) +
    labs(x="", y = "", title = paste0("Cloud Coverage by Month, ", country),
         subtitle = "% of pixels with clouds") +
    scale_x_date(date_breaks="2 months", expand=c(0.02,0.02), # date_labels = "%b", 
                 labels = function(x) if_else(is.na(lag(x)) | !year(lag(x)) == year(x), 
                                              paste(month(x, label = TRUE), "\n", year(x)), 
                                              paste(month(x, label = TRUE)))
    ) +
    theme_ipsum_rc()
  plt
  country <- gsub(" ", "-", country)
  ggsave(paste0("../../docs/images/ntl_cloud_coverage/", country, ".jpeg"), width = 10, height = 6)
}

plt <- ggplot(data=df, aes(x=date, y=pct_inv, group=WB_ADM0_NA)) +
  geom_col(alpha=0.5, width=20) +
  facet_wrap(~WB_ADM0_NA) +
  scale_y_continuous(labels = scales::percent) +
  labs(x="", y="% of pixels with clouds", title="Cloud Coverage by Month") +
  theme_minimal()
plt


country <- "Vanuatu"
df.filt <- df[df$WB_ADM0_NA==country,]
plt <- ggplot(data=df.filt, aes(x=date, y=pct_inv)) +
  geom_col(alpha=0.75, width=20) +
  scale_y_continuous(labels = scales::percent, breaks = c(0,.25,.5,.75,1), limits=c(0,1)) +
  labs(x="", y = "", title = paste0("Cloud Coverage by Month, ", country),
       subtitle = "% of pixels with clouds") +
  scale_x_date(date_breaks="2 months", expand=c(0.02,0.02), # date_labels = "%b", 
               labels = function(x) if_else(is.na(lag(x)) | !year(lag(x)) == year(x), 
                                            paste(month(x, label = TRUE), "\n", year(x)), 
                                            paste(month(x, label = TRUE)))
  ) +
  theme_ipsum()
plt
