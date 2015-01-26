## generates the specified generators in the specified directory 
## see generator for a description
## returns the generators which were used
function(cgen_generate dir)
  new(ProjectPackage "${dir}")
  ans(project)


  ## get the generators which were specified by varargs
  cgen_generators(${ARGN})
  ans(generators)

  ## todo sort generators in dependency order
  ## so they run in the correct order

  ## these phases were kindly lifted from yeoman priorities 
  ## 
  set(phases
    initializing #
    prompting    #
    configuring  #
    default      #
    writing      #
    conflicts    #
    install      #
  )
  
  ## get the project dir and cd to it
  ## project_dir will also be available as a variable
  ## in generator phase functions
  assign(project_dir = project.project_dir)
  cd("${project_dir}")

  ## generate context objects which are accessible to the generator 
  ## callbacks

  ## shared context
  map_new()
  ans(shared)

  ## map to store the per generator contexts
  map_new()
  ans(contexts)


  ## loop through all phases and call each generator's phase
  ##
  foreach(phase ${phases})
    foreach(generator ${generators})

      ## get the per generator context or create it
      map_tryget(${contexts} "${generator}")
      ans(this)
      if(NOT this)
        map_new()
        ans(this)
        map_set(${contexts} ${generator} ${this})
      endif()

      ## get callback and call it if it exists
      map_tryget(${generator} ${phase})
      ans(callback)
      if(NOT "${callback}_" STREQUAL "_")
        
        call("${callback}"())
        ans(res)

        ## todo check result for error
      endif()
    endforeach()
  endforeach()


  ## generation complete
  ## return the generators which were used
  return_ref(generators)
endfunction()