use inc::Module::Install;
name 'MojoX-Doorman';
all_from 'lib/MojoX/Doorman.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
