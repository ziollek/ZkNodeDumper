#!/usr/bin/perl -w
use ZkUtils::ZkNodeDumper;
use Getopt::Long;
use Term::ANSIColor;

my $configFile = 'config.cfg';
my $nodePath   = '/services/technical_break';

GetOptions ("config=s" => \$configFile,  "node=s" => \$nodePath);

print colored("Running with options:\n\t-config=$configFile\n\t-node=$nodePath\n", 'green');


my $config = ZkUtils::ConfigurationLoader->loadConfiguration($configFile);
my $dumper = new ZkUtils::ZkNodeDumper($config);

$dumper->dumpNode($nodePath);