#' @title Check project folder
#'
#' @description The function checkProjectFolder() verifies that the
#' project folder is set up correctly. The function
#' \code{\link{initCircRNAprofiler}} can be used to initialize the
#' project folder.
#'
#' @param pathToExperiment A string containing the path to the experiment.txt
#' file. The file experiment.txt contains the experiment design information.
#' It must have at least 3 columns with headers:
#' - label (1st column): unique names of the samples (short but informative).
#' - fileName (2nd column): name of the input files - e.g. circRNAs_X.txt, where
#' x can be can be 001, 002 etc.
#' - group (3rd column): biological conditions - e.g. A or B; healthy or
#' diseased if you have only 2 conditions.
#' By default pathToExperiment is set to NULL and the file it is searched in the
#' working directory. If experiment.txt is located in a different directory
#' then the path needs to be specified.
#'
#' @param pathToGTF A string containing the path to the the GTF file.
#' Use the same annotation file used during the RNA-seq mapping procedure.
#' By default pathToGTF is set to NULL and the file it is searched in the
#' working directory. If .gtf is located in a different directory then the
#' path needs to be specified.
#'
#' @param pathToMotifs A string containing the path to the motifs.txt
#' file. The file motifs.txt contains motifs/regular expressions specified
#' by the user. It must have 3 columns with headers:
#' - id (1st column): name of the motif. - e.g. RBM20 or motif1.
#' - motif (2nd column): motif/pattern to search.
#' - length (3rd column): length of the motif.
#' By default pathToMotifs is set to NULL and the file it is searched in the
#' working directory. If motifs.txt is located in a different directory then
#' the path needs to be specified. If this file is absent or empty only the
#' motifs of RNA Binding Proteins in the ATtRACT database are considered in the
#' motifs analysis.
#'
#' @param pathToMiRs A string containing the path to the miRs.txt file.
#' The file miRs.txt contains the microRNA ids from miRBase
#' specified by the user. It must have one column with header id. The first row
#' must contain the miR name starting with the ">", e.g >hsa-miR-1-3p. The
#' sequences of the miRs will be automatically retrieved from the mirBase latest
#' release or from the given mature.fa file, that should be present in the
#' working directory. By default pathToMiRs is set to NULL and the file it is
#' searched in the working directory. If miRs.txt is located in a different
#' directory then the path needs to be specified. If this file is absent or
#' empty, all miRs of the species specified in input are considered in the
#' miRNA analysis.
#'
#' @param pathToTranscripts A string containing the path to the transcripts.txt
#' file. The file transcripts.txt contains the transcript ids of the
#' circRNA host gene to analyze. It must have one column with header id.
#' By default pathToTranscripts is set to NULL and the file it is searched in
#' the working directory. If transcripts.txt is located in a different
#' directory then the path needs to be specified. If this file is empty or
#' absent the longest transcript of the circRNA host gene containing the
#' back-spliced junctions are considered in the annotation analysis.
#'
#' @param pathToTraits A string containing the path to the traits.txt
#' file. contains diseases/traits specified by the user. It must
#' have one column with header id. By default pathToTraits is set to NULL and
#' the file it is searched in the working directory. If traits.txt is located
#' in a different directory then the path needs to be specified. If this file is
#' absent or empty SNPs associated with all diseases/traits in
#' the GWAS catalog are considered in the SNPs analysis.
#'
#' @return An integer. If equals to 0 the project folder is correctly
#' set up.
#'
#' @examples
#' checkProjectFolder()
#'
#' @importFrom magrittr %>%
#' @export
checkProjectFolder <-
    function(pathToExperiment = NULL,
             pathToGTF = NULL,
             pathToMotifs = NULL,
             pathToMiRs = NULL,
             pathToTranscripts = NULL,
             pathToTraits = NULL) {
        check <- 0

        # Check  optional files
        # check motifs.txt
        if (is.null(pathToMotifs)) {
            pathToMotifs <- "motifs.txt"
        }

        if (file.exists(pathToMotifs)) {
            # Read motifs information
            motifsFromFile <-
                utils::read.table(
                    pathToMotifs,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = "\t"
                )

            cnm <- c("id", "motif", "length")
            if (!all(colnames(motifsFromFile) %in%  cnm)) {
                missingNamesId <- which(!cnm %in%
                                            colnames(motifsFromFile))
                cat(
                    "(!) missing or wrong column names in motifs.txt: ",
                    paste(cnm[missingNamesId], collapse = " \t"),
                    "\n"
                )

            }

            if (nrow(motifsFromFile) == 0) {
                cat(
                    "motifs.txt is empty.
                    Optional file. If empty only
                    ATtRACT motifs will be analyzed\n"
                )
            }


        } else{
            cat(
                "Missing motifs.txt file.
                    Optional file. If absent only
                    ATtRACT motifs will be analyzed\n"
            )
        }

        # check traits.txt
        if (is.null(pathToTraits)) {
            pathToTraits <- "traits.txt"
        }

        if (file.exists(pathToTraits)) {
            # Read traits information
            traitsFromFile <-
                utils::read.table(
                    pathToTraits,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = "\t"
                )

            if (!all(colnames(traitsFromFile) %in%  "id")) {
                cat("(!) missing or wrong column names in traits.txt: id\n ")
            }

            if (nrow(traitsFromFile) == 0) {
                cat(
                    "traits.txt is empty.
                    Optional file. If empty all
                    traits in the GWAS catalog will be analyzed\n"
                )
            }


        } else {
            cat(
                "Missing traits.txt file.
                    Optional file. If absent all
                    traits in the GWAS catalog will be analyzed\n"
            )
        }

        # check miRs.txt
        if (is.null(pathToMiRs)) {
            pathToMiRs <- "miRs.txt"
        }

        if (file.exists(pathToMiRs)) {
            # Read traits information
            miRsFromFile <-
                utils::read.table(
                    pathToMiRs,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = "\t"
                )

            if (!all(colnames(miRsFromFile) %in%  "id")) {
                cat("(!): missing or wrong column names in miRs.txt: id\n")
            }

            if (nrow(miRsFromFile) == 0) {
                cat(
                    "miRs.txt is empty.
                    Optional file. If empty all miRNAs of the
                    specified species will be analyzed\n"
                )
            }


        } else{
            cat(
                "Missing miRs.txt file.
                    Optional file. If absent all miRNAs of the
                    specified species will be analyzed\n"
            )
        }

        # check transcripts.txt
        if (is.null(pathToTranscripts)) {
            pathToTranscripts <- "transcripts.txt"
        }

        if (file.exists(pathToTranscripts)) {
            # Read traits information
            transcriptsFromFile <-
                utils::read.table(
                    pathToTranscripts,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = "\t"
                )

            if (!all(colnames(transcriptsFromFile) %in%  "id")) {
                cat("(!) missing or wrong column names in transcripts.txt: id\n")
            }


            if (nrow(transcriptsFromFile) == 0) {
                cat(
                    "transcripts.txt is empty.
                    Optional file. If empty the longest
                    transcripts for all circRNAs will be analyzed\n"
                )
            }


        } else{
            cat(
                "Missing transcripts.txt.
                    Optional file. If absent the longest
                    transcripts for all circRNAs will be analyzed\n"
            )
        }


        # Check mandatory files
        fileNames <- list.files()
        # check GTF file
        if (is.null(pathToGTF)) {
            pathToGTF <- grep("gtf", fileNames, value = TRUE)[1]
        }

        if (is.na(pathToGTF)) {
            cat("(!): missing gtf file\n")
            check <- check + 1

        }

        # check experiment.txt and prediction results
        if (is.null(pathToExperiment)) {
            pathToExperiment <- "experiment.txt"
        }

        if (file.exists(pathToExperiment)) {
            # Read experiment information
            experiment <-
                utils::read.table(
                    pathToExperiment,
                    header = TRUE,
                    stringsAsFactors = FALSE,
                    sep = "\t"
                )

            cne <- c("label", "fileName", "condition")
            if (!all(colnames(experiment) %in%  cne)) {
                missingNamesId <- which(!cne %in%  colnames(experiment))
                cat(
                    "(!): missing or wrong column names in experiment.txt: ",
                    paste(cne[missingNamesId], collapse = " \t", "\n")
                )
                check <- check + 1
            }

            if (nrow(experiment) != 0) {
                # check folder with circRNA predictions
                # Retrieve the code for each circRNA prediction tool
                predictionToolsAll <- getDetectionTools()

                if (sum(predictionToolsAll$name  %in% fileNames) >= 1) {
                    pt <-
                        predictionToolsAll$name[which(predictionToolsAll$name  %in% fileNames)]

                    for (i in seq_along(pt)) {
                        if (!all(experiment$fileName %in% list.files(pt[i]))) {
                            missingFilesId <- which(!experiment$fileName %in% list.files(pt[i]))
                            cat(
                                "(!): .txt files reported in experiment.txt are not
                                present in folder named",
                                pt[i],
                                "\n"
                            )
                            cat(
                                "Missing files:",
                                paste(experiment$fileName[missingFilesId],
                                      collapse = " \t"),
                                "\n"
                            )
                            check <- check + 1
                        }
                    }

                } else {
                    cat("(!): missing folders containing circRNA predictions\n")
                    cat(
                        "Folders containing .txt files with circRNA prediction
                        must be present in the wd\n"
                    )
                    check <- check + 1
                }


            } else {
                cat(
                    "(!): experiment.txt is empty.
                    Fill the file with the appropriate information\n"
                )
                check <- check + 1
            }

        } else{
            cat("(!): missing experiment.txt file\n")
            check <- check + 1
        }


        return(check)
    }