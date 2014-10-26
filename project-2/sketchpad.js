$(document).ready(function() {
	var dimension = 16;

	function setSize() {
		return Math.floor(960/dimension);
	};

	function drawGrid(dimension) {
		var numDivs = [];

		for (var i = 0 ; i < dimension * dimension ; i++) {
			numDivs[i] = "<div class='square' style='width:" + setSize() + "px; height:" + setSize() +"px;'></div>";
		};

		$('#container').append(numDivs.join(''));

		$('.square').mouseenter(function() {
			$(this).css('background-color', "black");
		});

		sketch();

	};

	drawGrid(dimension);

	function sketch() {

		function getRandomColor() {
    		var letters = '0123456789ABCDEF'.split('');
    		var color = '#';
    		for (var i = 0; i < 6; i++ ) {
        		color += letters[Math.floor(Math.random() * 16)];
    		}
    		return color;
		};

		$('button').click(function() {
			var buttonValue = parseInt($(this).attr("value"),10);

			$('.square').mouseenter(function() {
				switch (buttonValue) {
					case 1:
						$(this).css('background-color', "black");
						break;
					case 2:
						$(this).css('background-color', getRandomColor());
						break;
					case 3:
						$(this).css('background-color', "white");
						$('#container').css('background-color', "black");
						var op = $(this).css('opacity');
						$(this).css('opacity', (op === 0)? op : op - 0.1);
						break;
					case 4:
						$(this).animate({left: "+=50"}, 400); // This is not working and I don't know why
						break;
				};
			});

			$('.square').mouseleave(function() {
				switch (buttonValue) {
					case 4:
						$(this).animate({left: "-=50"}, 400); // This is not working and I don't know why
						break;
					};
				});
		});
		
	};

	$('#new').click(function() {
		dimension = parseInt(document.getElementById("size").value, 10);
		$('#container').html('');
		drawGrid(dimension);
	});

	$('#clear').click(function() {
		$('#container').html('');
		drawGrid(dimension);
	});

	function clear() {
		$('.square').css('background-color', "white");
	};


});