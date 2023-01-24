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
	@docker compose run --rm terraform-ansible terraform init

apply:
	@docker compose run --rm terraform-ansible generar_clave.sh
	@docker compose run --rm terraform-ansible terraform apply -auto-approve
	@docker compose run --rm terraform-ansible /bin/sh -c "echo 'Esperando 10 segundos a que la máquina termine de arrancar...' && sleep 10"
	@docker compose run --rm terraform-ansible comprobar_conexion.sh
	@docker compose run --rm terraform-ansible leer_claves.sh
	@docker compose run --rm terraform-ansible ansible-playbook -i remote_host_ip playbook.yml --extra-vars "UBUNTU_RELEASE=${UBUNTU_RELEASE}"

show:
	@docker compose run --rm terraform-ansible terraform show

destroy:
	@docker compose run --rm terraform-ansible terraform destroy -auto-approve

workspace:
	@docker compose run --rm terraform-ansible /bin/sh

clean:
	@docker compose down -v --remove-orphans
