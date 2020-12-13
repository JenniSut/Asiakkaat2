<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta asiakasta</title>
</head>
<body>
<form id="tiedot">
	<table>
	<thead>
		<tr>
			<th colspan="3" id="ilmo"></th>
			<th colspan="2" class="oikealle"><a href="listaaasiakkaat.jsp" id="takaisin">Takaisin listaukseen</a></th>
		</tr>
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sposti</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" name="etunimi" id="etunimi"></td>
			<td><input type="text" name="sukunimi" id="sukunimi"></td>
			<td><input type="text" name="puhelin" id="puhelin"></td>
			<td><input type="text" name="sposti" id="sposti"></td> 
			<td><input type="button" id="tallenna" value="Päivitä" onclick="vieTiedot()"></td>
		</tr>
	</tbody>
</table>
<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id="ilmo"></span>
</body>
<script>
var asiakas_id = requestURLParam("asiakas_id");
fetch ("asiakkaat/haeyksi/" + asiakas_id, {
	method: 'GET'
})
.then (function (response){
	return response.json()
})
.then (function (responseJson){
	document.getElementById("etunimi").value=responseJson.etunimi;
	document.getElementById("sukunimi").value=responseJson.sukunimi;
	document.getElementById("puhelin").value=responseJson.puhelin;
	document.getElementById("sposti").value=responseJson.sposti;
	document.getElementById("asiakas_id").value=responseJson.asiakas_id;
});

function vieTiedot() {
	var ilmo = "";
	if(document.getElementById("etunimi").value.length<3){
		ilmo = "Etunimi ei kelpaa!";
	}else if (document.getElementById("sukunimi").value.length<2){
		ilmo = "Sukunimi ei kelpaa!";
	}else if (document.getElementById("puhelin").value.length<8){
		ilmo = "Puhelinnumero ei kelpaa!";
	}else if (document.getElementById("sposti").value.length<1){
		ilmo = "Sähköposti ei kelpaa!";
	}
	if (ilmo != ""){
		document.getElementById("ilmo").innerHTML= ilmo;
		setTimeout(function(){
			document.getElementById("ilmo").innerHTML = ""}, 3000);
		return;
	}
	document.getElementById("etunimi").value= siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value= siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value= siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value= siivoa(document.getElementById("sposti").value);
	
	var formJsonStr = formDataJsonStr(document.getElementById("tiedot"));
	fetch ("asiakkaat", {
		method: 'PUT',
		body:formJsonStr
	})
	.then (function (response){
		return response.json();
	})
	.then (function (responseJson) {
		var vastaus = responseJson.response;
		if (vastaus == 0){
			document.getElementById("ilmo").innerHTML ="Asiakkaan muuttaminen epäonnistui!";
		}else if (vastaus == 1){
			document.getElementById("ilmo").innerHTML = "Asiakkaan muuttaminen onnistui!";
		}
		setTimeout (function(){ document.getElementById("ilmo").innerHTML = ""}, 3000);
	});
}


function requestURLParam(sParam){
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split("&");
    for (var i = 0; i < sURLVariables.length; i++){
        var sParameterName = sURLVariables[i].split("=");
        if(sParameterName[0] == sParam){
            return sParameterName[1];
        }
    }
}
function formDataJsonStr(formArray) {
	var returnArray = {};
	for (var i = 0; i < formArray.length; i++){
		returnArray[formArray[i]['name']] = formArray[i]['value'];
	}
	return JSON.stringify(returnArray);
}

function siivoa (teksti){
	teksti =teksti.replace("<","");
	teksti=teksti.replace(";","");
	teksti=teksti.replace("'","''");
	return teksti;
}
</script>
</html>