
  ## registers a generator or returns a existing generator for the specified id
  ## a generator is a map which contains callback for different phases of 
  ## generation the phases are 
  ## * initializing - check current configuration (should be readonly)
  ## * prompting  - ask user for input using prompt* functions
  ## * configuring - 
  ## * default - 
  ## * writing - write data
  ## * conflicts - 
  ## * install - 
  ## you need to assign at least one callable to these phases
  ## you may do whatever you want in each phase however prompting the user
  ## should only be done during the prompting phase
  ## you have access to the following variables and functions from the parent scope
  ## `${project_dir}` contains the directory of the current project
  ## `pwd()` returns project_dir
  ## `prompt_*` functions (`prompt`, `prompt_property`)
  ## `${generator}` the generator containing the callbacks
  ## `${this}` per generator context you can use to store and retrivie data between phases
  ## `${shared}` shared context between generators
  ## `${phase}` the name of the current phase
  ## `${project}` the current project
  ##  
  function(cgen_generator generator)
    map_new()
    ans(generator_map)
    map_set(cgen generator_map "${generator_map}")
    function(cgen_generator generator)
      data("${generator}")
      ans(generator)

      map_import_properties(cgen generator_map)

      map_isvalid("${generator}")
      ans(is_map)
      if(NOT is_map)
        set(generator_name "${generator}")
        set(generator)
      else()
        map_tryget("${generator}" generator_name )
        ans(generator_name)
      endif()

      if("${generator_name}_" STREQUAL "_")
        return()
      endif()


      map_tryget("${generator_map}" "${generator_name}")
      ans(exising_generator)
      
      if(NOT generator AND exising_generator)
        set(generator ${exising_generator})
      else()
        if(NOT is_map)
          if(COMMAND "${generator_name}")
            map_new()
            ans(gen)
            map_set(${gen} default "${generator_name}")
            set(generator ${gen})
          else()
            return()
          endif()

        endif()
        map_set("${generator_map}" "${generator_name}" "${generator}") 

      endif() 

      return_ref(generator)

    endfunction() 
    cgen_generator("${generator}" ${ARGN})
  endfunction()
