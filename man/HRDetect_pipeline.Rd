% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HRDetect.R
\name{HRDetect_pipeline}
\alias{HRDetect_pipeline}
\title{HRDetect Pipeline}
\usage{
HRDetect_pipeline(data_matrix = NULL, genome.v = "hg19",
  SNV_vcf_files = NULL, SNV_tab_files = NULL, SNV_catalogues = NULL,
  Indels_vcf_files = NULL, CNV_tab_files = NULL,
  SV_bedpe_files = NULL, SV_catalogues = NULL,
  signature_type = "COSMIC", bootstrap_scores = FALSE, nparallel = 1)
}
\arguments{
\item{data_matrix}{data frame containing a sample for each row and the six necessary features as columns. Columns should be labelled with the following names: del.mh.prop, SNV3, SV3, SV5, hrd, SNV8. Row names of the data frame should correspond to the sample names. If the values of the features need to be computed, set them to NA and provide additional data (e.g. catalogues, VCF/BEDPE/TAB files as specified in this documentation page).}

\item{genome.v}{genome version to use when constructing the SNV catalogue and classifying indels. Set it to either "hg19" or "hg38".}

\item{SNV_vcf_files}{list of file names corresponding to SNV VCF files to be used to construct 96-channel substitution catalogues. This should be a named vector, where the names indicate the sample name, so that each file can be matched to the corresponding row in the data_matrix input. The files should only contain SNV and should already be filtered according to the user preference, as all SNV in the file will be used and no filter will be applied.}

\item{SNV_tab_files}{list of file names corresponding to SNV TAB files to be used to construct 96-channel substitution catalogues. This should be a named vector, where the names indicate the sample name, so that each file can be matched to the corresponding row in the data_matrix input. The files should only contain SNV and should already be filtered according to the user preference, as all SNV in the file will be used and no filter will be applied. The files should contain a header in the first line with the following columns: chr, position, REF, ALT.}

\item{SNV_catalogues}{data frame containing 96-channel substitution catalogues. A sample for each column and the 96-channels as rows. Row names should have the correct channel names (see for example tests/testthat/test.snv.tab) and the column names should be the sample names so that each catalogue can be matched with the corresponding row in the data_matrix input.}

\item{Indels_vcf_files}{list of file names corresponding to Indels VCF files to be used to classify Indels and compute the proportion of indels at micro-homology. This should be a named vector, where the names indicate the sample name, so that each file can be matched to the corresponding row in the data_matrix input. The files should only contain indels (no SNV) and should already be filtered according to the user preference, as all indels in the file will be used and no filter will be applied.}

\item{CNV_tab_files}{list of file names corresponding to CNV TAB files (similar to ASCAT format) to be used to compute the HRD-LOH index. This should be a named vector, where the names indicate the sample name, so that each file can be matched to the corresponding row in the data_matrix input. The files should contain a header in the first line with the following columns: 'seg_no', 'Chromosome', 'chromStart', 'chromEnd', 'total.copy.number.inNormal', 'minor.copy.number.inNormal', 'total.copy.number.inTumour', 'minor.copy.number.inTumour'}

\item{SV_bedpe_files}{list of file names corresponding to SV (Rearrangements) BEDPE files to be used to construct 32-channel rearrangement catalogues. This should be a named vector, where the names indicate the sample name, so that each file can be matched to the corresponding row in the data_matrix input. The files should contain a rearrangement for each row (two breakpoint positions should be on one row as determined by a pair of mates of paired-end sequencing) and should already be filtered according to the user preference, as all rearrangements in the file will be used and no filter will be applied. The files should contain a header in the first line with the following columns: "chrom1", "start1", "end1", "chrom2", "start2", "end2" and "sample" (sample name). In addition, either two columns indicating the strands of the mates, "strand1" (+ or -) and "strand2" (+ or -), or one column indicating the structural variant class, "svclass": translocation, inversion, deletion, tandem-duplication. The column "svclass" should correspond to (Sanger BRASS convention): inversion (strands +/- or -/+ and mates on the same chromosome), deletion (strands +/+ and mates on the same chromosome), tandem-duplication (strands -/- and mates on the same chromosome), translocation (mates are on different chromosomes)..}

\item{SV_catalogues}{data frame containing 32-channel substitution catalogues. A sample for each column and the 32-channels as rows. Row names should have the correct channel names (see for example tests/testthat/test.cat) and the column names should be the sample names so that each catalogue can be matched with the corresponding row in the data_matrix input.}

\item{signature_type}{either "COSMIC" or one of the following organs: "Biliary", "Bladder", "Bone_SoftTissue", "Breast", "Cervix", "CNS", "Colorectal", "Esophagus", "Head_neck", "Kidney", "Liver", "Lung", "Lymphoid", "Ovary", "Pancreas", "Prostate", "Skin", "Stomach", "Uterus"}

\item{bootstrap_scores}{perform HRDetect score with bootstrap. This requires mutations or catalogues for subs/rearr to compute the bootstrap fit, and indels mutations to bootstrap the indels classification. HRD-LOH can still be provided using the input data_matrix.}

\item{nparallel}{how many parallel threads to use.}
}
\value{
return a list that contains $data_matrix (updated input data_matrix with additional computed features), $hrdetect_output (data frame with HRDetect BRCAness Probability and contribution of the features), $SNV_catalogues (input SNV_catalogues updated with additional computed substitution catalogues if any), $SV_catalogues (input SV_catalogues updated with additional computed rearrangement catalogues if any)
}
\description{
Run the HRDetect pipeline. This function allows for flexible input 
specification to the HRDetect pipeline that computes the HRDetect 
BRCAness probability score as published in Davies et al. 2017.
It requires an input data frame "data_matrix", which contains a sample
in each row and one of six necessary features in each column. 
The six features can be computed by the pipeline if the necessary input files are provided.
The six features are:
1) proportion of deletions at microhomology (del.mh.prop), 
2) number of mutations of substitution signature 3 (SNV3),
3) number of mutations of rearrangemet signature 3 (SV3),
4) number of mutations of rearrangemet signature 5 (SV5),
5) HRD LOH index (hrd),
6) number of mutations of substitution signature 8 (SNV8).
For example, if the HRD LOH index has already been calculated, these can be
added to the input data_matrix, or if the SNV catalogues have already been calculated,
these can be supplied using the SNV_catalogues parameter while setting SNV3 and SNV8 columns
as "NA". Also, it is possible to provide different data for different samples. For example,
one can provide SNV3 and SNV8 number of mutations for some samples in data_matrix, while setting
SNV3 and SNV8 to NA for other samples, and providing either SNV catalogues and/or SNV VCF 
files for these samples. The function will return the HRDetect BRCAness probability score for
all the samples for which enough data are available to calculate all six necessary features.
Along with the score, the contribution of each feature to the score will be provided. In addition,
an updated data_matrix and other other data that have been calculated during the execution of the pipeline
will be returned as well.
}
\details{
Single Nucleotide Variations. Columns in data_matrix relative to SNV are SNV3 and SNV8. Values
corresponding to number of SNV3 and SNV8 mutations in each sample can be provided in the data frame data_matrix.
Alternatively, an SNV_catalogue data frame can be used to provide 96-channel SNV catalogues for the samples
(96-channels as rows and samples as columns). The 30 consensus COSMIC signatures will be fitted to 
the catalogues using a bootstrapping approach (Huang et al. 2017) and estimates for SNV3 and SNV8 will be added to the data_matrix.
Alternatively, SNV_catalogues can be constructed providing a list of either SNV VCF files or SNV TAB files.

Structural Variants (Rearrangements). Columns in data_matrix relative to SV are SV3 and SV5. Values
corresponding to number of SV3 and SV5 rearrangements in each sample can be provided in the data frame data_matrix.
Alternatively, an SV_catalogue data frame can be used to provide 32-channel SV catalogues for the samples
(32-channels as rows and samples as columns). The 6 Breast Cancer Rearrangement signatures (Nik-Zainal et al. 2016) will be fitted to 
the catalogues using a bootstrapping approach (Huang et al. 2017) and estimates for SV3 and SV5 will be added to the data_matrix.
Alternatively, SV_catalogues can be constructed providing a list of SV BEDPE files.

Deletions at Micro-homology (Indels). The column in data_matrix corresponding to the proportion of deletions at micro-homology is del.mh.prop.
The proportion of deletions at micro-homology for the samples can be calculated by the pipeline if the user provides Indels VCF files.

HRD-LOH index (CNV). The column in data_matrix corresponding to the HRD-LOH index is hrd.
The HRD-LOH index for the samples can be calculated by the pipeline if the user provides copy numbers TAB files.
}
\references{
Davies, H., Glodzik, D., Morganella, S., Yates, L. R., Staaf, J., Zou, X., ... Nik-Zainal, S. (2017). HRDetect is a predictor of BRCA1 and BRCA2 deficiency based on mutational signatures. Nature Medicine, 23(4), 517–525. https://doi.org/10.1038/nm.4292

Nik-Zainal, S., Davies, H., Staaf, J., Ramakrishna, M., Glodzik, D., Zou, X., ... Stratton, M. R. (2016). Landscape of somatic mutations in 560 breast cancer whole-genome sequences. Nature, 534(7605), 1–20. https://doi.org/10.1038/nature17676

Huang, X., Wojtowicz, D., & Przytycka, T. M. (2017). Detecting Presence Of Mutational Signatures In Cancer With Confidence. bioRxiv, (October). https://doi.org/10.1101/132597
}
