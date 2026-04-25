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


##### Right boundary condition #####

# Settings

# Time interval used for the boundary condition

t_start <- as.POSIXct("2005-06-15 08:00:00", tz = "America/Los_Angeles")
t_end   <- as.POSIXct("2005-06-15 08:30:00", tz = "America/Los_Angeles")

# Right boundary region close to 600 m

x_min <- 580
x_max <- 600

# Time bin size for boundary data

dt_bc_sec <- 15

# Data preprocessing
# Convert variables to numeric format and transform units
# Filter data for lane 2, selected time interval, and right boundary region
# Create time bins

bc_base <- us101_clean %>%
  mutate(
    Local_Y_num = as.numeric(gsub(",", "", Local_Y)),
    v_Vel_num   = as.numeric(gsub(",", "", v_Vel)),
    Space_Headway_num = as.numeric(gsub(",", "", Space_Headway)),
    
    Local_Y_m   = Local_Y_num * 0.3048,
    v_kmh       = v_Vel_num * 1.09728,
    Space_Headway_m = Space_Headway_num * 0.3048
  ) %>%
  filter(
    Lane_ID == 2,
    Time_Pacific >= t_start,
    Time_Pacific <= t_end,
    Local_Y_m >= x_min,
    Local_Y_m <= x_max
  ) %>%
  mutate(
    time_bin = floor_date(Time_Pacific, unit = paste(dt_bc_sec, "seconds"))
  )

# Speed at the right boundary
# Compute mean speed in each time bin

v_right_df <- bc_base %>%
  filter(!is.na(v_kmh)) %>%
  group_by(time_bin) %>%
  summarise(
    v_right = mean(v_kmh, na.rm = TRUE),
    .groups = "drop"
  )

# Density at the right boundary from space headway
# Estimate density as inverse of space headway in each time bin

rho_right_df <- bc_base %>%
  filter(
    !is.na(Space_Headway_m),
    Space_Headway_m > 1
  ) %>%
  group_by(time_bin) %>%
  summarise(
    rho_right = median(1000 / Space_Headway_m, na.rm = TRUE),
    .groups = "drop"
  )

# Merge boundary profiles

right_bc <- full_join(rho_right_df, v_right_df, by = "time_bin") %>%
  arrange(time_bin)

print(right_bc)

# Optional smoothing
# Apply moving average to reduce short-term fluctuations

right_bc <- right_bc %>%
  mutate(
    rho_smooth = rollapply(
      rho_right,
      width = 3,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    ),
    v_smooth = rollapply(
      v_right,
      width = 3,
      FUN = function(z) mean(z, na.rm = TRUE),
      fill = NA,
      align = "center",
      partial = TRUE
    )
  )

# Control plots

# Plot right boundary speed

bc_speed <- ggplot(right_bc, aes(x = time_bin)) +
  geom_line(aes(y = v_right, color = "Pôvodné dáta"), alpha = 0.6) +
  geom_line(aes(y = v_smooth, color = "Vyhladené dáta"), linewidth = 1) +
  labs(
    title = "Okrajová rýchlosť (pravý okraj)",
    x = "t",
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

bc_speed

# Save right boundary speed plot

ggsave(
  "bc_speed.pdf",
  plot = bc_speed,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)

# Plot right boundary density

bc_density <- ggplot(right_bc, aes(x = time_bin)) +
  geom_line(aes(y = rho_right, color = "Pôvodné dáta"), alpha = 0.6) +
  geom_line(aes(y = rho_smooth, color = "Vyhladené dáta"), linewidth = 1) +
  labs(
    title = "Okrajová hustota (pravý okraj)",
    x = "t",
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

bc_density

# Save right boundary density plot

ggsave(
  "bc_density.pdf",
  plot = bc_density,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)

# Export for MATLAB

right_bc_export <- right_bc %>%
  mutate(
    t = as.numeric(difftime(time_bin, t_start, units = "secs"))
  ) %>%
  transmute(
    t = t,
    rho_right = rho_smooth,
    v_right = v_smooth
  )

write.csv(right_bc_export, "right_boundary_lane2.csv", row.names = FALSE)
