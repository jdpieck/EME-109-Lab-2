library(units)
library(dplyr)
library(readr)
library(jsonlite)

temperature     <- set_units(21, "degC")
pressure        <- set_units(29.94, "inHg")
humidity        <- set_units(43, "%")
air_density     <- set_units(1.225, "kg/m^3")
u_infinity      <- set_units(20, "m/s")
p_delta         <- set_units(245, "Pa")      
water_density   <- set_units(1000, "kg/m^3")
gravity         <- set_units(9.81, "m/s^2")
height_of_water <- set_units(24.97452, "mm")
height_2        <- set_units(25, "mm")


cylinder_data <- read_csv("cylinder-rotation-data.csv", show_col_types = FALSE) %>%
  rename(
    pressure_tap_angle = `Prssure Tap Angle (degrees)`,
    cylinder_manometer = `Cylinder Manometer (kPa)`,
    airspeed_manometer = `Airspeed Manometer (mmH2O)`,
    measured_drag      = `Measured Drag (N)`
  ) %>%

  mutate(
    pressure_tap_angle = set_units(pressure_tap_angle, "degree"),
    cylinder_manometer = set_units(cylinder_manometer, "kPa"),
    airspeed_manometer = set_units(airspeed_manometer - 0, "mm"),
    measured_drag      = set_units(measured_drag, "N")
  )

# Convert the units for prob1
cylinder_data$cylinder_manometer <- set_units(cylinder_data$cylinder_manometer, "Pa")
cylinder_data$airspeed_manometer <- water_density * gravity * cylinder_data$airspeed_manometer


prob_1 <- drop_units(cylinder_data)
write_json(prob_1, "cylinder_rotation_processed.json", dataframe = "columns", pretty = TRUE)


## Prob 2

c_p_exp <- cylinder_data$cylinder_manometer / cylinder_data$airspeed_manometer

angle_rad <- drop_units(cylinder_data$pressure_tap_angle) * pi / 180
c_p_inv   <- 1 - 4 * (sin(angle_rad))^2

prob_2 <- data.frame(
pressure_tap_angle = drop_units(cylinder_data$pressure_tap_angle),
  c_p_exp          = drop_units(c_p_exp),
  c_p_inv          = c_p_inv
)

write_json(prob_2, "c_p.json", dataframe = "columns", pretty = TRUE)


## Prob 3

cylinder_radius <- set_units(31.8, "mm")  
cylinder_length <- set_units(300, "mm")

integral_sum <- set_units(0, "Pa")

for (i in 1:(nrow(cylinder_data) - 1)) {
  d_theta <- angle_rad[i + 1] - angle_rad[i]
  
  avg_height <- (cylinder_data$cylinder_manometer[i] * cos(angle_rad[i]) + cylinder_data$cylinder_manometer[i + 1] * cos(angle_rad[i + 1])) / 2
  d_pressure <- avg_height * d_theta
  
  integral_sum <- integral_sum + d_pressure
}

print(integral_sum)
D_p = 2 * cylinder_length * cylinder_radius * integral_sum
units(D_p) <- "N"
print(D_p)

given_drag_coef <- 1.2
F_d = given_drag_coef * air_density / 2 * u_infinity ^2 * cylinder_radius *2 * cylinder_length # table 7-3, page 494
units(F_d) <- "N"
print(F_d)