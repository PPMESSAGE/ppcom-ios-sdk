tag=$1

git tag -a "$1" -m "tag $1" 

git push

git push --tags

pod spec lint PPComLib.podspec

pod trunk push PPComLib.podspec

#pod trunk register guijin.ding@ppmessage.com 'Guijin Ding' --description='macbook pro 17inch'
#pod trunk add-owner PPComLib guijin.ding@ppmessage.com
