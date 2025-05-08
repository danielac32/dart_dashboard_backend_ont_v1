

#export LD_LIBRARY_PATH=$(pwd)/lib/objectbox:$LD_LIBRARY_PAT
delete:
	rm -rf objectbox-db
migrate:
	dart run build_runner build
run:
	dart run