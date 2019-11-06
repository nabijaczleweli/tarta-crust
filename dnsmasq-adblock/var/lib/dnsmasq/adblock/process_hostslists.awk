BEGIN {
	sanitise_fname=""
	sanitise_fname_chunks_len=split(ARGV[1], sanitise_fname_chunks, "/");
	for(i in sanitise_fname_chunks)
		if(i != sanitise_fname_chunks_len)
			sanitise_fname = sanitise_fname sanitise_fname_chunks[i] "/"
	sanitise_fname = sanitise_fname "sanitise_hostlist.awk"
}

/^(ht|f)tp/ {
	outfile=gensub("/|\\.", "_", "g", gensub("?.+", "", 1, gensub("^.+\\/\\/", "", 1)))
	if(outfile !~ /hosts(_.+)?$/)
		outfile = outfile "_hosts"

	print "Downloading " $0
	system("wget -q \"" $0 "\" -O- | awk -f \"" sanitise_fname "\" > \"" outfile "\"")
}
