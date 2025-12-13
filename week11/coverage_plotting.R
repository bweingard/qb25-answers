setwd("~/qb25-answers/week11")
data <- read.table("output.txt", header = FALSE)[,1]


png("ex1_3x_cov.png")
hist(data, breaks = seq(-0.5, max(data) + 0.5, by = 1), main = "3x coverage", xlab = "coverage", ylab = "genome positions")

poisson <- dpois(0:max(data), lambda = 3)*length(data)
normal <- dnorm(0:max(data), mean = 3, sd = sqrt(3))*length(data)


lines(0:max(data), poisson, col = "purple", lwd = 2)
lines(0:max(data), normal, col = "blue", lwd = 2, lty = 2)

legend("topright",legend = c("observed coverage","poisson","normal"), col = c("gray", "purple", "blue"), lwd = c(NA, 2, 2), lty = c(NA, 1, 2),
  pch = c(15, NA, NA), pt.cex = 2, bty = "n")
dev.off()


data <- read.table("output.txt", header = FALSE)[,1]
png("ex1_10x_cov.png")
hist(data, breaks = seq(-0.5, max(data) + 0.5, by = 1), main = "10x coverage", xlab = "coverage", ylab = "genome positions")

poisson <- dpois(0:max(data), lambda = 10)*length(data)
normal <- dnorm(0:max(data), mean = 10, sd = sqrt(10))*length(data)


lines(0:max(data), poisson, col = "purple", lwd = 2)
lines(0:max(data), normal, col = "blue", lwd = 2, lty = 2)

legend("topright",legend = c("observed coverage","poisson","normal"), col = c("gray", "purple", "blue"), lwd = c(NA, 2, 2), lty = c(NA, 1, 2),
       pch = c(15, NA, NA), pt.cex = 2, bty = "n")
dev.off()


data <- read.table("output.txt", header = FALSE)[,1]
png("ex1_30x_cov.png")
hist(data, breaks = seq(-0.5, max(data) + 0.5, by = 1), main = "10x coverage", xlab = "coverage", ylab = "genome positions")

poisson <- dpois(0:max(data), lambda = 30)*length(data)
normal <- dnorm(0:max(data), mean = 30, sd = sqrt(30))*length(data)


lines(0:max(data), poisson, col = "purple", lwd = 2)
lines(0:max(data), normal, col = "blue", lwd = 2, lty = 2)

legend("topright",legend = c("observed coverage","poisson","normal"), col = c("gray", "purple", "blue"), lwd = c(NA, 2, 2), lty = c(NA, 1, 2),
       pch = c(15, NA, NA), pt.cex = 2, bty = "n")
dev.off()

num_zero <- sum(data == 0)
#3 - 48091
#10 - 53
#30 - 0

