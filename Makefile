
requirements:
	pip install -r requirements.txt
.PHONY : requirements

# updates tire data from repo
update_data:
	git submodule init
	git submodule update
.PHONY : update_data

# opens target jupyter notebook
plot:
	jupyter notebook rear_cornering_analysis.ipynb
.PHONY : plot

clean:
	rm -r -f __pycache__/
	rm -r -f .ipynb_checkpoints/
	rm -r -f *.asv