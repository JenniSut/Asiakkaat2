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
<title>Lisää asiakas</title>
</head>
<body>
<form id="tiedot">
	<table>
	<thead>
		<tr>
			<th colspan="3" id ="ilmo"></th>
			<th colspan="2" class="oikealle"><a href="listaaasiakkaat.jsp" id="takasisin">Takaisin listaukseen</a></th>
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
			<td><input type="button" name ="nappi" id="tallenna" value="Lisää" onclick ="lisaaTiedot()"></td>
		</tr>
	</tbody>
</table>
</form>
<span id="ilmo"></span>
</body>
<script>
function lisaaTiedot(){
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
	
	var formJsonStr=formDataJsonStr(document.getElementById("tiedot"));
	fetch ("asiakkaat",{
		method: 'POST',
		body:formJsonStr
	})
	.then(function (response){
		return response.json()
	})
	.then (function (responseJson){
		var vastaus = responseJson.response;
		if (vastaus == 0){
			document.GetElementById("ilmo").innerHTML = "Asiakkaan lisääminen epäonnistui";
		}else if (vastaus == 1){
			document.getElementById("ilmo").innerHTML = "Asiakkaan lisääminen onnistui!";
			haeTiedot();
		}
		setTimeout (function() {document.getElementById("ilmo").innerHTML =""}, 3000);
	});
	document.getElementById("tiedot").reset();
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