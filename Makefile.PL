use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'		=> 'ZkUtils::ZkNodeDumper',
	'VERSION'	=> '0.1',
	'PREREQ_PM'	=> {
		'Net::ZooKeeper' => 0.35,
		'Config::Tiny'   => 2.19
	}
);
