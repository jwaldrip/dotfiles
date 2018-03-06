date=`date`

sync: restore update
restore: pull-changes brew-bundle
update: brew-dump push-changes

init: git-init setup-private setup-directories force-restore

force-restore:
	@git fetch
	@git reset --hard origin/master
	@make restore

setup-private:
	@brew cask install keybase
	@keybase login
	@rm -rf .private
	@git clone keybase://private/jwaldrip/private .private
	@chmod 0400 .private/.ssh/id_rsa

setup-directories:
	@for folder in Documents Pictures Music Movies ; do \
		sudo rm -rf $$folder ; \
		ln -sf ./.cloud-drive/$$folder ; \
	done

git-init:
	@rm -rf ./.git
	@rm -rf ./.gitconfig
	@rm -rf ./.private
	@git init
	@git remote add origin git@github.com:jwaldrip/dotfiles.git

push-changes:
	@git submodule foreach --quiet --recursive git add -A
	@sh -c "cd .private && git commit -am 'dotfiles update on $date' || true"
	@sh -c "cd .private && git push origin master || true"
	@git add -A
	@git commit -m "dotfiles update on $date"

pull-changes:
	@git pull origin master
	@git submodule update --recursive --remote

brew-bundle:
	@brew bundle --verbose

brew-dump:
	@brew bundle dump --force
