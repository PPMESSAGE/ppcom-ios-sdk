# REMEMBER to modify version number in PPComLib.podspec and commit changes before add tag !

# If you pushed a wrong tag to github, you can delete that tag using following commands:
#   git tag -d tagName
#   git push origin :refs/tags/tagName

tag=$1

git tag -a "$1" -m "tag $1" 

git push

git push --tags

pod spec lint PPComLib.podspec  --allow-warnings


#pod trunk register guijin.ding@ppmessage.com 'Guijin Ding' --description='macbook pro 17inch'

#pod trunk add-owner PPComLib guijin.ding@ppmessage.com
pod trunk push PPComLib.podspec  --allow-warnings
