#!make

ifneq (,$(wildcard ./.env))
    include .env
    export
else
$(error No se encuentra el fichero .env)
endif

help: _header
	${info }
	@echo Opciones:
	@echo ------------------------------------------
	@echo build
	@echo init / apply / show / destroy
	@echo workspace
	@echo clean
	@echo ------------------------------------------

_header:
	@echo --------------------------------
	@echo Terraform + Ansible + OpenNebula
	@echo --------------------------------

build:
	@docker compose build

init:
	@docker compose run --rm terraform init

apply:
	@docker compose run --rm ansible generar_clave.sh
	@docker compose run --rm terraform apply -auto-approve
	@docker compose run --rm ansible /bin/sh -c "echo 'Esperando 10 segundos a que la máquina termine de arrancar...' && sleep 10"
	@docker compose run --rm ansible comprobar_conexion.sh
	@docker compose run --rm ansible leer_claves.sh
	@docker compose run --rm ansible ansible-playbook -i remote_host_ip playbook.yml --extra-vars "UBUNTU_RELEASE=${UBUNTU_RELEASE}"

show:
	@docker compose run --rm terraform show

destroy:
	@docker compose run --rm terraform destroy -auto-approve

workspace:
	@docker compose run --rm ansible /bin/sh

clean:
	@docker compose down -v --remove-orphans
