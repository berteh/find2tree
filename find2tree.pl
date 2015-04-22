#!/usr/bin/perl
# generate jstree json data from directory listing.
#
# usage
#    ./find2tree.pl [options] listing.txt > jstree.json
#    find . | ./find2tree.pl --localdir "./" --base "http://your-domain.com/" > jstree.json
#
# license: (c)2015 berteh, released in public domain.
#
# known limitation: does not distinguish directories with dot+letter ending (\.[a-z0-9]+) and treats them as files.


use Getopt::Long; 
use Pod::Usage;
use Digest::MD5 qw(md5_base64);


my $localdir = "/var/ftp";
my $base = "ftp://localhost"; 
my $verbose = 0, $includehidden = 0, $man = 0, $help = 0;
my $parent, $filename, $filepath, $icon;


GetOptions ("localdir|l=s" => \$localdir, # string
            "base|hrefbase|b=s" => \$base, # string
            "includehidden|i" => \$includehidden, "verbose|v" => \$verbose,  # flag
            'help|?' => \$help, man => \$man) or pod2usage(2);
pod2usage(1) if ($help or $man);
pod2usage(-exitval => 0, -verbose => 2) if $man;


my $drop = <>;
print("[\n".'{"id": "'.md5_base64("__root").'", "parent":"#", "text":"'.$base.'", "icon":"folder", "state":{ "opened":true, "selected":true}, "li_attr": {"rel": "'.$base.'"}}');

while (my $line = <>) {
	if ($line =~ m/^$localdir((.*)\/([^\/\n]+))$/) { #line starts with localdir
		$filename = $3;
		next if (!$includehidden && (substr($filename, 0, 1) eq "."));
		$parent = $2;
		$parent = "__root" if ($parent eq "");
		$filepath = $1;		

		if ($filename =~ m/([^\/]+)\.([a-z0-9]+)$/) { #filename finishes likely with an extension
			$icon = ', "icon" : "file file-'.$2.'"';
		} else { # $line is likely a directory
			$icon = ', "icon" : "folder"';	
		}
		print(",\n".'{"id": "'.md5_base64($filepath).'", "parent": "'.md5_base64($parent).'", "text":"'.$filename.'"'.$icon.', "li_attr": {"rel": "'.$base.$filepath.'"}}');
	} elsif ($verbose) {
			print(",\n{comment: \"### following line could not be parsed: ".($line)."\"}");#todo $line to single line
	}
}

print("\n]");


__END__

=head NAME
generate jstree json data from directory listing

=head SYNOPSIS
./find2tree.pl [options] < listing.txt > jstree.json
./find2tree.pl [options] listing.txt > jstree.json

or combined with 'find'
find some-directory | ./find2tree.pl --localdir "some-directory" --base "http://your-domain.com/" > jstree.json

=head OPTIONS

 --help -?      this help message

 --localdir -l  local directory as in listing.txt, 
                to be replaced by 'base', default: /var/ftp
 
 --base -b      remote (online) location of localdir, 
 	            default: ftp://localhost
 
 --includehidden -i    include hidden files if set
 
 --verbose -v   generates comments in json for entries that 
                could not been parsed as {"comment":"### -more info-"}

=head1 DESCRIPTION

This program will generate a valid jstree JSON data file from a simple (recursive) directory listing.

=cut
