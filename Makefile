

#export LD_LIBRARY_PATH=$(pwd)/lib/objectbox:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=$(pwd)/lib/oracle/instantclient_23_5:$LD_LIBRARY_PATH
delete:
	#rm -rf objectbox-db
	dart bin/dart_dashboard_backend_ont_v1.dart --reset-db
seed:
	dart bin/dart_dashboard_backend_ont_v1.dart --seed
migrate:
	# dart pub run build_runner build --delete-conflicting-outputs
	dart run build_runner build
run:
	#dart run
	dart bin/dart_dashboard_backend_ont_v1.dart --env=development --port=8085
help:
	dart bin/dart_dashboard_backend_ont_v1.dart --help
compile:
	dart compile exe bin/dart_dashboard_backend_ont_v1.dart -o backend