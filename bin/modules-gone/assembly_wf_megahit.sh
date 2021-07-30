#Usage: soure code.sh [directory with paired-end fastq] [threads]
cd $1
echo -e "\033[32;1muse forward sequences:\033[0m"
ls *_1.fq.gz | sed ':a;N;s/\n/,/g;ta'
echo -e "\033[32;1muse reverse sequences:\033[0m"
ls *_2.fq.gz | sed ':a;N;s/\n/,/g;ta'

echo -e "\033[32;1mAssembly reads into contigs using MEGAHIT...\033[0m"

forwardseq=$(ls *_1.fq.gz | sed ':a;N;s/\n/,/g;ta')
reverseseq=$(ls *_2.fq.gz | sed ':a;N;s/\n/,/g;ta')

conda activate assembly

megahit -1 $forwardseq -2 $reverseseq -o assembly --out-prefix ${1%} -t $2

# Simplified headers
mv assembly/${1%}.contigs.fa assembly/${1%}.raw.contigs.fa
cat assembly/${1%}.raw.contigs.fa | sed 's/ .*//g' | sed "s/k141/${1%}/g" > assembly/${1%}.contigs.fa

cd -
conda deactivate
echo -e "\033[32;1mAssembly finished\033[0m"
