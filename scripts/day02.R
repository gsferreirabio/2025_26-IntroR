################################################################################
# Day 2

# remember:
vec.1 < 4
# we can check this with more detail
all(vec.1 < 4)  ## all() tests if ALL values in the vector are less than 4
any(vec.1 < 4)  ## is there ANY values in the vector less than 4?

# logarithms 
log(42)  ## natural log
log10(42)  ## base 10 logs
log10(42*54)  ## operations can be fitted as arguments
log10(seq(2, 10, by = 2))  ## functions can also be fitted as arguments

log(19, 3)  ## the second argument of log allows determining the base

# antilog function
exp(1)
log(10)
exp(log(10))

# Square root
X = sqrt(4)
X*X == X^2

# mean, median, sum, max, min, range
mean(1:10)
sum(1:3)
max(1:52)
min(1:52)

sum.rep = rep(1:3, times = 1:3)
sum(sum.rep)
mean(sum.rep)
median(sum.rep)

z = c(5, 3, 6, 7, 7, 6, 2, 1, 10) 
range(z)

# sorting elements in a vector/list
z
sort(z)

# now suppose we want to sum the 3 largest numbers in this list
rev(sort(z))
rev(sort(z))[1:3]  ## it helps working the code piece-by-piece
sum(rev(sort(z))[1:3])  

# which
z
which(z == max(z))  ## which element in z has the maximum value of z
z[9]
which(z == min(z))
z[8] == min(z)

# or use which.max/which.min
which.max(z)


# Rounding numbers
floor(5.7)  ## the greatest integer less than
ceiling(5.7)  ## next integer
round(x = 5.7562, digits = 0)  ## this allows you to determine how many decimals you want 
round(5.7562, 1)
round(5.7562, 2)
signif(12345678, digits = 4)  ## signif() works similarly, but for large integers
signif(12345678, digits = 2)  ## see the notation for 12 million

length(sequence.2)
length(Y)
length(seq(0, 10, by = 2))

# Logical/checking functions
is.numeric(y)
is.numeric(written.answer)

is.character(written.answer)
as.character(y)  ## you can represent objects from one type to another
as.character(y) + Y  ## summing a character with a number should not work


# Random distributions
sample(100:200, 100)  ## random samples of integers

## random sample from a normal dist
rnorm(100)  ## sample 100 numbers from a normal distribution
rnorm(100, mean = 10, sd = 0.1)
rnorm(100, mean = 10, sd = 10)


## random sample from uniform dist
# The uniform distribution is a probability distribution in which every value 
#  between an interval from a to b is equally likely to occur.
runif(5)
runif(5, min = 0, max = 10) ## generates 5 random between 0 and 10

runif(5, min = 0, max = 10) == runif(5, min = 0, max = 10)


# Factors
# Factors are categorical variables that have a fixed number of levels
obj.colors = factor(c("black", "white", "black", "black", "pink", "white"))  ## 
class(obj.colors)
levels(obj.colors)
nlevels(obj.colors)
length(levels(obj.colors))  ## the length of the levels is = nlevels

# A data frame is created when you read a table in R
## check the arguments of read.table()
daphnia.data = read.table(file = "daphnia.txt", header = T)  
daphnia.data
class(daphnia.data)
head(daphnia.data)  ## returns parts of an object, by default the first 6 lines
## this data frame has column (w names): 1 continuous and 3 categorical variables
daphnia.data[,1]
daphnia.data$growthRate
daphnia.data[,1] == daphnia.data$growthRate
daphnia.data[10,1] == daphnia.data$growthRate[10]

# attach is very useful, it will attach a database to the R search path
attach(daphnia.data)
water
detergent
daphnia

# are the categorical variables factors?
is.factor(daphnia.data$detergent)
is.factor(as.factor(detergent)) ## as.factor() will convert a 
## variable to factor

# the change into factor can be made permanent as:
daphnia.data$detergent = as.factor(daphnia.data$detergent) 
is.factor(daphnia.data$detergent)
levels(daphnia.data$detergent)

# factors are treated alphabetically by default
as.factor(daphnia.data$water)
# the second argument in factor() allows you to change the order
factor(as.factor(daphnia.data$water), levels = c("Wear", "Tyne"))
## this might be useful when ordering bars in a bar chart, for example

# you can also turn factor levels into numbers
as.vector(unclass(daphnia.data$detergent))

# This type of treatment is called coercing
# There are many is. functions
lv = c(T, F, T)
is.logical(lv)
is.factor(lv)
fv = as.factor(lv)  ## as.factor() will coerce the object into factors
is.factor(fv)
fv
nv = as.numeric(lv)  ## as.numeric() will coerce the object into numbers
nv

as.numeric(factor(c("a", "b", "c")))
## these is. functions can be very useful in other functions when checking the 
##  type of the input object (see below)


################################################################################
# Missing values (NAs)
y = c(4, NA, 7)
is.na(y)  ## this will check if there are NAs in the vector y
# to produce a vector with the NA striped out, use:
y[!is.na(y)]  ## this reads: "values of y which are not NA

# some functions will not work when there are missing values in the data
x = c(1:8, NA)
mean(x)
mean(x, na.rm = T)  ## mean() has an argument to remove NAs

# it is also possible to replace the NAs using the ifelse() function
ifelse(test = is.na(x), yes = 9, no = x)




################################################################################
# End of session
#To see what variables you have created in this session
objects()



################################################################################
# Installing and using packages
# To use a package you just need to call it using the function library()
library(base)

# to see the contents of a package use:
library(help=base)

# not all packages are readly available on R, some you'll need to install
install.packages("ggplot2")
# and then load it
library(ggplot2)


# Setting the working directory
getwd()
setwd("Path to the directory")

#Another helpful function is to list files in the directory
dir()

################################################################################
# Functions: inspect the help page for a new function

daphnia.data = read.table("daphnia.txt", header = TRUE)
head(daphnia.data)
class(daphnia.data)
dim(daphnia.data)

F24.size = read.table("size-meas.csv", header = TRUE)  ## cannot open
F24.size = read.table("Ferreira_etal-2024/size-meas.csv", header = TRUE)

class(F24.size)
dim(F24.size)  ## there is something wrong, only one line
head(F24.size)

?read.table  ## sep = "" means the separator is space by default
# but there is another function called read.csv whose separator is "," by default
F24.size.csv = read.csv("Ferreira_etal-2024/size-meas.csv", header = TRUE)
identical(F24.size, F24.size.csv)
head(F24.size)
head(F24.size.csv)
dim(F24.size)
dim(F24.size.csv)

# But we can also change the sep argument to get the same result
F24.size.table = read.table("Ferreira_etal-2024/size-meas.csv", sep = ",", 
                            header = TRUE)

identical(F24.size.csv, F24.size.table)  ## they are identical

# In the folder Godoy_etal-2019 we have a .xlsx file, how to read it?
read.table("Godoy_etal-2019/G19-dataset.xlsx", header = T)
read.csv("Godoy_etal-2019/G19-dataset.xlsx", header = T)
## open it with notepad and you will see a different structure

# There is also a read_excel() function in another package, can you find it?
# Package readxl
find("read_excel")
# Install package and 
install.packages("readxl")
library(readxl)

?read_excel()
G19.data = read_excel("Godoy_etal-2019/G19-dataset.xlsx")
head(G19.data)  ## it looks different, let's check why
class(G19.data)  ## it has multiple object types, including "tbl"
G19.data$Species  ## but it works similarly to a dataframe
attach(G19.data)
Species

# there are a multitude of object types in R, this is always an important issue!+

objects()
attach(F24.size.table)
# I want the mean of SCL in this table
mean(SCL)  ## what is wrong?
mean(SCL, na.rm = T)

# but maybe I want the mean SCL for each clade in this dataset
mean(SCL[which(Clade == "Chelidae")], na.rm = T)  ## only SCL whose Clade is Chelidae

# You can do that for each Clade, or use tapply for applying a function to 
## groups of values
tapply(SCL, Clade, FUN = mean)  ## what is missing here?
tapply(SCL, Clade, FUN = mean, na.rm = T) 

# you can apply any function, let's check the maximum SCL now
tapply(SCL, Clade, max, na.rm = T)  ## warning message
SCL[which(Clade == "Dermochelyidae")]  ## this is the reason

# another very useful function that can do similar things, is aggregate
aggregate(SCL ~ Clade, F24.size.table, mean)
tapply(SCL, Clade, FUN = mean, na.rm = T)  ## same results

# aggregate can do interactions between variables, for example
names(G19.data)  ## mean dorsal cranial length per group and lifestyle
attach(G19.data)

aggregate(`DCL (mm)` ~ Group + Lifestyle, G19.data, mean)
# aquatic/marine Crocodylia have a DCL of 755.6444 mm, but 
## semi-aquatic/freshwater Crocodylia have 379.1041 mm


# which is the maximum value?
GL.DCL = aggregate(`DCL (mm)` ~ Group + Lifestyle, G19.data, max)
which.max(GL.DCL$`DCL (mm)`)
# now check the maximum value and organize the results in min to max values
sort(GL.DCL$`DCL (mm)`)

# let's now say I want to reorder the GL.DCL object based on DCL
names(GL.DCL)
attach(GL.DCL)

# using the function order() 
order(GL.DCL[,3])  ## this is ordering DCL from small to large
# now use it as a vector for the order of the rows in the dataframe
GL.DCL[order(GL.DCL[,3]),]
GL.DCL = GL.DCL[order(GL.DCL[,3]),]  ## this will replace the order

rownames(GL.DCL) = 1:11
GL.DCL


################################################################################
# other types of data
apropos("read")  # search for functions with read in their names

# this will only search on the loaded packages!
install.packages("phytools")
library(phytools)

apropos("read")  ## see how many additional types are in there now
?read.tree  ## we will use this one later

# Google search will help you finding other functions to read your data

################################################################################
# Other summary functions & inspecting functions
head(G19.data)
class(G19.data)
length(G19.data)  ## takes only the number of columns in multidimensional data
dim(G19.data)  ## takes more than one dimension

summary(G19.data)  ## this function gives more information about the variables
summary(F24.size.table)


################################################################################
# Let's subset a dataset
head(F24.size.table)
levels(as.factor(F24.size.table$Clade))  ## check which names are there
which(F24.size.table$Clade == "Chelidae")
Chelidae = F24.size.table[which(F24.size.table$Clade == "Chelidae"), ] ## subset 
## only chelids

summary(Chelidae)  ## there are 35 lines in this
# now let's just keep the first 10; how would you do it?
Chelidae.15 = Chelidae[1:15,]
Chelidae.10.35 = Chelidae[10:35,]

intersect(Chelidae.15, Chelidae.10.35)  ## did not work, why? Look at Help, it needs vector
chel.inter = intersect(Chelidae.15$Species, Chelidae.10.35$Species)  ## which species overlap?
Chelidae.subset = Chelidae[which(Chelidae$Species == chel.inter),]

union(Chelidae.10$Species, Chelidae.rest$Species)
levels(as.factor(Chelidae$Species))
chelid.uni = union(Chelidae.10$Species, Chelidae.rest$Species)
chelid.levels = levels(as.factor(Chelidae$Species))

# are the lists the same?
identical(chelid.levels, chelid.uni)  ## identical() compares all attributes
setdiff(chelid.levels, chelid.uni)  ## checks the differences between two objects

setdiff(Chelidae.10.35$Species, Chelidae.15$Species)
setdiff(Chelidae.15$Species, Chelidae.10.35$Species)  ## why is there only 5?

# now let´s create an object containing only the species that are in 15 but not 10.35
difference = setdiff(Chelidae.15$Species, Chelidae.10.35$Species)
new.Chelidae = Chelidae.15[which(Chelidae.15$Species %in% difference),]
new.Chelidae


################################################################################
# Writing your own function
# Write a function for calculating the median
# The median is the numeric value separating the distribution in half

# So, if your distribution is:
dist.1 <- c(1,2,3,4,5)
median(dist.1)  ## the median is 3
# The numbers need to be ordered from min to max to get the median
dist.2 <- c(5,3,1,3,2)
median(dist.2)

# What happens if the number of elements is odd? Than an average of the two
## numbers in the center of the distribution is the median
dist.3 = c(1,2,3,4,5,6)
median(dist.3)  ## 3+4/2

# Let's write a function to calculate the median? I will give you the algorithm
# 1. order the sequence
# 2. check if it is even or odd
# 3. if it is even, calculate the mean between the number before and after the 
#### half of the position
# 4. if it is odd, select the number in the position half the length of the seq

# let's check some functions that might be useful
length(dist.3)%%2
sort(dist.3)[length(dist.3)/2]
sort(dist.3)[1+ length(dist.3)/2]
ceiling(length(dist.2)/2)

# let's now create a function

med <- function(x) {
  odd.even <- length(x)%%2
  if (odd.even == 0) {  ## we are going to use if/else statements
    (sort(x)[length(x)/2] + sort(x)[1 + length(x)/2])/2
  }
  else sort(x)[ceiling(length(x)/2)]
}

med(dist.2)  ## always test with simple examples
med(dist.3)


# you could also write this function using the function ifelse instead

med <- function(x) ifelse(length(x)%%2 == 1, sort(x)[ceiling(length(x)/2)], 
                          (sort(x)[length(x)/2] + sort(x[1+ length(x)/2]))/2)


med(dist.2)
med(dist.3)


# Problem: is it morning, afternoon or evening?
# Morning = before 12h
# Afternoon = 12h onward but before 18h
# Evening = from 18h onward
Sys.time()
format(Sys.time(), "%D %H:%M:%S %Z")

good.day <- function(x) {
  if(format(Sys.time(), "%H") < 12) print("Good morning!")
  else if(format(Sys.time(), "%H") >= 18) print("Good evening!")
  else print("Good afternoon!")
}

good.day()

################################################################################
################################################################################
# Extra example: Calculating Variance 
# The measure of the variability in a sample is very important in statistics.
# The greater the variability, the greater will be the uncertainty in the values
## of the parameters estimated from the data.
# The measured of variance of a sample is a function of the "sum of the squares
## of the difference between the data and the arithmetic mean". This is the 
## "Sum of Squares". 
# Variance (s-squared) can be obtained from the sum of squares divided by the
## degrees of freedom, n - k, in which k is the number of estimated parameters.
## For this calculation we are estimating the mean of the sample, so df = n-1.
# Thus, the function for calculating the variance is:
variance = function(x) sum((x - mean(x))^2)/(length(x) -1)

# sum((x-mean(x))^2) sum of squares
# length(x) -1 is the same as n-k in this case, i.e., the degrees of freedom
# Let's test it
y <- c(13, 7, 5, 12, 9, 15, 6, 11, 9, 7, 12)
variance(y)
var(y)  ## there is an implemented function