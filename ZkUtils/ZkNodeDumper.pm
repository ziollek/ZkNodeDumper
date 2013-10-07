package ZkUtils::ZkNodeDumper;

use strict;
use Net::ZooKeeper qw(:errors);
use Term::ANSIColor;

sub new($$)
{
	my ($this, $configuration) = @_;
	my $class = ref($this) || $this;

	Net::ZooKeeper::set_deterministic_conn_order(1);
	my $connection = Net::ZooKeeper->new(join(',', @{$configuration->getHosts()}));

	unless ($connection)
	{
		die colored("Cannot connect to ZooKeeper\n", "red");
	}

	my $self = {
		_connection => $connection
	};
	bless $self, $class;

	return $self;
}

sub dumpNode($$)
{
	my ($self, $path) = @_;

	my $dumpedNode = $self->{_connection}->get($path);
	$self->verifyResponse($path);

	print colored("Content of node $path:\n", 'yellow');

	print $dumpedNode;
	print "\n";
}

sub verifyResponse($$)
{
	my ($self, $path) = @_;
	my $code = $self->{_connection}->get_error();

	if ($code != Net::ZooKeeper::ZOK)
	{
		die colored("ZooKeeper returned " . $self->{_connection}->get_error() . " error code when accessing $path\n", "red");
	}
}

package ZkUtils::Configuration;

sub new($$)
{
	my ($this, @hosts) = @_;
	my $class = ref($this) || $this;
	my $self = {
		hosts => @hosts
	};

	bless $self, $class;
	return $self;
}

sub getHosts($)
{
	my ($self) = @_;
	return $self->{hosts};
}

package ZkUtils::ConfigurationLoader;

use Term::ANSIColor;
use Config::Tiny;

sub loadConfiguration($$)
{
	my ($class, $path) = @_;

	my $config = Config::Tiny->read($path);
	return new ZkUtils::Configuration($class->getHosts($config));
}

sub getPort($$)
{
	my ($class, $config) = @_;

	unless (exists $config->{default}->{port}) {
		die colored("Cannot parse configuration file [missing port]\n", "red");
	}

	if (!($config->{default}->{port} =~ /\s*([0-9]+)\s*/))
	{
		die colored("Cannot parse configuration file [missing port]\n", "red");
	}

	return $config->{default}->{port};
}

sub getHosts($$)
{
	my ($class, $config) = @_;

	unless (exists $config->{default}) {
		die colored("Cannot parse configuration file [missing default section]\n", "red");
	}

	unless (exists $config->{default}->{hosts}) {
		die colored("Cannot parse configuration file [missing hosts]\n", "red");
	}

	my $port = $class->getPort($config);

	my @hosts;
	my $host;
	for $host (split /[\s]*,[\s]*/, $config->{default}->{hosts})
	{
		$host =~ s/^\s+//;
		$host =~ s/\s+$//;
		push @hosts, "$host:$port";
	}

	return \@hosts;
}

1;
