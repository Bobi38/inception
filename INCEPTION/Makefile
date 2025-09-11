all:	secrets compose

compose: 
	docker-compose -f srcs/docker-compose.yml up --build -d

down: 
	docker-compose -f srcs/docker-compose.yml down

prune: 
	docker system prune -af --volumes

volumes:
	docker volume rm $$(docker volume ls -q)

rmi:
	docker container rm -f $$(docker ps -aq) 2>/dev/null || true
	docker rmi -f $$(docker images -q) 2>/dev/null || true

clean:	down
	$(MAKE) prune
	$(MAKE) rmi
	$(MAKE) volumes

secrets:
	@mkdir -p secrets
	openssl rand -hex 6 > secrets/mysql_root_password
	openssl rand -hex 6 > secrets/wordpress_db_password
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout secrets/nginx.key -out secrets/nginx.crt -subj "/CN=tvoisin.42.fr"

fclean: clean
	docker volume prune -f
	docker network prune -f
	rm -r secrets

re: fclean all

.PHONY: all compose down prune rmi volumes clean secrets fclean re