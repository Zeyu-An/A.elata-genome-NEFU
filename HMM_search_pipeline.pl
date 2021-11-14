#!usr/bin/perl -w
use strict;
=head1 Usage
-hmm 		<str>	*	input the hmm file from Pfam	must absolute path
-ref	<str>	*	input the whole genome fasta file must absolue path
-ref_pep	<str>	*	input the protein file	must absolute path
-ref_cds	<str>	*	input the cds file	must absolute path
-gff	<str>	*	input the gff file	must absolute path
-help				output help information to screen
=head1 Example
perl /home/inspur/azy/bin/HMM_search_pipeline.pl -hmm hmm.txt -ref_pep pep.fa -ref_cds cds.fa -gff genome.gff -ref genome.fa
=cut
use strict;use Getopt::Long;use FindBin qw($Bin $Script);use POSIX;
my ($hmm,$ref_pep,$ref_cds,$gff,$ref);
GetOptions(
	"hmm:s"=>\$hmm,
	"ref_pep:s"=>\$ref_pep,
	"ref_cds:s"=>\$ref_cds,
	"gff:s"=>\$gff,
	"ref:s"=>\$ref
);
my $pwd=`pwd`;	chomp $pwd;
die `pod2text $0` unless  (defined $ref_pep);	die `pod2text $0` unless  (defined $hmm);
my $result="result"; mkdir $result unless(-d $result);
my $shell="shell";mkdir $shell unless(-d $shell);
my $blast="blast";mkdir $blast unless(-d $blast);

my @a=split /\//,$hmm;my @b=split /\./,$a[-1];
open A,">$pwd/$shell/S01.hmmsearch_$b[0].sh";
print A "hmmsearch $hmm $ref_pep > $pwd/$result/$b[0]_hmm.txt\n";
print A "cat $pwd/$result/$b[0]_hmm.txt | grep '>>' |sort|uniq|sed 's/>>//g'|awk '{print \$1}' > $pwd/$result/$b[0]_gene.list\n";
print A "sed -i 's/>//g' $pwd/$result/$b[0]_gene.list\n";

open B,">$pwd/$shell/S02.extract_$b[0]_seq.sh";
print B "seqkit grep -f $pwd/$result/$b[0]_gene.list $ref_pep > $pwd/$result/$b[0]_pep.fa\n";
print B "seqkit grep -f $pwd/$result/$b[0]_gene.list $ref_cds > $pwd/$result/$b[0]_cds.fa\n";

open C,">$pwd/$shell/S03.blastp_$b[0]_nr.sh";
print C "blastp -query $pwd/$result/$b[0]_pep.fa -db /home/Database/nr_db/split_nr/d__Eukaryota__k__Viridiplantae.fasta -out $pwd/$blast/$b[0]_pep.fa_vs_nr.xml -evalue 1e-5 -max_target_seqs 10 -num_threads 8 -outfmt 5\n";
print C "/home/bin/Anno/anno_st/Blast2table -format 10 -xml -expect 1E-5 -top  $pwd/$blast/$b[0]_pep.fa_vs_nr.xml >  $pwd/$blast/$b[0]_pep.fa_vs_nr.xls\n";

close A;
close B;
close C;
