#!/usr/bin/perl
####################################################
# Go2Group - Trigger to PUSH changes to ConnectAll #
####################################################
use URI::Escape;
use Env;

my $commitFrom=$ENV{'GITHUB_EVENT_BEFORE'};
my $commitTo=$ENV{'GITHUB_EVENT_AFTER'};

print "git commit before=$commitFrom\n";
print "git commit after=$commitTo\n";

