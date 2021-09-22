.PHONY: requirements update_data plot process_tire_data matlab_fit

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

# converts raw matlab data into processed data for fitting & other usage
process_tire_data:
	$(PYTHON) data_processing.py

matlab_fit:
	cd pacejka_fitting
	matlab -batch "fitting_cornering_2021_rear()"
	cd ..

clean:
	rm -r -f __pycache__/
	rm -r -f .ipynb_checkpoints/
	rm -r -f *.asv