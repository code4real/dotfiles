#!/bin/bash -x

# This script creates a user account under Mac OS X
# (tested with 10.5 and 10.6; likely works with 10.4 but not earlier)
# Written by Clinton Blackmore, based on work at
# http://serverfault.com/questions/20702

# === Typically, this is all you need to edit ===

USERNAME=cody
FULLNAME="Cody"
PASSWORD="hard_to_hack"

# A list of (secondary) groups the user should belong to
# This makes the difference between admin and non-admin users.
# Leave only one uncommented
#SECONDARY_GROUPS=""  # for a non-admin user
SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr" # for an admin user

# ====

if [[ $UID -ne 0 ]]; then echo "Please run $0 as root." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

# Create the user account
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/zsh
dscl . -create /Users/$USERNAME RealName "$FULLNAME"
dscl . -create /Users/$USERNAME UniqueID "$USERID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

dscl . -passwd /Users/$USERNAME $PASSWORD


# Add use to any specified groups
for GROUP in $SECONDARY_GROUPS ; do
    dseditgroup -o edit -t user -a $USERNAME $GROUP
done

# Create the home directory
createhomedir -c > /dev/null

echo "Created user #$USERID: $USERNAME ($FULLNAME)"
