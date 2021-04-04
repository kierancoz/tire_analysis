
requirements:
	pip install -r requirements.txt
	git clone git@github.com:kierancoz/tire_data.git
.PHONY : requirements

# updates tire data from repo
update_data:
	cd tire_data
	git pull
.PHONY : update_data

# opens target jupyter notebook
plot:
	jupyter notebook rear_cornering_analysis.ipynb
.PHONY : plot

clean:
	rm -r -f __pycache__/
	rm -r -f .ipynb_checkpoints/
	rm -r -f *.asv