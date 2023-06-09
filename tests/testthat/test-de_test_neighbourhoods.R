# context("Testing de_test_neighbourhoods")
library(miloDE)
library(miloR)
library(SingleCellExperiment)

# load data
data("sce_mouseEmbryo", package = "miloDE")
set.seed(32)
sce = assign_neighbourhoods(sce_mouseEmbryo , k = 25, prop = 0.2, order = 2, filtering = T, reducedDim_name = "pca.corrected", k_init = 50, d = 30)
meta_sce = as.data.frame(colData(sce))
de_stat_sce = de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = "SCE")
de_stat_df = de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"),  output_type = "data.frame")

# wrong inputs return error
# error msgs
test_that("Wrong input gives errors", {

  # x should be of the right format
  expect_error(de_test_neighbourhoods(x = 1 , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = "SCE"),
               "x should be a SingleCellExperiment or Milo object.",
               fixed=TRUE
  )
  sce_test = sce_mouseEmbryo
  colnames(sce_test) = rep(1,1,ncol(sce_test))
  expect_error(de_test_neighbourhoods(x = sce_test , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = "SCE"),
               "If colnames(x) exist, they should be unique.",
               fixed=TRUE
  )

  # sample_id should be character
  expect_error(de_test_neighbourhoods(x = sce , sample_id = 11, design = ~tomato, covariates = c("tomato"),  output_type = "SCE"),
               "Check sample_id - should be character vector",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = TRUE, design = ~tomato, covariates = c("tomato"),  output_type = "SCE"),
               "Check sample_id - should be character vector",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = sce, design = ~tomato, covariates = c("tomato"),  output_type = "SCE"),
               "Check sample_id - should be character vector",
               fixed=TRUE
  )

  # design should be formula
  expect_error(de_test_neighbourhoods(sce , sample_id = "sample", design = "~tomato", covariates = c("tomato"),  output_type = "SCE"),
               "Check design - should be formula object",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(sce , sample_id = "sample", design = 1, covariates = c("tomato"),  output_type = "SCE"),
               "Check design - should be formula object",
               fixed=TRUE
  )

  # covariates should be vector
  expect_error(de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = 1,  output_type = "SCE"),
               "Check covariates - should be character vector",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato,  output_type = "SCE"),
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = NULL, output_type = "SCE"),
               "Check covariates - should be character vector",
               fixed=TRUE
  )

  # contrasts should be NULL or character vector; if character - length 1
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), contrasts = c(1,2), output_type = "SCE"),
               "Check contrasts - should be NULL or character vector",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), contrasts = c("1","2"), output_type = "SCE"),
               "At the moment we only support one comparison - contrasts should be of length 1. If you wish to perform several comparisons, please run separately for each of them.",
               fixed=TRUE
  )

  # min_n_cells_per_sample - positive integer
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_n_cells_per_sample = "aa",  output_type = "SCE"),
               "Check min_n_cells_per_sample - should be positive integer",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_n_cells_per_sample = 1.5,  output_type = "SCE"),
               "Check min_n_cells_per_sample - should be positive integer",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_n_cells_per_sample = 0,  output_type = "SCE"),
               "Check min_n_cells_per_sample - should be positive integer",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_n_cells_per_sample = -100,  output_type = "SCE"),
               "Check min_n_cells_per_sample - should be positive integer",
               fixed=TRUE
  )


  # min_count - non negative
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_count = "aa",  output_type = "SCE"),
               "Check min_count - should be non negative number",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), min_count = -100,  output_type = "SCE"),
               "Check min_count - should be non negative number",
               fixed=TRUE
  )


  # output_type - either data.frame or SCE
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = 1 ),
               "Check output_type - should be either 'data.frame' or 'SCE'",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = TRUE ),
               "Check output_type - should be either 'data.frame' or 'SCE'",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = 'dataframe' ),
               "Check output_type - should be either 'data.frame' or 'SCE'",
               fixed=TRUE
  )

  # plot_summary_stat - either TRUE or FALSE
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), plot_summary_stat = -1),
               "Check plot_summary_stat - should be either TRUE or FALSE",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), plot_summary_stat = 10 ),
               "Check plot_summary_stat - should be either TRUE or FALSE",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), plot_summary_stat = "2" ),
               "Check plot_summary_stat - should be either TRUE or FALSE",
               fixed=TRUE
  )


  # sample_id - should be in colData x
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample1", design = ~tomato, covariates = c("tomato")),
               "'sample_id' should be in colData(x)",
               fixed=TRUE
  )


  # check covariates in coldata
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~sex+sample1+tomato, covariates = c("tomato" , "sex" , "sample1")),
               "All covariates should be colnames of colData(x).",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample",design = ~sex+stage+tomato, covariates = c("tomato" , "sex" , "stage")),
               "All covariates should have more than 1 contrast.",
               fixed=TRUE
  )


  # if plot_stat = T, reducedDim should be in sce
  expect_error(de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), plot_summary_stat = T , layout = "pca"),
               "reducedDim_name should be in reducedDimNames(x).",
               fixed=TRUE
  )

  # check subset_hoods
  subset_hoods = c(0,3,20)
  expect_error(de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), plot_summary_stat = F , subset_nhoods = c(0,3,20)),
               "If 'subset_nhoods' is numeric vector, it should lie within c(1:ncol(nhoods(x))).",
               fixed=TRUE
  )

  # design and covariates should match
  expect_error(de_test_neighbourhoods(x = sce , sample_id = "sample", design = ~stage.mapped*tomato, covariates = c("tomato"), plot_summary_stat = F ),
               "Some of the design's arguments are not in the covariate vector.",
               fixed=TRUE
  )

})



# right input returns the expected format (in default output)
test_that("Return is the correct class", {
  # right class
  expect_s4_class(de_stat_sce , "SingleCellExperiment")
  expect_s3_class(de_stat_df , "data.frame")

  cols_df = c("Nhood" , "gene" , "logFC" , "pval" , "pval_corrected_across_genes" , "pval_corrected_across_nhoods" , "Nhood_center" , "test_performed" )
  expect_identical(cols_df , colnames(de_stat_df))
  expect_identical(cols_df , colnames(de_stat_df))

  cols_meta_sce = c("Nhood" , "Nhood_center" , "test_performed" )
  expect_identical(cols_meta_sce , colnames(colData(de_stat_sce)))
  expect_identical(cols_meta_sce , colnames(colData(de_stat_sce)))

  cols_assay_sce = c("logFC" , "pval" , "pval_corrected_across_genes", "pval_corrected_across_nhoods" )
  expect_identical(cols_assay_sce , assayNames(de_stat_sce))
  expect_identical(cols_assay_sce , assayNames(de_stat_sce))

})



# subset hoods
## returns right hoods/colnames
test_that("Subset hoods returns right nhoods", {

  de_stat = de_test_neighbourhoods(sce , sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = "SCE" , subset_nhoods = c(1,8,4,10))
  expect_identical(colnames(de_stat) , c("1" , "4" , "8" , "10"))
  meta = as.data.frame(colData(de_stat))
  expect_equal(meta$Nhood , c(1,4,8,10))

  de_stat = convert_de_stat(de_stat)
  expect_equal(unique(de_stat$Nhood) , c(1,4,8,10))

})

## same fdr,pval across genes but not spatfdr
test_that("Subset hoods does not change FDR", {

  de_stat_subset = de_test_neighbourhoods(x = sce, sample_id = "sample", design = ~tomato, covariates = c("tomato"), output_type = "data.frame" , subset_nhoods = c(1,8,4,10))
  de_stat_subset = de_stat_subset[, c("Nhood" , "gene" , "pval" , "pval_corrected_across_genes" , "pval_corrected_across_nhoods")]
  de_stat_subset = de_stat_subset[!is.na(de_stat_subset$pval) , ]
  colnames(de_stat_subset) = c("Nhood" , "gene" , "pval_1" , "pval_corrected_across_genes_1" , "pval_corrected_across_nhoods_1")

  de_stat_full = de_stat_df[de_stat_df$Nhood %in% c(10,4,8,1) , ]
  de_stat_full = de_stat_full[, c("Nhood" , "gene" , "pval" , "pval_corrected_across_genes" , "pval_corrected_across_nhoods")]
  de_stat_full = de_stat_full[!is.na(de_stat_full$pval) , ]
  colnames(de_stat_full) = c("Nhood" , "gene" , "pval_2" , "pval_corrected_across_genes_2" , "pval_corrected_across_nhoods_2")

  de_stat = merge(de_stat_subset , de_stat_full, by = c("gene" , "Nhood"))

  expect_identical(de_stat$pval_1 , de_stat$pval_2)
  expect_identical(de_stat$pval_corrected_across_genes_1 , de_stat$pval_corrected_across_genes_2)
  expect_false(isTRUE(all.equal(de_stat$pval_corrected_across_nhoods_1 , de_stat$pval_corrected_across_nhoods_2)))

})


# min_n_cells_per_sample
## bigger min_n_cells_per_sample -- less hoods are tested
test_that("Bigger min_n_cells_per_sample -- less hoods are tested", {
  de_stat_1 = de_test_neighbourhoods(sce , design = ~tomato, covariates = c("tomato"), output_type = "SCE" , min_n_cells_per_sample = 1)
  out_1 = as.data.frame(colData(de_stat_1))
  out_1 = sum(out_1$test_performed)
  de_stat_2 = de_test_neighbourhoods(sce , design = ~tomato, covariates = c("tomato"), output_type = "SCE" , min_n_cells_per_sample = 100)
  out_2 = as.data.frame(colData(de_stat_2))
  out_2 = sum(out_2$test_performed)
  expect_lt(out_2 , out_1)
})



# min_count
## higher min_count -- less genes to be tested (in hood, not none)
test_that("Higher min_count -- less genes are tested", {
  de_stat_sce_2 = de_test_neighbourhoods(sce , design = ~tomato, covariates = c("tomato"), output_type = "SCE" , min_count = 50)
  expect_gt(nrow(de_stat_sce) , nrow(de_stat_sce_2))
})



# covs
test_that("Covariate check - wrong covariate matrix will give NULL", {
  de_stat = de_test_neighbourhoods(sce , design = ~sex+tomato, covariates = c("tomato" , "sex"), output_type = "SCE" , min_count = 3)
  expect_null(de_stat)

  de_stat = de_test_neighbourhoods(sce , design = ~sex+toy_cov_1+tomato, covariates = c("tomato","sex","toy_cov_1"), output_type = "SCE" , min_count = 3)
  expect_null(de_stat)

  de_stat = de_test_neighbourhoods(sce , design = ~toy_cov_1+tomato, covariates = c("tomato","toy_cov_1"), output_type = "SCE" , min_count = 3 )
  meta = as.data.frame(colData(de_stat))
  expect_gt(sum(meta$test_performed) , 0)
})

# contrast check
test_that("Contrasts check -- has to be formula colnames of model matrix", {
  expect_error(de_test_neighbourhoods(sce , design = ~0+tomato, covariates = c("tomato") , contrasts = c("tomatoT-tomatoF")),
               "contrasts are not right. All variables in the formula should be the colnames from model matrix: tomatoFALSE, tomatoTRUE",
               fixed=TRUE
  )
  expect_error(de_test_neighbourhoods(sce , design = ~0+tomato, covariates = c("tomato") , contrasts = c("tomatoTRUE-tomatoFALSE")),
               NA
  )
  expect_error(de_test_neighbourhoods(sce , design = ~0+tomato, covariates = c("tomato") ,
                                      contrasts = c("tomatoTRUE-tomatoFALSE" , "tomatoTRUE+tomatoFALSE")),
               "At the moment we only support one comparison - contrasts should be of length 1. If you wish to perform several comparisons, please run separately for each of them.",
               fixed=TRUE
  )
  # covariate as last model matrice's col (NULL) give same results
  out_1 = de_test_neighbourhoods(sce , design = ~tomato, covariates = c("tomato") ,
                                 contrasts = c("tomatoTRUE") , output_type = "data.frame")
  out_2 = de_test_neighbourhoods(sce , design = ~tomato, covariates = c("tomato") , output_type = "data.frame")
  expect_identical(out_1 , out_2)
})




