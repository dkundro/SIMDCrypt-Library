
all: objetos lib

objetos:
	cd SRC/ && $(MAKE) 

lib:
	rm -f LIBRARY/libsimdcrypt.a && rm -f TEST/Codigo/generateOutputC/libsimdcrypt.a && cd OBJECTS/ && $(MAKE) && cd ../TEST/Codigo/generateOutputC/ && $(MAKE) 
