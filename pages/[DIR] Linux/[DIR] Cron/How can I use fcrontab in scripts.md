# How can I use fcrontab in scripts
You can use pipes with `fcrontab -l` (list the fcrontab) and `fcrontab -` (read the new fcrontab from input). For
example:

    echo -e "`fcrontab -l | grep -v exim`\n0 * * * *   /usr/sbin/exim -q" | fcrontab -
    
can be used to add a line.

Another way to do it would be to: list the fcrontab settings into a temporary file

    fcrontab -l > tmpfile

modify the temporary file:

    echo $LINE >> tmpfile

replace the original fcrontab by the temporary, and finally, remove the temporary file:

    fcrontab tmpfile ; rm -f tmpfile
