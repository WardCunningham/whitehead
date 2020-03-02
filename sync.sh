# update limited distribution site
# usage: sh sync.sh

rsync -avz ~/.wiki/white.localhost/pages/ asia:.wiki/anw.fed.wiki/pages/
# rsync -avz ~/.wiki/white.localhost/assets/ asia:.wiki/anw.fed.wiki/assets/
ssh asia 'cd .wiki/anw.fed.wiki/status; rm -f site* index-updated'