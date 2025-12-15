The workflow consists of 5 modules: 

Module 1: Takes the hg19 bam sorts it, indexes it, and converts it to hg38 bam using liftover tool and samtools

Module 2: Takes the hg38 bam and converts it hg 38 bed using bedtools

Module 3: Converts the hg38 bam to hg38 Wig using readCounter with binsize of 1Mb and phred score 20

Module 4: Run ichorCNA and generate all the reports including params.txt used to extract tumor fraction information for individual samples with identifier

Module 5: Generates a final tsv report wth sample identifier and tumor fraction for each bam present in /input_bams


Installation: 
1. Install the latest version of nextflow 
2. Build the docker image from the Dockerfile
3. Run command - nextflow run main.nf 
Nextflow 



I/O files
1. Input bams directory - /input_bams 
2. Output directory - /results/reports
3. ichor output for each sample reports -  /results/reports/ichorCNA
4. nextflow execution report -  /results/reports
3. references directory - /ref 
4. ichor input files directory- /ref/ichorCNA 
