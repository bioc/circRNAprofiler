setwd(paste(getwd(), "testdata", sep = "/"))

context("Test that getMiRsites() function works correctly")
test_that("getMiRsites() generates the correct data structure", {
    gtf <- formatGTF(pathToGTF = "gencodeVM16.gtf")

    # Create the backSplicedJunctions data frame
    backSplicedJunctions <- getBackSplicedJunctions(gtf)
    mergedBSJunctions <- mergeBSJunctions(backSplicedJunctions, gtf)

    # Retrive the genomic features
    annotatedBSJs <- annotateBSJs(mergedBSJunctions, gtf)

    # Retrieve the target sequences
    targets <- getCircSeqs(annotatedBSJs[1, ],
        species = "Mmusculus",
        genome = "mm10",
        gtf)

    # miR analysis
    miRsites <- getMiRsites(
        targets,
        species = "Mmusculus",
        genome = "mm10",
        miRspeciesCode = "mmu",
        miRBaseLatestRelease = FALSE,
        totalMatches = 7,
        maxNonCanonicalMatches = 0
    )


    expect_is(miRsites, "list")

    namesList <-
        c(
            "targets",
            "microRNAs",
            "counts",
            "totMatchesInSeed",
            "cwcMatchesInSeed",
            "seedLocation",
            "t1",
            "totMatchesInCentral",
            "cwcMatchesInCentral",
            "totMatchesInCompensatory",
            "cwcMatchesInCompensatory",
            "localAUcontent"
        )

    expect_equal(names(miRsites), namesList)

    expect_equal(length(miRsites), 12)

    expect_equal(names(miRsites$targets), getTargetsColNames())
    expect_equal(names(miRsites$microRNAs),
        c("id", "length", "seq", "seqRev"))

    expect_equal(dim(miRsites$microRNAs)[1], 3)
    expect_equal(miRsites$microRNAs$id,
        c(">mmu-mySeq", ">mmu-mySeq2", ">mmu-miR-7000-3p"))


})


test_that("getMiRsites() retrieves the correct matches", {
    gtf <- formatGTF(pathToGTF = "gencodeVM16.gtf")
    # Create the backSplicedJunctions data frame
    backSplicedJunctions <- getBackSplicedJunctions(gtf)
    mergedBSJunctions <- mergeBSJunctions(backSplicedJunctions, gtf)

    # Retrive the genomic features
    annotatedBSJs <- annotateBSJs(mergedBSJunctions, gtf)

    # Retrieve the target sequences (Arhgap5:+:chr12:52516079:52542636)
    targets <- getCircSeqs(annotatedBSJs[11,],
        species = "Mmusculus",
        genome = "mm10",
        gtf)

    # miR analysis
    miRsites <- getMiRsites(
        targets,
        species = "Mmusculus",
        genome = "mm10",
        miRspeciesCode = "mmu",
        miRBaseLatestRelease = FALSE,
        totalMatches = 7,
        maxNonCanonicalMatches = 0
    )

    expect_equal(miRsites$microRNAs$id[1], ">mmu-mySeq")
    expect_equal(miRsites$microRNAs$seqRev[1], "GGUAUACUAGAGCUUCUU")

    expect_equal(miRsites$counts[1, 2], 1)
    expect_equal(miRsites$totMatchesInSeed[1, 2], "7")
    expect_equal(miRsites$cwcMatchesInSeed[1, 2], "7mer")
    expect_equal(miRsites$seedLocation[1, 2], "4061")
    expect_equal(miRsites$totMatchesInCentral[1, 2], "4")
    expect_equal(miRsites$cwcMatchesInCentral[1, 2], "4")
    expect_equal(miRsites$totMatchesInCompensatory[1, 2], "4")
    expect_equal(miRsites$cwcMatchesInCompensatory[1, 2], "4")
    expect_equal(miRsites$localAUcontent[1, 2], "0.6")
    expect_equal(miRsites$t1[1, 2], "A")


    # miR analysis
    miRsites <- getMiRsites(
        targets,
        species = "Mmusculus",
        genome = "mm10",
        miRspeciesCode = "mmu",
        miRBaseLatestRelease = FALSE,
        totalMatches = 6,
        maxNonCanonicalMatches = 0
    )

    expect_equal(miRsites$microRNAs$id[3], ">mmu-miR-7000-3p")
    expect_equal(miRsites$microRNAs$seqRev[3], "GACCUCCUGUCCGUCCACCCAC")

    expect_equal(miRsites$counts[1, 4], 1)
    expect_equal(miRsites$totMatchesInSeed[1, 4], "6")
    expect_equal(miRsites$cwcMatchesInSeed[1, 4], "4mer")
    expect_equal(miRsites$seedLocation[1, 4], "260")
    expect_equal(miRsites$totMatchesInCentral[1, 4], "1")
    expect_equal(miRsites$cwcMatchesInCentral[1, 4], "1")
    expect_equal(miRsites$totMatchesInCompensatory[1, 4], "2")
    expect_equal(miRsites$cwcMatchesInCompensatory[1, 4], "1")

    expect_equal(miRsites$localAUcontent[1, 4], "0.7")
    expect_equal(miRsites$t1[1, 4], "U")



})



test_that(" rearrangeMiRres() rearranges correctly the miRresults", {
    gtf <- formatGTF(pathToGTF = "gencodeVM16.gtf")
    # Create the backSplicedJunctions data frame
    backSplicedJunctions <- getBackSplicedJunctions(gtf)
    mergedBSJunctions <- mergeBSJunctions(backSplicedJunctions, gtf)

    # Retrive the genomic features
    annotatedBSJs <- annotateBSJs(mergedBSJunctions, gtf)

    # Retrieve the target sequences
    targets <-
        getCircSeqs(annotatedBSJs[1,],
            gtf,
            species = "Mmusculus",
            genome = "mm10")

    # We only analyze the first row
    miRsites <- getMiRsites(
        targets,
        species = "Mmusculus",
        genome = "mm10",
        miRspeciesCode = "mmu",
        miRBaseLatestRelease = FALSE,
        totalMatches = 6,
        maxNonCanonicalMatches = 0
    )

    rearrangedMiRres <- rearrangeMiRres(miRsites)
    expect_equal(miRsites$targets$id[1], rearrangedMiRres[[1]][[1]]$id)
    expect_equal(miRsites$targets$length[1], rearrangedMiRres[[1]][[1]]$length)
    expect_equal(miRsites$targets$seq[1], rearrangedMiRres[[1]][[1]]$seq)

    col <- 2:ncol(miRsites$counts)
    expect_equal(colnames(miRsites$counts)[col],
        rearrangedMiRres[[1]][[2]]$miRid)
    expect_equal(as.numeric(miRsites$counts[1, col]),
        rearrangedMiRres[[1]][[2]]$counts)

    expect_equal(as.numeric(miRsites$counts[1, col]),
        rearrangedMiRres[[1]][[2]]$counts)

    expect_equal(
        as.character(miRsites$totMatchesInSeed[1, col]),
        rearrangedMiRres[[1]][[2]]$totMatchesInSeed
    )
    expect_equal(
        as.character(miRsites$cwcMatchesInSeed[1, col]),
        rearrangedMiRres[[1]][[2]]$cwcMatchesInSeed
    )
    expect_equal(as.character(miRsites$seedLocation[1, col]),
        rearrangedMiRres[[1]][[2]]$seedLocation)
    expect_equal(as.character(miRsites$t1[1, col]), rearrangedMiRres[[1]][[2]]$t1)
    expect_equal(
        as.character(miRsites$totMatchesInCentral[1, col]),
        rearrangedMiRres[[1]][[2]]$totMatchesInCentral
    )
    expect_equal(
        as.character(miRsites$cwcMatchesInCentral[1, col]),
        rearrangedMiRres[[1]][[2]]$cwcMatchesInCentral
    )

    expect_equal(
        as.character(miRsites$totMatchesInCompensatory[1, col]),
        rearrangedMiRres[[1]][[2]]$totMatchesInCompensatory
    )
    expect_equal(
        as.character(miRsites$cwcMatchesInCompensatory[1, col]),
        rearrangedMiRres[[1]][[2]]$cwcMatchesInCompensatory
    )
    expect_equal(
        as.character(miRsites$localAUcontent[1, col]),
        rearrangedMiRres[[1]][[2]]$localAUcontent
    )

})


test_that(" compareSequences() works correctly ", {
    comparedSeq <-
        compareSequences("AUCCGU", "UAGCUU", isGUMatch = TRUE)
    expect_equal(comparedSeq, "wwwmnm")
    comparedSeq <-
        compareSequences("AUCCGU", "UAGCUU", isGUMatch = FALSE)
    expect_equal(comparedSeq, "wwwmmm")

})