#
# Makefile -- 
#



YAML_FILES=Activ01.yaml	

X_FILES=xp1.pl

SOURCE_FILES=Makefile \
	$(X_FILES) $(YAML_FILES)

PERL_EXE=/usr/bin/perl

.PHONY: all hello clean bkp chk x

all: hello

hello :
	echo "Hello!."
	
clean:
	rm *.trc
		
bkp : 
	bak.pl $(SOURCE_FILES)
	bak.pl $(X_FILES)

chk:
	clear
	$(PERL_EXE) -c xp1.pl
	yamllint Activ01.yaml	

x : 
	clear
	time ./xp1.pl --trace	

	
