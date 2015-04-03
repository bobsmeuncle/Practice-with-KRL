ruleset see_songs {
  meta 
  {
    name "See Songs"
    description <<
CS462 Lab 6 Part 1 #6
>>
    author "Lexi Christiansen"
    logging on
    sharing on
  }
  
  rule songs
  {
    select when echo message msg_type re#song#
      send_directive("sing") with
        song = event:attr("msg_type");
    always
    {
      raise explicit event 'sung'
        with song = event:attr("input");
    }
  }
  
  rule find_hymn
  {
    select when explicit sung song re#.*god.*#
    always
    {
      raise explicit event 'found_hymn' with
        Adam = "rocks"
    }
  }
}