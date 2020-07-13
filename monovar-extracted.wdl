version 1.0

## This is an extract of a WDL that used monovar in context of a larger, single cell analysis workflow
workflow singleCellGenotyping {
  input {
    # genome specific parameters
    String ref_name
    File ref_fasta
    File ref_fasta_index
  }

    String monovarDocker = "fredhutch/monovar:1.2"
###########################
  call monovar {
    input:
      singleCellBams = ApplyBaseRecalibrator.recalibrated_bam,
      singleCellBamBais = ApplyBaseRecalibrator.recalibrated_bai,
      base_file_name = sampleName,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      taskDocker = monovarDocker
  }
###########################


# Outputs that will be retained when execution is complete
output {
###########################
    File monovar_vcf = monovar.variants
  }
}# End workflow

#### TASK DEFINITIONS
###########################
# Monovar analysis
task monovar {
  input {
    Array[File] singleCellBams
    Array[File] singleCellBamBais
    String base_file_name
    File ref_fasta
    File ref_fasta_index
    String taskDocker
  }
  command {
    set -eo pipefail 

    samtools mpileup -BQ0 -d10000 -f ~{ref_fasta} \
      -q 40 -b ~{write_lines(singleCellBams)} | \
      monovar.py -p 0.002 -a 0.2 -t 0.05 -m 4 \
        -f ~{ref_fasta} -b ~{write_lines(singleCellBams)} -o ~{base_file_name}.monovar.vcf
  }
  runtime {
    docker: taskDocker
    cpu: 4
    memory: "8 GB"
    walltime: "4-00:00:00"
  }
  output {
    File variants = "~{base_file_name}.monovar.vcf"
  }
  }
  ###########################
