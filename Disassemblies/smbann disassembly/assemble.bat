ca65 -t nes -l ann.lst ann_fdswrap.asm -o smbann.o
del ann_fdswrap.asm
ren header.asm ann_fdswrap.asm
ld65 -C NROM.cfg smbann.o -o smbann.fds
