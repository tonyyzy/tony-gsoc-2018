#!usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  - class: StepInputExpressionRequirement
inputs:
  accession: string
  dataformat: string
  window_size: string
  step: string
  outformat: string
  omittail:
    type: string
    default: null
  singlefile:
    type: string
    default: null
  match: string
  mismatch: string
  delta: string
  PM: string
  PI: string
  minscore: string
  maxperiod: string
  flanking_sequence: string
  data_file: string
  masked_sequence: string
  suppress_html: string
  script:
    type: File
  
outputs:
  fasta_out:
    type: File
    outputSource: Fasta/output
  GCout:
    type: File
    outputSource: GC/output
  TRF_dat_out:
    type: File
    outputSource: TRF/dat
  TRF_mask_out:
    type: File
    outputSource: TRF/mask
  TRF_bed_out:
    type: File
    outputSource: TRFdat_to_bed/output
  CpG_out:
    type: File
    outputSource: CpG/output

steps:
  wgs_url:
    run: ../tools/gz_url.cwl
    in:
      accession: accession
      script: script
    out: [output]
  gz:
    run: ../tools/curl_ftp.cwl
    in:
      accession: accession
      url: wgs_url/output
    out: [output]
  
  Fasta:
    run: ../tools/gz.cwl
    in:
      gzfile: gz/output
    out: [output]
  
  GC:
    run: ../tools/GC_analysis.cwl
    in:
      genomefile:
        source: Fasta/output
      window_size: window_size
      step: step
      outformat: outformat
      outputfile: accession
      omittail: omittail
      singlefile: singlefile
    out: [output]
  
  TRF:
    run: ../tools/trf.cwl
    in:
      genomefile:
        source: Fasta/output
      match: match
      mismatch: mismatch
      delta: delta
      PM: PM
      PI: PI
      minscore: minscore
      maxperiod: maxperiod
      flanking_sequence: flanking_sequence
      data_file: data_file
      masked_sequence: masked_sequence
      suppress_html: suppress_html
    out: [dat, mask]
  
  TRFdat_to_bed:
    run: ../tools/trfdat_to_bed.cwl
    in:
      datfile:
        source: TRF/dat
    out: [output]
  
  CpG:
    run: ../tools/cpg.cwl
    in:
      accession: accession
      genomefile:
       source: TRF/mask
    out: [output]
    