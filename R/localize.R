
.cache_add_if_needed <- function(cache=BiocFileCache::BiocFileCache(), stub) {
    url = make_parq_url(stub)
    info <- BiocFileCache::bfcquery(cache, basename(url))
    nrec <- nrow(info)
    if (nrec > 1) {
        message(sprintf("multiple %s found in cache, using last recorded", stub))
        return(info$rpath[nrec])
    }
    if (nrec == 1) {
        message("returning path to cached parquet")
        return(info$rpath[nrec])
    }
    message(sprintf("retrieving from %s, caching, and returning path", url))
    ans = BiocFileCache::bfcadd(cache, rname=stub, fpath=url, rtype="web")
    names(ans) = stub
    ans
}

local_table = function(con, stub, path) {
 stub = gsub(".parquet", "", stub) # can't have dot
 DBI::dbExecute(con, sprintf("create view %s as select * from parquet_scan(%s)", 
        stub, sQuote(path, q=FALSE)))
 dplyr::tbl(con, stub)
}

#' obtain path to a localized parquet resource
#' @param x character(1) stub of use in make_parq_url
#' @param con DBI connection
#' @param cache BiocFileCache-compliant cache
#' @note If cache does not already have a relevant file, one is retrieved from Bioconductor OSN bucket.
#' @examples
#' ca = BiocFileCache::BiocFileCache()
#' con = DBI::dbConnect(duckdb::duckdb())
#' pa = get_local_table("gene_info.parquet", con, ca)
#' pa
#' @export
get_local_table = function(x, con, cache=BiocFileCache::BiocFileCache()) {
  ans = .cache_add_if_needed(cache, x)
  local_table(con, x, ans)
}
