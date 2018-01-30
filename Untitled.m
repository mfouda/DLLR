cc=unique(label);

[a,b]=hist(label,cc);

bar(b,a/length(label));

axis([52,89,0,0.15])