function(cgen_cutil_on_load)
  # cutil is being executed -> replace default cli with CtsCommandLineInterface

  map_tryget(global cli)
  ans(cli_root)

  new(command_line_handler)
  ans(clh)



  cgen_register_generators()





  function(cgen_generate_handler req res)
    map_tryget(${req} input)
    ans(generators)
    
    function(cgen_fwrite_cb)
      message("writing file ${ARGN}")
    endfunction()
    event_addhandler(on_fwrite cgen_fwrite_cb)
    cgen_generate("${CMAKE_CURRENT_SOURCE_DIR}" ${generators})
    event_removehandler(on_fwrite cgen_fwrite_cb)

  endfunction()
    
  function(cgen_list_generator_handler req res)
    map_tryget(${req} input)
    ans(query)

    cgen_generators(--all)
    ans(generators)

    foreach(generator ${generators})
      message(FORMAT "{generator.generator_name}")
    endforeach()
  endfunction()

  assign(clh.handlers[] = handler("{callable:'cgen_generate_handler', labels:'generate'}"))
  assign(clh.handlers[] = handler("{callable:'cgen_list_generator_handler', labels:'list'}"))
  



  call(cli_root.AddCommandHandler(cgen ${clh}))









endfunction()