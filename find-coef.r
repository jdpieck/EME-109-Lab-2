# 1. Define the input data in the provided reverse order
y_raw <- c(157.00, 111.00, 94.67, 56.33, 76.33, 64.33, 60.33, 35.33)

# 2. Reverse to get Y1, Y2, ..., Y8
y <- rev(y_raw)
y1 <- y[1]; y2 <- y[2]; y3 <- y[3]; y4 <- y[4]
y5 <- y[5]; y6 <- y[6]; y7 <- y[7]; y8 <- y[8]

# 3. Calculate Grand Average
Y_bar <- sum(y) / 8

# 4. Calculate Main Effects (E1, E2, E3)
E1 <- (-y1 + y2 - y3 + y4 - y5 + y6 - y7 + y8) / 4
E2 <- (-y1 - y2 + y3 + y4 - y5 - y6 + y7 + y8) / 4
E3 <- (-y1 - y2 - y3 - y4 + y5 + y6 + y7 + y8) / 4

# 5. Calculate Interaction Effects (I12, I13, I23, I123)
I12 <- ( y1 - y2 - y3 + y4 + y5 - y6 - y7 + y8) / 4
I13 <- ( y1 - y2 + y3 - y4 - y5 + y6 - y7 + y8) / 4
I23 <- ( y1 + y2 - y3 - y4 - y5 - y6 + y7 + y8) / 4
I123 <- (-y1 + y2 + y3 - y4 + y5 - y6 - y7 + y8) / 4

# 6. Display Results
results <- data.frame(
  Effect = c("Average", "E1", "E2", "E3", "I12", "I13", "I23", "I123"),
  Value = c(Y_bar, E1, E2, E3, I12, I13, I23, I123)
)
print(results)

# 7. Bonus: Function for Prediction (Factorial Model)
predict_y <- function(x1, x2, x3) {
  Y_bar + (E1/2)*x1 + (E2/2)*x2 + (E3/2)*x3 + 
          (I12/2)*x1*x2 + (I13/2)*x1*x3 + (I23/2)*x2*x3 + 
          (I123/2)*x1*x2*x3
}

angle <- 0.73

print(predict_y(1, +1, angle))
angle_out <- (165 - 135)/2 * angle + 150
print(angle_out)