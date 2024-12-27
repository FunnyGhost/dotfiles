function exists() {
	# command -v is similar to `which`
	# $1 = first argument
	# /dev/null  = black hole file
	# STDIN = 0, STDOUT = 1, STDERR = 2
	# 1>/dev/null = redirect output to /dev/null
	# &1 = same as STDOUT
	# 2>&1 = redirect error to same thing as output(/dev/null)

	# The only difference is in the status codes returned. 0 or != 0 
	command -v $1 >/dev/null 2>&1
}