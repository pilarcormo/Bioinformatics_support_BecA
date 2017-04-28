file=$1


sed 's:AA:A	A:g' $file  | sed 's:TT:T	T:g' | sed 's:GG:G	G:g' | sed 's:CC:C	C:g' | sed 's:GC:G	C:g' | sed 's:CG:C	G:g' | sed 's:AT:A	T:g' | sed 's:TA:T	A:g' | sed 's:TC:T	C:g' | sed 's:CT:C	T:g' | sed 's:GT:G	T:g' | sed 's:TG:T	G:g' | sed 's:AG:A	G:g' | sed 's:GA:G	A:g' | sed 's:CA:C	A:g' | sed 's:AC:A	C:g' | sed 's:00:0	0:g'
