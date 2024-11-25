Scripts in this folder were produced to document work on the
refactoring of BioconductorAnnotationPipeline.

Working from 

BioconductorAnnotationPipeline/annosrc/gene/script

note that

https://github.com/Bioconductor/BioconductorAnnotationPipeline/blob/master/annosrc/gene/script/getsrc.sh

has taxonomy codes for 18 model organisms.

We modified the selection to code 9606 (human) in one run, and 10090 (mouse) in a second run.

The shell files in gene/script will download gzipped text from NCBI: gene2go,
gene2pubmed, gene2refseq, gene2accession, mim2gene_medgen, gene_info, gene_orthologs

from https://ftp.ncbi.nlm.nih.gov/gene/DATA/

Index of /gene/DATA
Name                            Last modified      Size  
Parent Directory                                     -   
ARCHIVE/                        2020-01-02 15:38    -   
ASN_BINARY/                     2024-11-25 02:08    -   
GENE_INFO/                      2024-11-25 02:08    -   
expression/                     2017-03-06 17:55    -   
special_requests/               2024-05-13 16:57    -   
README                          2023-11-02 15:38   57K  
README_ensembl                  2024-11-19 01:57   58K  
gene2accession.gz               2024-11-25 01:54  3.4G  
gene2ensembl.gz                 2024-11-25 01:55  239M  
gene2go.gz                      2024-11-25 01:56  1.1G  
gene2pubmed.gz                  2024-11-25 01:57  195M  
gene2refseq.gz                  2024-11-25 02:00  1.7G  
gene_group.gz                   2024-11-25 02:00  289K  
gene_history.gz                 2024-11-25 02:00  139M  
gene_info.gz                    2024-11-25 02:02  1.2G  
gene_neighbors.gz               2024-11-25 02:04  1.5G  
gene_orthologs.gz               2024-11-25 02:04   87M  
gene_refseq_uniprotkb_collab.gz 2024-11-21 05:23  1.0G  
go_process.dtd                  2023-09-11 09:48  1.4K  
go_process.xml                  2024-07-09 16:13  8.0K  
mim2gene_medgen                 2024-11-24 05:05  832K  
stopwords_gene                  2011-06-09 07:58  737   

The download.sh will retrieve gzipped text into a dated folder.

The dosrc_human.sh script in this folder (in BiocAnnoParq/inst/scripts)
will filter these files and produce an 8+ GB indexed SQLite database
genesrc.sqlite.

The mouse_gene.R program shows how topical parquet files are
extracted from the SQLite database.
