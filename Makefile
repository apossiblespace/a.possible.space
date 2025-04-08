.POSIX:
.PHONY: all yeet serve

REMOTE_HOST = bubundel
REMOTE_PATH = /var/www/a.possible.space
NOW = $(shell date '+%Y-%m-%d %H:%M:%S %z')
YEAR = $(shell date '+%Y')

all: yeet

serve:
	bundle exec jekyll serve --livereload --incremental

yeet:
	bundle exec jekyll build
	rsync -rvlh --progress --delete _site/ $(REMOTE_HOST):$(REMOTE_PATH)
