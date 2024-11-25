library(DBI)
library(duckdb)
dcon = dbConnect(duckdb())
dbExecute(dcon, "ATTACH 'genesrc.sqlite' (TYPE SQLITE);")
dbExecute(dcon, "USE genesrc; SHOW TABLES;")

dbExecute(dcon, "COPY
    (SELECT * FROM gene_info)
    TO 'mouse.gene_info.parquet'
    (FORMAT 'parquet');")

dbExecute(dcon, "COPY
    (SELECT * FROM gene2go)
    TO 'mouse.gene2go.parquet'
    (FORMAT 'parquet');")

dbExecute(dcon, "COPY
    (SELECT * FROM gene2pubmed)
    TO 'mouse.gene2pubmed.parquet'
    (FORMAT 'parquet');")
#
dbExecute(dcon, "SET sqlite_all_varchar=true; COPY
    (SELECT * FROM gene2refseq)
    TO 'mouse.gene2refseq.parquet'
    (FORMAT 'parquet');")

dbExecute(dcon, "COPY
    (SELECT * FROM gene_synonym)
    TO 'mouse.gene_synonym.parquet'
    (FORMAT 'parquet');")
dbExecute(dcon, "SET sqlite_all_varchar=true; COPY
    (SELECT * FROM mim2gene)
    TO 'mouse.mim2gene.parquet'
    (FORMAT 'parquet');")
