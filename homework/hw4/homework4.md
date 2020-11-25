### Homework 4: Pipelines, Plotting, and Genome Assembly
##### Sam Du, EE282 Fall 2020

___

#### Summarize Partitions of a Genome

**Data**: Downloaded the most current _D. melanogaster_ genome (dmel-all-chromosome-r6.36.fasta.gz) from [FlyBase](ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/).

`wget ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.36_FB2020_05/fasta/dmel-all-chromosome-r6.36.fasta.gz`

**Partitioning the Genome**: I used bioawk to partition the genome into two partitions: all sequences  equal to or less than 100kb, and all other sequences  more than 100kb.

For sequences greater than 100kb:

`bioawk -c fastx \
'length($seq) > 100000 {print ">" $name "\n" $seq}' \
dmel-all-chromosome-r6.36.fasta.gz \
| gzip -c \
> dmelr6.gt.fa.gz`

For sequences less than or equal to 100kb:

`bioawk -c fastx \
'length($seq) <= 100000 {print ">" $name "\n" $seq}' \
dmel-all-chromosome-r6.36.fasta.gz \
| gzip -c \
> dmelr6.lte.fa.gz`

To calculate the statistics for the files, I used `faSize`:

`faSize dmelr6.gt.fa.gz`
`faSize dmelr6.lte.fa.gz`

**Results**

|                        | Less than or equal to 100kb | Greater than 100kb |
|------------------------|:---------------------------:|:------------------:|
| Total # of nucleotides |           6178042           |      137547960     |
|          Total # of Ns |            662593           |       490385       |
|   Total # of sequences |             1863            |          7         |

#### Plot Sequence Length Distributions, GC Percentage, Cumulative Sequence Size of Genom Partitions

For sequences greater than 100kb:
`bioawk -c fastx \
'{print length($seq) "\t" gc($seq) "\t" $name}' \
dmelr6.gt.fa.gz \
> dmelr6.gt_summarized.fa.gz `

### R plotting
```R
greaterThan <- read.table(file="clipboard", sep='\t', header=F)

colnames(greaterThan) <- c('length', 'GC', 'name')

greaterThan$log_length <- log(greaterThan$length)

plot_greaterThanLength <- ggplot(data=greaterThan, aes(x=logLength)) +geom_histogram(
binwidth=0.01)
plot_greaterThanLength


lessThan <- read.table(file="clipboard", sep='\t', header=F)

colnames(lessThan) <- c('length', 'GC', 'name')

lessThan$log_length <- log(lessThan$length)

plot_lessThanLength <- ggplot(data=lessThan, aes(x=log_length)) +geom_histogram(
bins=200)
plot_lessThanLength
```
