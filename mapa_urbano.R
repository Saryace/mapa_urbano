# Librerias ---------------------------------------------------------------

library(tidyverse) # data clean
library(ggmap) # mapas
library(sf)  # dataframe a espacial
library(ggspatial) #mapas
library(osmdata) #mapa

# Cargar bbox de la ciudad ------------------------------------------------

stgo_bbox <- osmdata::getbb("Santiago")

# Crear mapa OSM ----------------------------------------------------------

map <- get_stamenmap(
  bbox = c(
    left = stgo_bbox[1, 1],
    bottom = stgo_bbox[2, 1],
    right = stgo_bbox[1, 2],
    top = stgo_bbox[2, 2]
  ),
  zoom = 12,
  maptype = "terrain"
)

# Creamos dataset de ejemplo ----------------------------------------------

lugares_stgo <- tribble(
  ~ "lng", ~ "lat", ~ "numero_aves",
  -70.51861,
  -33.38371,
  21,
  -70.71982,
  -33.51318,
  33,
  -70.65768,
  -33.42345,
  12,
  -70.55768,
  -33.56177,
  15,
  -70.67279,
  -33.50156,
  52
)

lugares_stgo_sf <-
  st_as_sf(lugares_stgo, coords = c("lng", "lat"), crs = 4326)


# Mapa urbano -------------------------------------------------------------

mapa_urbano <- ggmap(map) +
  geom_sf(
    data = lugares_stgo_sf,
    aes(color = numero_aves),
    size = 3,
    inherit.aes = FALSE
  ) +
  labs(x = "", y = "", color = "número\nde aves") +
  annotation_scale(location = "br",
                   bar_cols = c("grey20", "white")) +
  ggtitle("Santiago de Chile") +
  annotation_north_arrow(
    location = "tl",
    which_north = "true",
    style = north_arrow_nautical(fill = c("grey40", "white"),
                                 line_col = "grey20")
  )

mapa_urbano

# Guardar resultado -------------------------------------------------------

ggsave("mapas/mapa_urbano.jpeg", device = "jpeg")

