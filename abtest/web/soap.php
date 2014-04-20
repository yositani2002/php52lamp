<?php  
  $client = new SoapClient("http://localhost/hw.wsdl");
  $response = $client->getHW(array(1,2));
  echo $response;
?>
