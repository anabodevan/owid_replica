### Replicating OWID Self-reported life satisfaction vs GDP per capita, 2022
### Author: Ana Bodevan 

## Loading packages

library(pacman)
pacman::p_load('ggplot2', 'ggrepel', 'showtext', 'readr', 'dplyr', 'janitor')

## Loading data (available at OWID website)

owid <- readr::read_csv(
  "https://github.com/viniciusoike/restateinsight/raw/main/static/data/gdp-vs-happiness.csv"
)

## Cleaning the data 

owid1 <- owid %>% 
  janitor::clean_names() %>% 
  rename(
    life_satisfaction = cantril_ladder_score,
    gdppc = gdp_per_capita_ppp_constant_2017_international,
    pop = population_historical_estimates
  ) %>% 
  filter(!is.na(gdppc), !is.na(life_satisfaction)) %>%  
  mutate(gdppc = log10(gdppc)) %>%  
  group_by(entity) %>% 
  filter(year == max(year)) %>%  
  ungroup() %>% 
  select(entity, pop, gdppc, life_satisfaction) # only 2022 data 

dc <- owid %>%  
  select(Entity, Continent) %>%  
  filter(!is.na(Continent), !is.na(Entity)) %>%  
  distinct() %>% 
  rename(
    entity = Entity,
    continent = Continent
  ) # creates a new data frame to allow us to join continent to the owid1 df 

owid1 <- left_join(owid1, dc, by = "entity")

## Plot: Bubbles 

ggplot(owid1, aes(x = gdppc, y = life_satisfaction)) +
  geom_point(
    aes(fill = continent, size = pop),
    color = "#A5A9A9",
    alpha = 0.8,
    shape = 21
  ) # https://ggplot2.tidyverse.org/articles/ggplot2-specs.html 21 shape 

## Plot: Highlights 

countries <- c(
  "Ireland", "Qatar", "Hong Kong", "Switzerland", "United States", "France",
  "Japan", "Costa Rica", "Russia", "Turkey", "China", "Brazil", "Indonesia",
  "Iran", "Egypt", "Botswana", "Lebanon", "Philippines", "Bolivia", "Pakistan",
  "Bangladesh", "Nepal", "Senegal", "Burkina Faso", "Ethiopia", "Tanzania",
  "Democratic Republic of Congo", "Mozambique", " Somalia", "Chad", "Malawi",
  "Burundi", "India")

highlights <- owid1 %>%  
  mutate(highlight = if_else(entity %in% countries, entity, NA))

base <- ggplot(owid1, aes(x = gdppc, y = life_satisfaction)) +
  geom_point(
    aes(fill = continent, size = pop),
    color = "#A5A9A9",
    alpha = 0.8,
    shape = 21
  ) +
  ggrepel::geom_text_repel(
    data = highlights,
    aes(x = gdppc, y = life_satisfaction, label = highlight, color = continent),
    size = 3
  )

## Plot: Further Aesthetics 

# Define breaks and labels for the x-axis
xbreaks <- c(3, 3.3, 3.7, 4, 4.3, 5)
xlabels <- c(1000, 2000, 5000, 10000, 20000, 100000)

# Format the x-axis labels with dollar signs and commas
xlabels <- paste0("$", format(xlabels, big.mark = ",", scientific = FALSE))

# Colors (or as close to them as I could) 
colors <- c("#A2559A", "#01847E", "#4C5A9C", "#E26E6A", "#9A5129", "#883039")

# Modify the base plot

base <- base +
  # Adds custom breaks and labels to the x-axis
  scale_x_continuous(breaks = xbreaks, labels = xlabels) +
  # Adds custom breaks to the y-axis 
  scale_y_continuous(breaks = 3:7) +
  # Scales the bubble sizes
  scale_size_continuous(range = c(1, 15)) +
  # Customizes the bubble colors using the defined color palette
  scale_fill_manual(name = "", values = colors) +
  # Removes the legends for size and color
  guides(
    color = "none",  # Remove color legend
    size = "none",   # Remove size legend
  )

base

# Plot: Text

# caption
caption <- "Source: World Happiness Report (2023), Data compiled from multiple sources by World Bank\nNote: GDP per capita is expressed in international-$ at 2017 prices.\nOurWorldInData.org/happiness-and-life-satisfacation/"

# subtitle
subtitle <- "Self-reported life satisfaction is measured on a scale ranging from 0-10, where 10 is the highest possible life\nsatisfaction. GDP per capita is adjusted for inflation and differences in the cost of living between countries."

# adds tex base
base <- base +
  labs(
    title = "Self-reported life satisfaction vs. GDP per capita, 2022",
    subtitle = subtitle,
    x = "GDP per capita",
    y = "Life satisfaction (country average; 0-10)",
    caption = caption
  )

base

## Theme 

font_add_google("Playfair Display", "Playfair Display")
font_add_google("Lato", "Lato")

showtext::showtext_auto()

base +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linetype = 3, color = "gray"),
    text = element_text(family = "Lato"),
    title = element_text(family = "Lato"),
    plot.caption = element_text(color = "gray", hjust = 0, size = 8),
    plot.title = element_text(
      color = "gray5",
      family = "Playfair Display",
      size = 18),
    plot.subtitle = element_text(color = "gray5", size = 11),
    axis.title = element_text(color = "black", size = 9),
    axis.text = element_text(color = "gray5", size = 12),
    legend.key.size = unit(5, "pt"),
    legend.position = "right",
    legend.text = element_text(size = 11),
    plot.margin = margin(rep(11, 5))
  )


