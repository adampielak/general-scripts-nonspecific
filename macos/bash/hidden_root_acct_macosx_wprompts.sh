#Create hidden macOS root account and hide it from GUI and Login
#!/bin/sh

echo "Please Enter the Username you want to create."
read USERNAME
echo "Please Type in the password" ; stty -echo
read PASSWORD; stty echo; echo

# Check to see if xcode tools is installed, and install it if it is not
command -v make >/dev/null 2>&1 || { echo >&2 "Installing XCode Tools Now"; \
xcode-select --install; }

sudo dscl . create /Users/$USERNAME
sudo dscl . create /Users/$USERNAME PrimaryGroupID 80
sudo dscl . create /Users/$USERNAME NFSHomeDirectory /private/var/$USERNAME
sudo dscl . create /Users/$USERNAME UniqueID 499
sudo dscl . create /Users/$USERNAME UserShell /bin/bash
sudo dscl . passwd /Users/$USERNAME $PASSWORD
sudo dscl . append /Groups/admin GroupMembership $USERNAME
sudo defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool TRUE
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array $USERNAME
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
sudo createhomedir -c -u $USERNAME
sudo SetFile -a V /private/var/$USERNAME

#Clear USERNAME & PASSWORD
USERNAME=
PASSWORD=

echo "All set, don't forget to set login options for typing username and password."