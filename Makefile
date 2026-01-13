.PHONY: model-shell vis-container docbuilder 

model-shell:
	docker run -it --pull always --rm -v $(shell pwd):/home/modex_user -v inputdata:/mnt/inputdata -v output:/mnt/output yuanfornl/ngee-arctic-modex26:models-main-latest /bin/bash

vis-container:
	docker run -it --pull always --rm -p 8888:8888 -v $(shell pwd):/home/jovyan -v inputdata:/mnt/inputdata -v output:/mnt/output yuanfornl/ngee-arctic-modex26:vis-main-latest
	
docbuilder:
	docker run --name docbuilder -p9999:9999 --mount type=bind,src=$(pwd)/docs,dst=/docs -it --rm docbuilder make livehtml
