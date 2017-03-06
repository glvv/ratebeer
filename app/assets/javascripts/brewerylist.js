var BREWERIES = {};

BREWERIES.show = function(){
    $("#brewerytable tr:gt(0)").remove();
    var table = $("#brewerytable");

    $.each(BREWERIES.list, function (index, brewery) {
        var active_as_string;
        if (brewery.active) {
            active_as_string = 'Active';
        } else {
            active_as_string = 'Retired';
        }
        table.append('<tr>'
                        +'<td>'+brewery['name']+'</td>'
                        +'<td>'+brewery['year']+'</td>'
                        +'<td>'+brewery['beers'].length+'</td>'
                        +'<td>'+ active_as_string +'</td>'
                    +'</tr>');
    });
};

BREWERIES.sort_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sort_by_year = function(){
    BREWERIES.list.sort( function(a,b){
        return a.year - b.year;
    });
};

BREWERIES.sort_by_number_of_beers = function(){
    BREWERIES.list.sort( function(a,b){
        return b.beers.length - a.beers.length;
    });
};

BREWERIES.reverse = function(){
    BREWERIES.list.reverse();
};

$(document).ready(function () {
    if ( $("#brewerytable").length>0 ) {

      $("#name").click(function (e) {
          BREWERIES.sort_by_name();
          BREWERIES.show();
          e.preventDefault();
      });

      $("#year").click(function (e) {
          BREWERIES.sort_by_year();
          BREWERIES.show();
          e.preventDefault();
      });

      $("#number_of_beers").click(function (e) {
          BREWERIES.sort_by_number_of_beers();
          BREWERIES.show();
          e.preventDefault();
      });

      $.getJSON('breweries.json', function (breweries) {
        BREWERIES.list = breweries;
        BREWERIES.sort_by_name;
        BREWERIES.show();
      });

    }
});
