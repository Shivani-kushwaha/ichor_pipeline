// module 3: process to convert hg38BAM to hg38 Wig using readCounter with binsiz 1Mb and phred score 20
process BAM_TO_WIG {
  tag "${id}"
  publishDir "results/wigs", mode: 'copy'
  
  input:
    tuple val(id), path(bam_hg38)

  output:
    tuple val(id), path("${id}.1Mb.wig")

  shell:
  """
  set -euo pipefail

  # sort & index 
  samtools sort -o ${id}.sorted.bam ${bam_hg38}
  samtools index ${id}.sorted.bam

  # generate WIG with 1Mb bin size
  readCounter -w ${params.bin_size} -q 20 ${id}.sorted.bam > ${id}.1Mb.wig
  """
}

