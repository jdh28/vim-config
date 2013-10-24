%s/::/./g
%s/->/./g
%s/\^//g
%s/\<nullptr\>/null/g
%s/\<for each\>/foreach/g
%s/\<gcnew\>/new/g
%s/\<auto\>/var/g
%s/\<array<\([^>]\+\)>/\1[]/g
%s/\<initonly\>/readonly/
%s/\<String\>\s\@=/string/g
