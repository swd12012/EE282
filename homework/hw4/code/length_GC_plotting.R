#For Length Plotting

library(ggplot2)

##Greater than 100kb

#Read in file
greaterThan <- read.table(file="dmelr6.gt_lengthSorted", sep='\t', header=F)

#Append column names so they are easily referenced
colnames(greaterThan) <- c('length', 'GC', 'name')

#Log transform length data
greaterThan$log_length <- log(greaterThan$length)

#gpplot logLength data by histogram
plot_greaterThanLength <- ggplot(data=greaterThan, aes(x=log_length)) +geom_histogram(
  bins=7) + labs(title = 'Log Sequence Length, >100kb')
plot_greaterThanLength

#Save file
ggsave('greaterThanLength.png')

##Less than or equal to 100kb

#Read in file
lessThan <- read.table(file="dmelr6.lte_lengthSorted", sep='\t', header=F)

#Append column names so they are easily referenced
colnames(lessThan) <- c('length', 'GC', 'name')

#Log transform length data
lessThan$log_length <- log(lessThan$length)

#gpplot logLength data by histogram
plot_lessThanLength <- ggplot(data=lessThan, aes(x=log_length)) +geom_histogram(
  bins=200) + labs(title = 'Log Sequence Length, <100kb')
plot_lessThanLength

#Save file
ggsave('lessThanLength.png')

#For GC Plotting

##Greater than 100kb

plot_greaterThanGC <- ggplot(data=greaterThan, aes(x=GC)) +geom_histogram(
  binwidth=0.01) + labs(title = 'GC Percentage, >100kb')
plot_greaterThanGC

#Save file
ggsave('greaterThanGC.png')

##Less than or equal to 100kb

plot_lessThanGC <- ggplot(data=lessThan, aes(x=GC)) + geom_histogram(bins=200) + 
  labs(title = 'GC Percentage, <100kb')
plot_lessThanGC

#Save file
ggsave('lessThanGC.png')
