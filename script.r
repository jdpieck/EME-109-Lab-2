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
    airspeed_manometer = `Airspeed Manometer (mm)`,
    measured_drag      = `Measured Drag(N)`
  ) %>%

  mutate(
    pressure_tap_angle = set_units(pressure_tap_angle, "degree"),
    cylinder_manometer = set_units(cylinder_manometer, "kPa"),
    airspeed_manometer = set_units(airspeed_manometer, "mm"),
    measured_drag      = set_units(measured_drag, "N")
  )

# Convert the units
cylinder_data$cylinder_manometer <- set_units(cylinder_data$cylinder_manometer, "Pa")
cylinder_data$airspeed_manometer <- water_density * gravity * cylinder_data$airspeed_manometer

export_df <- data.frame(
  pressure_tap_angle_deg = drop_units(cylinder_data$pressure_tap_angle),
  cylinder_manometer_pa  = drop_units(cylinder_data$cylinder_manometer),
  airspeed_manometer_pa  = drop_units(cylinder_data$airspeed_manometer),
  measured_drag_n        = drop_units(cylinder_data$measured_drag)
)

write_json(export_df, "cylinder_rotation_processed.json", dataframe = "columns", pretty = TRUE)