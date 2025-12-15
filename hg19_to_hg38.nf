// module 1: process to converts hg19bam to hg38bam using liftover
process LIFT_OVER_BAM {
  tag { id }
  publishDir "results/hg38_bams", mode: 'copy'

  input:
  tuple val(id), path(bam)
  path chainFile  // Staging the chain file
  path hg38fa     // Staging the reference FASTA
  
  output:
  tuple val(id), path("${id}.hg38.bam")

  script:
  """
  set -euo pipefail
  
  # Sort & index the hg19 bam 
  micromamba run -n base samtools sort -o ${id}.sorted.bam ${bam}
  micromamba run -n base samtools index ${id}.sorted.bam

  # Staging chain path into a bash var (Groovy expands ${chainFile} once)
  CHAIN="${chainFile}"
  if [[ "\$CHAIN" == *.gz ]]; then
    gunzip -c "\$CHAIN" > ${id}.chain
    CHAIN=${id}.chain
  fi
  
  # Liftover hg19BAM -> hg38BAM
  micromamba run -n base CrossMap bam "\$CHAIN" ${id}.sorted.bam ${id}.hg38.tmp

  # Re-sort & index liftover hg38BAM
  micromamba run -n base samtools sort -o ${id}.hg38.bam ${id}.hg38.tmp.bam
  micromamba run -n base samtools index ${id}.hg38.bam
  """
}

