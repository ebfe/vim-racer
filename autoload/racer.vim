if exists('g:loaded_racer')
	finish
end

if !has('python')
	echoerr 'racer.vim needs python'
	finish
end

let g:loaded_racer = 1

python import sys
exe 'python sys.path = ["' . expand('<sfile>:p:h')  . '"] + sys.path'
python import racer

fu! racer#Complete(findstart, base)
	if a:findstart
		let tmpfile = tempname()
		let buf = getline(1, '$')
		call writefile(buf, tmpfile, "b")

		let py = printf('racer.complete(%d, %d, "%s")', line('.'), col('.')-1, tmpfile) 
		let s:racer_completions = pyeval(py)

		call delete(tmpfile)
		return s:racer_completions[0]
	else
		return s:racer_completions[1]
	end
endf


fu! racer#FindDefinition()
	let fname = expand('%:p')
	let tmpfile = tempname()
	let buf = getline(1, '$')
	call writefile(buf, tmpfile, 'b')

	let py = printf('racer.find_definition(%d, %d, "%s")', line('.'), col('.')-1, tmpfile) 
	let def = pyeval(py)

	call delete(tmpfile)

	if def != '' 
		lexpr substitute(def, tmpfile, fname, "g")
	endif
endf
