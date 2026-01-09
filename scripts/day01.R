######
#Command line vs. scripts
## Text editor or RStudio's built-in editor 
### Learning to *read* code

################################################################################
# Getting help

# The Comprehensive R Archive Network
http://cran.r-project.org/  ## check Manuals & FAQs
  
  # if you know the function's name:
  ?read.table

# if you do not remember the name precisely, but remember the subject:
help.search("data input")  ## results are like: utils::read.DIF (package::function)
help.search("csv")  ## then use ?read.table for more precise info

# find tells you which package the function is in
find("max")
# > package:base
find("read.csv")
# > package:utils

# apropos returns a character vector giving the names of all objects in the 
## search list that match your enquiry
apropos("lm")

# to see a worked example:
example(lm)

# demonstrations of R functions
demo(graphics)  ## hit escape to finish

# citing R
citation()


################################################################################
#Basic syntax

code vs. ##comments

line to the right

use section "breakers" 
################################################################################


################################################################################
# R as a calculator
# Basic arithmetic  operators
2+3
2-3
2*3
2/3
3^2  # 3 to the power of 2

2+3+5+10+25-2  ## multiple operations
2+3*4  ## multiplications and divisions are done first
2+10/5
3^2/2  ## but power comes first

# Parenthesis are useful to determine the order of operations
(2+10)/5

# multiple but independent operations can also be done
2+3; 2*3; 1-10

# for large numbers R uses the following schemes
1.2e3 ## 1200 e3 means "move the decimal point 3 places to the right"
1.2e-2 ## 0.012 e-2 means "move the decimal point 2 places to the left

# Logical operators
1 == 1  ## with two == you are asking "does 1 equals 1?"
1 == 2  
1 != 2  ## with two != you are asking "does 1 differs from 2?"
1 != 1
1 > 2  ## is 1 greater than 2?
1 < 2  ## is 1 smaller than 2?
1 > 1
1 >= 1 ## is 1 greater than or equal to 1?

TRUE == T
FALSE != T
F == FALSE

# other logical operators
## ! & |  --> not, and, or

1:10  ## creates a sequence from 1 to 10

# Modulo and integer quotients
# Suppose we want to know the integer part of a division, in other words, how 
## many 13s are in 119:
119 %/% 13  ## 9 13s in 119

# Now suppose we want to know the remainder, or what is left:
119 %% 13

# You can use the modulo to test whether a number is odd or even
2 %% 2
3 %% 2

# Likewise, you can use modulo to test if a number is an exact multiple of another
15421 %% 7 == 0  ## if 15321 is an exact multiple of 7, than the modulo should be 0


################################################################################
# Storing results into variable
# = or -> to 
x = 1+2
x
y <- 1-x
y

answer = y - x == 3
answer

# R is case sensitive! So Y is not the same as y
Y = 2
y + Y

# use " " for character strings
written.answer <- "y - x is not 3"
written.answer

# Variables in R can store multiple types of objects
# Vectors or lists
sequence = 1:10
sequence

# you can also combine values into a vector or list using:
sequence = c(1, 2, 3, 4, 5)
sequence

# Matrices by combining vectors
vec.1 = c(2, 4, 6)
vec.2 = c(3, 5, 7)

matrix.1 = rbind(vec.1, vec.2)  ## binds them by row
matrix.2 = cbind(vec.1, vec.2)  ## binds them by column

# arithmetic operations can be done using vectors and matrices
vec.1 + vec.2  ## sums the compatible positions
sequence + vec.1  ## different sized objects won't work
vec.1 < 4  ## logical operations with a vector

## unless the number of positions are multiples
sequence = 1:6  ## this vector has six elements
vec.1  ## this has three
sequence + vec.1  ## vec.1 is repeated once so that all positions in sequence are met

sequence == vec.1  ## logical operators can also be use; positions are again repeated



################################################################################
# R has many functions to automatize basic operations
sequence.1 = 1:20
sequence.2 = seq(from = 1, to = 20)
sequence.1 == sequence.2  ## compares each position

# functions allow you to do more complex things
seq(from = 1, to = 20, by =2)  ## increment by 2
seq(from = 1, to = 20, length.out = 5)  ## five numbers will be spread along 
## this sequence

seq(0, 10)  ## if you do not use the argument's name, the order is kept

# Repetitions:
rep(9, 5)  ## repeat 9 five times
rep(1:4, 2)
rep(1:4, each = 2)  ## repeat 1:4, each number twice
rep(1:4, each = 2, times = 3)
# it also works with character strings
rep("cat", 5)
rep(c("cat", "dog", "mouse"), times = 1:3)