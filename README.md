irrsi-prowl
===========

Prowl notification script for irssi.

Sends notifications to your iOS device via Prowl on direct messages and highlights with chat room. Great for if your ssh to a remote server for your irrsi client but still want notifications and don't want to deal with ssh tunnels for notifications on OSX.

Installation
------------
1) Replace <YOUR API KEY> in notify.pl with an API key generated at https://www.prowlapp.com/api_settings.php
2) Install dependencies:

        [Ubuntu] sudo apt-get install libwww-perl
        cpan install Mozilla::CA

3) Put notify.pl in ~/.irssi/scripts, and then execute the following in irssi:

       /load perl
       /script load notify
