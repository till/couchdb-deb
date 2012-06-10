include /etc/lsb-release

all:
	debuild -S

karmic lucid maverick oneiric precise:

	cp changelog.$@ changelog
	$(MAKE)
	rm changelog
