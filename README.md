# primerAnalysis
a biological program that can analyze DNA for self similarity or similarity to a reference sequence

The primerAnalysis script takes a plain text file containing DNA bases (not in fasta format) and
generates a genBank file that can be opened using SnapGene viewer and color coded to visually
analyze repetitive regions of geneomes for primer viability. The program only examines repetition with
respect to the inputed genome and does not analyze potential primers for other nessecary considerations
such as GC content or secondary structure. All primers analyzed are 20 bps long.

This program is a pipeline that takes advantage of several existing programs. BLAST+ and tbl2asn are from
an outside source. Katherine Braught developed tabularFeaturesCreator.jar and slidingWindow.jar.

RUNNING THE PROGRAM
The first step to running the script is adding your information to the script. You need to put the name
of a blank sequence file (in text form, no FASTA header), the name of your BLAST database. Finally, you need
to specificy a prefix, which will used in all output files and should describe what your sequence is.

The folder also must contain a template.sbt file. You may leave the default that is provided in the folder
or download your own personal template from NCBI tbl2asn webpage.

Two jar files are also located in this folder and need to be there to run. If they need to be moved, you may adjust
the script  to find their new location.

The program can then be ran following typical procedures.

UNDERSTANDING THE OUTPUT
$PREFIX.gbf :
The final file produced will be called $PREFIX.gbf. This file can be opened in SnapGene Viewer(free version).
To make results more visually appealing, you can add colors within the SnapGene interface by sorting by feature name
and adjusting the color. The features are organized such that if you select a primer whose left most base is within a
feature, the primer will have that matching qualtiy. For example, if you had a feature 15 base pairs long that was "no
matches in reference" and you selected a primer that started at the 15th posisition in that feature, that entire primer
is not found anywhere in the specified blast database.

$PREFIX.summary.txt :
The program also produces a summary file. It describes the number of areas with no matches, between 1 and 10 matches,
and greater than 10 matches.


STEPS OF THE PROGRAM
The first step of the program is called the slidingWindow component. The slidingWindow.jar file takes in a text file
containing a sequence and slices the sequence into all possible 20 basepair primers. For example, a DNA sequence of
ACTGACTGTGCACGTGCACGTG would results in a file:
        >Sequence 1
        ACTGACTGTGCACGTGCACG
        >Sequence 2
        CTGACTGTGCACGTGCACGT
        >Sequence 3
        TGACTGTGCACGTGCACGTG
As the sliding window slides one base pair at a time and adds each short sequence to the file $PREFIX.outMers
This program also generates a .fsa fasta file that is used later by the tbl2asn program.
The argument 1 indicates that the program should start generating primers at the very first basepair in the test file.

The next step of the program is to BLAST all primers to the database. The task blastn-short is used because the primer
sequences are so long. The evalue is adjusted to 0.006 to require perfect matches of all 20 bases with no gaps.

The defining of the FINALHIT variable is to correct a short coming in the tabularFeaturesCreator.jar program and simply
searches for number of hits the final BLAST search returns.

Next, the pipeline runs tabularFeaturesCreator which looks at the BLAST results and find regional patterns of similarity
between primers and places them in a tabular format. For example, if three primers in a row have no matches found the database
rather than 3 different features appearing on snapGene, there will be only one feature. This allows you to indentify large
regions that have the same characterists. The program takes in $PREFIX.blastOut file and returns a $PREFIX.tbl and $PREFIX.summary.txt
file that contain the features and a summary file.

Finally, the $PREFIX.tbl and $PREFIX.fsa files are run in the program tbl2asn. Their file names are not specified as tbl2asn searches for a
.fsa and .tbl file with the same name and same header/table name. It will then convert the two separate files into a GenBank file along with
several other files.

The GenBank file is then opened in SnapGene for viewing.
