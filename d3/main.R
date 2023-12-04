require(stringi)
require(data.table)

get_number <- function(i, j, left, right){
  number = as.character(data[i, j])
  
  
  
  if (!is.null(as.numeric(data[i, j - 1])) && left) {
    if (!is.na(as.numeric(data[i, j - 1]))) {
      number = paste(as.character(data[i, j - 1]), number, sep="")
      
      if (!is.null(as.numeric(data[i, j - 2]))) {
        if (!is.na(as.numeric(data[i, j - 2]))) {
          number = paste(as.character(data[i, j - 2]), number, sep="")
        }
      }
    }
  }
  
  if (!is.null(as.numeric(data[i, j + 1])) && right) {
    if (!is.na(as.numeric(data[i, j + 1]))) {
      number = paste(number, as.character(data[i, j + 1]), sep="")
      
      if (!is.null(as.numeric(data[i, j + 2]))) {
        if (!is.na(as.numeric(data[i, j + 2]))) {
          number = paste(number, as.character(data[i, j + 2]), sep="")
        }
      }
    }
  }
  
  
  
  print(number)
  
  return(as.numeric(number))
}

data <- t(as.data.table(strsplit(readLines("advent_of_code/d3/in.txt"), "")))
sum <- 0
leni <- nrow(data)
lenj <- ncol(data)

print(data)

for (i in 0:leni) {
  for (j in 0:lenj) {
    c <- (data[i, j])

    if (!is.null(as.character(c))) {
      if (!is.null(as.numeric(c)) && length(as.numeric(c)) != 0) {
        if (!is.na(as.numeric(c))) {
          
        } else if (as.character(c) == '*') {
          ratio = 1
          count = 0
          
          if (!is.null(as.numeric(data[i, j - 1]))) {
            if (!is.na(as.numeric(data[i, j - 1]))) {
              ratio = ratio * get_number(i, j - 1, TRUE, FALSE)
              count = count + 1
            } 
          } 
          
          if (!is.null(as.numeric(data[i, j + 1]))) {
            if (!is.na(as.numeric(data[i, j + 1]))) {
              ratio = ratio * get_number(i, j + 1, FALSE, TRUE)
              count = count + 1
            } 
          } 
          
          if (!is.null(as.numeric(data[i + 1, j]))) {
            if (!is.na(as.numeric(data[i + 1, j]))) {
              ratio = ratio * get_number(i + 1, j, TRUE, TRUE)
              count = count + 1
            } 
            else {
              if (!is.null(as.numeric(data[i + 1, j - 1]))) {
                if (!is.na(as.numeric(data[i + 1, j - 1]))) {
                  ratio = ratio * get_number(i + 1, j - 1, TRUE, FALSE)
                  count = count + 1
                } 
              } 
              
              if (!is.null(as.numeric(data[i + 1, j + 1]))) {
                if (!is.na(as.numeric(data[i + 1, j + 1]))) {
                  ratio = ratio * get_number(i + 1, j + 1, FALSE, TRUE)
                  count = count + 1
                } 
              } 
            } 
          
          }
          
          if (!is.null(as.numeric(data[i - 1, j]))) {
            if (!is.na(as.numeric(data[i - 1, j]))) {
              ratio = ratio * get_number(i - 1, j, TRUE, TRUE)
              count = count + 1
            } 
            else {
              if (!is.null(as.numeric(data[i - 1, j - 1]))) {
                if (!is.na(as.numeric(data[i - 1, j - 1]))) {
                  ratio = ratio * get_number(i - 1, j - 1, TRUE, FALSE)
                  count = count + 1
                } 
              } 
              
              if (!is.null(as.numeric(data[i - 1, j + 1]))) {
                if (!is.na(as.numeric(data[i - 1, j + 1]))) {
                  ratio = ratio * get_number(i - 1, j + 1, FALSE, TRUE)
                  count = count + 1
                } 
              } 
            }
          } 
          
          if (count == 2) {
            sum = sum + ratio
          }
        }
      }
    }
  }
}

print(sum)




