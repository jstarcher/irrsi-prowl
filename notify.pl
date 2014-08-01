## 1) Replace <YOUR API KEY> with an API key generated at https://www.prowlapp.com/api_settings.php
## 2) Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load notify
##
## Copyright (C) 2014 Luke Macken, Paul W. Frields
##
## Modifications by Jordan Starcher
##

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use LWP::UserAgent;
use HTML::Entities;


$VERSION = "0.0.1";
%IRSSI = (
    authors     => 'Jordan Starcher',
    contact     => 'jstarcher@gmail.com',
    name        => 'notify.pl',
    description => 'Use Prowl to alert user to highlighted messages',
    license     => 'BSD License',
    url         => 'https://github.com/jstarcher/irrsi-prowl',
);

sub atoi {
    my $t;
    foreach my $d (split(//, shift())) {
  $t = $t * 10 + $d;
    }
}

sub notify {
    my ($server, $summary, $message) = @_;

    # Make the message entity-safe.
    encode_entities($message);

    $options{'apikey'} = '<YOUR API KEY>';

    # Generate our HTTP request.
    my ($userAgent, $request, $response, $requestURL);
    $userAgent = LWP::UserAgent->new;
    $userAgent->agent("ProwlScript/1.2");
    $userAgent->env_proxy();
    $requestURL = sprintf("https://prowlapp.com/publicapi/add?apikey=%s&application=%s&event=%s&description=%s&priority=%d",
            $options{'apikey'},
            'irssi',
            'summary',
            $message,
            0);
    
    $request = HTTP::Request->new(GET => $requestURL);
    
    $response = $userAgent->request($request);
    
    if ($response->is_success) {
      print "Notification successfully posted.\n";
    } elsif ($response->code == 401) {
      print STDERR "Notification not posted: incorrect API key.\n";
    } else {
      print STDERR "Notification not posted: " . $response->content . "\n";
    }
}
 
sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    notify($server, $dest->{target}, $stripped);

}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;

    return if (!$server);
    notify($server, "Private message from ".$nick, $msg);
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$server || !$dcc);
    notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick});
}

Irssi::signal_add('print text', 'print_text_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');
print "Prowl notification plugin loaded.";
