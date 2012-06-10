include /etc/lsb-release

all:
	debuild -S

karmic lucid maverick precise:

	cp changelog.$@ changelog
	$(MAKE)
	rm changelog
