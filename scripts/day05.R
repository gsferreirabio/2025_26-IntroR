################################################################################
## Day 05 started here

################################################################################
# Correlations & Regression
# When we have two continuous variables, we can test whether they are correlated
# Correlation is defined in terms of the variance of x, the variance of y, and 
## the covariance of x and y, the way they vary together. The formula to obtain
## the correlation between x and y is the covariance between x and y, divided
## by the square root of the variance of x times the variance of y.

# Let's test the correlation between SCm and SCL
# Let's first take a look at it
plot(SCm, SCL)  ## it looks like there is a strong correlation
var(SCm)
var(SCm, na.rm = T)
var(SCL, na.rm = T)

var(SCm, SCL, na.rm = T)  ## if var has two arguments, it calculates the covariance

# Thus, the correlation should be:
var(SCm, SCL, na.rm = T)/(sqrt(var(SCm, na.rm = T)*var(SCL, na.rm = T)))
#0.5285097 is not a strong correlation

# of course, there is an implement function to calculate that, let's check
cor(SCm, SCL)

################################################################################
# Problem 1.2: how to correct that?
# We need a new dataset in which all data points have both values
complete.cases(SCm, SCL)
head(F24.size)
SCm.SCL <- F24.size[complete.cases(SCm, SCL), 6:7]
SCm.SCL

cor(SCm.SCL$SCm, SCm.SCL$SCL)  ## results are different, do you know why?

## we have to keep only the values that are in BOTH variables

# Thus, the correlation should be:
var(SCm.SCL$SCm, SCm.SCL$SCL)/(sqrt(var(SCm.SCL$SCm)*var(SCm.SCL$SCL)))
# 0.8841411 is a strong correlation!

# if you want to determine the significance of a correlation, use:
cor.test(SCm.SCL$SCm, SCm.SCL$SCL)  ## highly significant

# use cor to test the correlation between all variables in a dataframe
cor(F24.size)  ## we have to remove the non-numeric columns
cor(F24.size[complete.cases(F24.size[,-c(1:3)]),-c(1:3)])

# do not over rely on correlation between two variables as they can be misleading
# check more complex models and also whether an additional category can change
## the explanation of the correlation. For example, using coplot:
coplot(SCm ~ SCL | Clade, pch = 16, col = "red")


################################################################################
# Regressions  
## we were not able to do the following due to time
attach(SCm.SCL)
sum(SCm); sum(SCm^2); sum(SCL); sum(SCL^2); sum(SCm*SCL)

## Sums of squares of independent variable
SSY = sum(SCm^2) - (sum(SCm))^2/length(SCm)

## Sums of squares of dependent variable
SSX = sum(SCL^2) - (sum(SCL))^2/length(SCL)

## Sums of squares of the product
SSXY = sum(SCm*SCL) - (sum(SCL)*sum(SCm))/length(SCL)

## The slope of a linear regression is given by the division of the sums of 
### squares of the product by the sums of squares of the dependent variable
b = SSXY/SSX

## And the intercept is given by:
mean(SCm) - b*mean(SCL)

## we jumped directly to here:
# using the implemented function, linear model (lm):
lm(SCm~SCL)

# let's inspect the object
SCm.SCL.lm <- lm(SCm~SCL)
summary(SCm.SCL.lm)  ## nice summary statistics of the model

SCm.SCL.lm$coefficients
print(SCm.SCL.lm$coefficients)

SCm.df <- data.frame(645)
colnames(SCm.df) <- "SCm"


new.SCm = data.frame(SCL = 645)
pred <- predict(SCm.SCL.lm, newdata = new.SCm, interval = "confidence")
pred

################################################################################
################################################################################
# Project 1: skull length and body size relation in turtles
# Problem 1.2: finish the plot including the regression formula on it
# hint: use the model object and a second legend() 

## we did not have time to do this project, so I will put it in the final project
par(mfrow = c(1,2), cex = 0.5)

# Emydidae
plot(x = SCL, 
     y = SCm, 
     log = "xy", 
     main = "Skull vs. carapace length in Emydidae",
     xlab = "Carapace length (SCL)",
     ylab = "Skull lenght (SCm)", 
     bty = "l",
     cex = 0)

points(x = SCL[which(F24.size$Clade != "Emydidae")], 
       y = SCm[which(F24.size$Clade != "Emydidae")], 
       pch = 16,
       col = rgb(0.5, 0.5, 0.5, 0.5))

points(x = SCL[which(F24.size$Clade == "Emydidae")], 
       y = SCm[which(F24.size$Clade == "Emydidae")], 
       pch = 15,
       cex = 1.3,
       col = rgb(136/255, 86/255, 167/255))

legend(x = "topleft", 
       legend = c("Emydidae", "Other turtles"),
       bty = "n",
       pch = c(15, 16),
       col = c(rgb(136/255, 86/255, 167/255), rgb(0.5, 0.5, 0.5, 0.5)))

## add a second legend
legend(x = "bottomright", 
       legend = c(paste("y = ", 
                        round(SCm.SCL.lm$coefficients[1], digits = 2), 
                        " + ", 
                        round(SCm.SCL.lm$coefficients[2], digits = 2), 
                        "x"), ""),
       bty = "n",
       cex = 0.8)


# Chelidae
plot(x = SCL, 
     y = SCm, 
     log = "xy", 
     main = "Skull vs. carapace length in Chelidae",
     xlab = "Carapace length (SCL)",
     ylab = "Skull lenght (SCm)", 
     bty = "l",
     cex = 0)

points(x = SCL[which(F24.size$Clade != "Chelidae")], 
       y = SCm[which(F24.size$Clade != "Chelidae")], 
       pch = 16,
       col = rgb(0.5, 0.5, 0.5, 0.5))

points(x = SCL[which(F24.size$Clade == "Chelidae")], 
       y = SCm[which(F24.size$Clade == "Chelidae")], 
       pch = 15,
       cex = 1.3,
       col = rgb(127/255, 191/255, 123/255))

legend(x = "topleft", 
       legend = c("Chelidae", "Other turtles"),
       bty = "n",
       pch = c(15, 16),
       col = c(rgb(127/255, 191/255, 123/255), rgb(0.5, 0.5, 0.5, 0.5)))





################################################################################
# Histogram
## this part of the script needs better explanation and contextualization, it
### was a bit chaotic

# Create two variables, one with uniform and another with normal distribution
# 100 observations for each
norm.var <- rnorm(1000, mean = 1, sd = 0.25)  ## mean around 1 and 0.25 sd
uni.var <- runif(1000, min = -1, max = 1)

plot(norm.var, uni.var)  ## plot does not show perfectly the nature of the dists

# a histogram should show it
?hist()  ## we have to define breaks

# let's define 100 intervals
rg.norm <- range(norm.var)  ## define the range
(max(rg.norm)-min(rg.-norm))/100  ## divide the range by 100

# let's write a function to do that

hundred.breaks <- function(x) {
  rg <- range(x)
  interval <- (max(rg)-min(rg))/100
}


br.norm <- hundred.breaks(norm.var)
br.uni <- hundred.breaks(uni.var)

rg.uni <- range(uni.var)

# now we can use hist
hist(norm.var, breaks = seq(min(rg.norm), max(rg.norm), by = br.norm))
hist(uni.var, breaks = seq(min(rg.uni), max(rg.uni), by = br.uni))

# let's plot them side by side
par(mfrow = c(1,2))

hist(norm.var, 
     breaks = seq(min(rg.norm), max(rg.norm), by = br.norm), 
     col = "red",
     border = "red")


hist(uni.var, 
     breaks = seq(min(rg.uni), max(rg.uni), by = br.uni), 
     col = "blue",
     border = "blue")


# You can save the results in an object and then check some info
hist.norm <- hist(norm.var, 
                  breaks = seq(min(rg.norm), max(rg.norm), by = br.norm), 
                  col = "red",
                  border = "red")

# for example, the density (which is proportional to the frequency)
hist.norm$density

# let's apply a color map based on the frequency?
par(mfrow = c(1,1))
?heat.colors()
heat.colors(10)  ## I want 10 colors from this heat map
heat <- heat.colors(5)  ## but I want the center to be the warm color
heat
rev(heat)
heat <- c(rev(heat), heat)  ## so I put together with its reverse
heat

# if I repeat this 10 times each, I will get a vector with the number of bars
rep(heat, each = 10)

# so let's apply this vector as the color argument
hist(norm.var,
     breaks = seq(min(rg.norm), max(rg.norm), by = br.norm), 
     col = rep(heat, each = 10))

# but, there is a problem. This is not proportional to the frequency itself, but
## relative to the position of the bar. This is clear if I apply it to the 
## uniform distribution histogram
hist(uni.var,
     breaks = seq(min(rg.uni), max(rg.uni), by = br.uni), 
     col = rep(heat, each = 10))


# to work around that, we can take the density of each bar, turn it into a 
## position in the heat map, and then sort them in the order of the bars  
heat <- heat.colors(10)  ## let's now take 10 colors directly
heat <- rev(heat)  ## revert to make red the higher value

# let's obtain 10 intervals for the density values
rg.density.norm <- (max(hist.norm$density)-min(hist.norm$density))/10
# now let's put each value within this interval
heat.density.norm <- hist.norm$density/rg.density.norm  ## we need to round this
#let's round up to avoid 0s
heat.density.norm <- ceiling(heat.density.norm)  ## but there are stil some absolute 0s
heat.density.norm
ifelse(heat.density.norm == 0, yes = 1, no = heat.density.norm)  ## let's turn them into 1s
heat.density.norm <- ifelse(heat.density.norm == 0, yes = 1, no = heat.density.norm)

## now we can use this
hist(norm.var,
     breaks = seq(min(rg.norm), max(rg.norm), by = br.norm), 
     col = heat[heat.density.norm])

# now it seems to work. Let's check with the uni.var
hist.uni <- hist(uni.var,
                 breaks = seq(min(rg.uni), max(rg.uni), by = br.uni), 
                 col = rep(heat, each = 10))
# let's obtain 10 intervals for the density values
rg.density.uni <- (max(hist.uni$density)-min(hist.uni$density))/10
# now let's put each value within this interval
heat.density.uni <- hist.uni$density/rg.density.uni  ## we need to round this

# instead of doing it all over again, let's write a function to adjust the range
adjust.rg <- function(x, new_min, new_max, integer_output = FALSE) {
  # this function will the range of value x and adjust it to a new range
  old_min <- range(x)[1]
  old_max <- range(x)[2]
  adjusted_value <- (x - old_min)/(old_max - old_min)*(new_max - new_min) + new_min
  # (x-old_min)/(old_max-old_min) this will transform the range to a 0:1 range
  # (new_max-new_min) multiplies 0:1 range to the new range
  # +new_min adds the starting point of the new range
  if(integer_output) return(round(adjusted_value))  ## no decimals
  return(adjusted_value)  ## decimals allowed
}

save(adjust.rg, file = "adjust.rg.R")

heat.density.uni <- adjust.rg(heat.density.uni, 1, 10, integer_output = TRUE)

# now plot
hist(uni.var,
     breaks = seq(min(rg.uni), max(rg.uni), by = br.uni), 
     col = heat[heat.density.uni])

# let's plot both side by side
par(mfrow = c(1,2))
hist(norm.var,
     breaks = seq(min(rg.norm), max(rg.norm), by = br.norm), 
     col = heat[heat.density.norm])

hist(uni.var,
     breaks = seq(min(rg.uni), max(rg.uni), by = br.uni), 
     col = heat[heat.density.uni])

################################################################################
# Boxplots
par(mfrow = c(1,1))
?boxplot
attach(F24.size)
boxplot(formula = SCL~Clade)

clade.box <- boxplot(SCL~Clade)  ## let's look at the object
clade.box

# I want to make a plot coloring the boxes based on their mean values

clade.box$stats  ## it looks like the third line is the mean
clade.box$stats[3,]  ## let's compare this to the mean
tapply(SCL, Clade, FUN = mean, na.rm = T)  ## mean, ignoring NAs. Close enough?

# But now let's use another color map, a colorblind-friendly one: viridis
install.packages("viridisLite")
library(viridisLite)
plot(1:10, 1:10, pch = 16, cex = 5, col = viridis(10))

clade.means <- clade.box$stats[3,]
mean.rg <- range(clade.means)[]
mean.int <- (max(clade.means)-min(clade.means))/10
mean.int <- clade.means/mean.int

adjust.rg(floor(mean.int), 1, 10)
adjust.rg(floor(mean.int), 1, 10, integer_output = TRUE)
mean.int <- adjust.rg(floor(mean.int), 1, 10, integer_output = TRUE)

boxplot(SCL~Clade, col = viridis(10)[mean.int])
# the argument log will again make it easier to see the smallest values, but 
## pay attention to the ranges
boxplot(SCL~Clade, col = viridis(10)[mean.int], log = "y")