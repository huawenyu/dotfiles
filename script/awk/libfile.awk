@namespace "file"
@include "libstd.awk"

# Usage:
#   {print FILENAME, filename(FILENAME)}
function filename(file, a, n) {
	n = split(file, a, "/")
	return a[n]
}


# Usage:
#   {print FILENAME, filedir(FILENAME)}
function filedir(file, a, n) {
	n = split(file, a, "/")
	return std::join(a, 1, n - 1, "/")
}

