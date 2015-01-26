function(cgen_register_generators)
  function(gitignore_init)

  
  endfunction()


  function(cgen_cpp_class_prompting)
    prompt_property("class_name")
    ans(class_name)
    assign(this.class_name = class_name)
  endfunction()


  function(cgen_cpp_class_writing)
    assign(namespace = this.class_name)

    string(REPLACE "::" ";" class_path "${namespace}")
    string_combine("::" ${class_path})
    ans(namespace)


    list_pop_back(class_path)
    ans(class_name)
    string(REPLACE ";" "/" class_path "${class_path}" )
    if(class_path)
      set(class_path "${class_path}/")
    endif()


    cpp_class_header_generate("{type_name:$class_name, namespace:$namespace}")
    ans(header_source)
    fwrite("include/${class_path}${class_name}.h" "${header_source}")
    fwrite("src/${class_path}${class_name}.cpp" "#include <${class_path}${class_name}.h>\n")

    event_emit(on_cgen_cpp_class_created "${class_path}" "${class_name}")

  endfunction()



  cgen_generator("{
    generator_name:'class',
    prompting:'cgen_cpp_class_prompting',
    writing:'cgen_cpp_class_writing'
  }")


  function(gitignore_prompt)
    prompt_property("{
      display_name:'Project Type',
      project_type:'string',
      property_name:'project_type'
      }")
    ans(input)
    assign(this.project_type = input.project_type)
  endfunction()

  function(gitignore_write)
    #pwd()
    #ans(pwd)
    #message("pwd ${pwd}")
    #fwrite(".gitignore" "# Auto generated gitignore")

    map_tryget(${generator} project_type)
    ans(project_type)
    download("https://raw.githubusercontent.com/github/gitignore/master/${project_type}.gitignore" ".gitignore")
    ans(res)
  endfunction()

  function(readme_init) 
    message("checking for a readme file in project_dir")
    if(EXISTS "${project_dir}/README.md")
      map_set(${generator} "readme_exists" true)
    endif()

  endfunction()


  function(readme_prompt)
    map_tryget("${generator}" readme_exists)
    ans(readme_exists)
    if(readme_exists)
      prompt_property("{
        property_name:'overwrite',
        display_name:'Overwrite Existing README.md?',
        default_value:false,
        property_type:'bool'
      }")
      ans(overwrite)
      map_set(${this} overwrite "${overwrite}")
    endif()
  endfunction()

  function(readme_write)
    map_import_properties(${this} readme_exists overwrite)
    if(readme_exists AND NOT overwrite)
      return()
    endif()    
    assign(project_name = project.packageDescriptor.id)
    assign(project_version = project.packageDescriptor.version)

    fwrite("${project_dir}/README.md"
"# ${project_name}
*${project_version}*
This is the automatically generated readme file for `${project_name}`. 
")
  endfunction()


      cgen_generator("{
        generator_name:'gitignore',
        initializing:'gitignore_init',
        prompting:'gitignore_prompt',
        configuring:'',
        default:'',
        writing:'gitignore_write',
        conflicts:'',
        install:'',
        end:''
      }")


      cgen_generator("{
        generator_name:'readme',
        initializing:'readme_init',
        prompting:'readme_prompt',
        configuring:'',
        default:'',
        writing:'readme_write',
        conflicts:'',
        install:'',
        end:''
      }")

      function(package_file)
        fwrite("package.cmake" "{id:'mypackage',version:'0.0.0'}")
      endfunction()
      cgen_generator(package_file)
  
endfunction()