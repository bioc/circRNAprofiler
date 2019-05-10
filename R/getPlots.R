#' @title Plot length introns flanking back-spliced junctions
#'
#' @description The function plotLenIntrons() generates vertical boxplots for
#' comparison of length of introns flanking the back-spliced junctions
#' (e.g. detected Vs randomly selected).
#'
#' @param annotatedFBSJs A data frame with the annotated back-spliced junctions
#' (e.g. detected). It can be generated with \code{\link{annotateBSJs}}.
#' These act as foreground back-spliced junctions.
#'
#' @param annotatedBBSJs A data frame with the annotated back-spliced junctions
#' (e.g. randomly selected). It can generated with \code{\link{annotateBSJs}}.
#' These act as background back-spliced junctions.
#'
#' @param df1Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot. Deafult value is "foreground".
#'
#' @param df2Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot. Deafult value is "background".
#'
#' @param title A character string specifying the title of the plot.
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedFBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf,
#' isRandom = FALSE)
#'
#' # Get random back-spliced junctions
#' randomBSJunctions <- getRandomBSJunctions( gtf, n = 10, f = 10)
#'
#' # Annotate random back-spliced junctions
#' annotatedBBSJs <- annotateBSJs(randomBSJunctions, gtf, isRandom = FALSE)
#'
#' # Plot
#' p <- plotLenIntrons(
#'     annotatedFBSJs,
#'     annotatedBBSJs,
#'     df1Name = "foreground",
#'     df2Name = "background",
#'     title = "")
#' p
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @import reshape2
#' @importFrom rlang .data
#' @export
plotLenIntrons <-
    function(annotatedFBSJs,
             annotatedBBSJs,
             df1Name = "foreground",
             df2Name = "background",
             title = "") {
        # Reshape the data frame
        reshForeground <- annotatedFBSJs %>%
            dplyr::mutate(circRNA = rep("foreground", nrow(annotatedFBSJs))) %>%
            dplyr::select(
                .data$id,
                .data$gene,
                .data$circRNA,
                .data$lenUpIntron,
                .data$lenDownIntron,
                .data$meanLengthIntrons
            ) %>%
            reshape2::melt(
                id.vars = c("id", "gene", "circRNA"),
                variable.name = "feature",
                value.name = "length"
            )
        # Reshape the data frame
        reshBackground <- annotatedBBSJs %>%
            dplyr::mutate(circRNA = rep("background", nrow(annotatedBBSJs))) %>%
            dplyr::select(
                .data$id,
                .data$gene,
                .data$circRNA,
                .data$lenUpIntron,
                .data$lenDownIntron,
                .data$meanLengthIntrons
            ) %>%
            reshape2::melt(
                id.vars = c("id", "gene", "circRNA"),
                variable.name = "feature",
                value.name = "length"
            )

        combinedFB <- rbind(reshForeground, reshBackground)
        combinedFB$length <- as.numeric(combinedFB$length)
        # Plot
        p <-
            ggplot(combinedFB, aes(x = .data$feature, y = log10(length))) +
            geom_boxplot(aes(fill = .data$circRNA), na.rm = TRUE) +
            labs(title = title, x = "", y = "Log10 length (nt)") +
            theme_classic() +
            theme(plot.title = element_text(hjust = 0.5),
                  axis.text.x = element_text(hjust = 0.5)) +
            scale_fill_discrete(name = "circRNA", labels = c(df1Name, df2Name))

        return(p)
    }


#' @title Plot length back-spliced exons
#'
#' @description The function plotLenBSEs() generates vertical boxplots for
#' comparison of length of back-spliced exons (e.g. detected Vs randomly
#' selected).
#'
#' @param annotatedFBSJs A data frame with the annotated back-spliced junctions
#' (e.g. detected). It can be generated with \code{\link{annotateBSJs}}.
#' These act as foreground back-spliced junctions.
#'
#' @param annotatedBBSJs A data frame with the annotated back-spliced junctions
#' (e.g. randomly selected). It can generated with \code{\link{annotateBSJs}}.
#' These act as background back-spliced junctions.
#'
#' @param df1Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot.
#'
#' @param df2Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot.
#'
#' @param title A character string specifying the title of the plot
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedFBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf, isRandom = FALSE)
#'
#' # Get random back-spliced junctions
#' randomBSJunctions <- getRandomBSJunctions(n = 10, f = 10, gtf)
#'
#' # Annotate random back-spliced junctions
#' annotatedBBSJs <- annotateBSJs(randomBSJunctions, gtf, isRandom = FALSE)
#'
#' # Plot
#' p <- plotLenBSEs(
#'     annotatedFBSJs,
#'     annotatedBBSJs,
#'     df1Name = "foreground",
#'     df2Name = "background",
#'     title = "")
#' p
#'
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @import reshape2
#' @importFrom rlang .data
#' @export
plotLenBSEs <-
    function(annotatedFBSJs,
             annotatedBBSJs,
             df1Name = "foreground",
             df2Name = "background",
             title = "") {
        # Reshape the data frame
        reshForeground <- annotatedFBSJs %>%
            dplyr::mutate(circRNA = rep("foreground", nrow(annotatedFBSJs))) %>%
            dplyr::select(
                .data$id,
                .data$gene,
                .data$circRNA,
                .data$lenUpBSE,
                .data$lenDownBSE,
                .data$meanLengthBSEs
            ) %>%
            reshape2::melt(
                id.vars = c("id", "gene", "circRNA"),
                variable.name = "feature",
                value.name = "length"
            )
        # Reshape the data frame
        reshBackground <- annotatedBBSJs %>%
            dplyr::mutate(circRNA = rep("background", nrow(annotatedBBSJs))) %>%
            dplyr::select(
                .data$id,
                .data$gene,
                .data$circRNA,
                .data$lenUpBSE,
                .data$lenDownBSE,
                .data$meanLengthBSEs
            ) %>%
            reshape2::melt(
                id.vars = c("id", "gene", "circRNA"),
                variable.name = "feature",
                value.name = "length"
            )

        combinedFB <- rbind(reshForeground, reshBackground)
        combinedFB$length <- as.numeric(combinedFB$length)
        # Plot
        p <-
            ggplot(combinedFB, aes(x = .data$feature, y = log10(length))) +
            geom_boxplot(aes(fill = .data$circRNA), na.rm = TRUE) +
            labs(title = title, x = "", y = "Log10 length (nt)") +
            theme_classic() +
            theme(plot.title = element_text(hjust = 0.5),
                  axis.text.x = element_text(hjust = 0.5)) +
            scale_fill_discrete(name = "circRNA", labels = c(df1Name, df2Name))

        return(p)
    }

#' @title Plot circRNA host genes
#'
#' @description The function plotHostGenes() generates a bar chart showing the
#' no. of circRNAs produced from each the circRNA host gene.
#'
#' @param annotatedBSJs A data frame with the annotated back-spliced junctions.
#' This data frame can be generated with \code{\link{annotateBSJs}}.
#'
#' @param title A character string specifying the title of the plot.
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf, isRandom = FALSE)
#'
#' # Plot
#' p <- plotHostGenes(annotatedBSJs, title = "")
#' p
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @importFrom rlang .data
#' @export
plotHostGenes <-
    function(annotatedBSJs, title = "") {
        # Plot
        p <-  annotatedBSJs %>%
            dplyr::group_by(.data$gene) %>%
            dplyr::summarise(n1 = n()) %>%
            dplyr::group_by(.data$n1) %>%
            dplyr::summarise(n2 = n()) %>%
            ggplot(aes(x = factor(.data$n1), y = factor(.data$n2))) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = title, x = "No. of circRNA", y = "No. of gene") +
            coord_flip() +
            theme_classic() +
            theme(plot.title = element_text(hjust = 0.5))

        return(p)
    }



#' @title Plot back-spliced exon positions
#'
#' @description The function plotExPosition() generates a bar chart showing
#' the position of the back-spliced exons within the transcript.
#'
#' @param annotatedBSJs A data frame with the annotated back-spliced junctions.
#' This data frame can be generated with \code{\link{annotateBSJs}}.
#'
#' @param title A character string specifying the title of the plot.
#'
#' @param n An integer specyfing the position counts cut-off. If 0 is specified
#' all position are plotted. Deafult value is 0.
#'
#' @param flip A logical specifying whether to flip the transcripts. If TRUE all
#' transcripts are flipped and the last exons will correspond to the first ones,
#' the second last exons to the second ones etc. Default value is FALSE.
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf, isRandom = FALSE)
#'
#' # Plot
#' p <- plotExPosition(annotatedBSJs, title = "", n = 0, flip = FALSE)
#' p
#'
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @import reshape2
#' @importFrom rlang .data
#' @export
plotExPosition <-
    function(annotatedBSJs,
             title ="",
             n = 0,
             flip= FALSE) {

        if (flip) {
            annotatedBSJs <- annotatedBSJs %>%
                dplyr::mutate(
                    exNumUpBSE = (.data$totExons - .data$exNumUpBSE) + 1,
                    exNumDownBSE = (.data$totExons - .data$exNumDownBSE) + 1
                ) %>%
                dplyr::select(.data$id,
                              .data$gene,
                              .data$exNumUpBSE,
                              .data$exNumDownBSE)
        } else{
            annotatedBSJs <- annotatedBSJs %>%
                dplyr::select(.data$id,
                              .data$gene,
                              .data$exNumUpBSE,
                              .data$exNumDownBSE)
        }

        # Plot
        p <-  annotatedBSJs %>%
            reshape2::melt(
                id.vars = c("id", "gene"),
                variable.name = "feature",
                value.name = "exNum"
            ) %>%
            dplyr::filter(!is.na(.data$exNum)) %>%
            dplyr::group_by(.data$exNum) %>%
            dplyr::summarise(n1 = n()) %>%
            dplyr::filter(.data$n1 > n) %>%
            ggplot(aes(x = factor(.data$exNum), y = .data$n1)) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = title, x = "Exon number", y = "Frequency") +
            theme_classic() +
            theme(axis.text.x = element_text(angle = 90, hjust = 1),
                  plot.title = element_text(hjust = 0.5))



        return(p)
    }

#' @title Plot exons between back-spliced junctions
#'
#' @description The function plotExBetweenBSEs() generates a bar chart showing
#' the no. of exons in between the back-spliced junctions.
#'
#' @param annotatedBSJs A data frame with the annotated back-spliced junctions.
#' This data frame can be generated with \code{\link{annotateBSJs}}.
#'
#' @param title A character string specifying the title of the plot.
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf,
#'     isRandom = FALSE)
#'
#' # Plot
#' p <- plotExBetweenBSEs(annotatedBSJs, title = "")
#' p
#'
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @importFrom rlang .data
#' @export
plotExBetweenBSEs <-
    function(annotatedBSJs, title = "") {
        # Plot
        p <-  annotatedBSJs %>%
            dplyr::filter(!is.na(.data$numOfExons)) %>%
            group_by(.data$numOfExons) %>%
            summarise(n1 = n()) %>%
            ggplot(aes(x = factor(.data$numOfExons), y = .data$n1)) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = title, x = "No. of exons", y =
                     "Frequency") +
            theme_classic() +
            theme(axis.text.x = element_text(angle = 90, hjust = 1),
                  plot.title = element_text(hjust = 0.5))

        return(p)

    }

#' @title Plot exons in the circRNA host transcript
#'
#' @description The function plotTotExons() generates a bar chart showing the
#' total number of exons (totExon column) in the transcripts selected for
#' the downstream analysis.
#'
#' @param annotatedBSJs A data frame with the annotated back-spliced junctions.
#' This data frame can be generated with \code{\link{annotateBSJs}}.
#'
#' @param title A character string specifying the title of the plot
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf,
#'     isRandom = FALSE)
#'
#' # Plot
#' p <- plotTotExons(annotatedBSJs, title = "")
#' p
#'
#'
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @importFrom rlang .data
#' @export
plotTotExons <-
    function(annotatedBSJs, title = "") {
        # Keep unique transcript
        annotatedBSJsNoDup <-
            annotatedBSJs[!duplicated(annotatedBSJs$transcript), ]

        p <- annotatedBSJsNoDup %>%
            dplyr::select(.data$totExons) %>%
            dplyr::filter(!is.na(.data$totExons)) %>%
            dplyr::group_by(.data$totExons) %>%
            dplyr::summarise(n1 = n()) %>%
            ggplot(aes(x = factor(.data$totExons), y = .data$n1)) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = title, x = "No. of exons", y =
                     "Frequency") +
            theme_classic() +
            theme(axis.text.x = element_text(angle = 90, hjust = 1),
                  plot.title = element_text(hjust = 0.5))

        return(p)
    }



#' @title Plot differential circRNA expression results
#'
#' @description The function volcanoPlot() generates a volcano plot with the
#' results of the differential expression analysis.
#'
#' @param res A data frame containing the the differential expression resuls.
#' It can be generated with \code{\link{getDeseqRes}} or
#' \code{\link{getEdgerRes}}.
#'
#' @param log2FC An integer specifying the log2FC cut-off. Deafult value is 1.
#'
#' @param padj An integer specifying the adjusted P value cut-off.
#' Deafult value is 0.05.
#'
#' @param title A character string specifying the title of the plot.
#'
#' @param gene A logical specifying whether to add the circRNA host gene names
#' to the plot. Deafult value is FALSE.
#'
#' @param setxLim A logical specifying whether to set x scale limits.
#' If TRUE the value in xlim will be used. Deafult value is FALSE.
#'
#' @param setyLim A logical specifying whether to set y scale limits.
#' If TRUE the value in ylim will be used. Deafult value is FALSE.
#'
#' @param xlim A numeric vector specifying the lower and upper x axis limits.
#' Deafult values are c(-8 , 8).
#'
#' @param ylim An integer specifying the lower and upper y axis limits
#' Deafult values are c(0, 5).
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' pathToExperiment <- system.file("extdata", "experiment.txt",
#'     package ="circRNAprofiler")
#'
#' # Filter circRNAs
#' filterdCirc <- filterCirc(
#'     mergedBSJunctions,
#'     allSamples = FALSE,
#'     min = 5,
#'     pathToExperiment)
#'
#' # Find differentially expressed circRNAs
#'  deseqResBvsA <- getDeseqRes(
#'     mergedBSJunctions,
#'     condition = "A-B",
#'     pAdjustMethod = "BH",
#'     pathToExperiment)
#'
#' # Plot
#' p <- volcanoPlot(
#'     deseqResBvsA,
#'     log2FC = 1,
#'     padj = 0.05,
#'     title = "",
#'     setxLim = TRUE,
#'     xlim = c(-8 , 7.5),
#'     setyLim = FALSE,
#'     ylim = c(0 , 4),
#'     gene = FALSE)
#' p
#'
#' @import ggplot2
#' @importFrom stats na.omit
#' @export
volcanoPlot <- function(res,
                        log2FC = 1,
                        padj = 0.05,
                        title = "",
                        gene = FALSE,
                        setxLim = FALSE,
                        xlim = c(-8 , 8),
                        setyLim= FALSE,
                        ylim = c(0, 5)) {
    res <- stats::na.omit(res)
    diffExpCirc <-
        stats::na.omit(res[abs(res$log2FC) >= log2FC &
                               res$padj <= padj, ])

    if (setxLim) {
        xmin <- xlim[1]
        xmax <- xlim[2]
    } else{
        xmin <- min(res$log2FC)
        xmax <- max(res$log2FC)
    }

    if (setyLim) {
        ymin <- ylim[1]
        ymax <- ylim[2]
    } else{
        ymin <- min(-log10(res$padj))
        ymax <- max(-log10(res$padj))
    }



    p <- ggplot(data = res, aes(x = log2FC, y = -log10(padj))) +
        geom_point(colour = "black",
                   size = 3,
                   na.rm = TRUE) +
        xlim(xmin, xmax) +
        ylim(ymin, ymax) +
        labs(title = title, x = "log2 FC", y = "-log10 padj") +
        geom_point(
            data = diffExpCirc,
            aes(x = log2FC, y = -log10(padj)),
            color = "blue",
            size = 3,
            na.rm = TRUE
        ) +
        theme(
            panel.background = element_blank(),
            plot.title = element_text(hjust = 0.5),
            panel.border = element_rect(
                colour = "black",
                fill = NA,
                size = 1.4
            )
        ) +
        geom_hline(
            yintercept = 1.3,
            linetype = "dashed",
            color = "black",
            size = 0.5
        ) +
        geom_vline(
            xintercept = -1,
            linetype = "dashed",
            color = "black",
            size = 0.5
        ) +
        geom_vline(
            xintercept = 1,
            linetype = "dashed",
            color = "black",
            size = 0.5
        )

    if (gene) {
        p <- p +
            geom_text(
                data = diffExpCirc,
                aes(
                    x = log2FC,
                    y = -log10(padj),
                    label = .data$gene
                ),
                size = 3,
                colour = "black",
                hjust = 0.5,
                vjust = -0.3
            )
    }



    return(p)
}


#' @title Plot motifs analysis results
#'
#' @description The function plotMotifs() generates 2 bar charts showing the
#' log2FC and the number of occurences of each motif found in the target
#' sequences (e.g detected Vs randomly selected).
#'
#'
#' @param mergedMotifsFTS A data frame containing the number of occurences
#' of each motif found in foreground target sequences (e.g from detected
#' back-spliced junctions). It can be generated with the
#' \code{\link{mergeMotifs}}.
#'
#' @param mergedMotifsBTS A data frame containing the number of occurences
#' of each motif found in the background target sequences (e.g. from
#' random back-spliced junctions). It can be generated with the
#' \code{\link{mergeMotifs}}.
#'
#' @param log2FC An integer specifying the log2FC cut-off. Default value is 1.
#'
#' @param nf1 An integer specifying the normalization factor for the
#' first data frame mergedMotifsFTS. The occurrences of each motif are divided
#' by nf1. The normalized values are then used for fold-change calculation.
#' Set this to the number of target sequences (e.g from detected
#' back-spliced junctions) where the motifs were extracted from.
#' Default value is 1.
#'
#' @param nf2 An integer specifying the normalization factor for the
#' second data frame mergedMotifsBTS. The occurrences of each motif are divided
#' by nf2. The normalized values are then used for fold-change calculation.
#' Set this to the number of target sequences (e.g from random
#' back-spliced junctions) where the motifs were extracted from.
#' Default value is 1.
#'
#' NOTE: By setting nf1 and nf2 equals to 1 the number of target sequences
#' (e.g detected Vs randomly selected) where the motifs were extrated from,
#' is supposed to be the same.
#'
#' @param df1Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot. Deafult value is "foreground".
#'
#' @param df2Name A string specifying the name of the first data frame. This
#' will be displayed in the legend of the plot. Deafult value is "background".
#'
#' @return A ggplot object.
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 10 back-spliced junctions
#' annotatedFBSJs <- annotateBSJs(mergedBSJunctions[1:10, ], gtf, isRandom = FALSE)
#'
#' # Get random back-spliced junctions
#' randomBSJunctions <- getRandomBSJunctions(gtf, n = 10, f = 10)
#'
#' # Annotate random back-spliced junctions
#' annotatedBBSJs <- annotateBSJs(randomBSJunctions, gtf, isRandom = TRUE)
#'
#' # Retrieve target sequences from detected back-spliced junctions
#' targetsFTS <- getSeqsFromGRs(
#'    annotatedFBSJs,
#'    lIntron = 200,
#'    lExon = 10,
#'    type = "ie",
#'    species = "Hsapiens",
#'    genome = "hg19")
#'
#' # Retrieve target sequences from random back-spliced junctions
#' targetsBTS <- getSeqsFromGRs(
#'    annotatedBBSJs,
#'    lIntron = 200,
#'    lExon = 10,
#'    type = "ie",
#'    species = "Hsapiens",
#'    genome = "hg19")
#'
#'
#' # Get motifs
#' motifsFTS <- getMotifs(
#'     targetsFTS,
#'     width = 6,
#'     species = "Hsapiens",
#'     rbp = TRUE,
#'     reverse = FALSE)
#'
#' motifsBTS <- getMotifs(
#'     targetsBTS,
#'     width = 6,
#'     species = "Hsapiens",
#'     rbp = TRUE,
#'     reverse = FALSE)
#'
#' # Merge motifs
#' mergedMotifsFTS <- mergeMotifs(motifsFTS)
#' mergedMotifsBTS <- mergeMotifs(motifsBTS)
#'
#' # Plot
#' p <- plotMotifs(
#'     mergedMotifsFTS,
#'     mergedMotifsBTS,
#'     log2FC = 2,
#'     nf1 = nrow(annotatedFBSJs),
#'     nf2 = nrow(annotatedBBSJs),
#'     df1Name = "foreground",
#'     df2Name = "background")
#'
#' @importFrom rlang .data
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @export
plotMotifs <-
    function(mergedMotifsFTS,
             mergedMotifsBTS,
             log2FC = 1,
             nf1 = 1,
             nf2 =1 ,
             df1Name = "foreground",
             df2Name = "background") {

        p <- list()
        mergedMotifsAll <-
            base::merge(mergedMotifsFTS,
                        mergedMotifsBTS,
                        by = "id",
                        all = TRUE) %>%
            dplyr::rename(foreground = .data$count.x,
                          background = .data$count.y) %>%
            dplyr::mutate(
                foreground = ifelse(
                    is.na(.data$foreground), 0, .data$foreground),
                background = ifelse(
                    is.na(.data$background), 0, .data$background)
            ) %>%
            dplyr::mutate(
                foregroundNorm = .data$foreground / nf1,
                backgroundNorm = .data$background / nf2
            ) %>%
            dplyr::mutate(log2fc = log2(
                (.data$foregroundNorm + 1) / (.data$backgroundNorm + 1))) %>%
            dplyr::filter(abs(.data$log2fc) >= log2FC) %>%
            dplyr::arrange(.data$log2fc) %>%
            dplyr::rename(log2FC = .data$log2fc) %>%
            dplyr::mutate(id = factor(.data$id, levels = .data$id)) %>%
            dplyr::mutate(motif.x = ifelse(
                is.na(.data$motif.x), .data$motif.y, .data$motif.x)) %>%
            dplyr::rename(motif = .data$motif.x) %>%
            dplyr::select(
                .data$id,
                .data$foreground,
                .data$background,
                .data$foregroundNorm,
                .data$backgroundNorm,
                .data$log2FC,
                .data$motif
            )


        p[[1]] <-  mergedMotifsAll %>%
            ggplot(aes(x = .data$id,
                       y = .data$log2FC)) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = "", x = "id", y = "log2 FC") +
            coord_flip() +
            theme_classic() +
            theme(plot.title = element_text(angle = 90, hjust = 0.5))


        p[[2]] <- mergedMotifsAll %>%
            dplyr::select(.data$id, .data$foregroundNorm, .data$backgroundNorm) %>%
            reshape2::melt(
                id.vars = "id",
                variable.name = "circRNA",
                value.name = "count"
            ) %>%
            ggplot(aes(
                x = .data$id,
                y = .data$count,
                fill = .data$circRNA
            )) +
            geom_bar(position = "dodge", stat = "identity") +
            labs(title = "", x = "id", y = "normalized count") +
            coord_flip() +
            theme_classic() +
            theme(plot.title = element_text(angle = 90, hjust = 0.5)) +
            scale_fill_discrete(name = "circRNA", labels = c(df1Name, df2Name))

        p[[3]] <- mergedMotifsAll %>%
            dplyr::arrange(desc(.data$log2FC))


        return(p)
    }

#' @title Plot miRNA analysis results
#'
#' @description The function plotMiR() generates a scatter plot showing the
#' number of miRNA binding sites for each miR found in the target sequence.
#'
#' @param rearragedMiRres A list containing containing rearranged
#' miRNA analysis results. See \code{\link{getMiRsites}} and then
#' \code{\link{rearrangeMiRres}}.
#'
#' @param n An integer specifying the miRNA binding sites cut-off. The miRNA
#' with a number of binding sites equals or higher to the cut-off will be
#' colored. Deafaut value is 40.
#'
#' @param color A string specifying the color of the top n miRs. Default value
#' is "blue".
#'
#' @param  miRid A logical specifying whether or not to show the miR ids in
#' the plot. default value is FALSE.
#'
#' @param id An integer specifying which element of the list
#' rearragedMiRres to plot. Each element of the list contains
#' the miR resutls relative to one circRNA. Deafult value is 1.
#'
#' @return A ggplot object.
#'
#'
#' @examples
#' # Load data frame containing detected back-spliced junctions
#' data("mergedBSJunctions")
#'
#' # Load short version of the gencode v19 annotation file
#' data("gtf")
#'
#' # Annotate the first 3 back-spliced junctions
#' annotatedBSJs <- annotateBSJs(mergedBSJunctions[1:3, ], gtf,
#'     isRandom = FALSE)
#'
#' # Retrieve target sequences.
#' targets <- getCircSeqs(
#'     annotatedBSJs,
#'     gtf,
#'     species = "Hsapiens",
#'     genome = "hg19")
#'
#' # Screen target sequence for miR binding sites.
#' pathToMiRs <- system.file("extdata", "miRs.txt", package="circRNAprofiler")
#'
#' miRsites <- getMiRsites(
#'     targets,
#'     species = "Hsapiens",
#'     genome = "hg19",
#'     miRspeciesCode = "hsa",
#'     miRBaseLatestRelease = TRUE,
#'     totalMatches = 6,
#'     maxNonCanonicalMatches = 1,
#'     pathToMiRs)
#'
#' # Rearrange miR results
#' rearragedMiRres <- rearrangeMiRres(miRsites)
#'
#' # Plot
#' p <- plotMiR(
#'     rearragedMiRres,
#'     n = 20,
#'     color = "blue",
#'     miRid = TRUE,
#'     id = 3)
#' p
#'
#'
#' @importFrom rlang .data
#' @import ggplot2
#' @import dplyr
#' @import magrittr
#' @export
plotMiR <-
    function(rearragedMiRres,
             n = 40,
             color = "blue",
             miRid = FALSE,
             id = 1
    ) {
        topMir <- rearragedMiRres[[id]][[2]] %>%
            dplyr::filter(.data$counts >= n) %>%
            dplyr::mutate(miRid = stringr::str_replace(
                .data$miRid, ">", ""))

        p <-  rearragedMiRres[[id]][[2]] %>%
            dplyr::mutate(miRid = stringr::str_replace(
                .data$miRid, ">", "")) %>%
            dplyr::filter(!is.na(.data$counts)) %>%
            dplyr::arrange(counts) %>%
            ggplot(aes(x = .data$miRid, y = .data$counts)) +
            geom_point(colour = "black", size = 4) +
            labs(title = "", x = "miRNA", y = "No. of binding sites") +
            geom_point(
                data = topMir,
                aes(x = .data$miRid, y = .data$counts),
                color = color,
                size = 4
            ) +
            theme(
                panel.background = element_blank(),
                plot.title = element_text(hjust = 0.5),
                axis.text.x = element_blank(),
                # element_text(angle = 90, hjust = 1),
                axis.ticks.x = element_blank(),
                panel.border = element_rect(
                    colour = "black",
                    fill = NA,
                    size = 1.4
                )
            ) +
            expand_limits(y = 0)

        if (miRid) {
            p <- p +
                geom_text(
                    data = topMir,
                    aes(
                        x = .data$miRid,
                        y = .data$counts,
                        label = .data$miRid
                    ),
                    size = 4,
                    colour = "black",
                    hjust = 0.5,
                    vjust = -0.3
                    #angle = 90
                )
        }

        return(p)
    }