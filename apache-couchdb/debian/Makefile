include /etc/lsb-release

all:
	debuild -S

karmic lucid maverick:

	ln -f changelog.$@ changelog
	$(MAKE)
	rm -f changelog
