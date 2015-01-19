nv.addGraph(function() {
    var chart = nv.models.lineChart()
            .options({
              margin: {left: 100},            //Adjust chart margins to give the x-axis some breathing room.
              transitionDuration: 500,        //how fast do you want the lines to transition?
              useInteractiveGuideline: true,  //We want nice looking tooltips and a guideline!
              showLegend: true,               //Show the legend, allowing users to turn on/off line series.
              showYAxis: true,                //Show the y-axis
              showXAxis: true                 //Show the x-axis
            })
    ;

    chart.xAxis
        .axisLabel("Seen at")
        .tickFormat(function(d) {
          return d3.time.format('%a %b %e %Y %H:%M')(new Date(d))
        })
        ;

    chart.yAxis
        .axisLabel("Price")
        .tickFormat(function(d) { return '€' + d3.format(',.2f')(d) });
        ;

    d3.select('#chart').append('svg')
        .datum(data)
        .transition().duration(500)
        .call(chart)
        ;

    nv.utils.windowResize(chart.update);

    return chart;
});
