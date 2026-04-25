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

##### Scatter plot data preparation #####

# Convert variables to numeric and transform units
# Filter data for selected lane, time interval, and spatial domain
# Remove missing and invalid headway values
# Create time and space bins
# Compute mean time and space headways in each bin
# Compute macroscopic traffic quantities


fd_data_metric <- us101_clean %>%
  mutate(
    Local_Y_num = as.numeric(gsub(",", "", Local_Y)),
    Time_Headway_num = as.numeric(gsub(",", "", Time_Headway)),
    Space_Headway_num = as.numeric(gsub(",", "", Space_Headway)),
    Local_Y_m = Local_Y_num * 0.3048,
    Space_Headway_m = Space_Headway_num * 0.3048
  ) %>%
  filter(
    Lane_ID == 2,
    Time_Pacific >= t_start,
    Time_Pacific <= t_end,
    Local_Y_m >= x_min,
    Local_Y_m <= x_max
  ) %>%
  filter(
    !is.na(Time_Headway_num),
    !is.na(Space_Headway_m),
    Time_Headway_num > 0,
    Space_Headway_m > 0
  ) %>%
  mutate(
    time_bin  = floor_date(Time_Pacific, unit = "15 seconds"),
    space_bin = floor(Local_Y_m / 20) * 20
  ) %>%
  group_by(time_bin, space_bin) %>%
  summarise(
    mean_time_headway = mean(Time_Headway_num, na.rm = TRUE),
    mean_space_headway_m = mean(Space_Headway_m, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    flow = 3600 / mean_time_headway,        # veh/h
    density = 1000 / mean_space_headway_m,  # veh/km/lane
    speed = flow / density                  # km/h
  )

##### Flow-density diagram #####

# Create flow-density scatter plot

p_fd_flow_density <- ggplot(fd_data_metric, aes(x = density, y = flow)) +
  geom_point(alpha = 0.5, size = 1) +
  labs(
    title = "Diagram intenzita-hustota (2. pruh)",
    x = expression(rho~"(voz/km/pruh)"),
    y = expression(q~"(voz/h)")
  ) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5)
  )

p_fd_flow_density

# Save flow-density plot

ggsave(
  "flow_density.pdf",
  plot = p_fd_flow_density,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)


##### Speed-density diagram #####

# Create speed-density scatter plot

p_fd_speed_density <- ggplot(fd_data_metric, aes(x = density, y = speed)) +
  geom_point(alpha = 0.5, size = 1) +
  labs(
    title = "Diagram rýchlosť-hustota (2. pruh)",
    x = expression(rho~"(voz/km/pruh)"),
    y = expression(v~"(km/h)")
  ) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5)
  )

p_fd_speed_density

# Save speed-density plot

ggsave(
  "speed_density.pdf",
  plot = p_fd_speed_density,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)


##### Speed-flow diagram #####

# Create speed-flow scatter plot

p_fd_speed_flow <- ggplot(fd_data_metric, aes(x = flow, y = speed)) +
  geom_point(alpha = 0.5, size = 1) +
  labs(
    title = "Diagram rýchlosť-intenzita (2. pruh)",
    x = expression(q~"(voz/h)"),
    y = expression(v~"(km/h)")
  ) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5)
  )

p_fd_speed_flow

# Save speed-flow plot

ggsave(
  "speed_flow.pdf",
  plot = p_fd_speed_flow,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)


##### NLS fit for fundamental diagram #####

# Keep only valid observations for fitting

fd_fit <- fd_data_metric %>%
  filter(
    is.finite(density),
    is.finite(speed),
    density > 0,
    speed >= 0
  )

# Fit logistic Kerner-Konhäuser-type fundamental diagram

kk_gen_fit <- nls(
  speed ~ a * (1 / (1 + exp((density - rho_c) / s))),
  data = fd_fit,
  start = list(
    a = 55,
    rho_c = 50,
    s = 8
  ),
  algorithm = "port",
  lower = c(
    a = 10,
    rho_c = 1,
    s = 0.5
  ),
  upper = c(
    a = 150,
    rho_c = 200,
    s = 100
  )
)

# Display fitted parameters

summary(kk_gen_fit)
coef(kk_gen_fit)

# Store estimated parameters

coef_kk <- coef(kk_gen_fit)

a_hat     <- coef_kk["a"]
rho_c_hat <- coef_kk["rho_c"]
s_hat     <- coef_kk["s"]

# Create density grid for fitted curves

rho_grid <- data.frame(
  density = seq(min(fd_fit$density), max(fd_fit$density), length.out = 400)
)

##### Fitted logistic/KK model #####

rho_grid$speed_fit <- a_hat * (
  1 / (1 + exp((rho_grid$density - rho_c_hat) / s_hat))
)

##### Original KK fundamental diagram #####

vmax_KK   <- 120
rhomax_KK <- 140

rho_grid$speed_KK <- vmax_KK * (
  1 / (1 + exp((rho_grid$density / rhomax_KK - 0.25) / 0.06)) - 3.72e-6
)

##### Plot with legend #####

rho_plot <- bind_rows(
  rho_grid %>%
    transmute(density, speed = speed_fit, curve = "Fitted KK"),
  rho_grid %>%
    transmute(density, speed = speed_KK, curve = "Original KK")
)

p_fd_fit <- ggplot(fd_fit, aes(x = density, y = speed)) +
  geom_point(alpha = 0.25, size = 1) +
  geom_line(
    data = rho_plot,
    aes(x = density, y = speed, color = curve, linetype = curve),
    linewidth = 1.2
  ) +
  scale_color_manual(
    values = c("Fitted KK" = "red", "Original KK" = "blue"),
    labels = c("Fitted KK" = "Odhadnutý model", "Original KK" = "Pôvodný model")
  ) +
  scale_linetype_manual(
    values = c("Fitted KK" = "solid", "Original KK" = "dashed"),
    labels = c("Fitted KK" = "Odhadnutý model", "Original KK" = "Pôvodný model")
  ) +
  labs(
    title = "Odhad fundamentálneho diagramu",
    x = expression(rho~"(voz/km/pruh)"),
    y = expression(v~"(km/h)"),
    color = NULL,
    linetype = NULL
  ) +
  theme_bw() +
  theme(
    text = element_text(family = "ArialMT"),
    plot.title = element_text(hjust = 0.5)
  )

p_fd_fit

# Save fitted fundamental diagram plot

ggsave(
  "speed_density_fit.pdf",
  plot = p_fd_fit,
  width = 7,
  height = 5,
  device = cairo_pdf,
  family = "ArialMT"
)
