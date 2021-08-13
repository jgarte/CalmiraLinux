function customTag(tagName,fn){
	document.createElement(tagName);
	//find all the tags occurrences (instances) in the document
	var tagInstances = document.getElementsByTagName(tagName);
	// for each occurrence run the associated function
	for ( var i = 0; i < tagInstances.length; i++) {
		fn(tagInstances[i]);
	}
}

function table(element){
   //add the canvas where to draw the piechart
    var canvas = document.createElement("canvas"); 
    //get the width and height from the custom tag attributes
    canvas.width = element.attributes.width.value;
    canvas.height = element.attributes.height.value;
    element.appendChild(canvas);
     
    //get the colors for the slices from the custom tag attribute
    var colors = element.attributes.colors.value.split(",");
     
    //load the chart data from the <codingdude-data> sub-tags
    var chartData = {};
    var chartDataElements = element.querySelectorAll("codingdude-data");
    for (var i=0;i<chartDataElements.length;i++){
        chartData[chartDataElements[i].attributes.category.value] = parseFloat(chartDataElements[i].textContent);
        //remove the data sub-tags
        chartDataElements[i].parentNode.removeChild(chartDataElements[i]);
    }
   
    //call the draw() function
    new Piechart(
        {
        canvas:canvas,
        data:chartData,
        colors:colors
        }
    ).draw();
}


customTag("code-table",table);
