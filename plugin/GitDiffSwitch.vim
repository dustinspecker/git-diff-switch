let s:diffAlgo = 0
let s:algos = ['myers', 'patience', 'histogram', 'minimal']
function! GitDiffSwitch()
	let hunk = getline(2)
	if (s:diffAlgo == 0)
		:%d | r !git diff --diff-algorithm=myers
	elseif (s:diffAlgo == 1)
		:%d | r !git diff --diff-algorithm=patience
	elseif (s:diffAlgo == 2)
		:%d | r !git diff --diff-algorithm=histogram
	elseif (s:diffAlgo == 3)
		:%d | r !git diff --diff-algorithm=minimal
	endif

	" delete other hunks before the hunk we care about
	execute "normal gg0"
	execute "normal d/^" . hunk . "\<CR>"

	" look for more hunks
	execute "normal /@@ -\<CR>"
	" if found - delete them
	if (line('.') != 1)
		execute "normal dG"
	endif

	" add quick guide to bottom
	execute "normal Go" .
		\ "# ---\<CR>" .
		\ "# To remove '-' lines, make them ' ' lines (context).\<CR>" .
		\ "# To remove '+' lines, delete them.\<CR>" .
		\ "# Lines starting with # will be removed.\<CR>" .
		\ "#\<CR>" .
		\ "# If the patch applies cleanly, the edited hunk will immediately be\<CR>" .
		\ "# marked for staging. If it does not apply cleanly, you will be given\<CR>" .
		\ "# an opportunity to edit again. If all lines of the hunk are removed.\<CR>" .
		\ "# then the edit is aborted and the hunk is left unchanged.\<CR>" .
		\ "#\<CR>\<esc>"
	
	execute "normal Gi# Current diff strategy: " . s:algos[s:diffAlgo] . "\<esc>"

	let s:diffAlgo += 1

	if (s:diffAlgo == 4)
		let s:diffAlgo = 0
	endif
	
	" add Manual hunk edit mode message
	execute "normal ggi" .
		\ "# Manual hunk edit mode -- see bottom for a quick guide\<CR>"

	" move cursor to top as if none of this terribleness ever happened to the user
	execute "normal gg"
endfunction
command GitDiffSwitch call GitDiffSwitch()