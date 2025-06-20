DATA_DIR := /home/kbaridon/data
MDB_DIR  := $(DATA_DIR)/mariadb
WP_DIR   := $(DATA_DIR)/wordpress

SUDO     := $(shell [ $$(id -u) -ne 0 ] && echo sudo)
COMPOSE  := docker compose -f srcs/docker-compose.yml
DOMAIN   := $(shell grep -E '^DOMAIN_NAME=' srcs/.env | cut -d= -f2)

all: add-host $(MDB_DIR) $(WP_DIR)
	@echo "> Build & up"
	@$(COMPOSE) up -d --build

add-host:
	@grep -q "$(DOMAIN)" /etc/hosts || \
	{ echo "127.0.0.1 $(DOMAIN)" | $(SUDO) tee -a /etc/hosts > /dev/null; }

$(MDB_DIR) $(WP_DIR):
	@$(SUDO) mkdir -p $@

clean:
	@echo "> Arrêt des conteneurs + suppression réseaux orphelins (images et volumes conservés)…"
	@$(COMPOSE) down --remove-orphans

fclean: clean
	@echo "> Suppression images, volumes et dossiers data…"
	@docker system prune -a -f
	@$(SUDO) rm -rf $(MDB_DIR) $(WP_DIR)

re: fclean all

.PHONY: all clean fclean re add-host
