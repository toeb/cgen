# cgen
## a project generator based on cmake

### Motivation

Creating projects for cpp or other languages is often frustrating and takes alot of time.  This tool will help developers by providing a framework to automate the generation process. Combined with a package manager like `cps` developers can contribute and exchange their generators.  

### How do I use `cgen`?

`cgen` is a command line tool based on `cmake`, `cutil` `oo-cmake` and `cps`. It is included in `cutil`.   `cgen` maintains a list of generators which can generate files for a project.  

*A Simple Example*

This simple example generates a readme file containing some project specific data.
```
/path/to/myproject> cgen generate readme
/path/to/myproject> ls
README.md
/path/to/myproject> more|less README.md
# myproject
*Version 0.0.0*
This is the automatically generated readme for `myproject`
```


### How do I create a generator for `cgen`

A `cgen` generator is a simple map containing callback for different phases. The phases available are 

* initializing
* prompting
* configuring
* default
* writing
* install
* end
 
As you might have notices these phases were stolen from (yeoman)[http://yeoman.io/authoring/running-context.html] which is the inspiration for this tool.

You can create a generator in your local project setting by setting the `cps_on_load` callback in your `package_descriptor` to a function which calls `cgen_generator(...)` this will register the generator in your current package and will be available to all packages depending on it. Be sure to depend on the `cgen` package.

*An Example*

```
<generator's package.cmake>
{
    "cps":{
        "exports":["cmake/**.cmake"]
        "hooks":{
            "on_load":"my_project_cps_on_load"
        }
    }
}
</generator's package.cmake>
<cmake/myproj_create_file.cmake>
function(myproj_create_file)
 fwrite("myprojfile.cmake" "hello")
 ans(path)
 message("created file ${path}")
endfunction()
</cmake/myproj_create_file.cmake>

<cmake/my_project_cps_on_load.cmake>
function(my_project_cps_on_load)
    generator("{generator_name:'mygen',writing:'myproj_create_file'}")
endfunction()
</cmake/my_project_cps_on_load.cmake>


<console>
current/path> cgen mygen
created file current/path/myprojfile.cmake
</console>
```

### Functions and Datatypes

* `<generator> := { generator_name:<generator name>, [initializing:<callable>], [prompting:<callable>], [configuring:<callable>], [default:<callable>], [writing:<callable>], [install:<callable>], [end:<callable>]}` a generator is a map which contains at least one callback for the specified phase and a prpoerty called `generator_name` which uniquely identifies the generator   
* `<generator?> := <generator>|<generator name>|<cmake function>` a generator can be created from a object a unique id or a cmake function.
* `cgen_generator(<generator?>) -> <generator>` either registers and returns the specified generator or returns the generator by unique id
* `cgen_generators(<generator?...>) -> <generator...>` same as generator however for multiple generators
* `cgen_generate(<directory> <generator?...>) -> <generator...>` runs the generators specified in the specified directory and returns them.





