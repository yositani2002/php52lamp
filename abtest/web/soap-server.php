<?php 

function getHW($arr) { 

$result  =  array_sum($arr);
  
return "<HTML>
 <HEAD>
  <TITLE>SOAP Server Example</TITLE>
 </HEAD
 <BODY>
 <table>
 <tr>
  <th>SOAP Server Example - adding array on the server</th>  
 </tr>
 <tr>
  <td>$arr[0] + $arr[1] = $result</td>  
 </tr>
</table>
</BODY>
</HTML>";
} 

ini_set("soap.wsdl_cache_enabled", "0"); 
$server = new SoapServer("hw.wsdl");
$server->addFunction("getHW"); 
$server->handle(); 

?>
