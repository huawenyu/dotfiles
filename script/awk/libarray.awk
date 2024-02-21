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
			if (_func)
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
#      family["me"]["father"]["grandpa"]["name"] = "George"
#      family["me"]["father"]["grandpa"]["age"]  = 70
#      family["me"]["father"]["grandma"]["name"] = "Katherine"
#      family["me"]["father"]["name"]            = "Vasiliy"
#      family["me"]["name"]                      = "Ivan"
#      array::show(family, "Family")
# }
function show(arr, arrname,      i, member, arrnum)
{
	if (!awk::isarray(arr)) {
		print indent arrname member "[\033[1;31m" elt "\033[0m]=\"\033[1;32m" arr "\033[0m\""
	} else {
		arrnum = elt
		member = elt ? member "[" elt "]" : ""
		#print indent (elt ? arrname member : arrname) "(\033[1;34m" length(arr) " member" (length(arr) > 1 ? "s" : "") "\033[0m)"
		indent = indent " "
		for (elt in arr) {
			if (elt ~ "^_@_") { #indrect function
				_func = arr[elt]
				if (_func)
					@_func()
			} else {
				show(arr[elt], arrname, elt, member, arrnum)
			}
		}
		indent = substr(indent, 1, length(indent)-1)
	}
}

function show2(arr, arrname, _1)
{
	indent = ""
	show(arr, arrname)
	indent = ""
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

