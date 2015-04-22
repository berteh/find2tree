#find2tree

This script generates a jstree json data file from a directory listing.

##Usage
Possible uses are, eg:
 
    ./find2tree.pl [options] < listing.txt > jstree.json
    
    ./find2tree.pl [options] listing.txt > jstree.json
    
    find some-directory | ./find2tree.pl --localdir "some-directory" --base "http://your-domain.com/" > jstree.json

##Options
    --help -?      this help message
     
    --localdir -l  local directory as in listing.txt, 
                   to be replaced by 'base', default: /var/ftp
      
    --base -b      remote (online) location of localdir, 
 	                 default: ftp://localhost
      
    --includehidden -i    include hidden files if set
      
    --verbose -v   generates comments in json for entries that 
                   could not been parsed as {"comment":"### -more info-"}
</code>
