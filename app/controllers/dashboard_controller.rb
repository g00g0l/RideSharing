class DashboardController < ApplicationController
  def index
  
    @a2b_distance = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Distance from point A to B")
      f.xAxis(categories: get_from)
      f.series(name: "Distance in Kilometers", yAxis: 0, data: Ride.pluck(:distance))

      f.yAxis [
        {title: {text: "Distance in Kilometers", margin: 30} },
      ]

      f.chart({defaultSeriesType: "line"})
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 2,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
    
  end
  
  def get_from
    from = []
    Ride.find_each do |data|
      from.push("#{data['from']} to #{data['to']}")
    end
    return from
  end

end
