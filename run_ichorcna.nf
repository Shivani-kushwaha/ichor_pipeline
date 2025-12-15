//module 4: process to run ichorCNA and generate all the reports including params.txt, which is used to extract tumor fraction information for individual samples.
process RUN_ICHORCNA {
  tag "${id}"
  publishDir "results/ichorCNA", mode: 'copy'

  input:
  tuple val(id), path(wig)
  path gc_wig
  path map_wig
  path centromere
  path pon

  output:
  tuple val(id), path("out_${id}/*params*.txt"), optional: true
  tuple val(id), path("out_${id}/*segments*.txt"), optional: true
  tuple val(id), path("out_${id}/*.seg"),          optional: true
  tuple val(id), path("out_${id}/*.cna.seg"),      optional: true
  tuple val(id), path("out_${id}/*.pdf"),          optional: true


  shell:
  """
  set -euo pipefail
  mkdir -p ./out_${id}
  RUNSCRIPT=/opt/ichorCNA/scripts/runIchorCNA.R
  echo "Using runIchorCNA at: \$RUNSCRIPT"

  micromamba run -n base Rscript "\$RUNSCRIPT" \
    --id ${id} \
    --outDir ./out_${id} \
    --WIG ${wig} \
    --gcWig ${gc_wig} \
    --mapWig ${map_wig} \
    --centromere ${centromere} \
    --normalPanel ${pon} \
    --ploidy "c(2)" --normal "0.5" \
    --estimateNormal TRUE --estimatePloidy TRUE \
    --includeHOMD FALSE --maxCN 5 --genomeBuild hg38 --genomeStyle UCSC

  """
}
