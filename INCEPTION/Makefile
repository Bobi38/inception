all:	secrets compose

compose: 
	docker-compose -f srcs/docker-compose.yml up --build -d

down: 
	docker-compose -f srcs/docker-compose.yml down

prune: 
	docker system prune

rmi: 
	docker rmi $$(docker images -q)

clean:	down
	$(MAKE) prune
	$(MAKE) rmi
	sudo rm -r ./secrets

secrets:
	@mkdir -p $@
	openssl rand -hex 6 > secrets/mysql_root_password
	openssl rand -hex 6 > secrets/wordpress_db_password

fclean: clean
	docker volume prune -f
	docker network prune -f

re: fclean all

.PHONY: all compose down prune rmi clean secrets fclean re