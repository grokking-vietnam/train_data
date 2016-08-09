all: clean schema

prepare:
	@echo "prepare things on the box"
	sudo apt-get install graphviz

run: create.sql
	psql -h localhost -p 5432 -U grokking -d grokking -f create.sql

clean:
	rm -rf visual/*

schema:
	java -jar schemaSpy_5.0.0.jar -dp postgresql-9.4.1208.jre6.jar -hq -t pgsql -host localhost -port 5432 -u grokking -db grokking -p password -s public -o visual

