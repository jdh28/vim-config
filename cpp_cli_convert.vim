%s/::/./ge
%s/->/./ge
%s/\^//ge
%s/\<nullptr\>/null/ge
%s/\<for each\>/foreach/ge
%s/\<gcnew\>/new/ge
%s/\<auto\>/var/ge
%s/\<array<\([^>]\+\)>/\1[]/ge
%s/\<initonly\>/readonly/e
%s/\<property\> //e
%s/\<Object\> /object /ge
%s/\<unsigned int\>/uint/ge
%s/\<BOOL\>/bool/ge
%s/\<TRUE\>/true/ge
%s/\<FALSE\>/false/ge
%s/virtual \(.*\) override/override \1/e
%s/virtual \(.*\) abstract/abstract \1/e
%s/isinst<\(\S\+\)>(\([^)]\+\))/\2 is \1/e
%s/asinst<\(\S\+\)>(\([^)]\+\))/\2 as \1/e
%s/\[Out\] \([a-z_0-9]\+\)%/out \1/ige
%s/\(\<[a-z_0-9]\+\)%/ref \1/ige
%s/\<String\>\s\@=/string/ge
%s/\s\+$//e
