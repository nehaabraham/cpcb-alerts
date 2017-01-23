$(document).ready(function(){
  $( "#user_subscribed_to_email" ).change(function(){

    if($( "#user_subscribed_to_email" ).checked){
      //reveal email options
      $( "#email-options" ).slideToggle();
    }
    else{
      //uncheck and hide email options
      $( "#user_day_before_email" ).prop( "checked", false );
      $( "#user_week_before_email" ).prop( "checked", false );
      $( "#email-options" ).slideToggle();
    }

  });
});
