
  function(cgen_generators)
    set(generators ${ARGN})
    if("${generators}" STREQUAL "--all")
      map_tryget(cgen generator_map)
      ans(generator_map)
      map_keys(${generator_map})
      ans(generators)
    endif()

    set(res)
    foreach(generator ${generators})
      cgen_generator("${generator}")
      ans(generator)
      if(generator)
        list(APPEND res "${generator}")
      endif()
    endforeach()

    return_ref(res)
  endfunction()