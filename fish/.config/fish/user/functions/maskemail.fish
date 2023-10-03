# 
# generated a masked email from fastmail
# requires: htpps://github.com/dvcrn/maskedemail-cli
# 
function maskemail 
   
   $HOME/go/bin/maskedemail-cli -token $FASTMAIL_MASKEDMAIL_TOKEN create -domain $argv[1] | pbcopy
   echo "done!"
end
