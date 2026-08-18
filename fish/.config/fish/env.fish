# AICHAT 
# https://github.com/sigoden/aichat
set -Ux AICHAT_CONFIG_DIR ~/.config/aichat

# SOPS
# Age identity used to decrypt the secret store. sops looks under
# os.UserConfigDir(), which is ~/Library/Application Support on macOS and
# ~/.config on Linux; setting the path explicitly keeps it the same on both.
set -gx SOPS_AGE_KEY_FILE ~/.config/sops/age/keys.txt
