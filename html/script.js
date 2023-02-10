var visable = false;

$(function () {

    function h2d(s) {

        function add(x, y) {
            var c = 0, r = [];
            var x = x.split('').map(Number);
            var y = y.split('').map(Number);
            while(x.length || y.length) {
                var s = (x.pop() || 0) + (y.pop() || 0) + c;
                r.unshift(s < 10 ? s : s - 10); 
                c = s < 10 ? 0 : 1;
            }
            if(c) r.unshift(c);
            return r.join('');
        }
    
        var dec = '0';
        s.split('').forEach(function(chr) {
            var n = parseInt(chr, 16);
            for(var t = 8; t; t >>= 1) {
                dec = add(dec, dec);
                if(n & t) dec = add(dec, '1');
            }
        });
        return dec;
    }    

        function display(bool) {
        if (bool) {
            $("#container").show();
            
        } else {                                
            $.post('http://playerpanel/close', JSON.stringify({}));
            $("#container").hide();      
        }
    }
    
    display(false)
	

    var buttonFunc = [];   
    $.getJSON("config.json", function(data){
        for (i = 0; i < data.items.length; i++) {    
            document.getElementById("idk").innerHTML = document.getElementById("idk").innerHTML + "<div id=\"box\" class=\"box divTableCell2\"><img src=\"" + data.items[i].img + "\" class=\"icon\" alt=\"Icon\"/><p class=\"title\" style=\"\text-align: center;\">" + data.items[i].name + "</p><p class=\"price\" style=\"\text-align: center;\">" + data.items[i].price + " CSP" + "</p></p><br><br><div id=\"buy"+ i + "\"class='buybutton'><div class='line'></div> <div class='line'></div> <div class='line'></div> <div class='line'></div> <div class='line'></div> <div class='line'></div><span>Vásárlás</span></div>";    
        }

        data.items.forEach(items);

        function items(item, i) {
            document.getElementById("buy"+i).addEventListener("click", function(){
                $.post('http://playerpanel/buy', JSON.stringify({
                    price: item.price,
                    func: item.function,
                }));
            });
        }
        
    })
	
		function moneyFormat(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            if (event.data.status == true) {
                info();
				   $.getJSON('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=9945B4E3CA2158D26E1DA395D1C3DEAC&steamids='+h2d(event.data.steam), function(data){
                    document.getElementById("avatar").src = data.response.players[0].avatarfull;
					document.getElementById("name").innerHTML = "&nbsp&nbsp&nbsp&nbsp<b>Üdv,</b> "+data.response.players[0].personaname; // 
                    document.getElementById("nev").innerHTML = "<b>Név :</b> "+event.data.name;
                    document.getElementById("munka").innerHTML = "<b>Munka :</b> "+event.data.munka;
                    document.getElementById("penz").innerHTML = "<b>Készpénz :</b> "+moneyFormat(event.data.penz)+" CS";
                    document.getElementById("bank").innerHTML = "<b>Banki egyenleg :</b> "+moneyFormat(event.data.bank)+" CS";
					document.getElementById("black").innerHTML = "<b>Piszkospénz :</b> "+moneyFormat(event.data.black)+" MCS";
                    document.getElementById("balance").innerHTML = "<b>Prémiumpont :</b> "+moneyFormat(event.data.bal)+" CSP"; 
                    document.getElementById("group").innerHTML = "<b>Jogosultság :</b> "+event.data.group[0].toUpperCase() + event.data.group.slice(1);
                    });             

                display(true)

            } else {
                display(false)
            }
        }
        else if (event.data.type === "balance"){
            document.getElementById("balance").innerHTML = "<b>Prémiumpont:</b> "+event.data.bal; 
        }
        else if (event.data.type === "wait"){
            if (event.data.wait === true){
                $(':button').prop('disabled', true);
            }
            else if (event.data.wait === false) {
                $(':button').prop('disabled', false);
            }
        }
        else if (event.data.type === "admin") {
            
           document.getElementById("owner").innerHTML = "<pre><p class=\"adminText\">Elérhető Tulajdonos</p></pre><pre><p id=\"noowner\">-</p></pre>".fontcolor("white");
           document.getElementById("dev").innerHTML = "<pre><p class=\"adminText\">Elérhető Fejlesztő</p></pre><pre><p id=\"nodev\">-</p></pre>".fontcolor("white");
           document.getElementById("admincon").innerHTML = "<pre><p class=\"adminText\">Elérhető Admin Controller</p></pre><pre><p id=\"noadmincon\">-</p></pre>".fontcolor("white");
           document.getElementById("adminsen").innerHTML = "<pre><p class=\"adminText\">Elérhető Admin Senior</p></pre><pre><p id=\"noadminsen\">-</p></pre>".fontcolor("white");
           document.getElementById("admin").innerHTML = "<pre><p class=\"adminText\">Elérhető Admin</p></pre><pre><p id=\"noadmin\">-</p></pre>".fontcolor("white");
           document.getElementById("adminjun").innerHTML = "<pre><p class=\"adminText\">Elérhető Admin Junior</p></pre><pre><p id=\"noadminjun\">-</p></pre>".fontcolor("white");

            event.data.admins.forEach(admins);
            function admins(admin,i) {
                if (admin.group == "owner" ) {
                    document.getElementById("owner").innerHTML = document.getElementById("owner").innerHTML + "<pre style=\"color:orange;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("noowner").style.display = "none";
                }
                else if (admin.group == "dev") {
                    document.getElementById("dev").innerHTML = document.getElementById("dev").innerHTML + "<pre style=\"color:#8f2487;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("nodev").style.display = "none";
                }
                else if (admin.group == "admincontroller") {
                    document.getElementById("admincon").innerHTML = document.getElementById("admincon").innerHTML + "<pre style=\"color:yellow;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("noadmincon").style.display = "none";
                }
                else if (admin.group == "superadmin") {
                    document.getElementById("adminsen").innerHTML = document.getElementById("adminsen").innerHTML +  "<pre style=\"color:#e40505;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("noadminsen").style.display = "none";
                }
                else if (admin.group == "admin") {
                    document.getElementById("admin").innerHTML = document.getElementById("admin").innerHTML + "<pre style=\"color:LawnGreen;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("noadmin").style.display = "none";
                }
                else if (admin.group == "mod") {
                    document.getElementById("adminjun").innerHTML = document.getElementById("adminjun").innerHTML + "<pre style=\"color:DeepSkyBlue;\"><p>"+admin.name+"</p></pre>";
                    document.getElementById("noadminjun").style.display = "none";
                }
            }
        }
        else if (event.data.type === "kocsi") {
            var carcount = 0;
            document.getElementById("autok").innerHTML = "<pre><p class=\"cartext\" id=\"cartext\"></p></pre><div id=\"carlabel\" class=\"divTable\" \"><div class=\"divTableBody\"><div class=\"divTableRow\"><b><div class=\"divTableCell\">&nbsp;Modell</div> <div class=\"divTableCell\">&nbsp;&nbsp;&nbsp;Rendszám</div><div class=\"divTableCell\">&nbsp;&nbsp;Parkolóban</div><div class=\"divTableCell\">&nbsp;&nbsp;Benzinszint</div></b></div></div></div></p></pre>";
            document.getElementById("autok").innerHTML = document.getElementById("autok").innerHTML + "<div class=\"divTable\" \"><div class=\"divTableBody\">";
            event.data.kocsik.forEach(kocsik);
            function kocsik(kocsilista,i) {
                if(kocsilista.stored == true)
                {
                    document.getElementById("autok").innerHTML = document.getElementById("autok").innerHTML + "<div class=\"divTableRow\"><div class=\"divTableCell\">"+kocsilista.kocsimodel+"</div><div class=\"divTableCell\">"+kocsilista.plate+"</div><div class=\"divTableCell\">"+"Igen"+"</div><div class=\"divTableCell\">"+kocsilista.fuel+"</div></div>";
                    carcount++;
                }
                else
                {
                    document.getElementById("autok").innerHTML = document.getElementById("autok").innerHTML + "<div class=\"divTableRow\"><div class=\"divTableCell\">"+kocsilista.kocsimodel+"</div><div class=\"divTableCell\">"+kocsilista.plate+"</div><div class=\"divTableCell\">"+"Nem"+"</div><div class=\"divTableCell\">"+kocsilista.fuel+"</div></div>";
                    carcount++;
                }
            }
            document.getElementById("cartext").innerHTML = "Járművek ("+carcount+"db)";
            document.getElementById("autok").innerHTML = document.getElementById("autok").innerHTML + "</div></div>";
            
        } 
		else if (event.data.type === "barat") {
				var baratid = 0;
				var baratokszam = 0;
				var baratx = [];
				var szam=0;
				document.getElementById("baratlista").innerHTML = "<table width=\"100%\"><tr><th class=\"divTableCellbarat\"><b>Barátod száma</b></th><th class=\"divTableCellbarat\"><b>Név</b></th><th class=\"divTableCellbarat\"><b>Hozzáadás ideje</b></th><th class=\"divTableCellbarat\"><b>Törlés</b></th></tr></table>";
				event.data.barat.forEach(barat);
				function barat(baratok,i) {
					szam++
				document.getElementById("baratlista").innerHTML += "<td class=\"divTableCellbarat\">"+ szam +"</td><td class=\"divTableCellbarat\">"+baratok.icname+"</td><td class=\"divTableCellbarat\">"+ formatDate(baratok.added) + "</td><td class=\"divTableCellbarat\"><button data-auth=\'"+(baratid+1)+"\' class=\"baratidek\"><img style=\"width:65px;\" id=\"locationimg\" src=\"images/torles.png\"></button></td>";
				baratx.push(baratok.index);
				baratid++;
				baratokszam++;
				}
			  document.getElementById("baratoktext").innerHTML = "Barátok ("+baratokszam+"db)";
			var buttons = document.getElementsByClassName('baratidek');
            for(var i=0; i<buttons.length; i++){
                buttons[i].addEventListener("click", function(){
                    display(false)
                    $.post('http://playerpanel/baratok', JSON.stringify({
                        x: baratx[$(this).data('auth')-1],
                    }));
                })
            }
			  
			  
            }
			switch (event.data.action) {
			case 'close':
				$('#wrap').fadeOut();
				visable = false;
				break;

			case 'updatePlayerJobs':
				var jobs = event.data.jobs;
				$('#player_count').html(jobs.player_count);
                
				$('#ems').html(jobs.ems);
				$('#police').html(jobs.police);
				$('#firefighter').html(jobs.firefighter);
				$('#mechanic').html(jobs.mechanic);
				/* $('#slaughterer').html(jobs.slaughterer);
				$('#fueler').html(jobs.fueler);
				$('#lumberjack').html(jobs.lumberjack);
				$('#tailor').html(jobs.tailor); */
				$('#reporter').html(jobs.reporter);
				/* $('#miner').html(jobs.miner); */
				$('#estate').html(jobs.estate);
				$('#cardeal').html(jobs.cardeal);
				$('#arma').html(jobs.arma);
				$('#stato').html(jobs.stato);
				$('#unemployed').html(jobs.unemployed);
				break;

			case 'updatePlayerList':
			$('#wrap').fadeIn();
				break;

			case 'updatePing':
				updatePing(event.data.players);
				break;

			case 'updateServerInfo':
				if (event.data.maxPlayers) {
					$('#max_players').html(event.data.maxPlayers);
				}

				if (event.data.uptime) {
					$('#server_uptime').html(event.data.uptime);
				}

				if (event.data.playTime) {
					$('#play_time').html(event.data.playTime);
				}

				break;

			default:
				break;
		}


        
    })
	    document.getElementById('s2').addEventListener('click', function() {
        var checkBox = document.getElementById("s2");
      
        if (checkBox.checked == true){            
            $.post('http://playerpanel/hudon', JSON.stringify({}));
        } else {
            $.post('http://playerpanel/hudoff', JSON.stringify({}));
        }
    }, false);
	document.getElementById('s3').addEventListener('click', function() {
        var checkBox = document.getElementById("s3");
      
        if (checkBox.checked == true){            
            $.post('http://playerpanel/chaton', JSON.stringify({}));
        } else {
            $.post('http://playerpanel/chatoff', JSON.stringify({}));
        }
    }, false);

    document.getElementById('closeButton').addEventListener('click', function() {
        setTimeout(function(){
            display(false)    
        }, 600);
    }, false);

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 36) {
            setTimeout(function(){
                display(false)    
            }, 600);
            return
        }
		else if (data.which == 27) {
            setTimeout(function(){
                display(false)    
            }, 600);
            return
         }
    };

// Todo: not the best code
function updatePing(players) {
	jQuery.each(players, function (index, element) {
		if (element != null) {
			$('#playerlist tr:not(.heading)').each(function () {
				$(this).find('td:nth-child(2):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(2).html(element.ping);
				});
				$(this).find('td:nth-child(5):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(5).html(element.ping);
				});
				$(this).find('td:nth-child(8):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(8).html(element.ping);
				});
				$(this).find('td:nth-child(11):contains(' + element.id + ')').each(function () {
					$(this).parent().find('td').eq(11).html(element.ping);
				});
			});
		}
	});
}
function formatDate(date) {
    var d = new Date(date),
		hour = '' + d.getHours(),
		minute = '' + d.getMinutes(),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;
	var szoveg = [year, month, day].join('-');
	var oraperc = [hour,minute].join(':');
    return [szoveg,oraperc].join(' ');
}

function sortPlayerList() {
	var table = $('#playerlist'),
		rows = $('tr:not(.heading)', table);

	rows.sort(function(a, b) {
		var keyA = $('td', a).eq(1).html();
		var keyB = $('td', b).eq(1).html();

		return (keyA - keyB);
	});

	rows.each(function(index, row) {
		table.append(row);
	});
}
    
})





