# Linux_Hostname_Changer
A script to automate the hostname changing process.

<B>For interactive use:</B>\n
chhostname.sh [NEW_HOSTNAME]

<B>For manual use:</B>\n
chhostname.sh -m

If you are using interactively and something doesnt look right, choose [N] to not make changes.  If you have run the script and not rebooted, re-running will not properly detect domain name.  If all else fails, run in manual mode.

Each time a change is made, backup files are created in /etc.
