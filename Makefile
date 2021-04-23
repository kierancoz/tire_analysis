.PHONY: requirements update_data plot process_tire_data

ifeq ($(shell uname -p), unknown) # windows
    PYTHON := python
    OS = windows
	PIP := pip
else # linux
    PYTHON := python3
    OS = linux
	PIP := pip3
endif

requirements:
	$(PIP) install -r requirements.txt

# updates tire data from repo
get_data:
	git submodule init
	git submodule update

# opens target jupyter notebook
plot:
	jupyter notebook rear_cornering_analysis.ipynb

process_tire_data:
	$(PYTHON) data_processing.py

clean:
	rm -r -f __pycache__/
	rm -r -f .ipynb_checkpoints/
	rm -r -f *.asv