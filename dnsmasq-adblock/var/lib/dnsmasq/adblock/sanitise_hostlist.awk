!/^[[:space:]]*(127\.0\.0\.1|::1)[[:space:]]+localhost/ {
	print gensub("^[[:space:]]*127\\.0\\.0\\.1", "0.0.0.0", 1)
}
