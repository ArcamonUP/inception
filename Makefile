DATA_DIR := /home/kbaridon/data
MDB_DIR  := $(DATA_DIR)/mariadb
WP_DIR   := $(DATA_DIR)/wordpress

SUDO    := $(shell [ $$(id -u) -ne 0 ] && echo sudo)
COMPOSE := $(SUDO) docker compose -f srcs/docker-compose.yml

all: $(MDB_DIR) $(WP_DIR)
	@echo "> Build & up"
	@$(COMPOSE) up -d --build

$(MDB_DIR) $(WP_DIR):
	@$(SUDO) mkdir -p $@

clean:
	@echo "> Arrêt des conteneurs + suppression réseaux orphelins (images et volumes conservés)…"
	@$(SUDO) docker compose -f srcs/docker-compose.yml down --remove-orphans

fclean: clean
	@echo "> Suppression images, volumes et dossiers data…"
	@$(SUDO) docker system prune -a -f
	@$(SUDO) rm -rf $(MDB_DIR) $(WP_DIR)

re: fclean all

.PHONY: all clean fclean re
