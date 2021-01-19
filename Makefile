
requirements:
	pip install -r requirements.txt
.PHONY : requirements

plot:
	jupyter notebook rear_cornering_analysis.ipynb
.PHONY : plot
