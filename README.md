# 2024 Sequencing exosomal RNA from plasma and urine of SLE and controls

For this project, we received isolated exosomes from different biofluids and generated sequencing libraries with the Takeda small RNA kit. After mapping, we saw substantial read coverage overlapping not just miRs, but coding genes. These may be transcript fragments or promoter-associated RNAs. The count matrices, normalized expression, and differential expression results can be found in the FigShare project.

This is a little different than our normal projects as we were working on a large number of different diseases at once. The differential expression used many different projects data and we extracted the contrasts of interest. By the time the paper was put together, we didn't have notice to regenerate figures using only this project's data. As a compromise to trying to recreate the paper images, the differential expression and rlog data for this project's samples are on FigShare. The count matrices are there as well, but since the exact conditions can't be repeated the exact values differ. The trends remain, and in spot checking are stronger than what's in the paper even. If you run the code sequentially, it will download the data files for you and recreate the images.

Paper: Pending

## Data

[FigShare project](https://figshare.com/projects/2024_Jarjour_SLE_exosome_miRs/203685)

## Requirements - R libraries
* cowplot
* DESeq2
* ggrepel
* here
* reshape2
* tidyverse

