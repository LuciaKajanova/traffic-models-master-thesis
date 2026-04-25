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

##### Estimation of initial condition #####

# Settings

# Initial time

t0 <- as.POSIXct("2005-06-15 08:00:00", tz = "America/Los_Angeles")

# Spatial domain

x_min <- 100
x_max <- 600

# Spatial discretization step

dx_data <- 20

# First 15 seconds for initial condition

dt_init_sec <- 15   

# Data preprocessing

init_base <- us101_clean %>%
  mutate(
    Local_Y_num = as.numeric(gsub(",", "", Local_Y)),
    v_Vel_num = as.numeric(gsub(",", "", v_Vel)),
    Space_Headway_num = as.numeric(gsub(",", "", Space_Headway)),
    
    Local_Y_m = Local_Y_num * 0.3048,
    v_kmh = v_Vel_num * 1.09728,
    Space_Headway_m = Space_Headway_num * 0.3048
  ) %>%
  filter(
    Lane_ID == 2,
    Time_Pacific >= t0,
    Time_Pacific < t0 + dt_init_sec,
    Local_Y_m >= x_min,
    Local_Y_m <= x_max
  ) %>%
  mutate(
    space_bin = floor(Local_Y_m / dx_data) * dx_data
  )

# Speed profile

speed_profile <- init_base %>%
  filter(!is.na(v_kmh)) %>%
  group_by(space_bin) %>%
  summarise(
    speed = mean(v_kmh, na.rm = TRUE),
    .groups = "drop"
  )

# Density profile from Space Headway

density_profile <- init_base %>%
  filter(
    !is.na(Space_Headway_m),
    Space_Headway_m > 1
  ) %>%
  group_by(space_bin) %>%
  summarise(
    density = median(1000 / Space_Headway_m, na.rm = TRUE),
    .groups = "drop"
  )

# Merge profiles

init_data <- full_join(density_profile, speed_profile, by = "space_bin") %>%
  arrange(space_bin) %>%
  mutate(
    x_model = space_bin - x_min
  )

print(init_data)

# Optional smoothing
# Apply moving average to reduce noise

init_data <- init_data %>%
  mutate(
    density_smooth = rollapply(
      density,
      width = 3,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    ),
    speed_smooth = rollapply(
      speed,
      width = 3,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    )
  )

# Control plots

# Initial speed profile plot

initial_speed <- ggplot(init_data, aes(x = x_model + 100)) +
  geom_line(aes(y = speed, color = "Pôvodné dáta"), linewidth = 0.8, alpha = 0.7) +
  geom_line(aes(y = speed_smooth, color = "Vyhladené dáta"), linewidth = 1) +
  labs(
    title = "Počiatočný profil rýchlosti",
    x = "x (m)",
    y = "v (km/h)",
    color = ""
  ) +
  scale_color_manual(values = c(
    "Pôvodné dáta" = "tomato",
    "Vyhladené dáta" = "red"
  )) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5),
    legend.position = "top"
  )

initial_speed

# Save speed plot

ggsave(
  "initial_speed.pdf",
  plot = initial_speed,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)

# Initial density profile plot

initial_density <- ggplot(init_data, aes(x = x_model + 100)) +
  geom_line(aes(y = density, color = "Pôvodné dáta"), linewidth = 0.8, alpha = 0.7) +
  geom_line(aes(y = density_smooth, color = "Vyhladené dáta"), linewidth = 1) +
  labs(
    title = "Počiatočný profil hustoty",
    x = "x (m)",
    y = expression(rho~"(voz/km/pruh)"),
    color = ""
  ) +
  scale_color_manual(values = c(
    "Pôvodné dáta" = "skyblue3",
    "Vyhladené dáta" = "blue"
  )) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5),
    legend.position = "top"
  )

initial_density

# Save density plot

ggsave(
  "initial_density.pdf",
  plot = initial_density,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)

# Export for MATLAB

init_export <- init_data %>%
  transmute(
    x_data_m = space_bin,
    x = x_model,
    rho0 = density_smooth,
    v0 = speed_smooth
  )

write.csv(init_export, "initial_condition_lane2.csv", row.names = FALSE)
