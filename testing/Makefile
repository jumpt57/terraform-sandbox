TF_WORKSPACE=dev

install:
	(cd tests && go mod tidy)

test:
	(cd tests && go test -v -timeout 10m)

plan:
	(cd app && terraform plan)

apply:
	(cd app && terraform apply)