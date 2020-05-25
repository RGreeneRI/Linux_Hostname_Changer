# Ubuntu Hostname Changer
A script to automate the hostname changing process.

<PRE>
<B>Usage:</B><BR>
<B>Change Hostname:</B>            chhostname.sh [NEW_HOSTNAME]<BR>
<B>Help:</B>                       chhostname.sh -h<BR>
<B>List config file contents:</B>  chhostname.sh -l<BR>
<B>Manually edit config files:</B> chhostname.sh -m<BR>
</PRE>

If you are using interactively and something doesnt look right, choose [N] to not make changes.  If you have run the script and not rebooted, re-running will not properly detect domain name.  If all else fails, run in manual mode.

Each time a change is made, backup files are created in /etc.
