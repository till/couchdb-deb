include /etc/lsb-release

all:
	debuild -S

karmic lucid maverick:

	cp changelog.$@ changelog
	$(MAKE)
	rm changelog
