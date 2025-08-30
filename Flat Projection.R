# Package Loading ---------------------------------------------------------
library(sf)
library(rnaturalearth)
library(ggplot2)
library(extrafont)

# Download country boundaries and ocean data ------------------------------
world_countries <- ne_countries(scale = 'medium', returnclass = 'sf')
world_oceans <- ne_download(scale = 'medium', type = 'ocean', 
                            category = 'physical', returnclass = 'sf')

# Projection Definition ---------------------------------------------------
target_crs_Flat<- "EPSG:4326" # Flat projection

# CRS Transformation ------------------------------------------------------
world_countries_Flat <- st_transform(world_countries, crs = target_crs_Flat)
world_oceans_Flat <- st_transform(world_oceans, crs = target_crs_Flat)

# Graticule Creation ------------------------------------------------------
graticules_Flat <- st_graticule(
  lat = seq(-90, 90, by = 15),
  lon = seq(-180, 180, by = 15),
  crs = st_crs(4326)
) |> st_transform(crs = target_crs_Flat)

# Create Map --------------------------------------------------------------
ggplot() + 
  geom_sf(data = world_oceans_Flat, fill = "deepskyblue", color = NA) +
  geom_sf(data = graticules_Flat, color = "#EEDFCC", linewidth = 0.1) +
  geom_sf(data = world_countries_Flat, fill = "gray90", color = "black", linewidth = 0.1) +
  ggtitle("World Map - Flat Projection") + 
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman"),
    plot.title = element_text(hjust = 0.5, size = 16),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save Map ----------------------------------------------------------------
ggsave("Flat_map.png", width = 10, height = 6, dpi = 300, bg = "white")
