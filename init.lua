local characters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"} --lo


for _, name in ipairs(characters) do --do this for all characters in the list
   if tonumber(name) ~= nil then --if it's a number
      local desc = "Number "..name 
   else --if it's a letter
      local desc = "Letter "..string.upper(name) --make the letter uppercase in the description
   end

   minetest.register_node("abjphabet:"..name, {
      description = desc,
      tiles = {"abjphabet_"..name..".png"},
      groups = {cracky=3}
   })
end

minetest.register_node("abjphabet:machine", {
   description = "Letter Machine",
   tiles = {"abjphabet_machine.png"},
   paramtype = "light",
   groups = {cracky=2},
   
   after_place_node = function(pos, placer)
      local meta = minetest.env:get_meta(pos)
   end,

   on_construct = function(pos)
      local meta = minetest.env:get_meta(pos)
      meta:set_string("formspec", "invsize[8,6;]"..
         "field[3.8,.5;1,1;lettername;Letter;]"..
         "list[current_name;input;2.5,0.2;1,1;]"..
         "list[current_name;output;4.5,0.2;1,1;]"..
         "list[current_player;main;0,2;8,4;]"..
         "button[2.54,-0.25;3,4;name;Paper -> Letter]")
         local inv = meta:get_inventory()
      inv:set_size("input", 1)
      inv:set_size("output", 1)
   end,

   on_receive_fields = function(pos, formname, fields, sender)
      local meta = minetest.env:get_meta(pos)
      local inv = meta:get_inventory()
      local inputstack = inv:get_stack("input", 1)
      if fields.lettername ~= nil and inputstack:get_name()=="default:paper" then
         for _,v in pairs(characters) do
            if v == fields.lettername then
               local give = {}
               give[1] = inv:add_item("output","abjphabet:"..fields.lettername)
               inputstack:take_item()
               inv:set_stack("input",1,inputstack)
               break
            end
         end
         
      end   
   end
})