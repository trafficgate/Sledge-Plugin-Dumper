use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'Sledge::Plugin::Dumper',
    'VERSION_FROM' => 'lib/Sledge/Plugin/Dumper.pm', # finds $VERSION
    'PREREQ_PM' => {
	Test::More => 0.32,
    },
);
