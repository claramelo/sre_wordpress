TERRAFORM_VERSION= 1.2.9

DOCKER_COMMAND=\
	AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>\
	AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>\
	TERRAFORM_VERSION=${TERRAFORM_VERSION}\
	docker-compose run sre_terraform
	
bash:
	 @${DOCKER_COMMAND} \
	 	bash -c "ls -la"
	
init:
	 @${DOCKER_COMMAND} \
	 	bash -c "tfenv use ${TERRAFORM_VERSION} && \
		 terraform -chdir=terraform/ init"

plan:
	 @${DOCKER_COMMAND} \
	 	bash -c "tfenv use ${TERRAFORM_VERSION} && \
		 terraform -chdir=terraform/ plan"

apply:
	 @${DOCKER_COMMAND} \
	 	bash -c "tfenv use ${TERRAFORM_VERSION} && \
		 terraform -chdir=terraform/ apply -auto-approve"

apply-auto-scaling:
	 @${DOCKER_COMMAND} \
	 	bash -c "tfenv use ${TERRAFORM_VERSION} && \
		 terraform -chdir=terraform/ apply -auto-approve -var='create_autoscaling=true'"

destroy:
	 @${DOCKER_COMMAND} \
	 	bash -c "tfenv use ${TERRAFORM_VERSION} && \
		 terraform -chdir=terraform/ destroy"

run-playbook:
		@${DOCKER_COMMAND} \
	 	bash -c " cd ansible && \
		ansible-playbook -u ubuntu --private-key /app/ssh/wordpress.pem -i hosts playbook.yml"

up_wordpress: init apply run-playbook apply-auto-scaling
