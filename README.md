# DyGS: a dynamic gene searching algorithm in cancer detection

# Dynamic Gene Search (DyGS) is a computational algorithm designed to dynamically search for and create an effective mutation gene panel that covers the maximum number of cancer cases possible. This algorithm was applied to 12 cancer types with the highest number of new cases and death rates and has many applications, including mutation gene panel design for liquid biopsy. 

# To generate (0-1)-matrix: mutation_matrix_generate.pl
# input: example_data.txt
# output: Matrix_example_data.txt

# To generate frequency matrix: freq_matrix.pl
# input: Matrix_example_data.txt
# output: Freq_Matrix.txt

# To account for tiebreaks: dynamic_search.pl
# input: Matrix_example_data.txt, cancer_gene_census_genelist.txt, drug_gene.txt
# output: Result_Matrix_example_data.txt
