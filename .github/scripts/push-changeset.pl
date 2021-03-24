#!/usr/bin/perl
####################################################
# Go2Group - Trigger to PUSH changes to ConnectAll #
####################################################
use URI::Escape;
use Env;
my $CURL = "curl";
my $CURLOPTS = "-k -X POST";



my $applink = $ENV{'CONNECTALL_APPLINK_NAME'};
my $project=$ENV{'CONNECTALL_PROJECT_KEY'};
my $commitFrom=$ENV{'GITHUB_EVENT_BEFORE'};
my $commitTo=$ENV{'GITHUB_EVENT_AFTER'};
my $url=$ENV{'CONNECTALL_BASE_URL'};
my $userName=$ENV{'CONNECTALL_USER'};
my $password=$ENV{'CONNECTALL_PASSWORD'};

my $HOST = "$url/SyncService/post";
my $BASICAUTH = "-u $userName:$password";

print "ConnectALL URL=$HOST\n";

my $commit_info = "";
#foreach $line ( <STDIN> ) {
    #chomp( $line );
    #my $commit_info = $commit_info + ";" + $line;
#}

# use this to grab the commit info
print "git commit before=$commitFrom\n";
print "git commit after=$commitTo\n";

my $commit_info = `git rev-parse $commitFrom`;
my $message = `git log $commitFrom...$commitTo  --stat --no-merges`;
my $destField = "ChangeList";

print "git commit info=$commit_info\n";

# Checkin sets the CLEARCASE_ACTIVITY environment variable for UCM checkins
my $HEADER = qq(-H "Accept: application/json" -H "Content-Type: application/json");
my $storeInComment="yes";  # set to "only" if writing the changelist to a custom field

my $id = "Header=$storeInComment|Project=$project|Repo=$repo|Commit=$commit_info$message";

#print $checkin_ref + "\n";
my $DATA = qq(\\\"appLinkName\\\": \\\"$applink\\\", \\\"origin\\\": \\\"source\\\", \\\"id\\\":\\\"$id\\\",\\\"$destField\\\":\\\"$message\\\");
my $status=system("$CURL $CURLOPTS $HEADER -d \"{$DATA}\" $BASICAUTH $HOST" );
print "\nStatus=$status\n";
