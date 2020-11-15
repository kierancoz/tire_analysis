
requirements:
	pip install -r requirements.txt
.PHONY : requirements

plot:
	python plot_data.py
.PHONY : plot

plot2:
	python3 plot_data.py
.PHONY : plot
