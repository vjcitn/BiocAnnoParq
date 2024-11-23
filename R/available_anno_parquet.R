
#' use 'paws::s3' to interrogate an NSF Open Storage Network
#' bucket for zipped zarr archives for various platforms
#' @examples
#' if (requireNamespace("paws")) {
#'   available_anno_parquet()
#' }
#' @export
available_anno_parquet <- function() {
    if (!requireNamespace("paws")) 
        stop("install 'paws' to use this function; without it",
            " we can't check existence of data in OSN bucket")
    message("checking Bioconductor OSN bucket...")
    s3 <- paws::s3(
        credentials=list(anonymous=TRUE),
        endpoint="https://mghp.osn.xsede.org")
    zz <- s3$list_objects("bir190004-bucket01")
    allk <- lapply(zz$Contents, "[[", "Key")
    basename(grep("BiocParquetAnno\\/", allk, value=TRUE))
}

