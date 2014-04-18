
ZIPNAME=osg-chrome-app.zip
ZIP=zip -r $(ZIPNAME)
#coffeefiles := coffee/settings.coffee coffee/graph.coffee coffee/graphContainerCtrl.coffee coffee/graphService.coffee 
coffeefiles = $(wildcard coffee/*.coffee)
compiledcoffee := $(coffeefiles:coffee/%.coffee=js/%.js)



all: package

clean:
	rm -f $(ZIPNAME)

$(copiledcoffee): $(coffeefiles)
	coffee -o js $< 

js/%.js: coffee/%.coffee
	coffee -o js $<

#js/%.js: coffee/%.coffee
#	coffee -o js $< 



	
package: $(ZIPNAME)

$(ZIPNAME): $(compiledcoffee) js/* html/* manifest.json fonts/* css/* data/* main.html osglogo.16.png PromotionalIcon128x128.png
	$(ZIP) $^

