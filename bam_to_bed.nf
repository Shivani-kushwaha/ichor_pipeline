// module 2: process to create hg38 bed from hg38 bam using bedtools
process BAM_TO_BED {
  tag { id }
  publishDir "results/hg38_beds", mode: 'copy'

  input:
  tuple val(id), path(bam)

  output:
  tuple val(id), path("${id}.hg38.bed")

  """
  # Bedtools to convert hg38 BAM to hg38BED 
  bedtools bamtobed -i ${bam} \
    | sort -k1,1 -k2,2n \
    > ${id}.hg38.bed
  """
}

