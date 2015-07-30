
Parse.Cloud.define("featured", function(request, response) {
//   console.log("Inside featured");
  
  var query = new Parse.Query("Brewery");
//   query.near("location", request.params.loc);
  query.withinMiles("location", request.params.loc, 50);
  query.limit(10);
  query.include("rating");
  
  query.find({
	  success: function(results) {
		  console.log("inside find");
		  console.log(results.length);
		  
		  var breweries = [];
		  for (var i = 0; i < results.length; i++) {
/*
			  console.log("Breweries");
			  console.log(results[i]);
			  console.log("Ratings: " + results[i].get("rating").length);
			  console.log(results[i].get("rating"));
*/
			  var ratings = [];
			  for(var j = 0; j < results[i].get("rating").length; j++) {
/*
				  console.log("Ratings Push");
				  console.log(results[i].get("rating")[j].get("rating"));
*/
				  ratings.push(results[i].get("rating")[j].get("rating"));
			  }
			  var avg = 0;
			  for (var k = 0; k < ratings.length; k++) {
				  avg += ratings[k];
			  }
			  avg = avg / ratings.length;
			  if (avg >= 4) {
				  breweries.push(results[i].get("breweryId"));
			  }
			  
		  }
		  console.log("**********");
		  console.log(breweries);
		  console.log(breweries.length);
		  console.log("**********");
		  
		  
		  
		  response.success(breweries);
		  
	  },
	  error: function() {
		  response.error("No breweriers in your area have been reviewed.");
	  }
	 
  });
  
});
