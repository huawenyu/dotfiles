# The array functions:
#
# https://www.gnu.org/software/gawk/manual/html_node/Walking-Arrays.html
#
@namespace "array"

# Usage:
# BEGIN {
#     a[1] = 1
#     a[2][1] = 21
#     a[2][2] = 22
#     a[3] = 3
#     a[4][1][1] = 411
#     a[4][2] = 42
#
#     walk(a, "a")
# }
function walk(arr, name, comma,      i, _func)
{
	for (i in arr) {
		if (awk::isarray(arr[i])) {
			if (comma)
				walk(arr[i], (name comma i), comma)
			else
				walk(arr[i], (name "[" i "]"), comma)
		} else if (i ~ "^_@_") { #indrect function
			_func = arr[i]
			@_func()
		} else if (comma) {
			printf("%s%s%s = %s\n", name, comma, i, arr[i])
		} else {
			printf("%s[%s] = %s\n", name, i, arr[i])
		}
	}
}


# Usage:
# BEGIN {
#     a[1] = 1
#     a[2][1] = 21
#     a[2][2] = 22
#     a[3] = 3
#     a[4][1][1] = 411
#     a[4][2] = 42
#
#     walk2(a, "a", "do_print", 0)
# }
#
# function do_print(name, element)
# {
#     printf "%s = %s\n", name, element
# }
function walk2(arr, name, process, do_arrays,   i, new_name)
{
	for (i in arr) {
		new_name = (name "[" i "]")
		if (awk::isarray(arr[i])) {
			if (do_arrays)
				@process(new_name, arr[i])
			walk2(arr[i], new_name, process, do_arrays)
		} else
			@process(new_name, arr[i])
	}
}


function copy(dst, src,      i)
{
	delete dst         # Empty "dst" for first call and delete the temp
	# array added by dst[i][1] below for subsequent.
	for (i in src) {
		if (isarray(src[i])) {
			dst[i][1]  # Force dst[i] to also be an array by creating a temp
			copy_array(src[i], dst[i])
		}
		else {
			dst[i] = src[i]
		}
	}
}

