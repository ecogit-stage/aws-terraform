show: init
	cd $(BUILD); $(TF_SHOW)

show_state: init
	cat $(BUILD)/terraform.tfstate

graph: init
	cd $(BUILD); $(TF_GRAPH)

refresh: init
	cd $(BUILD); $(TF_REFRESH)

init: | $(TF_PORVIDER) $(AMI_VARS)

$(BUILD): init_build_dir

$(TF_PORVIDER): update_provider

$(AMI_VARS): update_ami

init_build_dir:
	mkdir -p $(BUILD)
	cp -rf $(RESOURCES)/cloud-config $(BUILD)
	cp -rf $(RESOURCES)/certs $(BUILD)
	cp -rf $(RESOURCES)/policies $(BUILD)
	$(SCRIPTS)/substitute-AWS-ACCOUNT.sh $(POLICIES)/*.json

update_ami:	| $(BUILD)
	# Generate default AMI ids
	$(SCRIPTS)/get-ami.sh > $(AMI_VARS)

update_provider: | $(BUILD)
	# Generate tf provider
	$(SCRIPTS)/gen-provider.sh > $(TF_PORVIDER)
	

.PHONY: init show show_state graph refresh update_ami update_provider init_build_dir
