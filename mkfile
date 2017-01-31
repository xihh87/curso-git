all: git.pdf

%.html:	%.md
	pandoc \
		--to=dzslides \
		--standalone \
		--output=$target \
		$prereq

%.pdf:	%.md
	pandoc \
		--to=beamer \
		--latex-engine=xelatex \
		-V theme:metropolis \
		--output=$target \
		$prereq

w_%:V: %.html
	WID=`surf -p -x $prereq &`
	current_uri() {
	    xprop -id $1 \
	    | grep URI \
	    | sed -e 's#_SURF_URI(STRING) = ##' -e 's#"\(.*\)"#\1#'
	}
	while true; do
		inotifywait $stem.md -e modify >/dev/null 2>/dev/null || true
		URI=`current_uri $WID`
		mk $prereq
		xprop -id "$WID" -format _SURF_GO 8s -set _SURF_GO "about:blank"
		xprop -id "$WID" -format _SURF_GO 8s -set _SURF_GO "$URI"
	done
