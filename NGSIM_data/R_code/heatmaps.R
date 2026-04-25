##### Used libraries #####

library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(viridis)
library(zoo)

##### Load data #####

us101_clean <- read.csv("us101_clean.csv")

##### Time conversion #####

us101_clean$Time_Pacific <- as.POSIXct(us101_clean$Global_Time / 1000,
                                       origin = "1970-01-01",
                                       tz = "America/Los_Angeles")


##### Time and spatial range #####

# Time range of the dataset

range(us101_clean$Time_Pacific)

# Total duration of the dataset in minutes

difftime(max(us101_clean$Time_Pacific),
         min(us101_clean$Time_Pacific),
         units = "mins")

# Convert longitudinal position to numeric format

us101_clean$Local_Y_num <- as.numeric(gsub(",", "", us101_clean$Local_Y))

# Spatial range in feet

range(us101_clean$Local_Y_num)

# Spatial range length in feet

diff(range(us101_clean$Local_Y_num))

# Spatial range length in meters

diff(range(us101_clean$Local_Y_num)) * 0.3048

# Number of vehicles

n_distinct(us101_clean$Vehicle_ID)

# Size of the cleaned dataset

nrow(us101_clean)

##### Lane 2 #####

##### Final time and spatial boundaries #####

# Time interval used for analysis

t_start <- as.POSIXct("2005-06-15 08:00:00", tz = "America/Los_Angeles")
t_end   <- as.POSIXct("2005-06-15 08:30:00", tz = "America/Los_Angeles")

# Spatial interval used for analysis

x_min <- 100
x_max <- 600

##### Padding for density smoothing #####
# Smoothing parameters: k = 5, time bin = 10 s, space bin = 20 m

# Time padding in seconds

t_pad <- 20   # seconds

# Spatial padding in meters

x_pad <- 40   # meters


# Extended time interval

t_start_ext <- t_start - t_pad
t_end_ext   <- t_end + t_pad

# Extended spatial interval

x_min_ext <- x_min - x_pad
x_max_ext <- x_max + x_pad

##### Speed heatmap #####

# Convert variables to numeric format and transform units
# Filter data for lane 2, selected time interval, and spatial domain
# Create time and space bins
# Compute mean speed in each time-space bin

lane2_heat_crop <- us101_clean %>%
  mutate(
    Local_Y_num = as.numeric(gsub(",", "", Local_Y)),
    v_Vel_num   = as.numeric(gsub(",", "", v_Vel)),
    Local_Y_m   = Local_Y_num * 0.3048,
    v_kmh       = v_Vel_num * 1.09728
  ) %>%
  filter(Lane_ID == 2) %>%
  filter(
    Time_Pacific >= t_start,
    Time_Pacific <= t_end,
    Local_Y_m >= x_min,
    Local_Y_m <= x_max
  ) %>%
  mutate(
    time_bin  = floor_date(Time_Pacific, unit = "15 seconds"),
    space_bin = floor(Local_Y_m / 20) * 20
  ) %>%
  group_by(time_bin, space_bin) %>%
  summarise(
    mean_speed = mean(v_kmh, na.rm = TRUE),
    .groups = "drop"
  )

# Create speed heatmap

p_speed <- ggplot(lane2_heat_crop, aes(x = time_bin, y = space_bin, fill = mean_speed)) +
  geom_tile(na.rm = TRUE) +
  scale_fill_viridis_c(
    name = expression(v~"(km/h)"),
    option = "plasma",
    na.value = "white"
  ) +
  scale_x_datetime(
    limits = c(t_start, t_end),
    date_breaks = "10 min",
    date_labels = "%H:%M",
    expand = c(0, 0)
  ) +
  scale_y_reverse(
    limits = c(x_max, x_min),
    breaks = seq(100, 600, by = 100),
    expand = c(0, 0)
  ) +
  labs(
    title = "Heatmapa rýchlosti pre 2. pruh",
    x = expression(t~"(PDT)"),
    y = expression(x~"(m)")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

p_speed

# Save speed heatmap

ggsave("speed_heatmap.pdf", plot = p_speed, width = 8, height = 6, device = cairo_pdf)

##### Density heatmap #####

# Density estimation from space headway
# Convert variables to numeric format and transform units
# Filter data for lane 2, selected time interval, and spatial domain
# Create time and space bins
# Estimate density as inverse of space headway
# Complete missing time-space combinations

lane2_density_headway <- us101_clean %>%
  mutate(
    Local_Y_num = as.numeric(gsub(",", "", Local_Y)),
    Space_Headway_num = as.numeric(gsub(",", "", Space_Headway)),
    Local_Y_m = Local_Y_num * 0.3048,
    Space_Headway_m = Space_Headway_num * 0.3048
  ) %>%
  filter(
    Lane_ID == 2,
    Time_Pacific >= t_start,
    Time_Pacific <= t_end,
    Local_Y_m >= x_min,
    Local_Y_m <= x_max,
    !is.na(Space_Headway_m),
    Space_Headway_m > 1
  ) %>%
  mutate(
    time_bin  = floor_date(Time_Pacific, unit = "15 seconds"),
    space_bin = floor(Local_Y_m / 20) * 20
  ) %>%
  group_by(time_bin, space_bin) %>%
  summarise(
    density = median(1000 / Space_Headway_m, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  complete(time_bin, space_bin)

# Smooth density in time and space using moving averages
# Firstly smoothing step in time for each spatial bin
# Secondly smoothing step in space for each time bin

density_headway_smooth <- lane2_density_headway %>%
  arrange(space_bin, time_bin) %>%
  group_by(space_bin) %>%
  mutate(
    density_smooth = rollapply(
      density,
      width = 3,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    )
  ) %>%
  ungroup() %>%
  arrange(time_bin, space_bin) %>%
  group_by(time_bin) %>%
  mutate(
    density_smooth = rollapply(
      density_smooth,
      width = 5,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    )
  ) %>%
  ungroup()

# Create density heatmap

p_density_headway_smooth <- ggplot(
  density_headway_smooth,
  aes(x = time_bin, y = space_bin, fill = density_smooth)
) +
  geom_tile(na.rm = TRUE) +
  scale_fill_viridis_c(
    name = expression(rho~"(voz/km/pruh)"),
    option = "viridis",
    na.value = "white"
  ) +
  scale_x_datetime(
    limits = c(t_start, t_end),
    date_breaks = "10 min",
    date_labels = "%H:%M",
    expand = c(0, 0)
  ) +
  scale_y_reverse(
    limits = c(x_max, x_min),
    breaks = seq(100, 600, by = 100),
    expand = c(0, 0)
  ) +
  labs(
    title = "Heatmapa hustoty pre 2. pruh",
    x = expression(t~"(PDT)"),
    y = expression(x~"(m)")
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

p_density_headway_smooth

# Save density heatmap

ggsave("density_heatmap.pdf", plot = p_density_headway_smooth, width = 8, height = 6)
