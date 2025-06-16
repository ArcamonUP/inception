DATA_DIR := /home/kbaridon/data
MDB_DIR  := $(DATA_DIR)/mariadb
WP_DIR   := $(DATA_DIR)/wordpress

SUDO    := $(shell [ $$(id -u) -ne 0 ] && echo sudo)
DOCKER  := $(SUDO) docker
COMPOSE := $(DOCKER) compose -f srcs/docker-compose.yml

HOSTS_ENTRY := "127.0.0.1 kbaridon.42.fr"

all: hosts $(MDB_DIR) $(WP_DIR)
	@echo "> Build & up"
	@$(COMPOSE) up -d --build

hosts:
	@if ! grep -q $(HOSTS_ENTRY) /etc/hosts ; then \
		echo $(HOSTS_ENTRY) | $(SUDO) tee -a /etc/hosts > /dev/null; \
	fi

$(MDB_DIR) $(WP_DIR):
	@$(SUDO) mkdir -p $@

clean:
	@echo "> Arrêt des conteneurs + suppression réseaux orphelins (images et volumes conservés)…"
	@$(COMPOSE) down --remove-orphans

fclean: clean
	@echo "> Suppression images, volumes et dossiers data…"
	@$(COMPOSE) down --rmi local --volumes --remove-orphans
	@$(SUDO) rm -rf $(MDB_DIR) $(WP_DIR)

re: fclean all

.PHONY: all clean fclean re hosts
