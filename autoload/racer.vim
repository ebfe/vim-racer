if exists('g:loaded_racer')
	finish
end
let g:loaded_racer = 1

fu! s:racer(what)
	let fname = expand('%:p')
	let tmpfile = tempname()
	let buf = getline(1, '$')
	call writefile(buf, tmpfile, "b")

	let cmd = printf('racer %s %d %d %s', a:what, line('.'), col('.')- 1,  tmpfile)
	let lines = split(system(cmd), "\n")

	call delete(tmpfile)

	let prefix = 0
	let matches = []

	if v:shell_error == 0
		for line in lines
			if line =~ "^PREFIX "
				let tok = split(strpart(line, 7), ",", 1)
				let prefix = tok[0]
			elseif line =~ "^MATCH "
				let tok = split(strpart(line, 6), ",", 1)
				let m = {}
				let m['word'] = tok[0]
				let m['line'] = tok[1]
				let m['col'] = tok[2]
				if tok[3] == tmpfile
					let m['file'] = fname
				else
					let m['file'] = tok[3]
				endif
				if len(tok) > 4
					let m['abbr'] = tok[4]
				else
					let m['abbr'] = tok[0]
				endif
				let matches = matches + [m]
			endif
		endfor
	else
		"echom 'shell error:'. v:shell_error
	endif

	return [prefix, matches]
endf

fu! racer#Complete(findstart, base)
	if a:findstart
		let s:racer_completions = s:racer("complete")
		return s:racer_completions[0]
	else
		return s:racer_completions[1]
	end
endf


fu! racer#JumpToDefinition()
	let matches = s:racer('find-definition')[1]
	if len(matches) > 0
		let m = matches[0]
		lexpr printf('%s:%s:%s %s', m['file'], m['line'], m['col'], m['abbr'])
	endif
endf
