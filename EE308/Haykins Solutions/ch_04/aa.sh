     #!/bin/bash
        for i in $( ls ); do
            echo item: $i
	    cat $i >> aa.pdf
        done
