/\st\.co$/ {
	next
}

!/^[[:space:]]*(127\.0\.0\.1|::1)[[:space:]]+localhost/ {
	sub("^[[:space:]]*127\\.0\\.0\\.1", "0.0.0.0")
	print
}
