#!/sr/bin/env bash

conda activate ee282


n50 () {
  bioawk -c fastx ' { print length($seq); n=n+length($seq); } END { print n; } ' $1 \
  | sort -rn \
  | gawk ' NR == 1 { n = $1 }; NR > 1 { ni = $1 + ni; } ni/n > 0.5 { print $1; exit; } '
}

{ print $1; exit; } '
}

ln -sf /dfs5/bio/share/solarese/hw4/rawdata/iso1_onp_a2_1kb.fastq $raw/reads.fq

minimap -Sw5 -L100 -m0 iso1_onp_a2_1kb.fastq.gz{,} \
| gzip -1 \
> reads.paf.gz

minimap -t 32 -Sw5 -L100 -m0 reads.fq{,} \
| gzip -1 \
> onp.paf.gz
