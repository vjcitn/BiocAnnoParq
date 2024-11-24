# BiocAnnoParq

## SQL-based interfaces to Bioconductor's curated genomic annotation

The purpose of this package is to examine reliability and performance
impacts of reformulating Bioconductor's curation procedures
for general genomic annotation.

The AnnotationDbi idiom involves multiple packages and
a bespoke interface using concepts of keys and columns.
Thus to identify the three Gene Ontology categories
to which gene ORMDL3 has been annotated with traceable
author statements, we have:
```
library(org.Hs.eg.db)
library(GO.db)
tas1 = AnnotationDbi::select(org.Hs.eg.db, keytype="SYMBOL", keys="ORMDL3",
  columns="GO") |> dplyr::filter(EVIDENCE=="TAS")
cats = tas1$GO
AnnotationDbi::select(GO.db, keytype="GOID", keys = cats, columns="TERM")
```


With this package, more standard query processes are supported.
For example this chunk uses standard dplyr syntax to query
cloud-resident parquet files:

```
library(BiocAnnoParq)
con = DBI::dbConnect(duckdb::duckdb())
gi = query_osn(con, "gene_info")
ggo = query_osn(con, "gene2go")
otas = dplyr::left_join(gi |> dplyr::filter(symbol == "ORMDL3"), 
                        ggo |> dplyr::filter(evidence=="TAS"),
          by="gene_id")
otas
```

The `query_osn` function arranges connections to tables derived
from NCBI resources using tooling in the BioconductorAnnotationPipeline
stack.

The use of parquet appears to produce at least 10-fold reductions in file size.
Code complexity is also reduced with this approach, which does permit
queries in pure SQL.
