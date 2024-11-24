# find all pubmed IDs referring to genes annotated to viral suppression

## local code
#library(DBI)
#library(duckdb)
#con = dbConnect(duckdb())
#tbl(con, "read_parquet('gene_info.parquet')") |> filter(map_location %LIKE% '8p%')
#
## remote code
#
#

#' support for URL generation based on NSF OSN bucket
#' @param stub character(1) string like gene2go
#' @export
make_parq_url = function(stub) {
stub = sub(".parquet$", "", stub)
sprintf("https://mghp.osn.xsede.org/bir190004-bucket01/BiocParquetAnno/%s.parquet", stub)
}

.stubs = c("gene2go", "gene2pubmed", "gene2refseq", "gene_info",
 "gene_synonym", "mim2gene")
.stubs = c(.stubs, paste0("mouse.", .stubs))

# [1] "gene2go.parquet"            "gene2pubmed.parquet"       
# [3] "gene2refseq.parquet"        "gene_info.parquet"         
# [5] "gene_synonym.parquet"       "mim2gene.parquet"          
# [7] "mouse.gene2go.parquet"      "mouse.gene2pubmed.parquet" 
# [9] "mouse.gene2refseq.parquet"  "mouse.gene_info.parquet"   
#[11] "mouse.gene_synonym.parquet" "mouse.mim2gene.parquet"

#if (!dbIsValid(con)) con = dbConnect(duckdb())

#' produce a tbl with genomic annotation using a remote parquet file
#' @import DBI
#' @import dplyr
#' @param con a DBI connection, typically using duckdb, that can be used
#' to query remote parquet files
#' @param stub character(1) tag identifying an annotation resource
#' @note DBI::dbListTables is used to query connection for existence of
#' the desired table/view, which is returned if present.  Otherwise
#' an httpfs based query is used to produce a view.
#' @examples
#' con = DBI::dbConnect(duckdb::duckdb())
#' query_osn(con, stub="gene_info")
#' query_osn(con, stub="gene2go")
#' DBI::dbDisconnect(con)
#' @export
query_osn = function(con, stub="gene_info") {
    stopifnot(stub %in% .stubs)
    tablist = DBI::dbListTables(con)
    if (stub %in% tablist) return(tbl(con, stub)) # view already available
    url = make_parq_url(stub)
    dbExecute(con, "INSTALL httpfs from core_nightly;")
    dbExecute(con, "LOAD httpfs;")
    dbExecute(con, sprintf("create view %s as select * from parquet_scan(%s)", 
        stub, sQuote(url)))
    tbl(con, stub)
}
